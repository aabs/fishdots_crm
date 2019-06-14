#!/usr/bin/env fish

function crm -d "dispatcher function for fishdots_crm commands"
      if test 0 -eq (count $argv)
    project_help
    return
  end
  switch $argv[1]
    case opp
      # crm opp <summary> <contact_name> <contact_details>
      on_new_opportunity $argv[2] $argv[3] $argv[4]
    # case e
    #     edit_project $argv[2]
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
    # case sync
    #     project_sync
    # case todo
    #   emit task_project_new $argv[2]
    # case menu
    #   project_menu
    case '*'
      project_help
  end

end

function crm_open -d "select an opportunity"
  set matches (find $FD_CRM_HOME/ -maxdepth 1 -mindepth 1 -type d ! -name ".git")
  if test 1 -eq (count $matches) and test -d $matches
    set -U FD_CRM_CURRENT (crm_get_opp_id_by_name $matches[1])
    echo "chose option 1"
    return
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
  echo "edit option $choice"
    set -U FD_IDEA_CURRENT (crm_get_opp_id_by_name $matches[$choice])
  end

end

function crm_get_opp_id_by_name -a name -d "get the ID for an opp by using the top level folder name of the opp"
  set -l id_path "$FD_CRM_HOME/$name/id"
  if test -d $id_path
    cat $id_path
  else
    echo -n "nil"
  end
end

function crm_create_path -a summary -d "USAGE: crm_create_path 'blah' => ~/crm/2018-02-21.mojo.md"
    set -l title_slug (string sub -l 32 (string replace " " "_" $summary))
    set -l title_slug (string sub -l 32 (string replace "\"" "" $summary))
    set -l d (date --iso-8601)
    echo "$FD_CRM_HOME/$d-$title_slug"
end
