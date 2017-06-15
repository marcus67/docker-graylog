#! /bin/ash
# This file expects as environment variables:
# 
# TARGET_USERNAME: registered user in container running service
# TARGET_UID: desired UID which will be used as new uid for the TARGET_USERNAME
# TARGET_GROUPNAME: registered group in container running service
# TARGET_GID: desired GID which will be used as new gid for the TARGET_GROUPNAME

echo "move_uid_id_and_gid.sh: start..."
if [ "$TARGET_USERNAME"  != "" ] ; then

    echo "move_uid_id_and_gid.sh: checking target user $TARGET_USERNAME..."
    CURRENT_UID=`id -u $TARGET_USERNAME`
    if [ $TARGET_UID != $CURRENT_UID ] ; then        
        echo "move_uid_id_and_gid.sh: replacing UID $CURRENT_UID by $TARGET_UID in /etc/passwd..."
        sed -i "s/^\([a-zA-Z0-9]\+:[a-zA-Z0-9_]*:\)$CURRENT_UID\(:.*\)/\1$TARGET_UID\2/" /etc/passwd
        echo "move_uid_id_and_gid.sh: replacing UID $CURRENT_UID by $TARGET_UID in /etc/group..."
        sed -i "s/^\([a-zA-Z0-9]\+:[a-zA-Z0-9_]*:[0-9]\+:\)$CURRENT_GID\(:.*\)/\1$TARGET_GID\2/" /etc/passwd
        echo "move_uid_id_and_gid.sh: updating UID of all affected files..."
        find / -path /proc -prune -o -path /sys -prune -o -path /dev -prune -o -user $CURRENT_UID -exec chown $TARGET_USERNAME {} \;
    fi
fi

if [ "$TARGET_GROUPNAME"  != "" ] ; then

    echo "move_uid_id_and_gid.sh: checking target group $TARGET_GROUPNAME..."
    
    CURRENT_GID=`id -g $TARGET_GROUPNAME`

    if [ $TARGET_GID != $CURRENT_GID ] ; then
        echo "move_uid_id_and_gid.sh: replacing GID $CURRENT_GID by $TARGET_GID..."
        sed -i "s/^\([a-zA-Z0-9]\+:[a-zA-Z0-9_]*:\)$CURRENT_GID\(:.*\)/\1$TARGET_GID\2/" /etc/group
        echo "move_uid_id_and_gid.sh: updating GID of all affected files..."
        find / -path /proc -prune -o -path /sys -prune -o -path /dev -prune -o -group $CURRENT_GID -exec chgrp $TARGET_GROUPNAME {} \;
    fi
fi
echo "move_uid_id_and_gid.sh: end..."
