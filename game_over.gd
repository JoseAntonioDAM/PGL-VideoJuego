extends Control

func _on_retry_button_pressed():
	get_tree().change_scene_to_file("res://scenes/World.tscn")

func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
