extends Node

#All buttons. Turn off during enemy turns
@export var UI_buttons : CanvasLayer
#Move and Shoot buttons
@export var action_buttons : Control
#Cancel button
@export var cancel_button : Control

var bullet = preload("res://Prefabs/bullet.tscn")
@export var bullet_spawn = Node2D
#Node handling the tiles which can be moved to
var map = Node2D
#Child node containing the arrow buttons to choose which direction to shoot
@export var arrows : Node2D
#Turret child, used to set the direction of the turret for shooting
@export var turret : Node2D
#How many actions does the player get each turn
var max_actions = 3
#How many current actions remain
var actions_remaining

#Location where the player should move to
var target_location

#Used for rotating the turret
var turret_rotated = true
#Direction turret should rotate
var direction = Vector2.RIGHT
#Used for rotating the body
var body_rotated = true
#Direction body should rotate
var body_direction = Vector2.RIGHT

func _ready():
	actions_remaining = max_actions
	
var t = 0
var t2 = 0
func _process(delta: float) -> void:
	#Move towards desired location over time
	if(self.global_position != target_location and target_location != null and body_rotated):
		t += delta * 0.1
		self.global_position = self.global_position.lerp(target_location, t)
		#If player is close to the desired location, snap to location
		if(self.global_position.distance_to(target_location) <= 0.1):
			self.global_position = target_location
			action_taken()
	# Rotate turret smoothly
	if(!turret_rotated):
		t2 += delta * 0.3  # Adjust speed for smoother rotation
		# Lerp rotation towards target angle
		turret.rotation = lerp_angle(turret.rotation, direction.angle(), t2)
		# Normalize the angle difference to be within -PI to PI
		var angle_diff = fposmod(turret.rotation - direction.angle() + PI, 2 * PI) - PI
		if abs(angle_diff) < 0.1:  # Small threshold to stop jitter  # Small threshold to stop jitter
			turret.rotation = direction.angle()
			turret_rotated = true
			shoot()
			
	#Rotate body smoothly
	if(!body_rotated):
		# Get the angle the turret should face
		var target_angle = (target_location - self.global_position).angle()
		# Calculate angle difference
		var angle_diff = fposmod(self.rotation - target_angle + PI, 2 * PI) - PI
		# If not facing the target, lerp towards it
		if abs(angle_diff) > 0.1:  # Small threshold to stop jitter
			self.rotation = lerp_angle(self.rotation, target_angle, delta * 5)  # Adjust speed factor
		else:
			self.rotation = target_angle  # Snap to exact angle when close
			body_rotated = true
#Hurt Tank
#Sends signal to child which handles the tank health
func hurt(amount):
	find_child("Health").damage(amount)

#Move button pressed
func _on_move_button_pressed() -> void:
	#Turns off buttons so only one action can be taken
	UI_change(true,false,true)
	#Work out which nodes are moveable
	map.find_moveable_tiles(self.global_position)

#Set move location to node position and then move over time in func _process
func move(location):
	target_location = location
	t = 0
	body_rotated = false
#Shoot button sends signal here
func _on_shoot_button_pressed() -> void:
	arrows.visible = true
	#Turns off buttons so only one action can be taken
	UI_change(true,false, true)
#Shoots bullet
func shoot():
	#Spawning bullet and setting it to shoot from the "BulletSpawn" position
	var b = bullet.instantiate()
	add_child(b)
	b.global_position = bullet_spawn.global_position
	b.global_rotation = turret.global_rotation
	action_taken()
	
#Called once an action is taken
func action_taken():
	get_parent().player_turn = false
	actions_remaining -= 1
	#If no actions remain then end the turn
	if(actions_remaining == 0):
		get_parent().set_enemy_turn()
	else:
		#Turns on action buttons
		UI_change(true, true, false)	
#Rotate turret smootly
func rotate_turret(d):
	t2 = 0
	direction = d
	turret_rotated = false
#Called to set the turn to the player's
func player_turn():
	actions_remaining = max_actions
	#Turns on action buttons
	UI_change(true,true,false)
	
func tank_destroyed():
	print("You Lose")
	queue_free()
	
#Turn UI on/off
func UI_change(canvas, action, cancel):
	UI_buttons.visible = canvas
	action_buttons.visible = action
	cancel_button.visible = cancel

#Cancel action
func _on_cancel_button_pressed() -> void:
	UI_change(true,true,false)
	#Turn off shoot arrows
	arrows.visible = false
	#Turn off moveable tiles
	map.moveable_visibility(false)
