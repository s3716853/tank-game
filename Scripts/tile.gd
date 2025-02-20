extends Node2D

var cell_empty
var location

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
