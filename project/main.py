import logging
import os

from project import create_app

log = logging.getLogger("uvicorn")

app = create_app()
celery = app.celery_app

# if os.environ.get("WITH_NEW_RELIC"):
#     log.info("Booting New Relic agent...")
#     import newrelic.agent  # noqa


@app.on_event("startup")
def startup_event():
    print("Application started!")
