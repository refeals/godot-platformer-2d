extends 'state.gd'

func enter(host: PlayerPhysics):
	host.normalCollisionShape.disabled = true
	host.slideCollisionShape.disabled = false

func step(host: PlayerPhysics, delta: float):
	var x_input = Input.get_axis("ui_left", "ui_right")

	var isNotCollidingAbove = !host.slideRaycastLeft.is_colliding() and !host.slideRaycastRight.is_colliding()

	var direction = -1 if host.animatedSprite.flip_h else 1

	if !host.is_on_floor():
		return "run"

	if Input.is_action_just_pressed("ui_jump") and not Input.is_action_pressed("ui_down"):
		if isNotCollidingAbove:
			host.motion.y = -host.JUMP_FORCE
			return "run"

	host.currentSlideTimer += delta

	if host.currentSlideTimer > host.SLIDE_TIMER:
		if isNotCollidingAbove:
			return "run"

	if host.is_on_wall():
		if isNotCollidingAbove:
			return "run"

	if x_input != 0 and x_input != direction:
		if isNotCollidingAbove:
			return "run"
		else:
			direction = x_input
			host.animatedSprite.flip_h = direction != 1

	host.animatedSprite.play("Slide")

	host.motion.x += direction * host.SLIDE_ACCELERATION * delta * host.TARGET_FPS

	if direction == -1:
		host.motion.x = clamp(host.motion.x, -host.SLIDE_SPEED, 0)
	else:
		host.motion.x = clamp(host.motion.x, 0, host.SLIDE_SPEED)

	host.motion.y = 1


func exit(host: PlayerPhysics):
	host.currentSlideTimer = 0
	host.motion.x = 0
	return

func animation_step(host: PlayerPhysics, animator: CharacterAnimator):
	return

func _on_animation_finished(anim_name: String):
	pass
