# A simple LED status widget module for Awesome

Useful when you have a keyboard that does not have a LED status indicator for a
key, such as CAPS LOCK, NUM LOCK, or SCROLL LOCK.

This widget set is really simple and parses the output of `xset` to figure out
whether LED status is active for a particular LED or not. (Hint: you need the
`xset` utility for this widget to work)

This module also supports creating specific widgets, providing a Lua pattern
(to parse `xset q` output), active/inactive strings, an XF86 key symbol, and an
optional friendly name (in case the pattern is not fit for a status indicator
hover).

# Installation

1. Ensure that `xset` is available to you on your system.
2. Copy `led_status.lua` into your `~/.config/awesome/ folder` (e.g. by cloning
   this repository).
3. Restart Awesome (e.g. press `modkey + Control + r` or run `awesome-client
   "awesome.restart()"` from a terminal).

# Usage

For **Awesome 4.x**, add the following to your `~/.config/awesome/rc.lua`:

``` lua
-- If you just copied the file in ~/.config/awesome
local led_status = require("led_status")

-- If you cloned the repo as a submodule in
-- ~/.config/awesome/external/led_status
-- local led_status = require("external.led_status.led_status")

-- create the widgets for the standard LEDs
local num_lock = led_status.num_lock()
local caps_lock = led_status.caps_lock()
local scroll_lock = led_status.scoll_lock()

-- custom LED definition
local mute_led = led_status.create("Mute", "M", "m", "XF86AudioMute", "Output mute")

-- more config here

    -- Add widgets to the wibox
    s.mywibox:setup {
-- more config here
      { -- Right widgets
        layout = wibox.layout.fixed.horizontal,
        wibox.widget.systray(),
        num_lock,
        caps_lock,
        scroll_lock,
        mute_led,
-- more config here
-- {{{ Key bindings
local globalkeys = awful.util.table.join(
  num_lock.key,
  caps_lock.key,
  scroll_lock.key,
  mute_led.key,
-- more config follows
```

Now, when an LED status is active, an uppercase letter will be displayed.  Here
is an example for CAPS LOCK:

![active_capslock screenshot](/screenshots/active_capslock_widget.png?raw=true)

When an LED status is inactive, a lowecase letter will be displayed:

![inactive_capslock screenshot](/screenshots/inactive_capslock_widget.png?raw=true)

These can be changed by changing the `activated` and `deactivated` attributes
of the widget as [Pango
markup](https://developer.gnome.org/pango/stable/PangoMarkupFormat.html)
strings. You will probably need to adjust the `forced_width` attribute too.

For example:

``` lua
local capslock = require("capslock")
capslock.forced_width = 35
capslock.activated = "<u>CAPS</u>"
capslock.deactivated = "<u>caps</u>"
```

When the mouse is over the widget, a tooltip that says `<LED name> on`/`<LED
name> off` is also shown.

# Contributing

If you have ideas about how to make this better, feel free to open an issue or
submit a pull request.
