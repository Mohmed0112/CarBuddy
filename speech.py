import speech_recognition as sr

if __name__ == "__main__":
    init_rec = sr.Recognizer()
    with sr.Microphone() as source:
        audio_data = init_rec.record(source, duration=5)
        text = init_rec.recognize_google(audio_data)
        print(text)
        exit()
