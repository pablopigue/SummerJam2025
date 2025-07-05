extends CanvasLayer  # Para UI fija en pantalla

@onready var flame_indicator = $llamita  # La escena completa o nodo Sprite
@onready var player = get_node("../Player")
@onready var camera = get_node("../Player/Camera2D2")
@onready var hoguera = get_node("../fogata")

func _process(delta):
	var viewport_size_i = get_viewport().size  # Vector2i (enteros)
	var viewport_size = Vector2(viewport_size_i.x, viewport_size_i.y)  # convertir a Vector2 (floats)

	var hoguera_pos = hoguera.global_position
	var camera_pos = camera.global_position

	var relative_pos = hoguera_pos - camera_pos
	var screen_pos = relative_pos + viewport_size / 2

	var on_screen = screen_pos.x >= 0 and screen_pos.x <= viewport_size.x and screen_pos.y >= 0 and screen_pos.y <= viewport_size.y

	if on_screen:
		flame_indicator.visible = false
	else:
		flame_indicator.visible = true

		var center = viewport_size / 2
		var dir = (screen_pos - center).normalized()

		var pos = get_position_on_screen_edge(dir, viewport_size)

		var margin = 15  # margen para que no se salga la imagen

		pos.x = clamp(pos.x, margin, viewport_size.x - margin)
		pos.y = clamp(pos.y, margin, viewport_size.y - margin)

		flame_indicator.position = pos

		# Solo espejo horizontal, sin rotación
		flame_indicator.scale.x = -1 if dir.x < 0 else 1


func get_position_on_screen_edge(dir: Vector2, viewport_size: Vector2) -> Vector2:
	var rect_min = Vector2(0, 0)
	var rect_max = viewport_size
	var center = viewport_size / 2

	var points = []

	# Intersección con el borde izquierdo (x = 0)
	var t = (rect_min.x - center.x) / dir.x if dir.x != 0 else INF
	if t > 0:
		var y = center.y + dir.y * t
		if y >= rect_min.y and y <= rect_max.y:
			points.append(Vector2(rect_min.x, y))

	# Intersección con el borde derecho (x = max.x)
	t = (rect_max.x - center.x) / dir.x if dir.x != 0 else INF
	if t > 0:
		var y = center.y + dir.y * t
		if y >= rect_min.y and y <= rect_max.y:
			points.append(Vector2(rect_max.x, y))

	# Intersección con el borde superior (y = 0)
	t = (rect_min.y - center.y) / dir.y if dir.y != 0 else INF
	if t > 0:
		var x = center.x + dir.x * t
		if x >= rect_min.x and x <= rect_max.x:
			points.append(Vector2(x, rect_min.y))

	# Intersección con el borde inferior (y = max.y)
	t = (rect_max.y - center.y) / dir.y if dir.y != 0 else INF
	if t > 0:
		var x = center.x + dir.x * t
		if x >= rect_min.x and x <= rect_max.x:
			points.append(Vector2(x, rect_max.y))

	if points.size() == 0:
		return center

	var min_distance = INF
	var closest_point = center
	for p in points:
		var dist = (p - center).length()
		if dist < min_distance:
			min_distance = dist
			closest_point = p

	return closest_point
