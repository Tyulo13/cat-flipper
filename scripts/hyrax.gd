extends RigidBody2D
@export var target : RigidBody2D
@export var speed : float = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target:
		if target.global_position.x < global_position.x:
			$Sprite2D.flip_h = true
		elif target.global_position.x > global_position.x:
			$Sprite2D.flip_h = false
		var direction = -(global_position - target.global_position).normalized()
		linear_velocity = direction * speed
		
		


func _on_body_entered(body: Node) -> void:
	if body == target:
		if freeze == false:
			$Jumpscare.visible = true
			$Jumpscare.global_position = Vector2(323.0,160.5)
			$Jumpscare.global_rotation = 0
			set_deferred("freeze", true)
			$SFX.play()
			await get_tree().create_timer(0.2).timeout
			get_tree().reload_current_scene.call_deferred()
