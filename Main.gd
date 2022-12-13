extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_LoadBtn_pressed():
	$LoadFileDialog.popup()


func _on_SaveBtn_pressed():
	$SaveFileDialog.popup()


func _on_LoadFileDialog_file_selected(path):
	print("open: %s" % [path])
	var file = File.new()
	file.open(path, File.READ)
	$TextEdit.text = file.get_as_text()


func _on_SaveFileDialog_file_selected(path):
	print("open: %s" % [path])
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_string($TextEdit.text)
