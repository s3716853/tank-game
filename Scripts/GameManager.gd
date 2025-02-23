extends Node

@export var EnemyHandler : Node2D
@export var Player : Node2D
@export var Map : TileMapLayer
@export var ResetButton : TextureButton

var level_over
var player_turn
var map_number = 1

var map_folder = "res://Scenes/Maps/map"
var player_prefab = preload("res://Prefabs/player.tscn")
#Called when the player has no actions remaining
#Tells the Enemy Handler node that its the enemies' turn
func _ready():
	start_level(map_number)
	
func _process(delta: float) -> void:
	if level_over:
		start_level(map_number)
		
func set_enemy_turn():
	await get_tree().create_timer(1).timeout
	if !player_turn:
		EnemyHandler.enemy_turn(Map, Map.local_to_map(Player.target_location))
	else:
		player_turn = false

func set_player_turn():
	await get_tree().create_timer(1).timeout 
	if is_instance_valid(Player):
		Player.player_turn()
	else:
		print("Game Over")
		end_level()

#Updates the cell_empty for nodes that an enemy is occupying
func enemy_location(old_position, new_position):
	Map.set_cell_empty(old_position, new_position)
	
func end_level():
	Map.queue_free()
	Player.queue_free()
	map_number += 1
	level_over = true

#Turns on the reset button
func game_over():
	ResetButton.visible = true
#Reset Button Clicked
func _on_restart_button_pressed() -> void:
	ResetButton.visible = false
	reset_game()
#Resets the game
func reset_game():
	EnemyHandler.game_over()
	Map.queue_free()
	map_number = 1
	level_over = true
	
func start_level(map_number: int):
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
	EnemyHandler.spawn_enemies(Map.enemy_spawn)
