#!/bin/bash

## Global variables
N_ROWS=3
N_COLS=3
STARTING_PLAYER="o"
CURRENT_PLAYER=$STARTING_PLAYER
BOARD="$(printf "%0.s. " {1..9})"
# mode can be pvp or pvb
MODE=pvp

YELLOW='\e[0;33m'
WHITE='\e[0;37m'
SCRIPT_DIR=$(dirname -- "$0")
## 

## Utility functions
function save_state()
{
    cat << EOF > $SCRIPT_DIR/.gamesave
N_ROWS=$N_ROWS
N_COLS=$N_COLS
BOARD="$BOARD"
CURRENT_PLAYER=$CURRENT_PLAYER
STARTING_PLAYER=$STARTING_PLAYER
MODE=$MODE
EOF
}

function error() {
  echo "$@" 1>&2
}
##

## Game related functions

## print board given as string argument
function print_board()
{
    local board=( $1 )
    local n=${#board[@]}

    for i in `seq 0 8`
    do
        [ $(( $i % $N_COLS )) == 0 ] && echo -en "   |"
        echo -en ${board[$i]}
        echo -en "|"
        [ $(( ($i + 1) % $N_ROWS )) == 0 ] && echo
    done
}

## set board element row, column to value
## returns new modified board
function set_board_element()
{
    local i=$1
    local j=$2
    local value=$3
    local board=( $4 )
    local id_=$(($i * $N_COLS + $j))
    board[$id_]=$value
    echo ${board[@]}
}

## get board element row, column
## returns element
function get_board_element()
{
    local i=$1
    local j=$2
    local board=( $3 )
    local id_=$(($i * $N_COLS + $j))
    echo ${board[$id_]}
}

# checks if field i=row, j=column field
# does not have cross or
function is_field_empty()
{
    local i=$1
    local j=$2
    local board=$3
    local el="$(get_board_element $i $j "$board")"
    [ "$el" == x -o "$el" == o ] && return 1
    return 0
}

# checks if someone win on given board or
# there must be draw
function check_results()
{
    # string board repesentation no empty spaces
    local board=$(echo $1 | tr -d ' ')
    local board_cp=$1
    local win_x="xxx"
    local win_o="ooo"
    local xl=""
    local xr=""
    local layouts=()
    for i in `seq 0 2`
    do
        r_b=$((i * N_ROWS))
        row=${board:$r_b:$N_COLS}

        # could be some loop to make it N dimensional
        # but leaving at it is for now for 3x3
        col=$(get_board_element 0 $i "$board_cp"})$(get_board_element 1 $i "$board_cp")$(get_board_element 2 $i "$board_cp")

        xl+=$(get_board_element $i $i "$board_cp")

        layouts+=($col $row)

    done
    layouts+=($xl)
    
    xr=$(get_board_element 0 2 "$board_cp")$(get_board_element 1 1 "$board_cp")$(get_board_element 2 0 "$board_cp")
    layouts+=($xr)
    
    for layout in ${layouts[@]}
    do
        [ $layout == $win_o ] && echo "o" && exit 0
        [ $layout == $win_x ] && echo "x" && exit 0
    done
    
    # check if there is no draw
    [ "$(echo $board | tr -d 'xo')" == "" ] && echo "d"
    exit 0
}

