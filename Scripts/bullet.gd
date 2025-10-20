extends Area2D

var level = 1
var hp = 1
var speed = 100
var damage = 5
var knock_amount = 100
var attack_size = 1.0

var target = Vector2.ZERO
var angle = Vector2.ZERO

func _ready() -> void:
	# Only calculate direction if target was assigned (from player)
	if target != Vector2.ZERO:
		angle = global_position.direction_to(target)
		rotation = angle.angle() + deg_to_rad(135)
	else:
		angle = Vector2.UP  # fallback

	match level:
		1:
			hp = 1
			speed = 400
		
			damage = 5
			knock_amount = 100
			attack_size = 1.0 

func _physics_process(delta: float) -> void:
	position += angle * speed * delta

func enemy_hit(charge: int = 1) -> void:
	hp -= charge
	if hp <= 0:
		queue_free()

func _on_timer_timeout() -> void:
	queue_free()
