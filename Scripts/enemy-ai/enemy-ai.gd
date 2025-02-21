extends Object
class_name EnemyAi

enum DIRECTIONS {LEFT, RIGHT, UP, DOWN}
enum ACTIONS {SHOOT, MOVE}

func decide_action(map : Array[Array], ai_coord : Vector2i, player_coord: Vector2i):
	var coord_diff = ai_coord - player_coord
	
#	Checking if player and AI share a X/Y meaning a shot could be made
	var shoot_check_move_vector = null
	var shoot_direction = null
	if(coord_diff.y == 0):
		if(coord_diff.x < 0):
			shoot_check_move_vector = Vector2i(1,0)
			shoot_direction = DIRECTIONS.RIGHT
		elif(coord_diff.x > 0):
			shoot_check_move_vector = Vector2i(-1,0)
			shoot_direction = DIRECTIONS.LEFT
	elif(coord_diff.x == 0):
		if(coord_diff.y < 0):
			shoot_check_move_vector = Vector2i(0,1)
			shoot_direction = DIRECTIONS.DOWN
		elif(coord_diff.y > 0):
			shoot_check_move_vector = Vector2i(0,-1)
			shoot_direction = DIRECTIONS.UP
	
#	Check if there is an obstruction bewteen AI and player getting in way of shot  
#   if nothing is in the way, return information for shot
	var shot_obstructed = false
	if(shoot_check_move_vector != null):
		var current_check_vector = ai_coord + shoot_check_move_vector
		while(!shot_obstructed and current_check_vector != player_coord):
			shot_obstructed = check_obstruction(map, current_check_vector)
			current_check_vector = current_check_vector + shoot_check_move_vector
		if(!shot_obstructed):
			return {
				"action": ACTIONS.SHOOT,
				"direction": shoot_direction
			}
			
#	Can't shoot, so time to figure out what movement should be made
	if(shoot_check_move_vector == null or shot_obstructed):
#		TODO
		return null
		
func check_obstruction(map : Array[Array], coord : Vector2i):
#	TODO
	return false
