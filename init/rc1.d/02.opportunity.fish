function handle_new_opportunity -e opportunity_new -d "create and register a new opportunity as it arises"
    set -g payload "$argv"
    set -l id (get_unquoted payload id)
    set -l when (get_unquoted payload when)
    set -l opp_summary (get_unquoted payload opp_summary)
    set -l agency (get_unquoted payload agency)
    set -l contact_name (get_unquoted payload contact_name)
    set -l contact_details (get_unquoted payload contact_details)
    set -l opp_path (crm_create_path $agency"_"$opp_summary)
    mkdir -p $opp_path
    echo -n $id > $opp_path/id
    echo -e "
# $opp_summary

Created:         $when
Agency:          $agency
Contact:         $contact_name
Contact Details: $contact_details
Path:            $opp_path
" > $opp_path/index.md

echo "# Notes

" > $opp_path/notes
echo "# Activity

| When | Type | What |
| :--- | :--- | :--- |" > $opp_path/activity
echo -n "new" > $opp_path/state
end


function handle_opportunity_update -e opportunity_update
    set -g payload "$argv"
    set -l id (get_unquoted payload id)
    set -l when (get_unquoted payload when)
    set -l update_type (get_unquoted payload update_type)
    set -l content (get_unquoted payload content)
    set -l opp_path (crm_get_opp_path_by_id $id)
    echo -e "| $when | $update_type | $content |" >> $opp_path/activity
end