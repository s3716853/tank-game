extends Node

@export var EnemyHandler : Node2D
@export var Player : Node2D

#Called when the player has no actions remaining
#Tells the Enemy Handler node that its the enemies' turn
func set_enemy_turn():
	EnemyHandler.enemy_turn()

func set_player_turn():
	Player.player_turn()
