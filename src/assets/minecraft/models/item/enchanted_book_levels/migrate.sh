#!/bin/bash

set -eu -o pipefail
IFS=''

function enchant_init(){
	local id=$1;

	echo """
{
	\"parent\": \"item/enchanted_book_levels/${id}1\",
	\"overrides\": []
}
""";
}

function level_append(){
	local id=$1;
	local lvl=$2;

	jq -b ".overrides += [{\"predicate\":{\"level\": $lvl}, \"model\": \"item/enchanted_book_levels/$id$lvl\"}]"
}


function enchant_level(){
	local id=$1;
	local lvl=$2;
	local dst="../enchanted_book/$id.json"

	if ! [[ -f $dst ]]
	then enchant_init $id >$dst
	fi;

	if ! [[ $lvl = 1 ]]
	then 
		local in=`cat $dst`;
		level_append $id $lvl <<<"$in" >$dst
	fi;

}

for f in *.json
do if [[ -f $f ]] && [[ $f =~ ^([a-z_]+)([0-9]).json$ ]]
then
	enchant_level ${BASH_REMATCH[1]} ${BASH_REMATCH[2]}
fi
done;
