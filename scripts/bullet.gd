extends CharacterBody2D

var score := 0
var bullet := 10

@export var speed := 100.0
var direction := Vector2.ZERO
var has_collided := false  # Flag to ensure we print only once

func initialize(dir: Vector2):
	direction = dir.normalized()

func _physics_process(delta):
	velocity = direction * speed
	move_and_slide()
