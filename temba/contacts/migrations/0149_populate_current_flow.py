# Generated by Django 4.0.2 on 2022-02-11 19:55

from django.db import migrations, transaction
from django.utils import timezone


def populate_current_flow(apps, schema_editor):  # pragma: no cover
    FlowSession = apps.get_model("flows", "FlowSession")

    max_id = 0
    num_updated = 0

    while True:
        batch = list(
            FlowSession.objects.filter(status="W", id__gt=max_id)
            .select_related("contact")
            .only("current_flow", "contact__current_flow")
            .order_by("id")[:1000]
        )
        if not batch:
            break

        with transaction.atomic():
            for session in batch:
                session.contact.current_flow_id = session.current_flow_id
                session.contact.modified_on = timezone.now()
                session.contact.save(update_fields=("current_flow_id", "modified_on"))
                num_updated += 1

        print(f"Updated current flow on {num_updated} contacts")

        max_id = batch[-1].id


def reverse(apps, schema_editor):  # pragma: no cover
    pass


def apply_manual():  # pragma: no cover
    from django.apps import apps

    populate_current_flow(apps, None)


class Migration(migrations.Migration):

    dependencies = [
        ("contacts", "0148_fix_inactive_contacts_in_groups"),
    ]

    operations = [migrations.RunPython(populate_current_flow, reverse)]
