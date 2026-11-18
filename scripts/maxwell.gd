extends RigidBody2D

@export var flipped : bool
@export var mouseobject : StaticBody2D

var mouseentered = false
var mouseclicked = false

var clickpositionoffset

var clamp = 2000

var alive = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var velocity = linear_velocity.length()
	var rotationd = abs(rotation_degrees) 
	if mouseclicked:
		var distance = (global_position - get_global_mouse_position()).length()

		if distance > 500:
			mouseclicked = false
			$PinJoint2D.node_b = NodePath("")

	if velocity <= 0.1 and rotationd > 164 and not mouseclicked:
		flipped = true
		$AnimatedSprite2D.modulate = Color(0.0, 1.326, 0.0, 1.0) # Green
	else:
		flipped = false
		$AnimatedSprite2D.modulate = Color(1.0, 1.0, 1.0, 1.0) # White

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed() and mouseentered:
				mouseclicked = true
				$GrabSFX.play(0.3)
				clickpositionoffset = get_global_mouse_position()
		
				$PinJoint2D.global_position = clickpositionoffset
				$PinJoint2D.node_b = mouseobject.get_path()
				
			
			else:
				mouseclicked = false
				$PinJoint2D.node_b = NodePath("")

func _on_mouse_entered() -> void:
	mouseentered = true


func _on_mouse_exited() -> void:
	mouseentered = false

func _on_body_shape_entered(body_rid: RID, body: Node, _body_shape_index: int, _local_shape_index: int) -> void:
	if not alive:
		return
	if not (body is TileMapLayer):
		return

	var tile_coords: Vector2i = body.get_coords_for_body_rid(body_rid)
	var tile_data: TileData = body.get_cell_tile_data(tile_coords)
	# print(tile_data.get_collision_polygons_count(1))
	if tile_data == null:
		return
	if tile_data.get_collision_polygons_count(1) > 0:
		alive = false
		get_tree().reload_current_scene.call_deferred()
	
	
func _on_body_entered(body: Node) -> void:
	var velocitylength = clamp(linear_velocity.length()/100, 0, 10)
	var random_sfx = $SFX.get_children().pick_random()
	random_sfx.volume_db = -5 + velocitylength
	random_sfx.pitch_scale = randf_range(0.8,1.2)
	random_sfx.play()
	if alive and "hurts" in body:
		alive = false
		get_tree().reload_current_scene.call_deferred()
