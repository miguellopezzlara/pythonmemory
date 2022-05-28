#---------------------------------------- CONSTANTS -----------------------------
enter_game_button="120 785"
zoom_out="1240 85"
zoom_in="1240 110"
map_centre_x=1168
map_centre_y=84

addr_health="0x85A6158"
addr_mana="0x85A6208"
addr_exp="0x85A6160"
addr_x="0x842C6A0"
addr_y="0x842C6A4"
addr_z="0x842C6A8"
addr_flags="0x85a6260"

addr_soul="85A6210"
addr_lvl="85A6168"
addr_mlev="85A616C"
addr_perc_lvl="85A6200"
addr_perc_mlev="85A6204"

addr_fist="85A6228"
addr_club="85A622C"
addr_sword="85A6230"
addr_axe="85A6234"
addr_dist="85A6238"
addr_shield="85A623C"
addr_fishing="85A6240"

#----------------------------------- ROTATION & MOVEMENT ------------------------
function rot_l(){
sendkey "Control_R+Left"; }
function rot_r(){
sendkey "Control_R+Right"; }
function rot_u(){
sendkey "Control_R+Up"; }
function rot_d(){
sendkey "Control_R+Down"; }
function mov_d(){
sendkey "Down"; }
function mov_u(){
sendkey "Up"; }
function mov_l(){
sendkey "Left"; }
function mov_r(){
sendkey "Right"; }

function click_map(){
p_x=$(echo "$map_centre_x+$1" | bc)
p_y=$(echo "$map_centre_y+$2" | bc)
mouse_click $p_x $p_y 1; }

#-------------------------------------- SENDING MSGs ----------------------------
#function sendtext(){
#xvkbd -xsendevent -text "$1"; }

function mouse_move(){
xdotool mousemove $1 $2; }

function mouse_click(){
tibia_window=`xdotool search --name "Tibia Player"`
xdotool mousemove $1 $2 click --window $tibia_window $3 mousemove restore; }

function sendtext(){
tibia_window=`xdotool search --name "Tibia Player"`
xdotool type --window $tibia_window "$1"; }

function sendkey(){
xdotool search --name "Tibia Player" key "$1"; }

#---------------------------------------- READING -------------------------------
function read_value(){
PID=`pidof Tibia`
wartosc=`./readmem $PID $1`
echo $wartosc; }

function write_value(){
PID=`pidof Tibia`
./writemem $PID $1 $2; }

#---------------------------------------- POSITION ------------------------------
function get_x(){
x=`read_value $addr_x`
printf '%d' $x; }

function get_y(){
y=`read_value $addr_y`
printf '%d' $y; }

function get_z(){
z=`read_value $addr_z`
printf '%d' $z; }

function get_hdg(){
hdg=`read_value $addr_hdg`
printf '%d' $hdg; }

#------------------------------------------ STATE -------------------------------
is_poisoned=0
is_burning=0
is_electr=0
is_drunk=0
is_manash=0
is_paralyzed=0
is_hasted=0
is_battle=0
is_pz=0
is_cant_log=0

function get_mp(){
mp=`read_value $addr_mana`
printf '%d' $mp; }

function get_hp(){
hp=`read_value $addr_health`
printf '%d' $hp; }

function get_exp(){
exp=`read_value $addr_exp`
printf '%d' $exp; }

function get_flags(){
flags=`read_value $addr_flags`
if [ $flags -ge 16384 ]; then flags=$(echo "$flags-16384" | bc ); is_pz=1; fi
if [ $flags -ge 8182 ]; then flags=$(echo "$flags-8182" | bc ); is_pz=1; fi

if [ $flags -ge 128 ]; then flags=$(echo "$flags-128" | bc ); is_battle=1; fi
if [ $flags -ge 64 ]; then flags=$(echo "$flags-64" | bc ); is_hasted=1; fi
if [ $flags -ge 32 ]; then flags=$(echo "$flags-32" | bc ); is_paralyzed=1; fi
if [ $flags -ge 16 ]; then flags=$(echo "$flags-16" | bc ); is_manash=1; fi
if [ $flags -ge 8 ]; then flags=$(echo "$flags-8" | bc ); is_drunk=1; fi
if [ $flags -ge 4 ]; then flags=$(echo "$flags-4" | bc ); is_electr=1; fi
if [ $flags -ge 2 ]; then flags=$(echo "$flags-2" | bc ); is_burning=1; fi
if [ $flags -ge 1 ]; then flags=$(echo "$flags-1" | bc ); is_poisoned=1; fi; }

#------------------------------------------ MISC --------------------------------
function setzoom(){
if [ $1 = 1 ]; then 
mouse_click $zoom_out 1; sleep 0.2; mouse_click $zoom_out 1; sleep 0.2; mouse_click $zoom_out 1
fi
if [ $1 = 2 ]; then 
mouse_click $zoom_out 1; sleep 0.2; mouse_click $zoom_out 1; sleep 0.2;
mouse_click $zoom_out 1; sleep 0.2
mouse_click $zoom_in 1
fi
if [ $1 = 3 ]; then 
mouse_click $zoom_out 1; sleep 0.2; mouse_click $zoom_out 1; sleep 0.2; mouse_click $zoom_out 1
sleep 0.2
mouse_click $zoom_in 1; sleep 0.2; mouse_click $zoom_in 1
fi
if [ $1 = 4 ]; then 
mouse_click $zoom_in 1; sleep 0.2; mouse_click $zoom_in 1; sleep 0.2; mouse_click $zoom_in 1
fi
}

function log_out(){
sendkey "Control+R+l"; }

function osd_text(){
font="-*-*-*-*-*-*-18-*-*-*-*-*-*-*"
echo "$1" | osd_cat -p bottom -A left -o 90 -i 5 -f $font -O 1 -c yellow -d $2
}

#---------------------------------------- MACROS --------------------------------
function deposit(){
sendtext "hi"; sendkey "Return"; sleep 2
sendtext "deposit $1"; sendkey "Return"; sleep 1
sendtext "yes"; sendkey "Return"; }
