extends KinematicBody2D

signal died

const bullet_scn = preload("res://Enemy/Bullet.tscn")

var enemy_life = 5
var enemy_speed = 800
var delta_count = 0

var radius = 20
export var rotate_speed: float
export var max_rotate_speed = 80
export var min_rotate_speed = 20
export var interval: float
export var max_interval = 0.8
export var min_interval = 0.2
export var spawning_count: int
export var max_spawning_count = 11
export var min_spawning_count = 2

onready var sprite = $Sprite
onready var rotater = $Rotater
onready var timer = $Timer
onready var anim_player = $AnimationPlayer


func _ready():
	anim_player.play("spawn")
	
	randomize()
	sprite.frame = randi() % sprite.hframes # int, max: 5
	rotate_speed = rand_range(min_rotate_speed, max_rotate_speed) # float
	interval = rand_range(min_interval, max_interval) # float
	max_spawning_count += 1 # int
	spawning_count = randi() % max_spawning_count + min_spawning_count # int
	
	var step = PI * 2 / spawning_count
	for i in spawning_count:
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotater.add_child(spawn_point)

	timer.wait_time = interval
	yield(anim_player, "animation_finished")
	timer.start()


func _physics_process(delta):
	delta_count += delta
	if delta_count > 2:
		delta_count = 0
		if get_parent().has_node("Player"):
			anim_player.stop()
			anim_player.play("move")
			var direction = global_position.direction_to(get_parent().get_node("Player").global_position)
			var velocity = direction * enemy_speed
			velocity = move_and_slide(velocity)
			
	var new_rotation = rotater.rotation + rotate_speed * delta
	rotater.rotate(fmod(new_rotation, 360))


func _on_Timer_timeout():
	for node2d in rotater.get_children():
		var bullet = bullet_scn.instance()
		get_parent().add_child(bullet)
		bullet.position = node2d.global_position
		bullet.rotation = node2d.global_rotation


func _on_HitBox_area_entered(area):
	if area.is_in_group("Magic"):
		print(area, " hit enemy")
		if anim_player.current_animation != "spawn":
			anim_player.stop()
			anim_player.play("hit")
			yield(anim_player, "animation_finished")
			if enemy_life > 1:
				enemy_life -= 1
			else:
				anim_player.stop()
				anim_player.play("die")
				yield(anim_player, "animation_finished")
				queue_free()


func _on_Enemy_tree_exited():
	emit_signal("died")
