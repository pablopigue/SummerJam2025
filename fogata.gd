extends Node2D

@onready var area_ilumin = %areaIlumin
var shrink_speed := 0.5  # Unidades por segundo

func _process(delta):
	var current_scale = area_ilumin.scale
	if current_scale.x > 0.1 and current_scale.y > 0.1:
		var new_scale = current_scale - Vector2.ONE * shrink_speed * delta
		area_ilumin.scale = Vector2(
		max(new_scale.x, 0.1),
		max(new_scale.y, 0.1)
		)
