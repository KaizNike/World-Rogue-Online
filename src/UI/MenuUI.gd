extends CanvasLayer

onready var tempControl = $PanelContainer/VSplitContainer/TempSlider
onready var heightControl = $PanelContainer/VSplitContainer/HeightSlider
onready var sizeControl = $PanelContainer/VSplitContainer/SizeSlider
onready var roundToggle = $PanelContainer/VSplitContainer/RoundToggle
onready var overworld = self.get_parent().get_node("OverworldLayer/OverworldMenu")

func _ready():
	$PanelContainer/VSplitContainer/RegenButton.grab_focus()
	var name = OS.get_name()
	print(name)
	if name == "HTML5":
		$PanelContainer/VSplitContainer/ExitButton.visible = false
		$PanelContainer/VSplitContainer/FolderButton.visible = false
		$PanelContainer/VSplitContainer/LoadButton.visible = false
		$PanelContainer/VSplitContainer/SaveButton.visible = false
		$PanelContainer/VSplitContainer/ExportButton.visible = false


func _on_ExitButton_pressed():
	get_tree().quit()


func _on_RegenButton_pressed():
	$HistoryPanel.gen_history()
	overworld.regen(tempControl.value, heightControl.value, sizeControl.value, roundToggle.pressed, true)


func load_menu_ui(temp, height, size):
	tempControl.value = temp
	heightControl.value = height
	sizeControl.value = size
	pass


func _on_FolderButton_pressed():
	OS.shell_open(ProjectSettings.globalize_path("user://"))
	pass # Replace with function body.


func _on_SaveButton_pressed():
	overworld.save_to_file()
	pass # Replace with function body.


func _on_LoadButton_pressed():
	$PopupPanel.popup()
	pass # Replace with function body.


func _on_LineEdit_text_entered(new_text):
	$PopupPanel.visible = false
#	print(new_text)
	overworld.load_from_file(new_text)
	pass # Replace with function body.


func _on_LineEdit_text_changed(new_text):
	var regex = RegEx.new()
	regex.compile("^[0-9]*$")
	var result = regex.search($PopupPanel/LineEdit.text)
	if !result:
		$PopupPanel/LineEdit.text = ""
	pass # Replace with function body.


func _on_ExportButton_pressed():
	overworld.export_to_file()
	pass # Replace with function body.


func _on_HeightSlider2_toggled(button_pressed):
	pass # Replace with function body.
