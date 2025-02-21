extends Node

#When an arrow is clicked, a signal is sent to the parent (The main player object).
#This sets the shooting direction and then shoots

func _on_up_pressed() -> void:
	get_parent().shoot(Vector2.UP)
	self.visible = false
func _on_right_pressed() -> void:
	get_parent().shoot(Vector2.RIGHT)
	self.visible = false
func _on_down_pressed() -> void:
	get_parent().shoot(Vector2.DOWN)
	self.visible = false
func _on_left_pressed() -> void:
	get_parent().shoot(Vector2.LEFT)
	self.visible = false
