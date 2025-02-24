extends Node

@export var EnemyHandler : Node2D
@export var Player : Node2D
@export var Map : TileMapLayer
@export var ResetButton : TextureButton
@export var WinGameButton : TextureButton
@export var NextLevelButton : TextureButton
@export var Cam : Camera2D
@export var Decals : Node2D

var level_over
var player_turn
var map_number = 1
var number_of_maps = 0

var map_folder = "res://Scenes/Maps/map"
var player_prefab = preload("res://Prefabs/player.tscn")
#Called when the player has no actions remaining
#Tells the Enemy Handler node that its the enemies' turn
func _ready():
	find_map_number("res://Scenes/Maps/")
	start_level()
	
func _process(_delta: float) -> void:
	if level_over and map_number <= number_of_maps:
		start_level()
		
func find_map_number(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			number_of_maps += 1
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
		
func set_enemy_turn():
	await get_tree().create_timer(0.3).timeout
	if !player_turn:
		EnemyHandler.enemy_turn(Map, Map.local_to_map(Player.target_location))
	else:
		player_turn = false

func set_player_turn():
	await get_tree().create_timer(0.3).timeout 
	if is_instance_valid(Player):
		Player.player_turn()
	else:
		print("Game Over")

#Updates the cell_empty for nodes that an enemy is occupying
func enemy_location(old_position, new_position):
	Map.set_cell_empty(old_position, new_position)

#Turns on the next level button
func round_won():
	map_number += 1
	if map_number <= number_of_maps:
		NextLevelButton.visible = true
	elif map_number > number_of_maps:
		WinGameButton.visible = true
	Player.level_complete()

func _on_next_leve_l_button_pressed() -> void:
	NextLevelButton.visible = false
	end_level()
	
func end_level():
	Map.queue_free()
	level_over = true
	if(Player != null):
		Player.queue_free()

#Turns on the reset button
func game_over():
	ResetButton.visible = true
#Reset Button Clicked
func _on_restart_button_pressed() -> void:
	ResetButton.visible = false
	reset_game()
	
func _on_win_game_button_pressed():
	Player.queue_free()
	WinGameButton.visible = false
	reset_game()

#Resets the game
func reset_game():
	EnemyHandler.game_over()
	Map.queue_free()
	map_number = 1
	level_over = true
	
func start_level():
	player_turn = true
	level_over = false
	var new_map = load(map_folder + str(map_number) + ".tscn")
	Map = new_map.instantiate()
	add_child(Map)
	Player = player_prefab.instantiate()
	add_child(Player)
	Player.position = Map.player_spawn.position
	Player.target_location = Player.global_position
	Player.map = Map
	Map.player = Player
	move_child(Map, 0)
	EnemyHandler.spawn_enemies(Map.enemy_spawn, Map.hard_enemy_spawn, Map)
	#Sends map to camera so the camera can re-center itself
	Cam.recenter(Map)
	#Delete exploision decals from previous level
	for child in Decals.get_children():
		child.queue_free()
