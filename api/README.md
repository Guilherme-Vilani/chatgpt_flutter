Passo 1:
    pip install -r request.txt

Passo 2:
    vá para essa URL, https://beta.openai.com/account/api-keys e crie uma API Key, vc consegue criar ela no perfil do usuário.

Passo 3:
    copie a sua secret key.

Passo 4:
    crie um .env com uma variavel API_KEY e cole sua secret key, depois só executar o projeto.





## CRIANDO DOCKER ##

passo 1: 
    sudo yum docker install

passo 2:
    docker ps - se não aparecer uma resposta por conta de permissao é só colocar sudo na frente e teste, 
    mas se o erro for porque nao foi inicializado, execute o passo 3.

passo 3:
    sudo service docker start

passo 4:
    sudo yum install docker-compose
    pip3 install docker-compose

passo 5:
    sudo docker-compose up -d

