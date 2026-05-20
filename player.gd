extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 980.0

var lives = 3
var invincible = false
var invincible_timer = 0.0
const INVINCIBLE_TIME = 1.5

@onready var bullet_scene = preload("res://bullet.tscn")
@onready var shoot_point = $ShootPoint
@onready var sprite = $AnimatedSprite2D

signal died
signal lives_changed(new_lives)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var dir = Input.get_axis("move_left", "move_right")
	velocity.x = dir * SPEED
	if dir != 0:
		sprite.flip_h = dir < 0
	if not is_on_floor():
		sprite.play("jump")
	elif dir != 0:
		sprite.play("walk")
	else:
		sprite.play("idle")
	move_and_slide()
	if invincible:
		invincible_timer -= delta
		sprite.modulate.a = 0.5 if fmod(invincible_timer, 0.2) < 0.1 else 1.0
		if invincible_timer <= 0:
			invincible = false
			sprite.modulate.a = 1.0
			
			
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			shoot()

func shoot():
	if not ResourceLoader.exists("res://bullet.tscn"):
		return
	var bullet = bullet_scene.instantiate()
	bullet.direction = Vector2(1 if not sprite.flip_h else -1, 0)
	bullet.global_position = shoot_point.global_position
	get_tree().current_scene.add_child(bullet)

func take_damage():
	if invincible:
		return
	lives -= 1
	emit_signal("lives_changed", lives)
	invincible = true
	invincible_timer = INVINCIBLE_TIME
	if lives <= 0:
		emit_signal("died")
		queue_free()
