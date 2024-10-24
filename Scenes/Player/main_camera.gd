extends Camera2D

var player
var origin

func _ready():
	origin = global_position
	player = get_tree().get_first_node_in_group("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	position = player.position

#With the proper 2D position markers from camera_bounds scene, hand over the global_position of each along with a transition time
#Then transition from the old limits to the new ones with the transition time
func change_camera_limits(bottomLeft: Vector2, topRight: Vector2, transitionTime: float):
	var tweenTop = get_tree().create_tween().tween_property(self, "limit_top", topRight.y, transitionTime).set_trans(Tween.TRANS_CUBIC)
	var tweenBottom = get_tree().create_tween().tween_property(self, "limit_bottom", bottomLeft.y, transitionTime).set_trans(Tween.TRANS_CUBIC)
	var tweenLeft = get_tree().create_tween().tween_property(self, "limit_left", bottomLeft.x, transitionTime).set_trans(Tween.TRANS_CUBIC)
	var tweenRight = get_tree().create_tween().tween_property(self, "limit_right", topRight.x, transitionTime).set_trans(Tween.TRANS_CUBIC)
