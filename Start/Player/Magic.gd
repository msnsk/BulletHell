extends Area2D


var speed = 150
var rotate_speed = 800

onready var anim_player = $AnimationPlayer


func _ready():
	anim_player.play("attack")


func _process(delta):
	position += transform.x * speed * delta


func _on_Magic_body_entered(body):
	if body.name == "Player":
		return
#	print("Magic hit physics body")
	queue_free()


func _on_Timer_timeout():
#	print("Magic timeout")
	queue_free()
