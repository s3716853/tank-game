extends Node2D

# bool that shows if tile has an obstacle inside or not
var cell_empty

# Vector2i that is the tiles location on the map
var location

# number that describes the tile's proximity to a straight shot on the player
var heuristic

var mouse_over = false

#How much bigger should the tile get when hovering over
var hover_scale = 1.3
#Mouse is hovering over
#Used for checking if the mouse is clicked whilst hovering over
func _on_area_2d_mouse_entered() -> void:
	mouse_over = true
	t = 0
func _on_area_2d_mouse_exited() -> void:
	mouse_over = false
	t = 0

#Makes the tile slightly bigger when hovering over
var t = 0
func _process(delta: float) -> void:
	if(mouse_over and get_child(0).scale != Vector2(hover_scale,hover_scale)):
		t += delta
		get_child(0).scale = get_child(0).scale.lerp(Vector2(hover_scale,hover_scale), t)
	elif(!mouse_over and get_child(0).scale != Vector2(1,1)):
		t += delta
		get_child(0).scale = get_child(0).scale.lerp(Vector2(1,1), t)
		
#If the mouse is hovering over the current node and is clicked then send a signal to move the tank
func _input(event):
	if(mouse_over):
		if event is InputEventMouseButton:
			if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
				get_parent().tile_clicked(location)
