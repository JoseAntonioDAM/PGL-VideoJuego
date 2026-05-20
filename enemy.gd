extends CharacterBody2D

const SPEED = 80.0
const GRAVITY = 980.0

var direction = -1
var health = 2
var points_value = 100

signal died(points)

@onready var sprite = $AnimatedSprite2D

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	velocity.x = direction * SPEED
	sprite.flip_h = direction > 0
	sprite.play("walk")
	move_and_slide()
	if is_on_wall():
		direction *= -1

func take_damage():
	health -= 1
	modulate = Color(1, 0.3, 0.3)
	await get_tree().create_timer(0.1).timeout
	modulate = Color(1, 1, 1)
	if health <= 0:
		emit_signal("died", points_value)
		queue_free()

func _on_hit_area_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage()
