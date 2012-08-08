#!/bin/bash
# (C) Mason Larobina <mason.larobina@gmail.com>

set -e
rm -rf *.{dat,out}

function main {
    for ext in lua py "[ch]"; do
        tmp=$ext.tmp
        project_stats_by_lang | sort >> $tmp
        fill_in_missing_dates $tmp
        group_by_date $tmp $ext.dat
        rm $tmp
    done

    tmp=other.tmp
    project_stats_other | sort >> $tmp
    fill_in_missing_dates $tmp
    group_by_date $tmp other.dat
    rm $tmp
}

function fill_in_missing_dates {
    sdate=$(date +"%s" --date="`head -n 1 $1 | cut -d ' ' -f 1`")
    edate=$(date +"%s" --date="`tail -n 1 $1 | cut -d ' ' -f 1`")
    for ((i = $sdate; i < $edate; i = i + 86400)); do
        echo "`date +"%Y-%m-%d" --date="@$i"` 0";
    done >> $1
}

function group_by_date {
    cat $1 |
    gawk '{A[$1] += $2; next} END {for (i in A) {print i, A[i]}}' |
    sort >> $2
}

function project_stats_by_lang {
    for project in luakit uzbl spnavkbd game-engine project-euler dcpu16; do
        export GIT_DIR="/home/mason/src/$project/.git"
        git rev-list --author="Mason Larobina" HEAD |
        while read rev; do
            git show -M --stat --format="oneline" $rev |
            grab_stat_chunk |
            grep -e "\.$ext\s*|" |
            gawk '{printf "%s %s\n", "'`rev_date`'", $3}'
        done
    done
}

function project_stats_other {
    for project in luakit uzbl spnavkbd game-engine project-euler dcpu16; do
        export GIT_DIR="/home/mason/src/$project/.git"
        git rev-list --author="Mason Larobina" HEAD |
        while read rev; do
            git show -M --stat --format="oneline" $rev |
            grab_stat_chunk |
            grep -v -e "\.lua\s*|" |
            grep -v -e "\.py\s*|" |
            grep -v -e "\.[ch]\s*|" |
            gawk '{printf "%s %s\n", "'`rev_date`'", $3}'
        done
    done
}

function grab_stat_chunk {
    grep -v -e "^$" | tail -n +2 | head -n -1
}

function rev_date {
    date +"%Y-%m-%d" --date="@`git log -n 1 --format="%at" $rev`"
}

main
