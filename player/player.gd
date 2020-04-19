extends KinematicBody2D

class_name Player

export var cameraScale = 0.7

const GRAVITY_VEC = Vector2(0, 900)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 25.0
const WALK_SPEED = 250 # pixels/sec
const JUMP_SPEED = 480
const SIDING_CHANGE_SPEED = 10

var linear_vel = Vector2()
onready var raycast1 = $raycast

var anim = ""

# cache the sprite here for fast access (we will set scale to flip it often)
onready var sprite = $Sprite
# cache bullet for fast access
var on_moving_platform = false
var stepCounter = 0

func _ready():
	($Camera as Camera2D).zoom.x = cameraScale
	($Camera as Camera2D).zoom.y = cameraScale


func _physics_process(delta):
	# Increment counters
	stepCounter += delta

	### MOVEMENT ###

	# Apply gravity
	linear_vel += delta * GRAVITY_VEC
	# Move and slide
	var snap = Vector2.DOWN * 32 if on_moving_platform else Vector2.ZERO
	linear_vel = move_and_slide_with_snap(linear_vel, snap, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	# Detect if we are on floor - only works if called *after* move_and_slide
	var on_floor = is_on_floor()
	

	if(raycast1.is_colliding()):
		on_moving_platform = true
	else:
		on_moving_platform = false


	### CONTROL ###

	# Horizontal movement
	var target_speed = 0
	if Input.is_action_pressed("move_left"):
		target_speed -= 1
	if Input.is_action_pressed("move_right"):
		target_speed += 1

	target_speed *= WALK_SPEED
	linear_vel.x = lerp(linear_vel.x, target_speed, 0.1)

	# Jumping
	if on_floor and Input.is_action_just_pressed("jump"):
		linear_vel.y = -JUMP_SPEED
		($SoundJump as AudioStreamPlayer2D).play()

	### ANIMATION ###

	var new_anim = "idle"

	if on_floor:
		if(stepCounter > 0.4 && (linear_vel.x < -SIDING_CHANGE_SPEED || linear_vel.x > SIDING_CHANGE_SPEED)):
			($SoundStep as AudioStreamPlayer2D).play()
			stepCounter = 0.0
		if linear_vel.x < -SIDING_CHANGE_SPEED:
			sprite.scale.x = -1
			new_anim = "run"

		if linear_vel.x > SIDING_CHANGE_SPEED:
			sprite.scale.x = 1
			new_anim = "run"
	else:
		# We want the character to immediately change facing side when the player
		# tries to change direction, during air control.
		# This allows for example the player to shoot quickly left then right.
		if Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
			sprite.scale.x = -1
		if Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
			sprite.scale.x = 1

		if linear_vel.y < 0:
			new_anim = "jumping"
		else:
			new_anim = "falling"

	if new_anim != anim:
		anim = new_anim
		($Anim as AnimationPlayer).play(anim)
