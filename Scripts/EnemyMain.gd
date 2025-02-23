extends Node
class_name EnemyMain

var bullet = preload("res://Prefabs/bullet.tscn")
@export var bullet_spawn = Node2D
#Turret child, used to set the direction of the turret for shooting
@export var turret : Node2D
var map : TileMapLayer
var player_coord : Vector2

#How many actions should the enemy get each turn
var max_actions = 2
#Current actions remaining for the enemy
var actions_remaining
#Location where the enemy should move to
var target_location = null
#Used to rotate the turret smootly over time
var turret_rotated = true
#What direction should the turret face
var direction = Vector2.RIGHT
#Is the body rotated
var body_rotated = true

func _ready():
	actions_remaining = max_actions
	#Sets starting position cells to be not empty
	get_parent().enemy_locations(null,self.position)

#Choose an action to do
func action_choice():
	#For now it just shoots, this will be changed eventually
	var tank_coord = map.local_to_map(self.position)
	
	var surrounding_coord = map.get_surrounding_cells(tank_coord)
	
	var lowest_heuristic = 1000
	var lowest_coord = null
	for coord in surrounding_coord:
		if(
			range(map.grid_width).has(coord.x) and
			range(map.grid_height).has(coord.y) and
			map.grid[coord.x][coord.y].heuristic < lowest_heuristic
		):
			lowest_heuristic = map.grid[coord.x][coord.y].heuristic
			lowest_coord = coord
		if(lowest_heuristic <= 1):
			#If there is a 1 or 0, check to see if in the same row/column as the player
			if(tank_coord.x == player_coord.x or tank_coord.y == player_coord.y):
				rotate_turret(map.grid[coord.x][coord.y].global_position - self.global_position)
				break
			else:
				move(map.map_to_local(lowest_coord))
	#If there isn't a 1 or 0
	if(lowest_heuristic > 1):
		move(map.map_to_local(lowest_coord))
#Hurt Tank
#Sends signal to child which handles the tank health
func hurt(amount):
	find_child("Health").damage(amount)

#Called when an enemy moves
func move(location : Vector2):
	#Update heuristic number
	map.tile_heuristics(map.map_to_local(player_coord))
	#Sets the old grid cell_empty to true and the new cell_empty to false
	get_parent().enemy_locations(self.position, location)
	#MOVE to location
	target_location = location
	t = 0
	moving = true
	body_rotated = false
#Called when an enemy shoots
func shoot():
	#Spawning bullet and setting it to shoot from the "BulletSpawn" position
	var b = bullet.instantiate()
	add_child(b)
	b.global_position = bullet_spawn.global_position
	b.global_rotation = turret.global_rotation
	await get_tree().create_timer(1).timeout 
	action_taken()
#Rotate turret smootly
func rotate_turret(d):
	t2 = 0
	direction = d
	turret_rotated = false
	
#Once an action is taken check if any actions remain, if they do - do something, otherwise end turn
func action_taken():
	actions_remaining -= 1
	if(actions_remaining <= 0):
		get_parent().enemy_finished()
	else:
		action_choice()
		
var t = 0
var t2 = 0
var moving = false
func _process(delta: float) -> void:
	#Move towards desired location over time
	if(self.global_position != target_location and target_location != null and body_rotated):
		t += delta * 0.1
		self.global_position = self.global_position.lerp(target_location, t)
		if(self.global_position.distance_to(target_location) < 1):
			self.global_position = target_location
	if(moving and self.global_position == target_location):
		moving = false
		action_taken()
	# Rotate turret smoothly
	if(!turret_rotated and body_rotated):
		t2 += delta * 0.3  # Adjust speed for smoother rotation
		# Lerp rotation towards target angle
		turret.global_rotation = lerp_angle(turret.global_rotation, direction.angle(), t2)
		# Normalize the angle difference to be within -PI to PI
		var angle_diff = fposmod(turret.global_rotation - direction.angle() + PI, 2 * PI) - PI
		if abs(angle_diff) < 0.1:  # Small threshold to stop jitter  # Small threshold to stop jitter
			turret.global_rotation = direction.angle()
			turret_rotated = true
			shoot()
	#Rotate body smoothly
	if(!body_rotated):
		# Get the angle the turret should face
		var target_angle = (target_location - self.global_position).angle()
		# Calculate angle difference
		var angle_diff = fposmod(self.rotation - target_angle + PI, 2 * PI) - PI
		# If not facing the target, lerp towards it
		if abs(angle_diff) > 0.1:  # Small threshold to stop jitter
			self.rotation = lerp_angle(self.rotation, target_angle, delta * 5)  # Adjust speed factor
		else:
			self.rotation = target_angle  # Snap to exact angle when close
			body_rotated = true		
#Called when the tank is destroyed
func tank_destroyed():
	get_parent().tank_destroyed()
	var pos = map.local_to_map(self.position)
	map.grid[pos.x][pos.y].cell_empty = true
	queue_free()
