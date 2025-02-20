extends Node

var bullet = preload("res://Prefabs/bullet.tscn")
@export var bullet_spawn = Node2D

#Node handling the tiles which can be moved to
@export var map = Node2D

func shoot():
	#Spawning bullet and setting it to shoot from the "BulletSpawn" position
	var b = bullet.instantiate()
	add_child(b)
	b.global_position = bullet_spawn.global_position
	b.rotation = bullet_spawn.global_rotation
	
#THIS WILL GET REPLACED EVENTUALLY, FOR NOW JUST FOR TESTING
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			shoot()

#Hurt Tank
#Sends signal to child which handles the tank health
func hurt(amount):
	find_child("Health").damage(amount)

#Move button pressed, send signal to the tile map to work out which nodes are moveable
func _on_move_button_pressed() -> void:
	map.find_moveable_tiles(self.global_position)
	
func move(location):
	self.global_position = location
