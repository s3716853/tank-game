extends Node

var enemies_finished = 0


#Check if all enemies have finished their turn, if they have change to the player's turn
func enemy_finished():
	enemies_finished += 1
	if(enemies_finished == get_child_count()):
		enemies_finished = 0
		get_parent().set_player_turn()


func enemy_turn(map, player_coord: Vector2):
	for child : EnemyMain in get_children():
		child.actions_remaining = child.max_actions
		child.map = map
		child.player_coord = player_coord
		child.action_choice()

func _process(delta: float) -> void:
	#If there are no enemy tanks remaining then the player wins
	if(get_child_count() == 0):
		print("YOU WIN!")
		
#Sets the cell_empty = false for every enemy position
#this is called once at the start of the game and then every enemy move
#Current location is used to set the old cell to empty when the enemy moves
#New location is used to set the new cell to not empty

func enemy_locations(current_location, new_location):
	for child in get_children():
		get_parent().enemy_location(current_location, new_location)
