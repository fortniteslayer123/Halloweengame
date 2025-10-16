extends CharacterBody2D

var bullet_path = preload("res://Bullet.tscn")

func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())

	if Input.is_action_just_pressed("mouse_left"):
		fire()

func fire():
	var bullet = bullet_path.instantiate()

	# Set bullet position and rotation
	bullet.global_position = global_position
	bullet.rotation = rotation  # optional, if bullet has visuals that need it

	# Set movement direction
	bullet.dir = rotation
	

	get_parent().add_child(bullet)
