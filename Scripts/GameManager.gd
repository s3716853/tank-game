extends Node

@export var EnemyHandler : Node2D
@export var Player : Node2D
@export var Map : TileMapLayer

#Called when the player has no actions remaining
#Tells the Enemy Handler node that its the enemies' turn
func set_enemy_turn():
	EnemyHandler.enemy_turn(Map, map.local_to_map(Player.position))

func set_player_turn():
	Player.player_turn()

#Updates the cell_empty for nodes that an enemy is occupying
func enemy_location(old_position, new_position):
	Map.set_cell_empty(old_position, new_position)
