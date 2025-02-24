extends Node

#Explosion remenants for the ground
var destroyed = preload("res://Prefabs/Effects/destroyed_decal.tscn")
func _on_animated_sprite_2d_animation_finished() -> void:
	var d = destroyed.instantiate()
	get_tree().root.get_child(0).find_child("Decals").add_child(d)
	d.global_position = self.global_position
	queue_free()
