

function new_opportunity -a opp_summary agency contact_name contact_details
    set -g r '{"event_type": "opportunity-new"}'
    _set r id (uuidgen)
    _set r when (date --iso-8601=minutes)
    _set r opp_summary $opp_summary
    _set r agency $agency
    _set r contact_name $contact_name
    _set r contact_details $contact_details # freeform contact details such as phone, email etc
    echo $r
end

function opportunity_outcome -a id outcome
    set -g r '{"event_type": "opportunity-success"}'
    _set r when (date --iso-8601=minutes)
    _set r id $id
    _set r outcome $outcome
    echo $r
end

function opportunity_success -a id
    echo (opportunity_outcome -a $id 'success')
end

function opportunity_failure -a id
    echo (opportunity_outcome -a $id 'failure')
end

function opportunity_rejected -a id
    echo (opportunity_outcome -a $id 'rejected')
end

function opportunity_update -a id update_type update_body
    set -g r '{"event_type": "opportunity-update"}'
    _set r when (date --iso-8601=minutes)
    _set r id $id
    _set r update_type $update_type
    _set r content $update_body
    echo $r
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