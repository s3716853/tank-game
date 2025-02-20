extends Node

var bullet = preload("res://Prefabs/bullet.tscn")
@export var bullet_spawn = Node2D

func shoot():
	#Spawning bullet and setting it to shoot from the "BulletSpawn" position
	var b = bullet.instantiate()
	add_child(b)
	b.global_position = bullet_spawn.global_position
	b.rotation = bullet_spawn.global_rotation
	
	
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			shoot()

#Hurt Tank
func hurt(amount):
	find_child("Health").damage(amount)
