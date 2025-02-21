extends Node

var bullet = preload("res://Prefabs/bullet.tscn")
@export var bullet_spawn = Node2D
#Node handling the tiles which can be moved to
@export var map = Node2D
#Child node containing the arrow buttons to choose which direction to shoot
@export var arrows : Node2D
#Turret child, used to set the direction of the turret for shooting
@export var turret : Node2D
#How many actions does the player get each turn
var max_actions = 2
#How many current actions remain
var actions_remaining = 2

#Location where the player should move to
var target_location = null

var t = 0
func _process(delta: float) -> void:
	#Move towards desired location over time
	if(self.global_position != target_location and target_location != null):
		t += delta * 0.1
		self.global_position = self.global_position.lerp(target_location, t)
#Hurt Tank
#Sends signal to child which handles the tank health
func hurt(amount):
	find_child("Health").damage(amount)

#Move button pressed, send signal to the tile map to work out which nodes are moveable
func _on_move_button_pressed() -> void:
	map.find_moveable_tiles(self.global_position)

#Set move location to node position and then move over time in func _process
func move(location):
	target_location = location
	t = 0
	action_taken()

#Shoot button pressed, send signal to the tile map to work out which direction
func _on_shoot_button_pressed() -> void:
	arrows.visible = true
	
func shoot(direction):
	#Set turret direction
	turret.rotation = direction.angle()
	
	#Spawning bullet and setting it to shoot from the "BulletSpawn" position
	var b = bullet.instantiate()
	add_child(b)
	b.global_position = bullet_spawn.global_position
	b.rotation = bullet_spawn.global_rotation
	action_taken()

#Called to set the turn to the player's
func player_turn():
	actions_remaining = max_actions
#Once an action is taken, check if any actions remain. If they don't, set it to be the enemy turn
func action_taken():
	actions_remaining -= 1
	if(actions_remaining == 0):
		get_parent().set_enemy_turn()
	
