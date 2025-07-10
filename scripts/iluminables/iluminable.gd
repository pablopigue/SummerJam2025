extends Node2D
class_name Iluminable

## Script simplificado que solo controla la luz y el área de detección.
@export_group("Luz y Área")
# El radio visual de la luz y del área segura.
@export var light_radius : float = 200.0:
	set(value):
		light_radius = value
		update_light_and_area()

# El color principal de la luz (en el centro del degradado).
@export var light_color : Color = Color.LEMON_CHIFFON:
	set(value):
		light_color = value
		update_light_and_area()

# El color general de la luz en la zona iluminada
@export var general_color : Color = Color.DARK_GOLDENROD:
	set(value):
		light_color = value
		update_light_and_area()

# El color del borde de la luz (debe ser transparente para un degradado suave).
@export var border_color : Color = Color.DIM_GRAY:
	set(value):
		border_color = value
		update_light_and_area()

# Referencias a los nodos hijos
@onready var light: PointLight2D = $Light
@onready var safe_zone: Area2D = $SafeZone
@onready var collision_shape: CollisionShape2D = $SafeZone/CollisionShape2D

func _ready():
	update_light_and_area()
	# Conectamos las señales una sola vez para la detección del jugador.
	safe_zone.body_entered.connect(func(body): _on_body_entered(body))
	safe_zone.body_exited.connect(func(body): _on_body_exited(body))

# Actualiza todo lo relacionado con la luz y el área.
func update_light_and_area():
	if not is_node_ready():
		return

	# 1. Actualiza el PointLight2D
	light.color = light_color
	# La escala de la textura controla el tamaño visual de la luz.
	light.texture_scale = light_radius / (light.texture.get_width() / 2.0)
	
	# Actualiza los colores del degradado en la textura de la luz
	var gradient: Gradient = light.texture.gradient
	if gradient:
		# Asegúrate de que el gradiente tiene al menos 2 puntos de color
		if gradient.get_point_count() >= 2:
			gradient.set_color(0, light_color)
			gradient.set_color(1, general_color)
			gradient.set_color(2, border_color)
			gradient.set_color(3, Color.BLACK)

	# 2. Actualiza el CollisionShape2D para que coincida
	if not collision_shape.shape:
		collision_shape.shape = CircleShape2D.new()
	(collision_shape.shape as CircleShape2D).radius = light_radius

# --- Lógica de detección del jugador ---
func _on_body_entered(body: Node2D):
	if body.has_method("on_light_zone_entered"):
		body.on_light_zone_entered()

func _on_body_exited(body: Node2D):
	if body.has_method("on_light_zone_exited"):
		body.on_light_zone_exited()
