extends Area2D

signal gemCollected
var once = true

func _on_body_entered(body):
	if(body.name == "Player" and once):
		emit_signal("gemCollected")
		$AudioStreamPlayer.playing = true
		once=false
		visible=false
		await get_tree().create_timer(1.1).timeout
		get_parent().queue_free()
