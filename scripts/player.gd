extends Camera3D

@onready var raycast: RayCast3D = $RayCast3D
var is_selection_queued := false

var is_dragging := false
const DRAG_SENSITVITY := 0.02
const PAN_SPEED := 10.0

var view_forward: Vector3
var view_right: Vector3
var view_forward_compensation: float = 90.0 / abs(rotation_degrees.x) * 0.8

var selected_unit: Unit = null

# Called when the node enters the scene tree for the first time.
func _ready():
    view_forward = transform.basis.z.normalized()
    view_forward.y = 0.0 #ignore the Y component since the camera is looking down
    view_right = transform.basis.x.normalized()

func _queue_selection_from_mouse_position(mouse_position: Vector2):
    var from = project_ray_origin(mouse_position)
    var to = from + (project_ray_normal(mouse_position) * 100.0)
    raycast.global_position = from
    raycast.target_position = raycast.to_local(to)
    raycast.force_raycast_update()
    is_selection_queued = true

func _unhandled_input(event: InputEvent):
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
            _queue_selection_from_mouse_position(event.position)
        elif event.button_index == MOUSE_BUTTON_RIGHT:
            is_dragging = event.pressed
    elif event is InputEventMouseMotion and is_dragging:
        position += ((view_forward * -event.relative.y * view_forward_compensation) + (view_right * -event.relative.x)) * DRAG_SENSITVITY

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if not is_dragging:
        var input_dir := Input.get_vector("left", "right", "up", "down").normalized()
        var view_move_dir = (view_forward * input_dir.y * view_forward_compensation) + (view_right * input_dir.x)
        position += view_move_dir * PAN_SPEED * delta
    
func _process_selection(collider: Node3D):
    if selected_unit != null:
        selected_unit.select(false)
    
    if collider is Unit:
        selected_unit = collider as Unit
        selected_unit.select(true)
    else:
        selected_unit = null
    
func _physics_process(delta):
    if raycast.enabled and is_selection_queued:
        is_selection_queued = false
        if raycast.is_colliding():
            _process_selection(raycast.get_collider() as Node3D)
        
