extends StaticBody2D

@onready var area: Area2D = $Area2D
@onready var col: CollisionShape2D = $col


func _ready():
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("moveable"):
		self.set_collision_layer_value(2, false)
		self.set_collision_mask_value(3, false)
		
		body.set_collision_layer_value(5, false)
		body.set_collision_mask_value(1, false)
		body.set_collision_mask_value(5, false)
		print("fdsfds")

func _on_body_exited(body):
	if body.is_in_group("moveable"):
		self.set_collision_layer_value(2, true)
		self.set_collision_mask_value(3, true)
		
		body.set_collision_layer_value(5, true)
		body.set_collision_mask_value(1, true)
		body.set_collision_mask_value(5, true)
		print("gsdf")
		
