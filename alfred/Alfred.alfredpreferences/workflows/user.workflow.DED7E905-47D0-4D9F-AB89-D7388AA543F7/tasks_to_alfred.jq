{
    items: [
        .list.items.edges[]|
            .node.item_title as $TITLE|
            ($TITLE | gsub("[^a-zA-Z0-9]";" ")) as $CLEAN_TITLE|
            (.node.task_number|tostring) as $ID|
            ("T" + $ID) as $TID|
            .node.task_priority as $PRI|
            .node.task_owner.full_name as $NAME|
            .node.task_owner.unixname as $UNIX|
            (.node.updated_time|strftime("%b %d, %Y")) as $UPDATED|
            (.node.task_tags.nodes|[.[]|.name]|sort|join(" ")) as $TAGS|
            {
                uid: $ID,
                title: $TITLE,
                subtitle: ($TID + " " + $NAME + " (" + $UNIX + ")" + " updated " + $UPDATED + " " + $TAGS),
                match: (
                    [$TID, $UNIX, $NAME, $CLEAN_TITLE, $TAGS]|join(" ")
                ),
                arg: $ID,
                text: {
                    copy: $TID
                }
            }
    ]
}
