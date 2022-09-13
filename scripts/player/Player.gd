extends KinematicBody2D
class_name PlayerPhysics

const TARGET_FPS = 60
const ACCELERATION = 12
const SLIDE_ACCELERATION = 100
const MAX_SPEED = 80
const SLIDE_SPEED = 180
const SLIDE_TIMER = 0.43
const LADDER_TIMER = 0.25
const LADDER_SPEED = 80
const FRICTION = 30
const GRAVITY = 10
const JUMP_FORCE = 210

var motion = Vector2.ZERO

var currentSlideTimer = 0
var currentShootTimer = 0
var ladderAnimationTimer = 0

onready var animatedSprite = $AnimatedSprite
onready var normalCollisionShape = $NormalCollisionShape
onready var slideCollisionShape = $SlideCollisionShape
onready var slideRaycastLeft = $SlideRaycastLeft
onready var slideRaycastRight = $SlideRaycastRight
onready var ladderRaycast = $LadderRaycast

func _ready():
	pass

func _physics_process(_delta):
	pass
	# var is_falling = motion.y > 0.0 and not is_on_floor()
	# var is_jumping = Input.is_action_just_pressed("ui_accept") and is_on_floor()
	# var is_double_jumping = Input.is_action_just_pressed("ui_accept") and is_falling
	# var is_jump_cancelled = Input.is_action_just_released("ui_accept") and motion.y < 0.0
	# var is_idling = is_on_floor() and is_zero_approx(motion.x)
	# var is_running = is_on_floor() and not is_zero_approx(motion.x)

func physics_step():
	pass

### Helper functions ###

func applyGravity(delta):
	motion.y += GRAVITY * delta * TARGET_FPS

func isCollidingWithLadder():
	if not ladderRaycast.is_colliding():
		return false

	var collider = ladderRaycast.get_collider()
	if not collider is Ladder:
		return false

	return collider
