extends CanvasLayer

func _on_hud_winner():
	visible=true
	%MusicaInicio.stop()
	$AudioStreamPlayer.play()
	get_tree().paused = true 
