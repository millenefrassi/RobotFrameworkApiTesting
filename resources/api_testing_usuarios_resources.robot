*** Settings ***

Library    RequestsLibrary   
Library    String
Library    Collections

*** Keywords ***
Criar um novo usuario novo
    ${palavra_aleatoria}    Generate Random String    length=4    chars=[LETTERS]
    ${palavra_aleatoria}    Convert To Lower Case    ${palavra_aleatoria}
    Log    Minha palavra aleatoria ${palavra_aleatoria}@emailteste.com
    Set Test Variable    ${EMAIL_TESTE}    ${palavra_aleatoria}@emailteste.com
    Log    ${EMAIL_TESTE}  

Cadastrar o usuario criado na ServerRest
    [Arguments]    ${email}    ${status_code_desejado}
    ${body}    Create Dictionary
    ...    nome=Fulano da Silva    
    ...    email=${EMAIL_TESTE}    
    ...    password=1234    
    ...    administrador=true
    Log    ${body}
    Criar Sessao na ServerRest

    ${resposta}    POST On Session    
    ...    alias=ServeRest
    ...    url=/usuarios
    ...    json=${body}
    ...    expected_status=${status_code_desejado}
    
    Log    ${resposta.json()}
    
    IF   ${resposta.status_code} == 201
           Set Test Variable    ${ID_USUARIO}    ${resposta.json()["_id"]}
    END
 
    Set Test Variable    ${RESPOSTA}    ${resposta.json()}
    Log To Console    ${RESPOSTA}
    # Log To Console    ${ID_USUARIO}

Criar Sessao na ServerRest
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json
    Create Session    alias=ServeRest    url=https://serverest.dev    headers=${headers}

Conferir se o usuario foi cadastrado corretamente
    Log    ${RESPOSTA}
    Dictionary Should Contain Item    ${RESPOSTA}    message     Cadastro realizado com sucesso
    Dictionary Should Contain Key    ${RESPOSTA}     _id

Vou repetir o cadastro do usuario
    Cadastrar o usuario criado na ServerRest    ${EMAIL_TESTE}    status_code_desejado=400

Verificar se a API não permitiu o cadastro repetido
    Dictionary Should Contain Item    ${RESPOSTA}    message    Este email já está sendo usado

Consultar os dados de um novo usuario
    ${resposta_consulta}    GET On Session    alias=ServeRest    url=/usuarios/${ID_USUARIO}    expected_status=200
    Log    ${resposta_consulta.status_code}
    Log    ${resposta_consulta.reason}
    Log    ${resposta_consulta.headers}
    Log    ${resposta_consulta.elapsed}
    Log    ${resposta_consulta.text}
    Log    ${resposta_consulta.json()}

    Set Test Variable    ${RESP_CONSULTA}    ${resposta_consulta.json()}

Conferir os dados retornados
    Log    ${RESP_CONSULTA}
    Dictionary Should Contain Item    ${RESP_CONSULTA}     nome                Fulano da Silva
    Dictionary Should Contain Item    ${RESP_CONSULTA}     email               ${EMAIL_TESTE}
    Dictionary Should Contain Item    ${RESP_CONSULTA}     password            1234
    Dictionary Should Contain Item    ${RESP_CONSULTA}     administrador       true
    Dictionary Should Contain Item    ${RESP_CONSULTA}     _id                 ${ID_USUARIO}                
        
Realizar Login com o usuário
    ${body}  Create Dictionary
    ...      email=${EMAIL_TESTE}
    ...      password=1234  
    
    Criar Sessao na ServerRest

    ${resposta}  POST On Session
    ...          alias=ServeRest
    ...          url=/login
    ...          json=${body}
    ...          expected_status=200

    Set Test Variable    ${RESPOSTA}    ${resposta.json()} 

Conferir se o Login ocorreu com sucesso
    Log  ${RESPOSTA}
    Dictionary Should Contain Item  ${RESPOSTA}  message  Login realizado com sucesso
    Dictionary Should Contain Key   ${RESPOSTA}  authorization