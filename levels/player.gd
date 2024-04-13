extends Camera3D

var is_dragging := false
var drag_start := Vector2.ZERO
var drag_current := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if is_dragging:
        pass
    else:
        var input_dir := Input.get_vector("left", "right", "up", "down").normalized()
        
        var view_forward := transform.basis.z.normalized()
        view_forward.y = 0.0 #ignore the Y component since the camera is looking down
        var view_right := transform.basis.x.normalized()
        
        var view_forward_compensation: float = 90.0 / abs(rotation_degrees.x) * 0.8
        view_forward_compensation = 2
        print(view_forward_compensation)
        
        var view_movement := (view_forward * input_dir.y * view_forward_compensation) + (view_right * input_dir.x)
        position += view_movement * 10.0 * delta
    
    
