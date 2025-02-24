extends TileMapLayer

var grid = Array()
@export var grid_width = 8
@export var grid_height = 3
@export var move_distance = 3

var tiles

var player_spawn
var enemy_spawn = []
var hard_enemy_spawn = []

#Player tank. Used to move send signal to move player
@export var player = Node2D
#Tiles which can be moved to
var moveable = []

var tile_scene = preload("res://Prefabs/tile.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	#move_distance += 1
	tiles = get_used_cells()
	var xmax = 0
	var ymax = 0
	for cell in tiles:
		if cell.x > xmax:
			xmax = cell.x
		if cell.y > ymax:
			ymax = cell.y
	grid_width = xmax + 1
	grid_height = ymax + 1
	
#	inititates 2d array
	grid.resize(grid_width)
	for i in range(grid_width):
		grid[i] = Array()
		grid[i].resize(grid_height)
		for j in range(grid_height):
			grid[i][j] = 0
			
	
	for tile in tiles:
		var scene = tile_scene.instantiate()
		add_child(scene)
		scene.position = map_to_local(tile)
		scene.location = tile
		var type = get_cell_atlas_coords(tile)
#		regular tile
		if type == Vector2i(0, 0):
			scene.cell_empty = true
			
#		wall
		elif type == Vector2i(1, 0):
			scene.cell_empty = false
			
#		player spawn
		elif type == Vector2i(2, 0):
			scene.cell_empty = true
			player_spawn = scene
			set_cell(tile, 0, Vector2i(0, 0))
			
#		enemy spawn
		elif type == Vector2i(3, 0):
			scene.cell_empty = false
			enemy_spawn.append(scene)
			set_cell(tile, 0, Vector2i(0, 0))
			
#		hard enemy spawn
		elif type == Vector2i(4, 0):
			scene.cell_empty = false
			hard_enemy_spawn.append(scene)
			set_cell(tile, 0, Vector2i(0, 0))
		
		grid[tile.x][tile.y] = scene
		
	tile_heuristics(player_spawn.position)

func find_moveable_tiles(player_position):
	#Reset moveable tiles
	moveable = []
	var player_grid_pos = local_to_map(player_position)
	var x = player_grid_pos.x
	#Check all cells to the left of player
	while x >= 0 && x >= player_grid_pos.x - move_distance:
		#If there isn't a wall continue, otherwise stop
		if(grid[x][player_grid_pos.y].cell_empty):
			moveable.append(grid[x][player_grid_pos.y])
		else:
			break
		x -= 1
	#Check all cells to the right of the player
	x = player_grid_pos.x
	while x < grid_width && x <= player_grid_pos.x + move_distance:
		#If there isn't a wall continue, otherwise stop
		if(grid[x][player_grid_pos.y].cell_empty):
			moveable.append(grid[x][player_grid_pos.y])
		else:
			break
		x += 1
	#Check all cells to the top of player
	var y = player_grid_pos.y
	while y >= 0 && y >= player_grid_pos.y - move_distance:
		#If there isn't a wall continue, otherwise stop
		if(grid[player_grid_pos.x][y].cell_empty):
			moveable.append(grid[player_grid_pos.x][y])
		else:
			break
		y -= 1
	#Check all cells to the right of the player
	y = player_grid_pos.y
	while y < grid_height && y <= player_grid_pos.y + move_distance:
		#If there isn't a wall continue, otherwise stop
		if(grid[player_grid_pos.x][y].cell_empty):
			moveable.append(grid[player_grid_pos.x][y])
		else:
			break
		y += 1
	#Turn on moveable tiles
	for tile in moveable:
		if(tile.cell_empty and tile.global_position != player.global_position):
			tile.visible = true
			tile.get_node("AnimationPlayer").play("tile_pop_in")
		
		
	
#A tile has been clicked on and the tank will be moved to the tile
func tile_clicked(location):
	grid[local_to_map(player.position).x][local_to_map(player.position).y].cell_empty = true
	#For all the currently visible tile nodes, turn them off
	moveable_visibility(false)
	moveable = []
	#Move player to tile
	player.move(map_to_local(location))
	tile_heuristics(map_to_local(location))
	
func tile_heuristics(player_position):
	for child in get_children():
		child.heuristic = null
	var player_grid_pos = local_to_map(player_position)
#	players pos heuristic = 1
	grid[player_grid_pos.x][player_grid_pos.y].heuristic = 1
	var straight_shot = []
	var x = player_grid_pos.x
	#Check all cells to the left of player
	while x >= 0:
		#If there isn't a wall continue, otherwise stop
		if(grid[x][player_grid_pos.y].cell_empty):
			straight_shot.append(grid[x][player_grid_pos.y])
		else:
			break
		x -= 1
	#Check all cells to the right of the player
	x = player_grid_pos.x
	while x < grid_width:
		#If there isn't a wall continue, otherwise stop
		if(grid[x][player_grid_pos.y].cell_empty):
			straight_shot.append(grid[x][player_grid_pos.y])
		else:
			break
		x += 1
	#Check all cells to the top of player
	var y = player_grid_pos.y
	while y >= 0:
		#If there isn't a wall continue, otherwise stop
		if(grid[player_grid_pos.x][y].cell_empty):
			straight_shot.append(grid[player_grid_pos.x][y])
		else:
			break
		y -= 1
	#Check all cells to the right of the player
	y = player_grid_pos.y
	while y < grid_height:
		#If there isn't a wall continue, otherwise stop
		if(grid[player_grid_pos.x][y].cell_empty):
			straight_shot.append(grid[player_grid_pos.x][y])
		else:
			break
		y += 1
		
	for tile in straight_shot:
		tile.heuristic = 1
	
#	set player's pos heuristic = 1
#	grid[player_grid_pos.x][player_grid_pos.y].heuristic = 1
	
	var neighbours = straight_shot
	var empty_values = []
	
	var can_move_on = false
	while !can_move_on:
		#print("I'm in can move on while loop")
		empty_values = []
		var cardinal_cells = []
		for neighbour in neighbours:
			cardinal_cells = get_surrounding_cells(neighbour.location)
			
			for cell in cardinal_cells:
				if cell.x >= 0 && cell.x <= grid_width - 1 && cell.y >= 0 && cell.y <= grid_height - 1:
					if !grid[cell.x][cell.y].heuristic:
						if !grid[cell.x][cell.y].cell_empty:
							grid[cell.x][cell.y].heuristic = 100
						else:
							empty_values.append(grid[cell.x][cell.y])
							var values = get_surrounding_cells(cell)
							var lowest = null
							for value in values:
								if value.x >= 0 && value.x <= grid_width - 1 && value.y >= 0 && value.y <= grid_height - 1:
									if grid[value.x][value.y].heuristic:
										if !lowest:
											lowest = grid[value.x][value.y].heuristic
										else:
											if grid[value.x][value.y].heuristic < lowest:
												lowest = grid[value.x][value.y].heuristic
							grid[cell.x][cell.y].heuristic = lowest + 1
					
		neighbours = empty_values
		var is_empty = false
		if neighbours.is_empty():
			is_empty = true
		can_move_on = true
		for child in get_children():
			if is_empty:
				if !child.heuristic:
					child.heuristic = 100
			if !child.heuristic:
				can_move_on = false
#	test output
	for child in get_children():
		child.find_child("Label").text = str(child.heuristic)
			
func set_cell_empty(old_position, location):
	if(old_position != null):
		grid[local_to_map(old_position).x][local_to_map(old_position).y].cell_empty = true
	grid[local_to_map(location).x][local_to_map(location).y].cell_empty = false

#Turn moveable tiles on/off
func moveable_visibility(visibility):
	#For all the currently visible tile nodes, turn them off
	for tile in moveable:
		#Stops tile player is on, from playing pop out animation
		if(tile.global_position != player.global_position):
			tile.get_node("AnimationPlayer").play("tile_pop_out")
	
	await get_tree().create_timer(0.5).timeout 
	for tile in moveable:
		tile.visible = visibility
	
