extends TileMapLayer

var grid = Array()
var grid_width = 7
var grid_height = 7
var tiles

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
