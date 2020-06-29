local wibox = require('wibox')
local gears = require('gears')
local awful = require('awful')
local beautiful = require('beautiful')

ret = wibox.widget {
	{
		awful.widget.watch('bash -c "acpi -i | awk \'FNR == 1 {print substr($4,1,3)}\'"', 60, function(widget, stdout)
			local bg_color
			widget:set_text("bat|" .. stdout)
			case = tonumber(stdout:sub(1,2))
			if case < 15 then
				bg_color = beautiful.fg_urgent
			elseif case < 40 then
				bg_color = beautiful.battery_bg_warning
			else
				bg_color = beautiful.battery_bg_healthy
			end

			widget:emit_signal_recursive("widget::bg_changed", bg_color)
		end),
		left  = 25,
		right = 25,
		forced_height = 30,
		widget = wibox.container.margin
	},
	id = "background_role",
	widget = wibox.container.background,
	bg = beautiful.taglist_bg_occupied,
	shape = function(cr, width, height) 
		gears.shape.transform(gears.shape.powerline) : rotate_at(width/2,height/2, math.pi)(cr, width, height, height/2)
	end,
}

ret:connect_signal("widget::bg_changed", function(self, bg_color)
	self.bg = bg_color
end)

return ret
