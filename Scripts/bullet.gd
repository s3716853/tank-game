extends Node

#How much damage does the bullet do
@export var damage_amount = 1

#Hit mark that spawns when the bullet hits a tank
var hit = preload("res://Prefabs/hit.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(self.rotation)  # Local forward direction
	self.position += direction * 1000 * delta  # Move forward


func _on_area_2d_area_entered(area: Area2D) -> void:
	if(area.get_parent() != get_parent()):
		if(area.is_in_group("Enemy")):
			area.get_parent().hurt(damage_amount)
			#Spawn a hit effect
			var h = hit.instantiate()
			get_parent().add_child(h)
			h.global_position = self.global_position
			h.global_rotation = self.global_rotation
			#Delete the bullet
			queue_free()
		if(area.is_in_group("Player")):
			area.get_parent().hurt(damage_amount)
			#Spawn a hit effect
			var h = hit.instantiate()
			get_parent().add_child(h)
			h.global_position = self.global_position
			h.global_rotation = self.global_rotation
			#Delete the bullet
			queue_free()
			

#called when hitting tilemap wall
func _on_area_2d_body_entered(body):
	var h = hit.instantiate()
	get_parent().add_child(h)
	h.global_position = self.global_position
	h.global_rotation = self.global_rotation
	#Delete the bullet
	queue_free()
