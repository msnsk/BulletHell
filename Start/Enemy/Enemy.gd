extends KinematicBody2D

signal died

var enemy_life = 5
var enemy_speed = 800
var delta_count = 0

onready var sprite = $Sprite
onready var rotater = $Rotater
onready var timer = $Timer
onready var anim_player = $AnimationPlayer


func _ready():
	anim_player.play("spawn")
	
	randomize()
	sprite.frame = randi() % sprite.hframes # int, max: 5


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


func _on_Timer_timeout():
	pass


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
