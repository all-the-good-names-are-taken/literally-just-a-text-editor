extends Control

var save_path := ""

func _ready() -> void:
	if FileAccess.file_exists("user://save"):
		_on_open_dialog_file_selected(file_io("user://save"))
	if FileAccess.file_exists("user://theme"):
		theme = str_to_var(file_io("user://theme"))

func file_io(path: String, content: String = "") -> String:
	if content:
		print_debug("Writing to file %s" % path)
		var file := FileAccess.open(path,FileAccess.WRITE)
		file.store_string(content)
		file.close()
		return ""
	else:
		if not FileAccess.file_exists(path):
			print_debug("File %s doesn't exist" % path)
			return ""
		print_debug("Reading file %s" % path)
		var file := FileAccess.open(path, FileAccess.READ)
		content = file.get_as_text()
		file.close()
		return content

func _on_save_button_pressed() -> void:
	if not save_path: return
	file_io(save_path, %Editor.text)

func _on_save_as_button_pressed() -> void: $SaveAsDialog.show()

func _on_open_button_pressed() -> void: $OpenDialog.show()

func _on_theme_button_pressed() -> void: $ThemeDialog.show()

func _on_save_as_dialog_file_selected(path: String) -> void:
	file_io(path, %Editor.text)

func _on_open_dialog_file_selected(path: String) -> void:
	save_path = path
	file_io("user://save", path)
	%Editor.text = file_io(path)

func _on_theme_dialog_file_selected(path: String) -> void:
	var selected = load(path)
	if selected is Theme:
		theme = selected
		file_io("user://theme", var_to_str(selected))
	else: return
