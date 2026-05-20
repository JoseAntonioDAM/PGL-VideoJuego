extends Area2D
$"."
var direction = Vector2.RIGHT
const SPEED = 500.0

func _physics_process(delta):
	position += direction * SPEED * delta

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		body.take_damage()
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
