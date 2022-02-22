extends Panel

var id = 0
var type = ""
var timeAppear = 0.0
var timeUse = 0.0
var docString = ""

func getId() -> String:
	return id
	
func setId(newId):
	id = newId
	
func setInfo(info):
	id = info.id
	type = info.type
	timeAppear = info.time_appear
	timeUse = info.time_use
	docString = info.doc_string
	setNameDescription()

func setNameDescription():
	var label = get_node("Label")
	label.text = docString
