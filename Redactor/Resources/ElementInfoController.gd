extends Node2D

var type = ""
var timeAppear = 0.0
var timeUse = 0.0
var chooseType = "Appear"

var redactorController = null

func _ready():
	var popupChooseType = get_parent().get_parent().get_node("PopupMenu")
	var popupModeChoose = get_parent().get_parent().get_node("PopupModeChoose")
	if popupChooseType:
		popupChooseType.add_check_item("single")
		popupChooseType.add_check_item("none")
	if popupModeChoose:
		popupModeChoose.add_check_item("Appear")
		popupModeChoose.add_check_item("Use")

func setInfo(params):
	type = params.type
	timeAppear = params.timeAppear
	timeUse = params.timeUse
	
	var labelType = get_node("LabelTypeSelected")
	labelType.text = type
	var inputAppear = get_node("AppearLineEdit")
	inputAppear.text = String(timeAppear)
	var inputUse = get_node("UseLine")
	inputUse.text = String(timeUse)
	
func getChooseType() -> String:
	return chooseType

func setType(type):
	self.type = type
	saveElementInfo()
	
func setTimeAppear(timeAppear):
	self.timeAppear = timeAppear
	saveElementInfo()
	
func setTimeUse(timeUse):
	self.timeUse = timeUse
	saveElementInfo()

func saveElementInfo():
	var params = {}
	params.type = type
	params.timeAppear = timeAppear
	params.timeUse = timeUse
	redactorController.saveElementInfo(params)

func AppearLineEdit_text_changed(new_text):
	setTimeAppear(float(new_text))

func UseLine_text_changed(new_text):
	setTimeUse(float(new_text))

func ButtonLabelSelectedClicked():
	var popupChooseType = get_parent().get_parent().get_node("PopupMenu")
	if popupChooseType:
		popupChooseType.popup()

func PopupMenuChoosen(id): #TODO: on popup choose type
	var labelTypeSelected = get_node("LabelTypeSelected")
	if labelTypeSelected:
		var popupChooseType = get_parent().get_parent().get_node("PopupMenu")
		if popupChooseType:
			labelTypeSelected.text = popupChooseType.get_item_text(id)
			type = labelTypeSelected.text
			popupChooseType.visible = false


func onModeChoose(id):
	var labelModeSelectedNode = get_parent().get_node("LabelModeSelected")
	if labelModeSelectedNode:
		var popupModeChoose = get_parent().get_parent().get_node("PopupModeChoose")
		if popupModeChoose:
			labelModeSelectedNode.text = popupModeChoose.get_item_text(id)
			chooseType = popupModeChoose.get_item_text(id)
			popupModeChoose.visible = false


func onButtomModePressed():
	var popupMode = get_parent().get_parent().get_node("PopupModeChoose")
	if popupMode:
		popupMode.popup()
