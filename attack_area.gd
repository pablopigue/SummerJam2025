extends Area2D


func _ready():
	$Timer.start()
 

func _on_body_entered(body):
	#if body.is_in_group("enemies"):
		#body.take_damage()
	pass

func _on_timer_timeout() -> void:
		queue_free()
