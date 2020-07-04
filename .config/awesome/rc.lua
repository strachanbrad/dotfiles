-- awesome_mode: api-level=4:screen=on
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local ruled = require("ruled")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

require("awful.autofocus")
require("config.globalkeys")
require("config.clientkeys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
	naughty.notification {
		urgency = "critical",
		title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
		message = message
	}
end)
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/gruvbox.lua")

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Tag
-- Table of layouts to cover with awful.layout.inc, order matters.
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
	-- }}}

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
		local batwidget = require('widgets.battery')

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
							--batwidget,
							layout = wibox.layout.fixed.horizontal,
							spacing = beautiful.taglist_power_arrow_spacing
						},
						halign = 'right',
						fill_horizontal = true,
						fill_vertical = true,
						widget = wibox.container.place
					}
				},
				layout = wibox.layout.ratio.horizontal
			}
		}
	end)
	-- }}}

	-- {{{ Mouse bindings
	awful.mouse.append_global_mousebindings({
			awful.button({ }, 4, awful.tag.viewnext),
			awful.button({ }, 5, awful.tag.viewprev),
		})
	-- }}}

	client.connect_signal("request::default_mousebindings", function()
		awful.mouse.append_client_mousebindings({
				awful.button({ }, 1, function (c)
					c:activate { context = "mouse_click" }
				end),
				awful.button({ modkey }, 1, function (c)
					c:activate { context = "mouse_click", action = "mouse_move"  }
				end),
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

		-- }}}

		-- {{{ Rules
		-- Rules to apply to new clients.
		ruled.client.connect_signal("request::rules", function()
			-- All clients will match this rule.
			ruled.client.append_rule {
				id         = "global",
				rule       = { },
				properties = {
					focus     = awful.client.focus.filter,
					raise     = true,
					screen    = awful.screen.preferred,
					placement = awful.placement.no_overlap+awful.placement.no_offscreen
				}
			}

			-- Floating clients.
			ruled.client.append_rule {
				id       = "floating",
				rule_any = {
					instance = { "copyq", "pinentry" },
					class    = {
						"Arandr", "Blueman-manager", "Gpick", "Kruler", "Sxiv",
						"Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer", "MEGAsync"
					},
					-- Note that the name property shown in xprop might be set slightly after creation of the client
					-- and the name shown there might not match defined rules here.
					name    = {
						"Event Tester",  -- xev.
					},
					role    = {
						"AlarmWindow",    -- Thunderbird's calendar.
						"ConfigManager",  -- Thunderbird's about:config.
						"pop-up",         -- e.g. Google Chrome's (detached) Developer Tools.
					}
				},
				properties = { floating = true }
			}


			-- Set Firefox to always map on the tag named "2" on screen 1.
			-- ruled.client.append_rule {
			--     rule       = { class = "Firefox"     },
			--     properties = { screen = 1, tag = "2" }
			-- }
		end)

		-- {{{ Notifications


		ruled.notification.connect_signal('request::rules', function()
			-- All notifications will match this rule.
			ruled.notification.append_rule {
				rule       = { },
				properties = {
					screen           = awful.screen.preferred,
					implicit_timeout = 5,
				}
			}
		end)

		naughty.connect_signal("request::display", function(n)
			naughty.layout.box { notification = n }
		end)

