extends KinematicBody2D

const TARGET_FPS = 60
const ACCELERATION = 12
const SLIDE_ACCELERATION = 100
const MAX_SPEED = 80
const SLIDE_SPEED = 180
const SLIDE_TIMER = 0.43
const FRICTION = 30
const GRAVITY = 10
const JUMP_FORCE = 210

var motion = Vector2.ZERO

enum STATES {
	run,
	slide
}
var currentState = STATES.run

var currentSlideTimer = 0
var currentShootTimer = 0

onready var animatedSprite = $AnimatedSprite
onready var normalCollisionShape = $NormalCollisionShape
onready var slideCollisionShape = $SlideCollisionShape
onready var slideRaycastLeft = $SlideRaycastLeft
onready var slideRaycastRight = $SlideRaycastRight

func _ready():
	pass

func _physics_process(delta):
	# var is_falling = motion.y > 0.0 and not is_on_floor()
	# var is_jumping = Input.is_action_just_pressed("ui_accept") and is_on_floor()
	# var is_double_jumping = Input.is_action_just_pressed("ui_accept") and is_falling
	# var is_jump_cancelled = Input.is_action_just_released("ui_accept") and motion.y < 0.0
	# var is_idling = is_on_floor() and is_zero_approx(motion.x)
	# var is_running = is_on_floor() and not is_zero_approx(motion.x)

	if (currentState == STATES.run): _runMovement(delta)
	if (currentState == STATES.slide): _slideMovement(delta)

func _runMovement(delta):
	normalCollisionShape.disabled = false
	slideCollisionShape.disabled = true
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	if x_input != 0:
		animatedSprite.flip_h = x_input < 0
		motion.x += x_input * ACCELERATION * delta * TARGET_FPS
		animatedSprite.play("Run")

		if x_input > 0:
			motion.x = clamp(motion.x, 0, MAX_SPEED)
		elif x_input < 0:
			motion.x = clamp(motion.x, -MAX_SPEED, 0)
	else:
		animatedSprite.play("Idle")

	motion.y += GRAVITY * delta * TARGET_FPS

	if is_on_floor():
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION * delta)

		if Input.is_action_just_pressed("ui_jump"):
			motion.y = -JUMP_FORCE
			
		if Input.is_action_just_pressed("ui_shoot"):
			print("shoot")

		if Input.is_action_just_pressed("ui_slide"):
			motion = Vector2.ZERO
			currentState = STATES.slide
	else:
		animatedSprite.play("Jump")

		if Input.is_action_just_released("ui_jump") and motion.y < 0:
			motion.y = -25

		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION * delta)

	motion = move_and_slide(motion, Vector2.UP)

func _slideMovement(delta):
	normalCollisionShape.disabled = true
	slideCollisionShape.disabled = false

	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	var isNotCollidingAbove = !slideRaycastLeft.is_colliding() and !slideRaycastRight.is_colliding()

	var direction
	if animatedSprite.flip_h:
		direction = -1
	else:
		direction = 1

	if !is_on_floor():
		currentState = STATES.run
		currentSlideTimer = 0
		motion.x = 0
		return

	if Input.is_action_just_pressed("ui_jump"):
		if isNotCollidingAbove:
			currentState = STATES.run
			currentSlideTimer = 0
			motion.x = 0
			motion.y = -JUMP_FORCE
			return

	currentSlideTimer += delta

	if currentSlideTimer > SLIDE_TIMER:
		if isNotCollidingAbove:
			currentState = STATES.run
			currentSlideTimer = 0
			motion.x = 0
			return

	if is_on_wall():
		if isNotCollidingAbove:
			currentState = STATES.run
			currentSlideTimer = 0
			motion.x = 0
			return

	if x_input != 0 and x_input != direction:
		if isNotCollidingAbove:
			currentState = STATES.run
			currentSlideTimer = 0
			motion.x = 0
			return
		else:
			direction = x_input
			animatedSprite.flip_h = direction != 1

	animatedSprite.play("Slide")

	motion.x += direction * SLIDE_ACCELERATION * delta * TARGET_FPS

	if direction == -1:
		motion.x = clamp(motion.x, -SLIDE_SPEED, 0)
	else:
		motion.x = clamp(motion.x, 0, SLIDE_SPEED)

	motion.y = 1

	motion = move_and_slide(motion, Vector2.UP)
