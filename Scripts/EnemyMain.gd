extends Node
class_name EnemyMain

var bullet = preload("res://Prefabs/bullet.tscn")
@export var bullet_spawn = Node2D
#Turret child, used to set the direction of the turret for shooting
@export var turret : Node2D

#How many actions should the enemy get each turn
var max_actions = 1
#Current actions remaining for the enemy
var actions_remaining = 1

func _ready():
	#Sets starting position cells to be not empty
	get_parent().enemy_locations(null,self.position)

#Choose an action to do
func action_choice(map : TileMapLayer, player_coord: Vector2):
	#For now it just shoots, this will be changed eventually
	var tank_coord = map.local_to_map(self.position)
	
	var surrounding_coord = map.get_surrounding_cells(tank_coord)
	
	shoot(Vector2.LEFT, map)
		
#Hurt Tank
#Sends signal to child which handles the tank health
func hurt(amount):
	find_child("Health").damage(amount)

#Called when an enemy moves
func move(location : Vector2):
	#Sets the old grid cell_empty to true and the new cell_empty to false
	get_parent().enemy_locations(self.position, location)
	#MOVE to location
	#TODO
	
#Called when an enemy shoots
func shoot(direction, map : TileMapLayer):
	#Set turret direction
	turret.rotation = direction.angle()
	#Spawning bullet and setting it to shoot from the "BulletSpawn" position
	var b = bullet.instantiate()
	add_child(b)
	b.global_position = bullet_spawn.global_position
	b.rotation = bullet_spawn.global_rotation
	action_taken(map)

#Once an action is taken check if any actions remain, if they do - do something, otherwise end turn
func action_taken(map : TileMapLayer):
	actions_remaining -= 1
	if(actions_remaining == 0):
		get_parent().enemy_finished()
	else:
		action_choice(map)
