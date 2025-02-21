extends Node

var bullet = preload("res://Prefabs/bullet.tscn")
@export var bullet_spawn = Node2D
#Turret child, used to set the direction of the turret for shooting
@export var turret : Node2D

#How many actions should the enemy get each turn
var max_actions = 1
#Current actions remaining for the enemy
var actions_remaining = 1

#Choose an action to do
func action_choice():
	#For now it just shoots, this will be changed eventually
	shoot(Vector2.LEFT)
	
#Hurt Tank
#Sends signal to child which handles the tank health
func hurt(amount):
	find_child("Health").damage(amount)
	
func shoot(direction):
	#Set turret direction
	turret.rotation = direction.angle()
	#Spawning bullet and setting it to shoot from the "BulletSpawn" position
	var b = bullet.instantiate()
	add_child(b)
	b.global_position = bullet_spawn.global_position
	b.rotation = bullet_spawn.global_rotation
	action_taken()

#Once an action is taken check if any actions remain, if they do - do something, otherwise end turn
func action_taken():
	actions_remaining -= 1
	if(actions_remaining == 0):
		get_parent().enemy_finished()
	else:
		action_choice()
