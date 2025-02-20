extends TileMapLayer

var grid = Array()
@export var grid_width = 7
@export var grid_height = 7
var tiles

#Player tank. Used to move send signal to move player
@export var player = Node2D
#Tiles which can be moved to
var moveable = []

var tile_scene = preload("res://Prefabs/tile.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
#	inititates 2d array
	grid.resize(grid_height)
	for i in range(grid_height):
		grid[i] = Array()
		grid[i].resize(grid_width)
		for j in range(grid_width):
			grid[i][j] = 0
			
	tiles = get_used_cells()
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
		
		grid[tile.x][tile.y] = scene
		
	print(grid)

func find_moveable_tiles(player_position):
	#Reset moveable tiles
	moveable = []
	var player_grid_pos = local_to_map(player_position)
	var x = player_grid_pos.x
	#Check all cells to the left of player
	while x >= 0:
		#If there isn't a wall continue, otherwise stop
		if(grid[x][player_grid_pos.y].cell_empty):
			moveable.append(grid[x][player_grid_pos.y])
		else:
			break
		x -= 1
	#Check all cells to the right of the player
	x = player_grid_pos.x
	while x < grid_width:
		#If there isn't a wall continue, otherwise stop
		if(grid[x][player_grid_pos.y].cell_empty):
			moveable.append(grid[x][player_grid_pos.y])
		else:
			break
		x += 1
	#Check all cells to the top of player
	var y = player_grid_pos.y
	while y >= 0:
		#If there isn't a wall continue, otherwise stop
		if(grid[player_grid_pos.x][y].cell_empty):
			moveable.append(grid[player_grid_pos.x][y])
		else:
			break
		y -= 1
	#Check all cells to the right of the player
	y = player_grid_pos.y
	while y < grid_height:
		#If there isn't a wall continue, otherwise stop
		if(grid[player_grid_pos.x][y].cell_empty):
			moveable.append(grid[player_grid_pos.x][y])
		else:
			break
		y += 1
	#Turn on moveable tiles
	for tile in moveable:
		tile.visible = true
		
#A tile has been clicked on and the tank will be moved to the tile
func tile_clicked(location):
	#For all the currently visible tile nodes, turn them off
	for tile in moveable:
		tile.visible = false
	moveable = []
	
	#Move player to tile
	player.move(map_to_local(location))
