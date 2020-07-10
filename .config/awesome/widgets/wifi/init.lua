local awful = require('awful')
local naughty = require('naughty')
local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')

local setmetatable = setmetatable

local wifi = { mt = {} }
local base_widget = { mt = {} }

function base_widget.new(screen) 
	local wifimodal = require('widgets.wifi.wifimodal')(screen)
	return wibox.widget{
		{
			{
				id = "textbox",
				markup = '<b>?</b>', 
				align  = 'center',
				valign = 'center',
				widget = wibox.widget.textbox
			},
			left  = 8,
			right = 5,
			widget = wibox.container.margin,
		},
		id = "background_role",
		screen = screen,
		widget = wibox.container.background,
		bg = beautiful.taglist_bg_occupied,
		shape = shape or function(cr, width, height) 
			gears.shape.rectangular_tag(cr, width, height, height/2)
		end,
		buttons = {
			awful.button({ }, 1, function() wifimodal.visible = true end)
		}
	}
end

function base_widget.mt.__call(_, ...)
	return base_widget.new(...)
end

setmetatable(base_widget, base_widget.mt)

local bg_hash = {
	{-80, beautiful.wifi_bg_bad or "#cc241d"},
	{-70, beautiful.wifi_bg_fair or "#d65d0e"},
	{-60, beautiful.wifi_bg_good or "#689d6a"},
	{-50, beautiful.wifi_bg_excellent or "#458588"},
}

function wifi.new(interface, screen)
	local cmd = 'bash -c "iw dev ' .. interface .. ' station dump | awk \'FNR == 12 {print($2)}\'"'

	return awful.widget.watch(cmd, 15, function(base_widget, stdout)

		base_widget:get_children_by_id('textbox')[1]:set_text(stdout)

		local background = base_widget:get_children_by_id('background_role')[1]
		local i = 1
		for _, entry in ipairs(bg_hash) do
			if tonumber(stdout) >= entry[1] then
				background.bg = entry[2]
			end
		end
	end, base_widget(screen)) 
end

function wifi.mt.__call(_, ...)
	return wifi.new(...)
end

return setmetatable(wifi, wifi.mt)
