extends Iluminable
class_name Hacha

@export var fire_seconds: float = 5.0:
	set(value):
		fire_seconds = max(value,0.0)
		light_radius = max(value,0.0) * grow_multiplier

@export var reload_seconds: float = 30.0
@export var grow_multiplier: float = 5.0

func reload() -> void:
	fire_seconds = reload_seconds

func _physics_process(delta: float) -> void:
	fire_seconds -= delta
