extends CanvasLayer

signal Winner

var gems = 0

func _ready():
	%CoinsCollectedText.text = "%d" % gems
	
func _on_gem_collected():
	gems +=1
	%CoinsCollectedText.text = "%d" % gems
	
	if gems == 5:
		emit_signal("Winner")
