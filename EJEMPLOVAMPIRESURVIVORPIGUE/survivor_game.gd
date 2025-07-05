extends Node2D

func _ready():
	spawn_mob()


func spawn_mob():
	var new_mob = preload("res://mob.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)


func _on_timer_timeout():
	var overlapping_bodies = $"Player/Spawn control".get_overlapping_bodies()
	
	if(overlapping_bodies.size() < 15):
		spawn_mob()


func _on_player_health_depelted():
	%GameOver.visible = true
	get_tree().paused = true
