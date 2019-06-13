function on_new_opportunity -a opp_summary contact_name contact_details
    set -g r '{"event_type": "opportunity-new"}'
    _set r id (uuidgen)
    _set r when (date --iso-8601=minutes)
    _set r opp_summary $opp_summary
    _set r contact_name $contact_name
    _set r contact_details $contact_details # freeform contact details such as phone, email etc
    emit new_event $r
    emit opportunity_new $r
end

function on_opportunity_outcome -a id outcome
    set -g r '{"event_type": "opportunity-success"}'
    _set r when (date --iso-8601=minutes)
    _set r id $id
    _set r outcome $outcome
    emit new_event $r
    emit opportunity_outcome $r
end

function on_opportunity_success -a id
    on_opportunity_outcome -a $id 'success'
end

function on_opportunity_failure -a id
    on_opportunity_outcome -a $id 'failure'
end

function on_opportunity_rejected -a id
    on_opportunity_outcome -a $id 'rejected'
end

function on_opportunity_update -a id update_type update_body
    set -g r '{"event_type": "opportunity-update"}'
    _set r when (date --iso-8601=minutes)
    _set r id $id
    _set r update_type $update_type
    _set r content $update_body
    emit new_event $r
    emit opportunity_update $r
end


# CRM workflow
# triage -> opportunity -> various comms & meetings -> decision -> end
#                       ^                          |
#                       |__________________________|

# CRM EVENTS
#   - [X] new opportunity
#   - [ ] incoming comms
#   - [ ] outgoing comms
#   - [ ] meeting scheduled
#   - [ ] meeting attended
#   - [ ] meeting feedback
#   - [X] opportunity decision
#   - [X] opportunity notes
#   - [X] opportunity closed