extends Area2D

@export var experience = 1

var spr_green = preload("res://Objects/Exp Sprites/spr_coin_strip4.png")
var spr_blue = preload("res://Objects/Exp Sprites/spr_coin_azu.png")
var spr_red = preload("res://Objects/Exp Sprites/spr_coin_roj.png")

var target = null
var speed = 100  # Positive speed for moving toward the target

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var sound = $snd_collected

func _ready():
	if experience < 5:
		sprite.texture = spr_green
	elif experience < 25:
		sprite.texture = spr_blue
	else:
		sprite.texture = spr_red

func _physics_process(delta):
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed * delta)

func collect():
	sound.play()
	collision.disabled = true
	sprite.visible = false
	return experience

func _on_snd_collected_finished() -> void:
	queue_free()
