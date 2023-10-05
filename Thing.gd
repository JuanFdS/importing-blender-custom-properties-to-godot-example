tool
extends Spatial

export(String) var thing_name = "" setget set_thing_name

func set_thing_name(new_thing_name):
	thing_name = new_thing_name
	if(is_inside_tree()):
		update_name_label()

func _ready():
	update_name_label()

func update_name_label():
	$Name.text = thing_name
