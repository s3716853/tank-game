extends Node

@export var EnemyHandler : Node2D
@export var Player : Node2D
@export var Map : TileMapLayer

var map_folder = "res://Scenes/Maps/"
var player_prefab = preload("res://Prefabs/player.tscn")
#Called when the player has no actions remaining
#Tells the Enemy Handler node that its the enemies' turn
func _ready():
	Player = player_prefab.instantiate()
	add_child(Player)
	start_level()

func set_enemy_turn():
	await get_tree().create_timer(1).timeout 
	EnemyHandler.enemy_turn(Map, Map.local_to_map(Player.target_location))

func set_player_turn():
	await get_tree().create_timer(1).timeout 
	if is_instance_valid(Player):
		Player.player_turn()
	else:
		print("Game Over")
		set_map("map")

#Updates the cell_empty for nodes that an enemy is occupying
func enemy_location(old_position, new_position):
	Map.set_cell_empty(old_position, new_position)
	
func set_map(map_number: String):
	var new_map = load(map_folder + map_number + ".tscn")
	Map.queue_free()
	Map = new_map.instantiate()
	add_child(Map)
	start_level()
	
func start_level():
	Player.position = Map.player_spawn.position
	Player.map = Map
	Map.player = Player
	EnemyHandler.spawn_enemies(Map.enemy_spawn)
