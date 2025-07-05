extends CharacterBody2D

const MOVESPEED=25
const MAXSPEED=150

const JUMPHEIGHT= -210
const UP= Vector2(0,-1)
const GRAVITY=9

@onready var sprite= %SpritePlayer
@onready var animationPlayer= %AnimationPlayer

var motion = Vector2()

func _physics_process(delta):
	motion.y += GRAVITY
	var friction = false
	
	if Input.is_action_pressed("MOVERIGHT"):
		sprite.flip_h=true
		animationPlayer.play("Walk")
		motion.x= min(motion.x + MOVESPEED,MAXSPEED)
	elif Input.is_action_pressed("MOVELEFT"):
		sprite.flip_h=false
		animationPlayer.play("Walk")
		motion.x= max(motion.x - MOVESPEED,-MAXSPEED)
		
	else:
		animationPlayer.play("Stop")
		motion.x=0
		
	
	if is_on_floor():
		if Input.is_action_pressed("MOVEUP"):
			motion.y = JUMPHEIGHT
		if friction == true:
			motion.x = lerp(motion.x,0,0.5)
	
	else:
		if friction == true:
			motion.x = lerp(motion.x,0,0.01)
	velocity = motion
	
	move_and_slide()
