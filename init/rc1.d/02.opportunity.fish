function handle_new_opportunity -e opportunity_new -d "create and register a new opportunity as it arises"
    echo handle_new_opportunity
    set -g payload "$argv"
    log_payload $payload
    set -l id (get_unquoted payload id)
    set -l when (get_unquoted payload when)
    set -l opp_summary (get_unquoted payload opp_summary)
    set -l contact_name (get_unquoted payload contact_name)
    set -l contact_details (get_unquoted payload contact_details)
    set -l opp_path (crm_create_path $opp_summary)
    mkdir -p $opp_path
    echo -n $id > $opp_path/id
    echo -e "
# $opp_summary

Created:\t$when
Contact:\t$contact_name
Contact Details:\t$contact_details
" > $opp_path/index.md

echo "# Notes

" > $opp_path/notes
echo "# Activity

" > $opp_path/activity
echo -n "new" > $opp_path/state
end

function log_payload -d "output the whole of argv to stdout"
    echo $argv
end

function get_unquoted -a v k -d "description"
    echo (string replace -a "\"" "" (_get $v $k))
end