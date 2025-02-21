extends Node2D

# bool that shows if tile has an obstacle inside or not
var cell_empty

# Vector2i that is the tiles location on the map
var location

# number that describes the tile's proximity to a straight shot on the player
var heuristic

var mouse_over = false
#Mouse is hovering over
#Used for checking if the mouse is clicked whilst hovering over
func _on_area_2d_mouse_entered() -> void:
	mouse_over = true
func _on_area_2d_mouse_exited() -> void:
	mouse_over = false
#If the mouse is hovering over the current node and is clicked then send a signal to move the tank
func _input(event):
	if(mouse_over):
		if event is InputEventMouseButton:
			if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
				get_parent().tile_clicked(location)
