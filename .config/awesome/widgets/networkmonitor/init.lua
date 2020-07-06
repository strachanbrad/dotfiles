local awful = require('awful')
local naughty = require('naughty')
local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')

local setmetatable = setmetatable 
local netmon = { mt = {} }

function netmon.new(interface, shape)
	--vnstatdump = gears.filesystem.get_configuration_dir() .. "networkmonitor/vnstat_dump"
	--local test = awful.spawn.with_shell("vnstat -i " .. interface .. "-tr")
	--naughty.notify({text = tostring(test), timeout = 0})
	--naughty.notify({text = vnstatdump, timeout = 0})
	widget = wibox.widget {
		{
			awful.widget.watch('bash -c "vnstat -i wlp3s0 -tr | awk \'FNR == 4 || FNR == 5 {print(\\$1, \\$2 \\$3)}\' ORS=\' \'"', 0 ), 
			left  = 25,
			right = 25,
			forced_height = 30,
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

function netmon.mt.__call(_, ...)
	return netmon.new(...)
end

return setmetatable(netmon, netmon.mt)
