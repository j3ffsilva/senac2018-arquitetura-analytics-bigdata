# Como configurar o acesso ao GitHub pela Máquina Virtual (VM)


## Siga estes passos


### Gerando uma nova chave SSH


1. Abra um terminal na VM


2. Cole o comando abaixo, substituindo por seu e-mail cadastrado no GitHub

```
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

Este passo cria uma nova chave ssh, usando o e-mail fornecido. Você deverá ver uma mensagem como a seguir:

```
Generating public/private rsa key pair.
```


3. Quando solicitado a responder "Enter a file in which to save the key", tecle Enter. Dessa forma, aceita-se o local padrão do arquivo.


```
Enter a file in which to save the key (/home/you/.ssh/id_rsa): [Tecle enter]
```


4. No prompt, tecle enter na frase de segurança (sugestão)

```
Enter passphrase (empty for no passphrase): [Tecle Enter]
Enter same passphrase again: [Tecle Enter]
```


### Adicionando sua chave SSH ao ssh-agent

5. Inicialize o serviço do SSH agent 

```
eval "$(ssh-agent -s)"
```

Você deverá ter como resposta algo como (o número do pid será diferente para você):

```
Agent pid 59566
```


6. Adicione sua chave privada ao SSH-agent

```
ssh-add ~/.ssh/id_rsa
```


### Adicionado uma nova chave SSH a sua conta GitHub

7. Você deve copiar sua chave SSH para a área de transferência


7a. Você pode ter que instalar o xclip. Nesse caso, digite:

Lembre-se que a senha de admin da VM é `bigdata`.


```
sudo apt-get install xclip
```

7b. Para efetivamente copiar a chave SSH para a área de transferência

```
xclip -sel clip < ~/.ssh/id_rsa.pub
```


### Vá até a sua página do GitHub

8. Clique em sua foto e então em configurações (**Settings**)


9. No menu lateral, clique **SSH e GPG keys**


10. Clique **New SSH key** ou **Add SSH key**


11. Dê um nome descritivo, como "VM-Senac-Arq-BigData" e cole (CTRL-V) a chave no local apropriado.


12. Finalize com **Add SSH key**


### Vá até a raiz de um terminal

13. Crie um diretório para conter as aulas

```
mkdir aulas
```


14. Clone o projeto GitHub

```
git clone git@github.com:j3ffsilva/senac2018-arquitetura-analytics-bigdata.git
```

### Iniciando o jupyter

15. Vá até o projeto clonado do GitHub

ex:

```
cd ~/aulas/senac2018-arquitetura-analytics-bigdata
```

16. Inicie o Jupyter:

```
jupyter notebook
```
