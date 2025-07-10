extends Label
@onready var fogata = get_node ("../../../Fogata")
@onready var label: Label = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var time = fogata.fire_seconds
	var truncado = int (time)
	label.text = str(truncado) + " s"
	
