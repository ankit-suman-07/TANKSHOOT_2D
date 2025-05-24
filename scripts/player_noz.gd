extends CharacterBody2D

@export var speed := 200.0
@export var bullet_scene: PackedScene

func _physics_process(delta):
	rotate_toward_mouse()
	
	if Input.is_action_just_pressed("shoot"):  # Ensure "shoot" is mapped to "x"
		shoot()

func rotate_toward_mouse():
	# Get the mouse's global position
	var mouse_pos = get_global_mouse_position()
	
	# Calculate the angle between the player and the mouse pointer
	var angle_to_mouse = (mouse_pos - global_position).angle()
	
	# Set the rotation of the player to face the mouse
	rotation = angle_to_mouse
	
func shoot():
	if bullet_scene:
		var bullet = bullet_scene.instantiate()
		print(bullet.name)
		
		
		var spawn_point = $BulletSpawnPoint.global_position
		var direction = Vector2.UP.rotated(global_rotation)  # Shoot in the facing direction

		bullet.global_position = spawn_point
		if bullet.has_method("initialize"):
			bullet.initialize(direction)
 
		get_tree().current_scene.add_child(bullet)
		# Play shoot sound
