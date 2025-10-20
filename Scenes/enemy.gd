extends CharacterBody2D
class_name Enemy

var player: Player = null

var speed: float = 100.0
var direction:= Vector2.ZERO

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if player != null:
		var enemy_to_player = (player.global_position - global_position)
		direction = enemy_to_player.normalized()
		
		if direction != Vector2.ZERO:
			direction = direction
		velocity = direction * speed
		move_and_slide()

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		if player == null:
			player = body
			

func _on_player_detector_body_exited(body: Node2D) -> void:
	if body is Player:
		if player != null:
			player = null
			
