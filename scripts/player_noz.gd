extends CharacterBody2D

@export var speed := 1000.0
@export var rotation_speed := 5.0  # Smooth rotation speed
#@export var bullet_scene : PackedScene
var bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")

var last_mouse_pos := Vector2.ZERO
const MOUSE_MOVE_THRESHOLD := 2.0  # Minimum pixels moved to trigger rotation


func _ready():
	print("bullet_scene is:", bullet_scene)
	if bullet_scene == null:
		print("🚨 bullet_scene is still null at runtime!")
	else:
		print("✅ bullet_scene loaded successfully!")
	last_mouse_pos = get_global_mouse_position()

func _physics_process(delta):
	rotate_toward_mouse(delta)
	handle_movement(delta)

	if Input.is_action_just_pressed("shoot"):
		print("shoot")
		shoot()

func rotate_toward_mouse(delta):
	var mouse_pos = get_global_mouse_position()

	if last_mouse_pos.distance_to(mouse_pos) > MOUSE_MOVE_THRESHOLD:
		var angle_to_mouse = (mouse_pos - global_position).angle()
		rotation = lerp_angle(rotation, angle_to_mouse, rotation_speed * delta)
		last_mouse_pos = mouse_pos

func handle_movement(delta):
	var input_vector = Vector2.ZERO
	
	if Input.is_action_pressed("forward"):   # W
		input_vector.y -= 1
	if Input.is_action_pressed("back"):     # S
		input_vector.y += 1
	if Input.is_action_pressed("left"):     # A
		input_vector.x -= 1
	if Input.is_action_pressed("right"):    # D
		input_vector.x += 1

	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		var rotated_vector = input_vector.rotated(rotation)
		velocity = rotated_vector * speed
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func shoot():
	print("Shoot func")
	print(bullet_scene)
	if bullet_scene:
		if bullet_scene == null:
			print("Bullet scene not assigned!")
		else:
			print("Bullet is present")
		var bullet = bullet_scene.instantiate()
		var spawn_point = $BulletSpawnPoint.global_position
		var direction = Vector2.UP.rotated(global_rotation)

		bullet.global_position = spawn_point
		if bullet.has_method("initialize"):
			bullet.initialize(direction)

		get_tree().current_scene.add_child(bullet)
