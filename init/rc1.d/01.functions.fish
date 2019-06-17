#!/usr/bin/env fish

function crm -d "dispatcher function for fishdots_crm commands"
      if test 0 -eq (count $argv)
    crm_help
    return
  end
  switch $argv[1]
    case opp
      # crm opp <summary> <contact_name> <contact_details>
      on_new_opportunity $argv[2] $argv[3] $argv[4]
    case update
        crm_update
    # case cd
    #     project_cd $argv[2]
    # case goto
    #     project_goto $argv[2]
    # case help
    #     project_help
    # case home
    #     project_home
    # case ls
    #     project_list
    case open
        crm_open
    # case path
    #     project_path $argv[2]
    # case set
    #     project_set $argv[2]
    case sync
        project_sync
    # case todo
    #   emit task_project_new $argv[2]
    # case menu
    #   project_menu
    case '*'
      crm_help
  end
end

function crm_help -d "display usage info"
  
  echo "CRM:"
  colour_print normal "  Current Opportunity: "
  colour_print green $FD_CRM_CURRENT
  echo ""
  colour_print normal "                       "
  colour_print green (crm_get_current_opp_path)
  echo ""
  echo ""

  echo "USAGE:"
  echo ""
  echo "crm <command> [options] [args]"
  echo ""
  _fd_display_option 'crm' 'opp <summary> <contact_name> <contact_details>' "create a new opportunity"
  _fd_display_option 'crm' "help" "display usage info"
  _fd_display_option 'crm' "open" "choose current crm opportunity"
  _fd_display_option 'crm' "sync" "save activity to git origin"
  echo ""
end

function crm_open -d "select an opportunity"
  crm_select_opp
  if test $status -eq 0
    set -U FD_CRM_CURRENT $selected_opportunity
    set -e selected_opportunity
  end
end

function crm_select_opp -d "select an opportunity"
  set matches (find $FD_CRM_HOME/ -maxdepth 1 -mindepth 1 -type d ! -name ".git")
  if test 1 -eq (count $matches) and test -d $matches
    set -U selected_opportunity (crm_get_opp_id_by_path $matches[1])
    return 0
  end
  set -g dcmd "dialog --stdout --no-tags --menu 'select the file to edit' 20 60 20 " 
  set c 1
  for option in $matches
    set l (get_file_relative_path $option)
    set -g dcmd "$dcmd $c '$l'"
    set c (math $c + 1)
  end
  set choice (eval "$dcmd")
  clear
  if test $status -eq 0
    set -U selected_opportunity (crm_get_opp_id_by_path $matches[$choice])
    return 0
  else
    return 1
  end
end

function crm_create_path -a summary -d "USAGE: crm_create_path 'blah' => ~/crm/2018-02-21.mojo.md"
    set -l title_slug (string sub -l 32 (string replace " " "_" $summary))
    set -l title_slug (string sub -l 32 (string replace "\"" "" $summary))
    set -l d (date --iso-8601)
    echo "$FD_CRM_HOME/$d-$title_slug"
end

function crm_sync -d "save all crm updates to origin repo"
  fishdots_git_sync $FD_CRM_HOME "crm updates and activity"
end

function crm_create_new_opp -d "display a form to gather info for creating a new opportunity"
set x (dialog --ok-label 'submit' --backtitle 'Create new opportunity'  --title 'new opportunity' --form 'new opportunity'  15 80 0 'summary:' 1 1	'' 1 10 50 0 'name:'    2 1	'' 2 10 50 0 'details:' 3 1	'' 3 10 50 0)

end

function get_input -a prompt var_name -d 'get user input and place it in var_name'
  read --global --prompt-str="$prompt" $var_name
end

function crm_update -d "description"
  crm_select_opp
  if test $status -eq 0
    set id $selected_opportunity; set -e selected_opportunity
    get_input 'type of update ("contact, meeting, email): ' update_type
    get_input 'details: ' content
    on_opportunity_update $id "$update_type" "$content"
  end
end