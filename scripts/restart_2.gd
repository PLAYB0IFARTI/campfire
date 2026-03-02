extends Node2D

@onready var theme: AudioStreamPlayer = $Theme

func _ready() -> void:
	theme.play()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().change_scene_to_file("res://scenes/level_2.tscn")
