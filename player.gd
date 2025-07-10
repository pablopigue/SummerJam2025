extends CharacterBody2D

@export var speed = 200.0
@export var health: float = 100.0
@export var damage_multiplier: float = 10.0
@export var roll_speed = 400.0       
@export var roll_duration = 0.3       
@export var roll_cooldown = 1.0       
@onready var hacha: Hacha = $Hacha

var is_rolling = false
var roll_timer = 0.0
var roll_cooldown_timer = 0.0

var last_direction = Vector2.RIGHT  

var is_scared = false
var sonidopasos = false

var footstep_delay = 0.5
var footstep_timer = 0.0

var num_items = 0
var tengo_plutonio=false

var first_time = true
var getting_damage=false

var cough_timer := 0.0


func _ready():
	randomize()

func _physics_process(delta):
		
	footstep_timer -= delta

	if roll_timer > 0:
		roll_timer -= delta
		if roll_timer <= 0:
			is_rolling = false

	if roll_cooldown_timer > 0:
		roll_cooldown_timer -= delta
		
		
	var input_vector = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()

	# Si se mueve, actualizamos la dirección en la que "mira"
	if input_vector != Vector2.ZERO:
		last_direction = input_vector
		# Animación de caminar
		
		if is_rolling:
			footstep_delay = 0.2
		else:
			footstep_delay = 0.5
		
		if getting_damage:
			pass
		elif is_scared and not getting_damage:
			$AnimatedSprite2D.play("scare")
		else:
			$AnimatedSprite2D.play("walk")
			if sonidopasos:
				if not $SonidoPasos2.playing and footstep_timer <= 0.0:
					$SonidoPasos1.play()
					sonidopasos = !sonidopasos
					footstep_timer = footstep_delay
			else:
				if not $SonidoPasos1.playing and footstep_timer <= 0.0:
					$SonidoPasos2.play()
					sonidopasos = !sonidopasos
					footstep_timer = footstep_delay
			

		# Aumentar velocidad de animación asi está "rodando"
		if is_rolling:
			$AnimatedSprite2D.speed_scale = 2.0
		else:
			$AnimatedSprite2D.speed_scale = 1.0  
		if input_vector.x < 0:
			$AnimatedSprite2D.flip_h = false  # Mira a la izquierda
			$Hacha/AnimatedSprite2D.flip_h=false
			if not first_time:
				$Hacha.position.x -=38
				$Hacha.position.y -=9
				$Hacha.rotate(-190)
				first_time = true
		elif input_vector.x > 0:
			$AnimatedSprite2D.flip_h = true   # Mira a la derecha
			$Hacha/AnimatedSprite2D.flip_h=true
			if first_time:
				$Hacha.position.x +=38
				$Hacha.position.y +=9
				$Hacha.rotate(190)
				first_time = false
			
	else:
		# Si no hay movimiento, detiene animación
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.speed_scale = 1.0 

	var velocity = input_vector * speed
	if is_rolling:
		velocity = last_direction.normalized() * roll_speed
		
	set_velocity(velocity)
	move_and_slide()
	
	if Input.is_action_just_pressed("roll") and not is_rolling and roll_cooldown_timer <= 0:
		
		start_roll()

	if Input.is_action_just_pressed("attack") and not is_rolling:
		attack_in_direction(last_direction)

func _process(delta: float) -> void:
	if(hacha.fire_seconds == 0):
		health -= delta * damage_multiplier
		getting_damage=true
		$AnimatedSprite2D.play("damage")
		cough_timer += delta
		if cough_timer >= 1.5:
			$tos.play()
			cough_timer = 0.0
		if health <= 0.0:
			get_tree().change_scene_to_file("res://loose.tscn")
	else:
		getting_damage=false
		cough_timer = 1.5
func start_roll():
	is_rolling = true
	roll_timer = roll_duration
	roll_cooldown_timer = roll_cooldown
	
func attack_in_direction(direction: Vector2):
	var attack_scene = preload("res://attack_area.tscn")
	var attack = attack_scene.instantiate()
	attack.position = direction.normalized() * 30  
	attack.rotation = direction.angle()
	add_child(attack)


func _on_pick_up_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("recogibles"):
		pick_up_item(area)


func pick_up_item(item: Area2D) -> void:
	if item.get_parent().is_in_group("branch"):
		num_items+=1
		$pickupsound.play()
	elif item.get_parent().is_in_group("grandma"):
		num_items+=2
		$pickupsound.play()
	elif item.get_parent().is_in_group("fuel"):
		num_items+=5
		$pickupsound.play()
	else:
		tengo_plutonio=true
		$plutoniumsound.play()
	
	item.get_parent().queue_free() 


func _on_scare_timer_timeout() -> void:
	if randi()%2:
		play_scare_animation()
	
	
func play_scare_animation():
	if is_scared or is_rolling:
		return 

	is_scared = true
	$AnimatedSprite2D.play("scare")
	$Grito.play()
	
	await get_tree().create_timer(1.0).timeout  
	is_scared = false


func _on_dejar_items_body_entered(body: Node2D) -> void:
	if body.is_in_group("body_fogata"):
		var fogata: Fogata = body.get_parent()
		
		# Añadir objetos a la fogata
		fogata.add_fire_seconds(num_items)
		num_items = 0
		if tengo_plutonio:
			get_tree().change_scene_to_file("res://win.tscn")
		
		# Recargar hacha
		hacha.reload()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if(body.is_in_group("enemies")):
		hacha.fire_seconds-=5
		body.die()
