# importing-blender-custom-properties-to-godot-example

Small example of how the custom properties in blender can be read by using a custom import script in godot.

## Blender side

The blend file has 2 empties, `Thing` and `Thing.001`, which have a `thing_name` as a custom property:

![image](https://github.com/JuanFdS/importing-blender-custom-properties-to-godot-example/assets/11432672/458cf3c9-2dfa-4088-8c51-3854177939c4)

The blend file is exported as a gltf into the assets folder.

## Godot side

The gltf is imported into godot with a custom script that takes any node whose name starts with `Thing` and attaches an instance of `Thing.tscn` as a child to it.

Then, by parsing the gltf as a JSON, the `thing_name` is extracted and set as a name in both godot's `Thing`s.

![image](https://github.com/JuanFdS/importing-blender-custom-properties-to-godot-example/assets/11432672/98a3819d-85cc-4cd6-bed4-4ae2293fd8b5)
