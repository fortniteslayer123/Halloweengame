extends Node2D

@onready var enemy = preload("res://Scenes/enemy.tscn")
@onready var player = get_tree().get_first_node_in_group("player")


func _ready():
	if player == null:
		push_error("❌ Player not found! Make sure the Player node is in the 'player' group.")
	else:
		print("✅ Player found: ", player.name)

	var timer = Timer.new()
	timer.wait_time = 2.0
	timer.one_shot = false
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.start()
	print("⏱️ Timer started")



func _on_timer_timeout() -> void:
	print("⏰ Timer fired!")
	
	if player == null:
		push_error("Player not found in group 'player'")
		return

	var ene = enemy.instantiate()
	ene.global_position = get_random_spawn_position(player.global_position)
	get_tree().current_scene.add_child(ene)

func get_random_spawn_position(player_position: Vector2) -> Vector2:
	var viewport_size = get_viewport().get_visible_rect().size
	var angle = randf() * TAU
	var distance = max(viewport_size.x, viewport_size.y) * randf_range(1.2, 1.5)
	var offset = Vector2(cos(angle), sin(angle)) * distance
	return player_position + offset
