# Virtual Keyboard plugin

**This is a plugin for Noctalia-Shell**

It **REQUIRES** the following package: `ydotool`

## Technical informations

### about modifier keys

Pressing modifier keys (such as SUPER, SHIFT or CTRL) won't toggle themeselves immediately since this causes issues.

They will only be pressed in combination with a normal key.

You can have multiple modifier keys pressed at the same time.

### about keyboard layouts

Pre-installed keyboard layouts are : QWERTY, AZERTY and DVORAK

You can add your own layout by adding a `layoutname.json` in `~/.config/noctalia/plugins/virtual-keyboard/layouts/` and configuring it to your liking. Check pre-installed layouts for examples.

Since `ydotool` only presses the English format keys, I had to force French format keys (q becoming a, for example) in the `type-key.py` script. If your layout isn't in English or French format, please check `type-key.py` and ajust it to your needs : You'll need a new constant, similar to `AZERTY_TO_QWERTY` and you'll need to add another if statement to the `apply_layout` function. 