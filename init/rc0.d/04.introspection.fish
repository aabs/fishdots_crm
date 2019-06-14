function crm_get_opp_id_by_path -a abs_path -d "get the ID for an opp by using the top level folder name of the opp"
  set -l id_path "$abs_path/id"
  if test -e $id_path
    cat $id_path
  else
    echo -n "nil"
  end
end

function crm_get_opp_path_by_id -a id -d "search for an opportunity with an id matching id supplied"
  set opp_ids (find $FD_CRM_HOME -name id)
  for idfilepath in $opp_ids
    if test (cat $idfilepath) = $id 
      echo (dirname $idfilepath)
      return 0
    end
  end
end


function crm_get_current_opp_path
  crm_get_opp_path_by_id $FD_CRM_CURRENT
end