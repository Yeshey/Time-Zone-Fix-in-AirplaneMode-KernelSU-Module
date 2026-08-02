#!/system/bin/sh
MODDIR=${0%/*}
SAVED_TZ_FILE="$MODDIR/saved_tz"
sleep 15

save_current_tz() {
    local tz
    tz=$(settings get global time_zone)
    [ -z "$tz" ] && tz=$(getprop persist.sys.timezone)
    echo "$tz" > "$SAVED_TZ_FILE"
}

get_saved_tz() {
    if [ -f "$SAVED_TZ_FILE" ]; then
        cat "$SAVED_TZ_FILE"
    else
        # First boot ever: use whatever the system currently thinks
        settings get global time_zone || getprop persist.sys.timezone || echo "UTC"
    fi
}

freeze_tz() {
    save_current_tz
    local tz=$(get_saved_tz)
    settings put global auto_time_zone 0
    settings put global time_zone "$tz"
    setprop persist.sys.timezone "$tz"
    service call alarm 3 s16 "$tz"
    am broadcast -a android.intent.action.TIMEZONE_CHANGED --ei status 0
}

restore_auto() {
    settings put global auto_time_zone 1
}

prev=$(settings get global airplane_mode_on)
[ "$prev" = "1" ] && freeze_tz || restore_auto

while true; do
    cur=$(settings get global airplane_mode_on)
    if [ "$cur" != "$prev" ]; then
        [ "$cur" = "1" ] && freeze_tz || restore_auto
        prev="$cur"
    fi
    sleep 3
done
