#!/usr/bin/env bash

ACTIONS=("Save" "Restore" "Delete")
TARGETS=("Programs" "Layout" "Both")

prompt="i3-resurrect"
action=$(printf "%s\n" ${ACTIONS[@]} | dmenu -p $prompt)

case $action in
  Save)
    command="i3-resurrect save -p"
    ;;
  Restore)
    command="i3-resurrect restore -p"
    ;;
  Delete)
    command="i3-resurrect rm -p"
    ;;
  *)
    echo "Invalid action"
    exit 1
    ;;
esac

prompt="Profile"
profile=$(i3-resurrect ls profiles | awk '{$NF=""; $1=""; print $0}' | uniq | dmenu -p "$prompt" | xargs)

if [[ "$profile" == "" ]]; then
  echo "Invalid profile"
  exit 1
fi

prompt="Target"
target=$(printf "%s\n" ${TARGETS[@]} | dmenu -p $prompt)

case $target in
  Programs)
    target_option="--programs-only"
    ;;
  Layout)
    target_option="--layout-only"
    ;;
  Both)
    target_option=""
    ;;
  *)
    echo "Invalid target"
    exit 1
    ;;
esac

if [[ -n "$target_option" ]]; then
  $command "$profile" "$target_option"
else
  $command "$profile"
fi