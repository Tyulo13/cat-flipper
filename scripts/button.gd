extends RigidBody2D
@export var flipped : bool = false

func _on_body_entered(body: Node) -> void:
	flipped = true
	$ButtonDown.play()
	$AnimatedSprite2D.play("pressed")


func _on_body_exited(body: Node) -> void:
	if not is_inside_tree():
		return
	flipped = false
	$ButtonUp.play()
	$AnimatedSprite2D.play("default")
