extends KinematicBody2D

const magic_scn = preload("res://Player/Magic.tscn")

var life = 10
var speed = 160
var velocity = Vector2()

onready var sprite = $Sprite
onready var wand = $Wand
onready var timer = $Timer
onready var anim_player = $AnimationPlayer


func _physics_process(_delta):
	get_input()
	velocity = move_and_slide(velocity)


func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		sprite.flip_h = false
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		sprite.flip_h = true
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	velocity = velocity.normalized()
	if velocity != Vector2():
		wand.position = velocity * 8
		wand.rotation = velocity.angle()
	velocity = velocity * speed

	if Input.is_action_just_pressed("magic") and timer.is_stopped():
		var magic = magic_scn.instance()
		get_parent().add_child(magic)
		magic.transform = wand.global_transform
		timer.start()


func _on_HitBox_area_entered(area):
	if area.is_in_group("Bullets"):
		print(area, " hit Player")
		anim_player.play("hit")
		if life > 1:
			life -= 1
		else:
			yield(anim_player, "animation_finished")
			print("Game Over!!!!!")
			get_tree().quit()

