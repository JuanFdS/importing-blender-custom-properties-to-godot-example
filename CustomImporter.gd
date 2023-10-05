tool
extends EditorScenePostImport

const replaceable_nodes := {
	"Thing": preload("res://Thing.tscn")
}

func post_import(scene):
	var nodes_json = JSON.parse(_get_content(get_source_file())).result["nodes"]
	process_children_nodes(scene, scene, nodes_json)
	return scene

func process_children_nodes(parent, scene, nodes_json):
	for child in parent.get_children():
		process_children_nodes(child, scene, nodes_json)
		var custom_properties = custom_properties_for(
			child, nodes_json
		)
		var instanced_node = instance_node(child)
		if(instanced_node):
			child.add_child(instanced_node)
			instanced_node.owner = scene
			apply_custom_properties(instanced_node, custom_properties)

func instance_node(node):
	var node_name = normalized_json_node_name(node.name)
	for node_type in replaceable_nodes.keys():
		if node_name.begins_with(node_type):
			var node_klass = replaceable_nodes[node_type]
			return node_klass.instance()

func apply_custom_properties(node, custom_properties):
	for property in custom_properties.keys():
		var property_name = property
		var property_value = custom_properties[property]
		
		# fancy stuff could be done instead of just set here
		node.set(property_name, property_value)

func custom_properties_for(node, nodes_json):
	var node_json = find_json_node_for(node, nodes_json)
	
	if node_json and node_json.has("extras"):
		return node_json["extras"]
	else:
		return {}

func find_json_node_for(node, nodes_json):
	for node_json in nodes_json:
		if normalized_json_node_name(node_json["name"]) == node.name:
			return node_json

# This might not really cover all cases in converting names from blender objects from godot nodes.
# It is working for us so far.
func normalized_json_node_name(node_name: String):
	var suffix_regex := RegEx.new()
	
	assert(
		suffix_regex.compile("-col(only)?(\\d*)$") == OK,
		"Error compiling regex!"
	)

	return suffix_regex.sub(node_name.replace(".", ""), "$2")

func _get_content(path) -> String:
	var file = File.new()
	file.open(path, File.READ)
	var content = file.get_as_text()
	file.close()
	return content
