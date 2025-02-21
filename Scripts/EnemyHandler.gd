extends Node

var enemies_finished = 0

#Check if all enemies have finished their turn, if they have change to the player's turn
func enemy_finished():
	enemies_finished += 1
	if(enemies_finished == get_child_count()):
		enemies_finished = 0
		get_parent().set_player_turn()


func enemy_turn():
	for child in get_children():
		child.actions_remaining = child.max_actions
		child.action_choice()
