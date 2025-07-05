extends CharacterBody2D

var gravity=10
var speed= 25
var moving_right = false

func _ready() -> void:
	%AnimationPlayer.play("Walk")

func _process(delta: float) -> void:
	move_character()
	turn()
	
func move_character():
	velocity.y+=gravity
	if(moving_right):
		velocity.x=-speed
	else:
		velocity.x=speed
	
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		get_tree().reload_current_scene()

func turn():
	if not $Area2D/RayCast2D.is_colliding():
		moving_right = !moving_right
		scale.x= -scale.x
