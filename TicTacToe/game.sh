#!/bin/bash

N_ROWS=3
N_COLS=3
n=9
BOARD="$(printf "%0.s. " {1..9})"

function error() {
  echo "$@" 1>&2
}

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
        [ $layout == $win_o ] && echo "o"
        [ $layout == $win_x ] && echo "x"
    done
    
    # check if there is no draw
    [ "$(echo $board | tr -d 'xo')" == "" ] && echo "d"
}

function main_loop()
{
    local x=0
    local y=0
    local temp_board="${BOARD}"
    local wrong_field=false
    local curr="o"
    local redraw=true
    clear

    while true;
    do

        result=$(check_results "$BOARD")
        # if game isn't finished yet lets save state
        if $redraw
        then
            clear
            echo -en "Use 'wsad' to move cursor and 'p' to pick field.\n\n"
            echo "Turn: '$curr'"
            yellow='\e[0;33m'
            white='\e[0;37m'
            character=$(get_board_element $y $x "${BOARD}")
            temp_board=$(set_board_element $y $x "$yellow$character$white" "${BOARD}")
            print_board "${temp_board}"
        fi
        redraw=true
        
        if [ "$result" != "" ]
        then
            clear
            echo -e "Game finished.\n"
            
            print_board "${BOARD}"

            desription="Player '$result' wins."
            [ "$result" == "d" ] && desription="There is no winner."
            
            echo -e "\n$desription\nPress ENTER to exit"
            read
            exit 0
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
                    echo "This field is already set..."
                    echo -e "Please choose another.\n"
                    redraw=false
                    continue
                fi
                BOARD=$(set_board_element $y $x "$curr" "${BOARD}")
                [[ $curr = x ]] && curr=o || curr=x
                x=0
                y=0
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

# new_board=$(set_board_element 1 1 "x" "${BOARD}")
# BOARD="${new_board}"

# print_board "${board}"


main_loop