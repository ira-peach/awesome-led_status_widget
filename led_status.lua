--[[

  Copyright 2017 Stefano Mazzucco <stefano AT curso DOT re>

  This program is free software: you can redistribute it and/or modify it under
  the terms of the GNU General Public License as published by the Free Software
  Foundation, either version 3 of the License, or (at your option) any later
  version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
  details.

  You should have received a copy of the GNU General Public License along with
  this program.  If not, see <https://www.gnu.org/licenses/gpl-3.0.html>.

  Further modifications under the same terms by Ira Peach
  <yoshi_says_acab@proton.me>.

]]

--[[

  A simple widget to show LED statuses for Num Lock, Caps Lock, and Scroll
  Lock.  Allows for the creation of custom LED statuses if given the correct
  key code and pattern.

  Requirements:
  - Awesome 4.x
  - xset

  @usage
  local led_status = require("led_status")

  -- standard LEDs
  local num_lock = led_status.num_lock()
  local caps_lock = led_status.caps_lock()
  local scroll_lock = led_status.scoll_lock()

  -- custom LED definition
  local mute_led = led_status.create("Mute", "M", "m", "XF86AudioMute", "Output mute")

  -- Add widget to wibox
  s.mywibox:setup {
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      num_lock,
      caps_lock,
      scroll_lock,
      mute_led
    }
  -- more stuff
  }

  -- Add key to globalkeys
  globalkeys = awful.util.table.join(globalkeys,
    num_lock.key,
    caps_lock.key,
    scroll_lock.key,
    mute_led.key)

]]

local awful = require("awful")
local wibox = require("wibox")

local led_status = {}

function led_status.create(pattern, active, inactive, key, friendly_name)
  friendly_name = friendly_name or pattern
  local led = wibox.widget {
    widget = wibox.widget.textbox,
    align = "center",
    valign = "center",
    forced_width = 15,
  }

  led.activated = "<b>" .. active .. "</b>"
  led.deactivated = "<b>" .. inactive .. "</b>"

  local tooltip = awful.tooltip({})

  tooltip:add_to_object(led)

  function led:check()
    awful.spawn.with_line_callback(
      "bash -c 'sleep 0.2 && xset q'",
      {
        stdout = function (line)
          if line:match(pattern) then
            local status = line:gsub(".*(" .. pattern .. ":%s+)(%a+).*", "%2")
            tooltip.text = pattern .. " " .. status
            if status == "on" then
              self.markup = self.activated
            else
              self.markup = self.deactivated
            end
          end
        end
      }
    )
  end

  led.key = awful.key(
    {},
    key,
    function () led:check() end)

  led:check()
  return led
end

function led_status.caps_lock()
  return led_status.create("Caps Lock", "A", "a", "Caps_Lock")
end

function led_status.num_lock()
  return led_status.create("Num Lock", "N", "n", "Num_Lock")
end

function led_status.scroll_lock()
  return led_status.create("Scroll Lock", "S", "s", "Scroll_Lock")
end

return led_status
