local awful = require('awful')
local naughty = require('naughty')
local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')

local setmetatable = setmetatable 
local netmon = { mt = {} }
local template = { mt = {} }

function template.new(_id)
	local widget = {
		{
			{
				id = _id,
				markup = _id .. ': 0bit/s',
				align  = 'center',
				valign = 'center',
				widget = wibox.widget.textbox
			},
			left  = 25,
			right = 25,
			widget = wibox.container.margin,
		},
		id = "background_role",
		widget = wibox.container.background,
		bg = beautiful.taglist_bg_occupied,
		shape = shape or function(cr, width, height) 
			gears.shape.transform(gears.shape.powerline) : rotate_at(width/2,height/2, math.pi)(cr, width, height, height/2)
		end,
	}

	return widget
end

function template.mt.__call(_,...)
	return template.new(...)
end

setmetatable(template, template.mt)

function netmon.new(interface, shape)
	local cmd = 'bash -c "vnstat -i ' .. interface .. ' -tr | awk \'FNR == 4 || FNR == 5 {print(\\$2 \\$3)}\' ORS=\',\'"'

	return awful.widget.watch(cmd, 0, function(widget, stdout)

		local split = gears.string.split(stdout:sub(1, #stdout -2), ",")
		local x = { "rx", "tx" }

		for i, str in pairs(split) do

			widget:get_children_by_id(x[i])[1].markup = "<b>" .. x[i] .. ":</b>" .. str
			if tonumber(split[i]:sub(1, 1)) > 0 then
				widget:get_children_by_id("background_role")[i].bg = beautiful.netmon_bg_warning
			else	
				widget:get_children_by_id("background_role")[i].bg = beautiful.netmon_bg_healthy
			end
		end

		widget:emit_signal("widget::redraw_needed")
	end,

	wibox.widget{

		template("rx"),
		template("tx"),
		layout   = wibox.layout.fixed.horizontal,
		fill_space = true,
		spacing = beautiful.taglist_power_arrow_spacing,

	}) 
end

function netmon.mt.__call(_, ...)
	return netmon.new(...)
end

return setmetatable(netmon, netmon.mt)
