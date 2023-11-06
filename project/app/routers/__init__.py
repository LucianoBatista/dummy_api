from fastapi import APIRouter

event_router = APIRouter(prefix="/event", tags=["Event"])

from . import event_trigger  # noqa: E402 F401
