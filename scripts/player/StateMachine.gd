extends Node

onready var states = {
	'run' : $run,
	'slide' : $slide,
	'ladder' : $ladder,
}

onready var host = get_parent()

var current_state = 'run'
var previous_state = null

func _physics_process(delta):
	host.physics_step()

	var state_name = states[current_state].step(host, delta)

	if state_name:
		change_state(state_name)

	host.motion = host.move_and_slide(host.motion, Vector2.UP)
	states[current_state].animation_step(host, host.animatedSprite)
	# host.player_camera.camera_step(host, delta)

func change_state(state_name):
	if state_name == current_state:
		return

	states[current_state].exit(host)
	previous_state = current_state
	current_state = state_name
	states[current_state].enter(host)

func _on_AnimationPlayer_animation_finished(anim_name):
	states[current_state]._on_animation_finished(anim_name)
