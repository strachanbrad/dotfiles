-- awesome_mode: api-level=4:screen=on
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local autostart = require("config.apps").autostart

require("config.rules")
require("awful.autofocus")
require("config.globalkeys")
require("config.clientkeys")

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
	naughty.notification {
		urgency = "critical",
		title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
		message = message
	}
end)

beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/gruvbox.lua")

tag.connect_signal("request::default_layouts", function()
	awful.layout.append_default_layouts({
			--awful.layout.suit.floating,
			awful.layout.suit.tile,
			--awful.layout.suit.tile.left,
			--awful.layout.suit.tile.bottom,
			awful.layout.suit.tile.top,
			--awful.layout.suit.fair,
			--awful.layout.suit.fair.horizontal,
			--awful.layout.suit.spiral,
			awful.layout.suit.spiral.dwindle,
			--awful.layout.suit.max,
			--awful.layout.suit.max.fullscreen,
			--awful.layout.suit.magnifier,
			--awful.layout.suit.corner.nw,
		})
	end)

	screen.connect_signal("request::wallpaper", function(s)
		-- Wallpaper
		if beautiful.wallpaper then
			local wallpaper = beautiful.wallpaper
			-- If wallpaper is a function, call it with the screen
			if type(wallpaper) == "function" then
				wallpaper = wallpaper(s)
			end
			gears.wallpaper.maximized(wallpaper, s, true)
		end
	end)

	screen.connect_signal("request::desktop_decoration", function(s)
		awful.tag({ "SYS", "WWW", "DEV", "DOC", "GFX"}, s, awful.layout.layouts[1])

		local mytaglist = require('widgets.taglist')
		local mylayoutbox = require('widgets.layoutbox')
		local battery = require('widgets.battery')
		local netmon = require('widgets.networkmonitor')("wlp2s0")
		local wifi = require('widgets.wifi')("wlp2s0", s)

		s.mywibox = awful.wibar { 
			position = "top", 
			screen = s, 
			shape = function(cr, width, height) 
				gears.shape.partially_rounded_rect(cr, width, height, false, false, true, true, 10) 
			end,
			widget = {
				{
					layout   = wibox.layout.fixed.horizontal,
					spacing = beautiful.taglist_power_arrow_spacing,
					mylayoutbox(s),
					mytaglist(s),
				},
				{
					layout = wibox.layout.fixed.horizontal,
					{
						wibox.widget.textclock(),
						halign = 'center',
						fill_horizontal = true,
						widget = wibox.container.place
					}
				},
				{
					layout = wibox.layout.fixed.horizontal,
					{
						wibox.widget {
							wibox.widget.systray(),
							netmon,
							battery,
							wifi,
							layout = wibox.layout.fixed.horizontal,
							spacing = beautiful.taglist_power_arrow_spacing
						},
						halign = 'right',
						fill_horizontal = true,
						content_fill_vertical = true,
						widget = wibox.container.place
					}
				},
				layout = wibox.layout.ratio.horizontal
			}
		}
	end)

	awful.mouse.append_global_mousebindings({
			awful.button({ }, 4, awful.tag.viewnext),
			awful.button({ }, 5, awful.tag.viewprev),
		})

	client.connect_signal("request::default_mousebindings", function()
		awful.mouse.append_client_mousebindings({
				awful.button({ }, 1, function (c)
					c:activate { context = "mouse_click" }
				end),
				--awful.button({ modkey }, 1, function (c)
				--	c:activate { context = "mouse_click", action = "mouse_move"  }
				--end),
				awful.button({ modkey }, 3, function (c)
					c:activate { context = "mouse_click", action = "mouse_resize"}
				end),
			})
		end)


		client.connect_signal("manage", function (c)
			c.shape = function (cr, w, h)
				gears.shape.rounded_rect(cr, w, h, 5)
			end
			if not _G.awesome.startup then
				awful.client.setslave(c)
			end

			if _G.awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
				-- Prevent clients from being unreachable after screen count changes.
				awful.placement.no_offscreen(c)
			end
		end)

		naughty.connect_signal("request::display", function(n)
			naughty.layout.box { notification = n }
		end)

		for app = 1, #autostart do
			awful.util.spawn(autostart[app])
		end
