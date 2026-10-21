---
name: verify
description: Check a kitty config change by driving a throwaway kitty instance over remote control
---

Needs a real desktop session (kitty has to open a window; it can start minimized).

```sh
SOCK=unix:/tmp/kt-verify.sock
kitty --config .config/kitty/kitty.conf -o allow_remote_control=yes --listen-on $SOCK --start-as=minimized &
kitten @ --to $SOCK action <action or action_alias>   # run what a key would run
kitten @ --to $SOCK ls                                # tabs, splits, sizes, cwd, commands
kitten @ --to $SOCK get-text --match state:active     # what the pane or prompt shows
```

- Key maps: `action debug_config`, then type `/name` + enter into the pager and read the screen. Real key presses can't be sent this way.
- Answer a prompt with `send-text` for the text and `send-key enter`; a `\r` inside `send-text` is not enough.
- Match with `state:active`, not `state:focused`: a minimized window never has focus.
- Swap ssh and other commands with side effects for an `echo` in a copy of the session file.
- Kill the instance and delete any files the test saved.
