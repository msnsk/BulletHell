extends Node2D

export var speed = 150

func _physics_process(delta): 
	position += transform.x * speed * delta


func _on_Bullet_body_entered(body):
#	print("Bullet hit ", body)
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
#	print("Bullet exited from screen")
	queue_free()
