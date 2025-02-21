extends Node

@export var EnemyHandler : Node2D
@export var Player : Node2D
@export var Map : TileMapLayer
@export var UI : CanvasLayer
#Called when the player has no actions remaining
#Tells the Enemy Handler node that its the enemies' turn
func set_enemy_turn():
	UI.visible = false
	await get_tree().create_timer(1).timeout 
	EnemyHandler.enemy_turn(Map, Map.local_to_map(Player.target_location))

func set_player_turn():
	await get_tree().create_timer(1).timeout 
	UI.visible = true
	Player.player_turn()

#Updates the cell_empty for nodes that an enemy is occupying
func enemy_location(old_position, new_position):
	Map.set_cell_empty(old_position, new_position)
