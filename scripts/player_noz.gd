extends CharacterBody2D

@export var speed := 400.0
var bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")

const ROTATION_SPEED := 150.0
const MIN_ROTATION := deg_to_rad(-60.0)
const MAX_ROTATION := deg_to_rad(60.0)

func _ready():
	print("bullet_scene is:", bullet_scene)
	if bullet_scene == null:
		print("🚨 bullet_scene is still null at runtime!")
	else:
		print("✅ bullet_scene loaded successfully!")

func _physics_process(delta):
	handle_rotation(delta)
	handle_movement(delta)

	if Input.is_action_just_pressed("shoot"):
		print("shoot")
		shoot()

func handle_rotation(delta):
	var input = 0.0
	if Input.is_action_pressed("left"):  # ← arrow
		input -= 1.0
	if Input.is_action_pressed("right"):  # → arrow
		input += 1.0

	if input != 0.0:
		rotation += deg_to_rad(ROTATION_SPEED) * input * delta

func handle_movement(delta):
	var input_vector = Vector2.ZERO

	if Input.is_action_pressed("forward"):   # W
		input_vector.y -= 1
	if Input.is_action_pressed("back"):     # S
		input_vector.y += 1
	#if Input.is_action_pressed("left"):     # A
		#input_vector.x -= 1
	#if Input.is_action_pressed("right"):    # D
		#input_vector.x += 1

	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		var rotated_vector = input_vector.rotated(rotation)
		velocity = rotated_vector * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

func shoot():
	print("Shoot func")
	if bullet_scene:
		var bullet = bullet_scene.instantiate()
		var spawn_point = $BulletSpawnPoint.global_position
		var direction = Vector2.UP.rotated(global_rotation)

		bullet.global_position = spawn_point
		if bullet.has_method("initialize"):
			bullet.initialize(direction)

		get_tree().current_scene.add_child(bullet)
