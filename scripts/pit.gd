extends StaticBody2D

@onready var area: Area2D = $Area2D
@onready var col: CollisionShape2D = $col

# keep track of blocks inside

func _ready():
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

# When a block enters the Area2D
func _on_body_entered(body):
	if body.is_in_group("moveable"):
		self.set_collision_layer_value(2, false)
		self.set_collision_mask_value(3, false)
		
		body.set_collision_layer_value(5, false)
		body.set_collision_mask_value(1, false)
		body.set_collision_mask_value(5, false)
		print("fdsfds")

# When a block exits the Area2D
func _on_body_exited(body):
	if body.is_in_group("moveable"):
		self.set_collision_layer_value(2, true)
		self.set_collision_mask_value(3, true)
		
		body.set_collision_layer_value(5, true)
		body.set_collision_mask_value(1, true)
		body.set_collision_mask_value(5, true)
		print("gsdf")
		
