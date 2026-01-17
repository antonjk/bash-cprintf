#!/usr/bin/env bats

#setup_file() {
#    load 'test_helper/common-setup'
#    _common_setup
#}

function print() {
    local result=$(./cprintf "$1")
    echo "${result//$'\033'/}"
    echo "${result//$'\033'/}" >&2
}

@test "decimal color codes select correct color space" {
    [[ "$(print "<fg:11> <fg:0>test</fg> </fg> ")" =~ ^\[38\;5\;11m.\[30mtest\[38\;5\;11m.\[39m.\[0m$ ]] &&
        [[ "$(print "<fg:11> <fg:1>test</fg> </fg> ")" =~ ^\[38\;5\;11m.\[31mtest\[38\;5\;11m.\[39m.\[0m$ ]] &&
        [[ "$(print "<fg:11> <fg:2>test</fg> </fg> ")" =~ ^\[38\;5\;11m.\[32mtest\[38\;5\;11m.\[39m.\[0m$ ]] &&
        [[ "$(print "<fg:11> <fg:7>test</fg> </fg> ")" =~ ^\[38\;5\;11m.\[37mtest\[38\;5\;11m.\[39m.\[0m$ ]]

}

@test "decimal color codes greater that 256 select default" {
    [[ "$(print "<fg:11> <fg:1000>test</fg> </fg> ")" =~ ^\[38\;5\;11m.\[39mtest\[38\;5\;11m.\[39m.\[0m$ ]]
}

@test "single hex 0-7 select standard" {
    [[ "$(print "<fg:11> <fg:#0>test</fg> </fg> ")" =~ ^\[38\;5\;11m.\[30mtest\[38\;5\;11m.\[39m.\[0m$ ]] &&
        [[ "$(print "<fg:11> <fg:#1>test</fg> </fg> ")" =~ ^\[38\;5\;11m.\[31mtest\[38\;5\;11m.\[39m.\[0m$ ]] &&
        [[ "$(print "<fg:11> <fg:#2>test</fg> </fg> ")" =~ ^\[38\;5\;11m.\[32mtest\[38\;5\;11m.\[39m.\[0m$ ]] &&
        [[ "$(print "<fg:11> <fg:#7>test</fg> </fg> ")" =~ ^\[38\;5\;11m.\[37mtest\[38\;5\;11m.\[39m.\[0m$ ]]
}

@test "single hex 8-F select high" {
    result=$(print "<fg:11> <fg:#8>test</fg> </fg> ")
    # Strip ANSI escape sequences
    result="${result//$'\033'/}"

    echo "$result" >&2

    [[ "$result" =~ ^\[38\;5\;11m.\[90mtest\[38\;5\;11m.\[39m.\[0m$ ]]
}

@test "double hex select extended" {
    result=$(print "<fg:11> <fg:#80>test</fg> </fg> ")
    # Strip ANSI escape sequences
    result="${result//$'\033'/}"

    echo "$result" >&2

    [[ "$result" =~ ^\[38\;5\;11m.\[38\;5\;128mtest\[38\;5\;11m.\[39m.\[0m$ ]]
}

@test "six hex select true" {
    result=$(print "<fg:11> <fg:#800000>test</fg> </fg> ")
    # Strip ANSI escape sequences
    result="${result//$'\033'/}"

    [[ "$result" =~ ^\[38\;5\;11m.\[38\;2\;128\;0\;0mtest\[38\;5\;11m.\[39m.\[0m$ ]]
}

@test "3 4 5 hex select default" {
    [[ "$(print "<fg:11> <fg:#800>test</fg> </fg> ")" =~ ^\[38\;5\;11m.\[39mtest\[38\;5\;11m.\[39m.\[0m$ ]] &&
        [[ "$(print "<fg:11> <fg:#8000>test</fg> </fg> ")" =~ ^\[38\;5\;11m.\[39mtest\[38\;5\;11m.\[39m.\[0m$ ]] &&
        [[ "$(print "<fg:11> <fg:#80000>test</fg> </fg> ")" =~ ^\[38\;5\;11m.\[39mtest\[38\;5\;11m.\[39m.\[0m$ ]]
}

@test "No sequence emitted if no text to output" {
    [[ "$(print "<fg:11><fg:black>test</fg></fg>")" =~ ^\[30mtest\[39m\[0m$ ]]
}
