source `pwd`/functions.sh

spell="F2"
cooldown=1
minimum=220

sleep 2

osd_text "Autohealing ON" 5

while true
do 
health=`get_hp`
get_flags
if [ $health -lt $minimum ] || [ $is_paralyzed -eq 1 ]; then sendkey $spell; fi
sleep $cooldown
done

