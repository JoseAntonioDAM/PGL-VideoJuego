extends Node2D

@onready var player = $Player
@onready var hud = $HUD
var score = 0

func _ready():
	player.connect("died", _on_player_died)
	player.connect("lives_changed", _on_lives_changed)
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.connect("died", _on_enemy_died)

func _on_player_died():
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/GameOver.tscn")

func _on_lives_changed(new_lives):
	hud.update_lives(new_lives)

func _on_enemy_died(points):
	score += points
	hud.add_score(points)
	if score >= 10:
		get_tree().change_scene_to_file("res://scenes/Victory.tscn")
	else:
		await get_tree().create_timer(0.5).timeout
		var enemy = load("res://scenes/Enemy.tscn").instantiate()
		enemy.position = Vector2(600, 0)
		add_child(enemy)
		enemy.connect("died", _on_enemy_died)
