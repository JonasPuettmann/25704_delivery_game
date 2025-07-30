extends CharacterBody2D


const SPEED = 300.0
const MAX_JUMP_VELOCITY = -800.0
var jump_height = 0
var floor_timer = 0

@onready var anim : AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if floor_timer > 0:
			floor_timer -= delta * 10
			#print(floor_timer)
	else:
		if abs(velocity.x) > 10:
			anim.play("walking")
		else:
			anim.play("default")
		floor_timer = 1
	if velocity.x > 10:
		anim.flip_h = false
	if velocity.x < -10:
		anim.flip_h = true

	# Handle jump.
	
	if Input.is_action_pressed("ui_accept"):
		jump_height -= delta * 400
		#print(jump_height)
		if jump_height < MAX_JUMP_VELOCITY:
			jump_height = MAX_JUMP_VELOCITY
		if jump_height > -200:
			jump_height = -200
	
	if Input.is_action_just_released("ui_accept") and is_on_floor() or Input.is_action_just_released("ui_accept")and floor_timer > 0:
		velocity.y = jump_height
		jump_height = 0
		floor_timer = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
