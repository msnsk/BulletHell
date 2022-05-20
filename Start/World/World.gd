extends Node2D

const enemy_scn = preload("res://Enemy/Enemy.tscn")

var spawn_point: Vector2

onready var player = $Player
onready var enemy = $Enemy


func _ready():
	randomize()
	spawn_enemy()


func spawn_enemy():
	enemy = enemy_scn.instance()
	spawn_point = Vector2(player.position.x + rand_range(-50, 50), player.position.y + rand_range(-50, 50))
	enemy.position = spawn_point
	enemy.connect("died", self, "spawn_enemy")
	call_deferred("add_child", enemy)

