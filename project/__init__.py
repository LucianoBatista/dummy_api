from fastapi import FastAPI

from project.app.routers import event_router
from project.app.celery.config import create_celery


def create_app() -> FastAPI:
    app = FastAPI()
    app.celery_app = create_celery()
    app.include_router(event_router)

    return app
