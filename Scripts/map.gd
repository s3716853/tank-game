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
	for column in grid_width:
		moveable.append(grid[column][player_grid_pos.y])
	for row in grid_height:
		moveable.append(grid[player_grid_pos.x][row])
	
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
