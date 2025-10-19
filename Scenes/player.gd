extends CharacterBody2D
class_name Player

signal died

@onready var camera_remote_transform = $CameraRemoteTransfrom
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var speed := 300.0

# We'll remember the last direction so we know which Idle animation to play
var last_direction := Vector2.DOWN

func _physics_process(delta: float) -> void:
	var move_dir = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)

	if move_dir != Vector2.ZERO:
		move_dir = move_dir.normalized()
		velocity = move_dir * speed
		_play_walk_animation(move_dir)
		last_direction = move_dir
	else:
		velocity = Vector2.ZERO
		_play_idle_animation()

	move_and_slide()


func _play_walk_animation(dir: Vector2) -> void:
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			anim_sprite.play("Walk Right")
		else:
			anim_sprite.play("Walk Left")
	else:
		if dir.y > 0:
			anim_sprite.play("Walk Down")
		else:
			anim_sprite.play("Walk Up")


func _play_idle_animation() -> void:
	if abs(last_direction.x) > abs(last_direction.y):
		if last_direction.x > 0:
			anim_sprite.play("Idle Right")
		else:
			anim_sprite.play("Idle Left")
	else:
		if last_direction.y > 0:
			anim_sprite.play("Idle Down")
		else:
			anim_sprite.play("Idle Up")


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body is Enemy:
		died.emit()
		queue_free()
