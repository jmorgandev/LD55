extends Camera3D

var is_dragging := false
const DRAG_SENSITVITY := 0.02

var view_forward: Vector3
var view_right: Vector3
var view_forward_compensation: float = 90.0 / abs(rotation_degrees.x) * 0.8

# Called when the node enters the scene tree for the first time.
func _ready():
    view_forward = transform.basis.z.normalized()
    view_forward.y = 0.0 #ignore the Y component since the camera is looking down
    view_right = transform.basis.x.normalized()

func _unhandled_input(event: InputEvent):
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT:
            is_dragging = event.pressed
    elif event is InputEventMouseMotion and is_dragging:
        position += ((view_forward * -event.relative.y * view_forward_compensation) + (view_right * -event.relative.x)) * DRAG_SENSITVITY

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var view_movement := Vector3.ZERO

    if not is_dragging:
        var input_dir := Input.get_vector("left", "right", "up", "down").normalized()
        view_movement = (view_forward * input_dir.y * view_forward_compensation) + (view_right * input_dir.x) * 10.0
        position += view_movement * delta
    
    
