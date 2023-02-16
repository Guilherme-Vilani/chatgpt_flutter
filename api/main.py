import openai
from dotenv import load_dotenv
import os
import json
from fastapi import FastAPI
import firebase_admin
from firebase_admin import messaging
from firebase_admin import credentials

cred = credentials.Certificate("serviceAccountKey.json")
firebase_admin.initialize_app(cred)



app = FastAPI()

load_dotenv('.env')
openai.api_key = os.getenv("API_KEY")

@app.post("/envia-mensagem")
def envia_mensagem(mensagem: str):
    def generate_text(mensagem):
        completions = openai.Completion.create(
            engine="text-davinci-003",
            prompt=mensagem,
            max_tokens=1024,
            n=1,
            stop=None,
            temperature=0.5,
        )

        message = completions.choices[0].text
        return message.strip()

    # exemplo de uso
    generated_text = generate_text(mensagem)
    return generated_text

@app.post("/dispara-push")
def apns_message():
    message = messaging.Message(
        apns=messaging.APNSConfig(
            headers={'apns-priority': '10'},
            payload=messaging.APNSPayload(
                aps=messaging.Aps(
                    alert=messaging.ApsAlert(
                        title='CHAT GPT WITH FLUTTER',
                        body='Boa tarde amigo, está precisando de ajuda?',
                    ),
                    badge=42,
                ),
            ),
        ),
        token='d82fQnnLmUALiiSGFra9nz:APA91bEWjgHdNvCtLb8Sb7XYm7p59mfujEbKNDJ9Gd4yVsciHQEiIezekuv7Cgb0cMk-8Od2iAY_E6EUcrXm_DXT084XpSHJo127ff8pAOQX2LIMcQcz7Nzu4aLxJ5spHp9diH5tZPR7',
    )

    return messaging.send(message)