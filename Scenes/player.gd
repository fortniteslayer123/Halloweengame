extends CharacterBody2D
class_name Player

signal died

var iceSpear = preload("res://Scripts/bullet.tscn")

@onready var iceSpearTimer = get_node("%IceSpearTimer")
@onready var iceSpearAttackTimer = get_node("%IceSpearAttackTimer")

# PLAYER ATTACK
var icespear_ammo = 0
var icespear_baseammo = 1 
var icespear_attackspeed = 1.5
var icespear_level = 1

var experience = 0
var experience_level = 1
var collected_experience = 0

# ENEMY STUFF
var enemy_close = []

@onready var camera_remote_transform = $CameraRemoteTransfrom
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var speed := 300.0

func _ready():
	attack()

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

func attack():
	if icespear_level > 0:
		iceSpearTimer.wait_time = icespear_attackspeed
		if iceSpearTimer.is_stopped():
			iceSpearTimer.start()

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

func _on_ice_spear_timer_timeout() -> void:
	icespear_ammo += icespear_baseammo
	iceSpearAttackTimer.start()

func _on_ice_spear_attack_timer_timeout() -> void:
	if icespear_ammo > 0:
		var icespear_attack = iceSpear.instantiate()
		icespear_attack.global_position = global_position
		icespear_attack.target = get_random_target()
		icespear_attack.level = icespear_level
		get_tree().current_scene.add_child(icespear_attack)

		icespear_ammo -= 1

		if icespear_ammo > 0:
			iceSpearAttackTimer.start()
		else:
			iceSpearAttackTimer.stop()

func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP

func _on_enemy_detection_area_body_entered(body: Node2D) -> void:
	if not enemy_close.has(body):
		enemy_close.append(body)

func _on_enemy_detection_area_body_exited(body: Node2D) -> void:
	if enemy_close.has(body):
		enemy_close.erase(body)

func _on_grab_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		area.target = self

func _on_collect_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		var gem_exp = area.collect()
		calculate_experience(gem_exp)

func calculate_experience(gem_exp):
	collected_experience += gem_exp
	
	while collected_experience > 0:
		var exp_required = calculate_experiencecap()
		var exp_to_level = exp_required - experience
		
		if collected_experience >= exp_to_level:
			# Level up
			collected_experience -= exp_to_level
			experience = 0
			experience_level += 1
			print("Level up! New level:", experience_level)
		else:
			# Add remaining exp without leveling up
			experience += collected_experience
			collected_experience = 0

func calculate_experiencecap():
	var exp_cap = 0
	if experience_level < 20:
		exp_cap = experience_level * 5
	elif experience_level < 40:
		exp_cap = 95 + (experience_level - 19) * 8
	else:
		exp_cap = 255 + (experience_level - 39) * 12
	return exp_cap
