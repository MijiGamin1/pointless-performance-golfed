#!/bin/bash

NC='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'

_PWD=$PWD
RESULTS_FILE=$_PWD/timetrials

touch $RESULTS_FILE

time_language() {
    iters=5
    lang="$1"
    file="$2"
    cmd=""
    
    case $lang in 

        cpp)
            cmd="$file"
            ;;
        golang)
            cmd="$file"
            ;;
        python)
            cmd="python $file"
            ;;
        rust)
            cmd="$file"
            ;;
        *)
            cmd=""
            ;;    
    esac

    echo $lang >> $RESULTS_FILE

    i=1
    sp="/-\|"
    echo -n ' '
    for i in $(seq 1 $iters); do 
        printf "\b${sp:i++%${#sp}:1}"
        /usr/bin/time -o $RESULTS_FILE -a $cmd
    done
}

printf "${CYAN}Running CPP Tests${NC}\n"
cd $_PWD/cpp
g++ -o counter *.cpp
time_language "cpp" "./counter"
cd $_PWD

printf "\n${CYAN}Running GoLang Tests${NC}\n"
cd $_PWD/golang
go build
time_language "golang" "./pointless-performance-tests"
cd $_PWD

printf "\n${CYAN}Running Python Tests${NC}\n"
cd $_PWD/python
time_language "python" "./main.py"
cd $_PWD

printf "\n${CYAN}Running Rust Tests${NC}\n"
cd $_PWD/rust
cargo build
time_language "rust" "./target/debug/counting"
cd $_PWD