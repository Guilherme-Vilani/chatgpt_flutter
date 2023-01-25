import openai
from dotenv import load_dotenv
import os
import json
from fastapi import FastAPI


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