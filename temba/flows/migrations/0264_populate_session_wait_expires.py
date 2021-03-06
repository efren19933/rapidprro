# Generated by Django 3.2.9 on 2022-01-05 21:13

from datetime import timedelta

from django.db import migrations, transaction
from django.db.models import Q
from django.utils import timezone

EXPIRES_DEFAULTS = {
    "M": 60 * 24 * 7,  # 1 week
    "V": 5,  # 5 minutes
    "B": 0,
    "S": 0,
}


def populate_session_wait(apps, schema_editor):  # pragma: no cover
    FlowSession = apps.get_model("flows", "FlowSession")
    FlowRun = apps.get_model("flows", "FlowRun")

    num_updated = 0
    num_expired = 0

    while True:
        with transaction.atomic():
            # get a batch of waiting sessions which don't have wait_started_on or wait_expires_on set
            batch = list(
                FlowSession.objects.filter(status="W")
                .filter(Q(wait_started_on__isnull=True) | Q(wait_expires_on__isnull=True))
                .only("id", "status", "session_type", "wait_started_on", "wait_expires_on", "ended_on")[:1000]
            )
            if not batch:
                break

            # get the waiting runs that belong to these sessions
            session_ids = [s.id for s in batch]
            waiting_runs = FlowRun.objects.filter(status="W", session_id__in=session_ids).only(
                "session", "modified_on", "expires_on"
            )
            waiting_runs_by_session = {r.session_id: r for r in waiting_runs}

            for session in batch:
                waiting_run = waiting_runs_by_session.get(session.id)
                if waiting_run:
                    # if we have a waiting run, use its wait details
                    if not session.wait_started_on:
                        session.wait_started_on = waiting_run.modified_on
                    if not session.wait_expires_on:
                        session.wait_expires_on = waiting_run.expires_on

                    # if run didn't have a expires_on.. use default for flow type
                    if not session.wait_expires_on:
                        default_expires_after = EXPIRES_DEFAULTS[session.session_type]
                        session.wait_expires_on = session.wait_started_on + timedelta(minutes=default_expires_after)

                    session.save(update_fields=("wait_started_on", "wait_expires_on"))
                    num_updated += 1
                else:
                    # if we don't have a waiting run.. we're in an invalid state so expire this session
                    session.status = "X"
                    session.ended_on = timezone.now()
                    session.wait_started_on = None
                    session.wait_expires_on = None
                    session.save(update_fields=("status", "ended_on", "wait_started_on", "wait_expires_on"))
                    num_expired += 1

            print(f" > updated {num_updated}, expired {num_expired}")


def reverse(apps, schema_editor):  # pragma: no cover
    pass


def apply_manual():  # pragma: no cover
    from django.apps import apps

    populate_session_wait(apps, schema_editor=None)


class Migration(migrations.Migration):

    dependencies = [
        ("flows", "0263_remove_recent_runs_from_triggers"),
    ]

    operations = [migrations.RunPython(populate_session_wait, reverse)]
