extends CharacterBody2D
class_name PlayerController

@export var speed = 10.0
@export var jump_power = 10.0
@export var wall_jump_pushback = 600

var speed_multiplier = 10.0
var jump_multiplier = -30.0
var direction = 0

var just_wall_jumped = false
var wall_jump_timer = 0.2 #seconds
var wall_jump_time_left = 0.0

var wall_slide_gravity = 50
var is_wall_sliding = false

var is_sprinting = false
var sprint_multiplier = 3.0



#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0

func jump(event):
	if event.is_action_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_power * jump_multiplier
		elif is_on_wall():
			velocity.y = jump_power * jump_multiplier
			if Input.is_action_pressed("move_right"):			
				velocity.x = -wall_jump_pushback
			elif Input.is_action_pressed("move_left"):			
				velocity.x = wall_jump_pushback
			just_wall_jumped = true
			wall_jump_time_left = wall_jump_timer

func sprint(event):
	if is_on_floor():
		if Input.is_action_pressed("sprint"):
			is_sprinting = true
		elif Input.is_action_just_released("sprint"):
			is_sprinting = false
			
		

func _input(event):
	# Handle jump.
	jump(event)
	sprint(event)
	
	if event.is_action_pressed("move_down"):
		# use the physics layer
		set_collision_mask_value(10, false)
	else:
		set_collision_mask_value(10, true)

func wall_slide(delta):
	if is_on_wall() and !is_on_floor():
		if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			is_wall_sliding = true
		else:
			is_wall_sliding = false
	else:
		is_wall_sliding = false
	
	if is_wall_sliding:
		velocity.y += (wall_slide_gravity * delta)
		velocity.y = min(velocity.y, wall_slide_gravity)
	

func _physics_process(delta: float) -> void:
	#wall jump timer
	if wall_jump_time_left > 0:
		wall_jump_time_left -= delta
		if wall_jump_time_left <= 0:
			just_wall_jumped = false
	
	wall_slide(delta)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("move_left", "move_right")
	var current_speed_multiplier = speed_multiplier
	if is_sprinting:
		current_speed_multiplier *= sprint_multiplier
		
	if direction:
		velocity.x = direction * speed * current_speed_multiplier
	else:
		velocity.x = move_toward(velocity.x, 0, speed * speed_multiplier)

	move_and_slide()
