import openai

class mensagem_Service(object):

    def __init__(self):
        pass

    @classmethod
    async def enviaMensagem(self, mensagem: str):
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