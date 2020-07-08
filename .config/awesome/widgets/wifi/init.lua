local awful = require('awful')
local naughty = require('naughty')
local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')

local setmetatable = setmetatable

local wifi = { mt = {} }

function wifi.new(interface)
	local cmd = 'bash -c "iw dev ' .. interface .. ' station dump | awk \'FNR == 12 {print($2)}\'"'

	local widget = wibox.widget{
		{
			awful.widget.watch(cmd),
			right = 5,
			left = 8,
			widget = wibox.container.margin
		},
		id = "background_role",
		bg = beautiful.taglist_bg_occupied,
		widget = wibox.container.background,
		shape = function (cr, width, height)
			gears.shape.rectangular_tag(cr, width, height, height/2)
		end,
	}

	return widget
end

function wifi.mt.__call(_, ...)
	return wifi.new(...)
end

return setmetatable(wifi, wifi.mt)

