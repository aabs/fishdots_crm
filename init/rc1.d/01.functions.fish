#!/usr/bin/env fish

function crm -d "dispatcher function for fishdots_crm commands"
      if test 0 -eq (count $argv)
    project_help
    return
  end
  switch $argv[1]
    # case add
    #   # project add <name> <path> <desc>
    #   emit add_project $argv[2] $argv[3] $argv[4]
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
    # case open
    #     project_open
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