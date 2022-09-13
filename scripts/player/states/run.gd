extends 'state.gd'

func enter(host: PlayerPhysics):
	host.normalCollisionShape.disabled = false
	host.slideCollisionShape.disabled = true

func step(host: PlayerPhysics, delta: float):
	var x_input = Input.get_axis("ui_left", "ui_right")
	var y_input = Input.get_axis("ui_up", "ui_down")

	if x_input != 0:
		host.animatedSprite.flip_h = x_input < 0
		host.motion.x += x_input * host.ACCELERATION * delta * host.TARGET_FPS
		host.animatedSprite.play("Run")

		if x_input > 0:
			host.motion.x = clamp(host.motion.x, 0, host.MAX_SPEED)
		elif x_input < 0:
			host.motion.x = clamp(host.motion.x, -host.MAX_SPEED, 0)
	else:
		host.animatedSprite.play("Idle")

	host.applyGravity(delta)

	# movement specific code
	if host.is_on_floor():
		if x_input == 0:
			host.motion.x = lerp(host.motion.x, 0, host.FRICTION * delta)

		if Input.is_action_just_pressed("ui_jump"):
			host.motion.y = -host.JUMP_FORCE

		if Input.is_action_just_pressed("ui_shoot"):
			print("shoot")

		if Input.is_action_just_pressed("ui_slide") or (Input.is_action_pressed("ui_down") and Input.is_action_just_pressed("ui_jump")):
			host.motion = Vector2.ZERO
			return "slide"
	else:
		host.animatedSprite.play("Jump")

		if Input.is_action_just_released("ui_jump") and host.motion.y < 0:
			host.motion.y = -25

		if x_input == 0:
			host.motion.x = lerp(host.motion.x, 0, host.FRICTION * delta)

	# movement agnostic code (works on floor or not)
	var ladder = host.isCollidingWithLadder()
	if ladder:
		if y_input < 0 or (y_input > 0 and !host.is_on_floor()):
			host.motion = Vector2.ZERO
			host.position.x = ladder.position.x + 8
			return "ladder"

	# host.motion = host.move_and_slide(host.motion, Vector2.UP)

func exit(host: PlayerPhysics):
	return

func animation_step(host: PlayerPhysics, animator: CharacterAnimator):
	return

func _on_animation_finished(anim_name: String):
	pass
