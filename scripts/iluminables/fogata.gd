extends Iluminable
class_name Fogata

@export var fire_seconds: float = 5.0:
	set(value):
		fire_seconds = max(value,0.0)
		light_radius = max(value,0.0) * grow_multiplier


@onready var fuego: AnimatedSprite2D = $Fuego


@export var fire_color: Color = Color.WHITE
@export var grow_multiplier: float = 5.0

func _ready() -> void:
	update_fire_color(light_color, general_color)

func update_fire_color(first: Color, second: Color) -> void:
	fire_color = first
	light_color = first
	general_color = second
	fuego.modulate = fire_color

func add_fire_seconds(seconds: float) -> void:
	fire_seconds += seconds

func _physics_process(delta: float) -> void:
	fire_seconds -= delta
	if(fire_seconds == 0.0):
		gameover()

func gameover() -> void:
	fuego.hide()
	get_tree().change_scene_to_file("res://loose.tscn")
