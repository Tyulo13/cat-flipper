extends RigidBody2D

@export var flipped : bool




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var velocity = linear_velocity.length()
	var rotationd = abs(rotation_degrees) 
	if velocity <= 0.1 and rotationd > 164:
		flipped = true
		$AnimatedSprite2D.modulate = Color(0.0, 1.326, 0.0, 1.0) # Green
	else:
		flipped = false
		$AnimatedSprite2D.modulate = Color(1.0, 1.0, 1.0, 1.0) # White



func _on_body_shape_entered(body_rid: RID, body: Node, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is TileMapLayer:
		var tile_coords: Vector2i = body.get_coords_for_body_rid(body_rid)
		var tile_data: TileData = body.get_cell_tile_data(tile_coords)
		# print(tile_data.get_collision_polygons_count(1))
		if tile_data.get_collision_polygons_count(1) > 0:
			get_tree().reload_current_scene.call_deferred()
	
func _on_body_entered(body: Node) -> void:
	var velocitylength = clamp(linear_velocity.length()/100, 0, 10)
	var random_sfx = $SFX.get_children().pick_random()
	random_sfx.volume_db = -5 + velocitylength
	random_sfx.pitch_scale = randf_range(0.8,1.2)
	random_sfx.play()
	
