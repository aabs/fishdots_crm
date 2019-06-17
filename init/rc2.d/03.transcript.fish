
function crm_opp_activity_by_id -a id -d 'pretty list of activity on an opportunity'
    set -l fields_new '[.when,.agency,.opp_summary]'
    set -l fields_update '[.when,.update_type,.content]'
    set -l fields_default '[.when,.event_type]'
    fdt_ls -t opportunity | jq -r '. | select(.id == "'$id'") | if .event_type == "opportunity-new" then '$fields_new' elif  .event_type == "opportunity-update" then '$fields_update' else '$fields_default' end | join("\t\t")' | sort -r
end
