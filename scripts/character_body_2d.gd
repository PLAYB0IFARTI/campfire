extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta: float) -> void:
	var direction_y := Input.get_axis("ui_up", "ui_down")
	var direction_x := Input.get_axis("ui_left", "ui_right")
	if direction_x != 0:
		velocity.x = direction_x * SPEED
		if direction_x == 1:
			sprite.play("right")
		elif direction_x == -1:
			sprite.play("left")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if direction_y != 0:
		velocity.y = direction_y * SPEED
		if direction_y == 1:
			sprite.play("up")
		elif direction_y == -1:
			sprite.play("down")
	else:
		velocity.y = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()
