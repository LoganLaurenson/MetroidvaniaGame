extends CharacterBody2D

@onready var animation = $AnimationPlayer
@onready var jump_height_timer = $JumpHeightTimer
@onready var coyote_timer = $CoyoteTimer
const SPEED = 450.0
const JUMP_VELOCITY = -550.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor || !coyote_timer.is_stopped():
		jump_height_timer.start() 
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	if Input.is_action_pressed("Left"):
		animation.play("Attack_left")
	elif Input.is_action_pressed("Right"):
		animation.play("Attack_right")


func _on_jump_height_timer_timeout() -> void:
	if !Input.is_action_pressed("Jump"):
		if velocity.y < -100:
			velocity.y = -100
			print("Low Jump")
	else:
		print("High Jump")
	
	var was_on_floor = is_on_floor()
	
	if was_on_floor && !is_on_floor():
		coyote_timer.start()
