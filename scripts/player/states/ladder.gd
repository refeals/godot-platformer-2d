# Interface for states
extends Node

func enter(host: PlayerPhysics):
	return

func step(host: PlayerPhysics, delta: float):
	var y_input = Input.get_axis("ui_up", "ui_down")

	host.motion.y = y_input * host.LADDER_SPEED

	host.animatedSprite.play("Climb")

	if (y_input != 0):
		host.ladderAnimationTimer += delta

	if host.ladderAnimationTimer >= host.LADDER_TIMER:
		host.ladderAnimationTimer -= host.LADDER_TIMER
		host.animatedSprite.flip_h = not host.animatedSprite.flip_h

	# motion = move_and_slide(motion, Vector2.UP)

	if Input.is_action_just_pressed("ui_jump"):
		host.motion.y = 0
		return "run"

	if host.is_on_floor() and y_input > 0:
		host.motion.y = 0
		return "run"

	if !host.isCollidingWithLadder():
		host.motion.y = 0
		return "run"

func exit(host: PlayerPhysics):
	return

func animation_step(host: PlayerPhysics, animator: CharacterAnimator):
	return

func _on_animation_finished(anim_name: String):
	pass
