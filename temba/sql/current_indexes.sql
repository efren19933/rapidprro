-- Generated by collect_sql on 2017-03-09 17:12 UTC

CREATE INDEX CONCURRENTLY locations_adminboundary_name on locations_adminboundary(upper("name"))

CREATE INDEX CONCURRENTLY locations_boundaryalias_name on locations_boundaryalias(upper("name"))

CREATE INDEX CONCURRENTLY values_value_field_datetime_value_not_null
ON values_value(contact_field_id, datetime_value)
WHERE contact_field_id IS NOT NULL AND datetime_value IS NOT NULL;

CREATE INDEX CONCURRENTLY values_value_field_decimal_value_not_null
ON values_value(contact_field_id, decimal_value)
WHERE contact_field_id IS NOT NULL AND decimal_value IS NOT NULL;

CREATE INDEX CONCURRENTLY values_value_field_string_value_concat
ON values_value((contact_field_id || '|' || UPPER(string_value)));

-- index for fast fetching of unsquashed rows
CREATE INDEX channels_channelcount_unsquashed
ON channels_channelcount(channel_id, count_type, day) WHERE NOT is_squashed;

CREATE INDEX channels_channelevent_api_view
ON channels_channelevent(org_id, created_on DESC, id DESC)
WHERE is_active = TRUE;

CREATE INDEX channels_channelevent_calls_view
ON channels_channelevent(org_id, "time" DESC)
WHERE is_active = TRUE AND event_type IN ('mt_call', 'mt_miss', 'mo_call', 'mo_miss');

CREATE INDEX channels_channellog_channel_created_on
ON channels_channellog(channel_id, created_on desc);

CREATE INDEX contacts_contact_org_modified_id_where_nontest_active
ON contacts_contact (org_id, modified_on DESC, id DESC)
WHERE is_test = false AND is_active = true;

CREATE INDEX contacts_contact_org_modified_id_where_nontest_inactive
ON contacts_contact (org_id, modified_on DESC, id DESC)
WHERE is_test = false AND is_active = false;

-- index for fast fetching of unsquashed rows
CREATE INDEX contacts_contactgroupcount_unsquashed
ON contacts_contactgroupcount(group_id) WHERE NOT is_squashed;

CREATE INDEX flows_flowpathcount_unsquashed ON flows_flowpathcount(flow_id, from_uuid, to_uuid, period) WHERE NOT is_squashed

CREATE INDEX flows_flowpathrecentstep_from_to_left ON flows_flowpathrecentstep (from_uuid, to_uuid, left_on DESC)

CREATE INDEX flows_flowrun_expires_on ON flows_flowrun(expires_on) WHERE is_active = TRUE;

CREATE INDEX flows_flowrun_flow_modified_id ON flows_flowrun (flow_id, modified_on DESC, id DESC);

CREATE INDEX flows_flowrun_flow_modified_id_where_responded ON flows_flowrun (flow_id, modified_on DESC, id DESC) WHERE responded = TRUE;

CREATE INDEX flows_flowrun_null_expired_on ON flows_flowrun (exited_on) WHERE exited_on IS NULL;

CREATE INDEX flows_flowrun_org_modified_id ON flows_flowrun (org_id, modified_on DESC, id DESC);

CREATE INDEX flows_flowrun_org_modified_id_where_responded ON flows_flowrun (org_id, modified_on DESC, id DESC) WHERE responded = TRUE;

CREATE INDEX flows_flowrun_parent_created_on_not_null ON flows_flowrun (parent_id, created_on desc) WHERE parent_id IS NOT NULL;

CREATE INDEX flows_flowrun_timeout_active ON flows_flowrun (timeout_on) WHERE is_active = TRUE AND timeout_on IS NOT NULL;

CREATE INDEX flows_flowruncount_unsquashed ON flows_flowruncount(flow_id, exit_type) WHERE NOT is_squashed

CREATE INDEX msgs_broadcasts_org_created_id_where_active
ON msgs_broadcast(org_id, created_on DESC, id DESC)
WHERE is_active = true;

CREATE INDEX msgs_msg_external_id_where_nonnull
ON msgs_msg(external_id)
WHERE external_id IS NOT NULL;

CREATE INDEX msgs_msg_org_created_id_where_outbound_visible_failed
ON msgs_msg(org_id, created_on DESC, id DESC)
WHERE direction = 'O' AND visibility = 'V' AND status = 'F';

CREATE INDEX msgs_msg_org_created_id_where_outbound_visible_outbox
ON msgs_msg(org_id, created_on DESC, id DESC)
WHERE direction = 'O' AND visibility = 'V' AND status IN ('P', 'Q');

CREATE INDEX msgs_msg_org_created_id_where_outbound_visible_sent
ON msgs_msg(org_id, created_on DESC, id DESC)
WHERE direction = 'O' AND visibility = 'V' AND status IN ('W', 'S', 'D');

CREATE INDEX msgs_msg_org_modified_id_where_inbound
ON msgs_msg (org_id, modified_on DESC, id DESC)
WHERE direction = 'I';

CREATE INDEX msgs_msg_responded_to_not_null
ON msgs_msg (response_to_id)
WHERE response_to_id IS NOT NULL;

CREATE INDEX msgs_msg_visibility_type_created_id_where_inbound
ON msgs_msg(org_id, visibility, msg_type, created_on DESC, id DESC)
WHERE direction = 'I';

-- index for fast fetching of unsquashed rows
CREATE INDEX msgs_systemlabel_unsquashed
ON msgs_systemlabel(org_id, label_type) WHERE NOT is_squashed;

CREATE INDEX org_test_contacts
ON contacts_contact (org_id) WHERE is_test = TRUE;

-- indexes for fast fetching of unsquashed rows
CREATE INDEX orgs_debit_unsquashed_purged
ON orgs_debit(topup_id) WHERE NOT is_squashed AND debit_type = 'P';

CREATE INDEX orgs_topupcredits_unsquashed
ON orgs_topupcredits(topup_id) WHERE NOT is_squashed;

CREATE INDEX values_value_contact_field_location_not_null
ON values_value(contact_field_id, location_value_id)
WHERE contact_field_id IS NOT NULL AND location_value_id IS NOT NULL;

