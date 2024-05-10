import newrelic.agent

newrelic.agent.initialize("newrelic.ini")
from celery import shared_task
from celery.signals import task_success

from project.app.routers import event_router


@event_router.post("/trigger")
async def trigger_event():
    _ = event_celery_trigger.delay()
    return {"message": "Event triggered!"}


@shared_task
def event_celery_trigger():
    print("Event triggered!")
    return True


@shared_task
def event_celery_trigger2():
    print("Signal is working")
    return True


@task_success.connect(sender=event_celery_trigger, weak=False)
def event_celery_trigger_success_handler(sender, result, **kwargs):
    print("Event triggered successfully!")
    event_celery_trigger2.delay()
    return True
