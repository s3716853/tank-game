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
#Location where the enemy should move to
var target_location = null

func _ready():
	#Sets starting position cells to be not empty
	get_parent().enemy_locations(null,self.position)

#Choose an action to do
func action_choice(map : TileMapLayer, player_coord: Vector2):
	#For now it just shoots, this will be changed eventually
	var tank_coord = map.local_to_map(self.position)
	
	var surrounding_coord = map.get_surrounding_cells(tank_coord)
	
	var lowest_heuristic = 1000
	var lowest_coord = null
	for coord in surrounding_coord:
		if(map.grid[coord.x][coord.y].heuristic < lowest_heuristic):
			lowest_heuristic = map.grid[coord.x][coord.y].heuristic
			lowest_coord = coord
		if(lowest_heuristic <= 1):
			#If there is a 1 or 0, check to see if in the same row/column as the player
			if(tank_coord.x == player_coord.x or tank_coord.y == player_coord.y):
				shoot(Vector2.LEFT, map, player_coord)
				break
			else:
				move(map.map_to_local(lowest_coord), player_coord, map)
	#If there isn't a 1 or 0
	if(lowest_heuristic > 1):
		move(map.map_to_local(lowest_coord), player_coord, map)
#Hurt Tank
#Sends signal to child which handles the tank health
func hurt(amount):
	find_child("Health").damage(amount)

#Called when an enemy moves
func move(location : Vector2, player_coord: Vector2, map : TileMapLayer):
	map.tile_heuristics(map.map_to_local(player_coord))
	#Sets the old grid cell_empty to true and the new cell_empty to false
	get_parent().enemy_locations(self.position, location)
	#MOVE to location
	target_location = location
	#Update heuristic number
	action_taken(map, player_coord)
	
#Called when an enemy shoots
func shoot(direction, map : TileMapLayer, player_coord: Vector2):
	#Set turret direction
	turret.rotation = direction.angle()
	#Spawning bullet and setting it to shoot from the "BulletSpawn" position
	var b = bullet.instantiate()
	add_child(b)
	b.global_position = bullet_spawn.global_position
	b.rotation = bullet_spawn.global_rotation
	action_taken(map, player_coord)

#Once an action is taken check if any actions remain, if they do - do something, otherwise end turn
func action_taken(map : TileMapLayer, player_coord: Vector2):
	actions_remaining -= 1
	if(actions_remaining <= 0):
		get_parent().enemy_finished()
	else:
		action_choice(map, player_coord)
		
var t = 0
func _process(delta: float) -> void:
	#Move towards desired location over time
	if(self.global_position != target_location and target_location != null):
		t += delta * 0.1
		self.global_position = self.global_position.lerp(target_location, t)
