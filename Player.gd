extends KinematicBody2D

const TARGET_FPS = 60
const ACCELERATION = 8
const MAX_SPEED = 80
const FRICTION = 30
const GRAVITY = 10
const JUMP_FORCE = 210

var motion = Vector2.ZERO

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer

func _ready():
	pass

func _physics_process(delta):
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	# var is_falling = motion.y > 0.0 and not is_on_floor()
	# var is_jumping = Input.is_action_just_pressed("ui_accept") and is_on_floor()
	# var is_double_jumping = Input.is_action_just_pressed("ui_accept") and is_falling
	# var is_jump_cancelled = Input.is_action_just_released("ui_accept") and motion.y < 0.0
	# var is_idling = is_on_floor() and is_zero_approx(motion.x)
	# var is_running = is_on_floor() and not is_zero_approx(motion.x)

	if x_input != 0:
		sprite.flip_h = x_input < 0
		motion.x += x_input * ACCELERATION * delta * TARGET_FPS
		animationPlayer.play("Run")

		if x_input > 0:
			motion.x = clamp(motion.x, 0, MAX_SPEED)
		elif x_input < 0:
			motion.x = clamp(motion.x, -MAX_SPEED, 0)
	else:
		animationPlayer.play("Idle")

	motion.y += GRAVITY * delta * TARGET_FPS

	if is_on_floor():
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION * delta)

		if Input.is_action_just_pressed("ui_accept"):
			motion.y = -JUMP_FORCE
	else:
		animationPlayer.play("Jump")

		if Input.is_action_just_released("ui_accept") and motion.y < 0:
			motion.y = -25

		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION * delta)

	motion = move_and_slide(motion, Vector2.UP)