# Returns new board string with
# random move made.
function make_bot_move()
{
    local board=( $1 )
    local empty_fields=()
    for i in $(seq 0 ${#board[@]})
    do
        [ "${board[$i]}" == "." ] && empty_fields+=($i)
    done
    
    # should be handled properly but will not happen
    # as we check results before moves
    [ ${#empty_fields[@]} -eq 0 ] && return 1
    
    local random_id=$((RANDOM % ${#empty_fields[@]}))
    board[${empty_fields[$random_id]}]="x"
    
    echo "${board[@]}"
}

# main loop
# args:
# $1 - which player 'x' or 'o' starts
function main_loop()
{
    local x=0
    local y=0
    local temp_board="${BOARD}"
    local wrong_field=false
    local curr=$1
    local redraw=true
    local msg=""
    local player_info=""
    [ ${MODE} == "pvb" ] && player_info="\n|Player - 'o' | Bot - 'x'|\n"
    clear

    while true;
    do

        result=$(check_results "$BOARD")
        if $redraw
        then
            clear
            echo -en "Use 'wsad' to move cursor and 'p' to pick field.\nPress 'l' to save game for later. Press 'x' to exit.\n"
            echo -e $player_info
            echo "Turn: '$curr'"

            character=$(get_board_element $y $x "${BOARD}")
            temp_board=$(set_board_element $y $x "$YELLOW$character$WHITE" "${BOARD}")
            print_board "${temp_board}"
            echo "$msg"
            msg=""
        fi
        redraw=true
        
        if [ "$result" != "" ]
        then
            clear
            echo -e "Game finished.\n"
            
            print_board "${BOARD}"
            local winner="Player"
            
            [ "$MODE" == "pvb" -a "$result" == "x" ] && winner="Bot"
            
            desription="$winner '$result' wins."

            [ "$result" == "d" ] && desription="There is no winner."
            
            echo -e "\n$desription\nPress ENTER to exit"
            read
            exit 0
        fi

        if [ "${MODE}" == "pvb" -a "${curr}" == "x" ]
        then
            BOARD=$(make_bot_move "${BOARD}")
            curr="o"
            continue
        fi

        read -n 1 -sr input
        case $input in
            w)
                ((y-=1))
            ;;
            s)
                ((y+=1))
            ;;
            a)
                ((x-=1))
            ;;
            d)
                ((x+=1))
            ;;
            p)
                if ! is_field_empty $y $x "$BOARD"
                then
                    echo -e "\nThis field is already set..."
                    echo -e "Please choose another."
                    redraw=false
                    continue
                fi
                BOARD=$(set_board_element $y $x "$curr" "${BOARD}")
                [[ $curr = x ]] && curr=o || curr=x
            ;;
            x)
                exit 0;
            ;;

            l)
                save_state
                msg="Game saved successfully!"
            ;;
            *)
                redraw=false
            ;;
        esac

        x=$((x > (N_COLS-1) ? N_COLS-1 : x))
        y=$((y > (N_ROWS-1) ? N_ROWS-1 : y))
        x=$((x < 0 ? 0 : x))
        y=$((y < 0 ? 0 : y))
    done
}
##

## main menu
options=("New PvP" "New PvB" "Load Game")
curr_option=0
msg=""
while true
do
    clear
    echo -e "\nUse 'ws' to move currsor. Click 'p' to pick game option:"
    for i in `seq 0 $((${#options[@]}-1))`
    do
        [ $i == $curr_option ] && echo -en $YELLOW
        echo "-> ${options[$i]}"
        echo -en $WHITE
    done
    
    echo -en "$msg"

    read -n 1 -sr input
        case $input in
            w)
                ((curr_option-=1))
                msg=""
            ;;
            s)
                ((curr_option+=1))
                msg=""
            ;;
                p)
                case ${options[$curr_option]} in
                "Load Game")
                    if ! [ -e "$SCRIPT_DIR/.gamesave" ]
                    then
                        msg="\n> There is no saved game please start new game.\n"
                        continue
                    fi
                    source "$SCRIPT_DIR/.gamesave" 
                    break
                ;;
                "New PvB")
                    MODE="pvb"
                    break;
                ;;
                *)
                    break;
                ;;
                esac
            ;;
        esac
        curr_option=$((curr_option > 2 ? 2 : curr_option))
        curr_option=$((curr_option < 0 ? 0 : curr_option))
done
# echo "picked option ${options[$curr_option]}"

main_loop "$CURRENT_PLAYER"
