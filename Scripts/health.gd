extends Node

@export var health = 3

#Deal damage equal to the amount
func damage(amount):
	health -= amount
	
	#Iterates over each child and turns off the correct amount of hearts when damaged
	var i = 0
	for heart in get_children():
		if(health < i + 1):
			heart.visible = false
		i += 1
	#Check if they are dead
	if(health <= 0):
		get_parent().tank_destroyed()
#Keeps the hearts rotated correctly
func _process(_delta):
	self.global_rotation = 0.0
