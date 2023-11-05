extends Control

var key
var history = []
var speech_to_text

var link = "https://api.openai.com/v1/chat/completions"
var header


func _ready():
	var file = File.new()
	file.open("apiKey.txt", file.READ)
	var content = file.get_as_text()
	key = content

	file.close()
	header = ["Content-type: application/json", "Authorization: Bearer " + key]
	
	speech_to_text =  $SpeechToText
	speech_to_text.init()
	while not speech_to_text.can_speak():
		yield(get_tree(), "idle_frame")
	$Button.disabled = false
	print("godot-speech-to-text plugin loaded")

func getResponse():
	var query = JSON.print({
		"messages":history,
		"temperature":0.7,
		"max_tokens":1024,
		"model": "gpt-3.5-turbo"
	})
	
	print(query)
	
	$HTTPRequest.request(link, header, true, HTTPClient.METHOD_POST, query)

func _on_HTTPRequest_request_completed(result, _response_code, _headers, body):
	if(result == HTTPRequest.RESULT_SUCCESS):
		var json = JSON.parse(body.get_string_from_utf8()).result
		if(json != null):
			var r = json["choices"][0]["message"]["content"]
			print(r)
			history.append({"role": "assistant", "content": r})
			yield($TextToSpeech.say(r, TextToSpeech.VOICE_AWB, 1), "completed")
	else:
		print("Yowza")


func _on_Button_button_down():
	if speech_to_text.can_speak():
		print("Speech recognition started")
		speech_to_text.start()


func _on_Button_button_up():
	if speech_to_text.am_speaking():
		var result = speech_to_text.stop_and_get_result()
		if result is GDScriptFunctionState:
			result = yield(result, "completed")
		history.append({"role": "user", "content": result})
		print(result)
		getResponse()
