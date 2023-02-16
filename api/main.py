import openai
from dotenv import load_dotenv
import os
from fastapi import FastAPI
import firebase_admin
from firebase_admin import messaging
from firebase_admin import credentials

#Controllers
from Controllers.mensagem_controller import Route_Mensagens


cred = credentials.Certificate("serviceAccountKey.json")
firebase_admin.initialize_app(cred)
load_dotenv('.env')
openai.api_key = os.getenv("API_KEY")


app = FastAPI(title="CHATGPT WITH FASTAPI",
    description="Documentação da API do chatbot GPT-3 com FastAPI",
    version="1.0.0")

app.include_router(Route_Mensagens, prefix='/api/mensagem', tags=["Mensagens"])

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