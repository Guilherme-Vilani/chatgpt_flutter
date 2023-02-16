from fastapi import APIRouter, Depends, HTTPException, Body
from fastapi.security import OAuth2PasswordRequestForm

from Services.mensagem_service import mensagem_Service

Route_Mensagens = APIRouter()

@Route_Mensagens.post("/envia-mensagem", status_code=200)
async def envia_mensagem(mensagem: str = Body(...)):
    return await mensagem_Service.enviaMensagem(mensagem)