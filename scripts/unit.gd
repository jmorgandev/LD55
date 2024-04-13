extends StaticBody3D
class_name Unit

func select(is_selected: bool):
    $highlight_mesh.visible = is_selected

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
