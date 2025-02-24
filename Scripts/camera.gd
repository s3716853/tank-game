extends Node

func recenter(map : TileMapLayer):
	var map_width = float(map.grid_width)
	var map_height = float(map.grid_height)
	
	var world_scale = map.map_to_local(Vector2(map_width, map_height))
	
	#Set position to be in the center of the map
	#The -30 fixes an offsetting issue. Can't work out why but the camera was
	#slightly off center
	self.global_position = Vector2((world_scale.x-30)/2, (world_scale.y-30)/2)
	
	#Finds which axis to scale on
	var largest_side
	if(map_width >= map_height):
		largest_side = map_width
	else:
		largest_side = map_height
		
	#8 is the default size of the first map, so we scale based on that
	var amount = largest_side - 8
	#0.0277 works for scaling the correct amount
	var factor = 0.032 * amount
	self.zoom = Vector2(1.25 - factor,1.25 - factor)
