# Testando

- Para testar basta buildar a aplicação pelo docker-compose.
- O NewRelic está apenas para o worker e tudo fou feito pelo newrelic.ini.
- A senha eu passo pelo slack
- o arquivo que inicializa o newrelic é o `project>app>routers>event_trigger.py`
  - as três primeiras linhas se você comenta, o comportamento esperado funciona.
  - se você descomenta, apenas a task `event_celery_trigger` vai funcinar, e o log pode ser ver visto new-relic

Depois de buildado, vc consegue acessar o swagger no localhost:8010.
