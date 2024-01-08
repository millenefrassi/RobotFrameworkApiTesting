*** Settings ***
Resource    ../resources/api_testing_usuarios_resources.robot


*** Variables ***


*** Test Cases ***
Cenario 01: Cadastrar um novo usuario com sucesso na ServerRest
    Criar um novo usuario novo
    Cadastrar o usuario criado na ServerRest    email=${EMAIL_TESTE}    status_code_desejado=201
    Conferir se o usuario foi cadastrado corretamente

Cenario 02: Cadastrar um usuario ja existente
    Criar um novo usuario novo
    Cadastrar o usuario criado na ServerRest    email=${EMAIL_TESTE}    status_code_desejado=201  
    Vou repetir o cadastro do usuario
    Verificar se a API não permitiu o cadastro repetido        

Cenario 03: Consultar os dados de um novo usuário
    Criar um novo usuario novo
    Cadastrar o usuario criado na ServerRest    email=${EMAIL_TESTE}    status_code_desejado=201 
    Consultar os dados de um novo usuario
    Conferir os dados retornados   

Cenário 04: Logar com o novo usuário criado
    Criar um novo usuario novo
    Cadastrar o usuario criado na ServerRest    email=${EMAIL_TESTE}    status_code_desejado=201 
    Realizar Login com o usuário
    Conferir se o Login ocorreu com sucesso