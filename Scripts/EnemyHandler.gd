extends Node

var enemies_finished = 0

var enemy_amount = 0

var enemy_prefab = preload("res://Prefabs/enemy.tscn")

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
	if(enemy_amount <= 0):
		get_parent().end_level()
		
#Sets the cell_empty = false for every enemy position
#this is called once at the start of the game and then every enemy move
#Current location is used to set the old cell to empty when the enemy moves
#New location is used to set the new cell to not empty

func enemy_locations(current_location, new_location):
	for child in get_children():
		get_parent().enemy_location(current_location, new_location)
		
func spawn_enemies(spawn_locations: Array):
	enemies_finished = 0
	enemy_amount = 0
	for location in spawn_locations:
		enemy_amount += 1
		var enemy = enemy_prefab.instantiate()
		add_child(enemy)
		enemy.position = location.position
		
func tank_destroyed():
	enemy_amount -= 1

func game_over():
	for child in get_children():
		child.queue_free()
