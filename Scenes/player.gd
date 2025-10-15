
	
extends CharacterBody2D

@export var speed := 300.0

func _physics_process(delta: float) -> void:
	var move_dir = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)

	if move_dir != Vector2.ZERO:
		move_dir = move_dir.normalized()

	velocity = move_dir * speed
	move_and_slide()
