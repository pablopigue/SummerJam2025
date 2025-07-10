extends CharacterBody2D


@onready var player = get_node("/root/game/Player")
@onready var sprite = $AnimatedSprite2D

func _ready():
	$AnimatedSprite2D.play("play_walk")

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	position+=direction*150.0*delta
	if(direction.x < 0):
		sprite.flip_h = true
	else:
		sprite.flip_h = false

#region morir
signal died(enemy_instance)

func die():
	died.emit(self)
	queue_free()

#endregion
