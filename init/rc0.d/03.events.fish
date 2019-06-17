function on_new_opportunity -a opp_summary agency contact_name contact_details
    set r (new_opportunity $opp_summary $agency $contact_name $contact_details)
    echo $r
    emit new_event $r
    emit opportunity_new $r
end

function on_opportunity_outcome -a id outcome
    set r (opportunity_outcome $id $outcome)
    emit new_event $r
    emit opportunity_outcome $r
end

function on_opportunity_success -a id
    on_opportunity_outcome $id 'success'
end

function on_opportunity_failure -a id
    on_opportunity_outcome $id 'failure'
end

function on_opportunity_rejected -a id
    on_opportunity_outcome $id 'rejected'
end

function on_opportunity_update -a id update_type update_body
    set r (opportunity_update $id $update_type $update_body)
    emit new_event $r
    emit opportunity_update $r
end