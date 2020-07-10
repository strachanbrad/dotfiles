local naughty = require('naughty')
local wibox = require('wibox')
local beautiful = require('beautiful')

local wifimodal = { mt = {} }
local setmetatable = setmetatable

function wifimodal.new(screen)
	self = wibox {
		screen = screen,
		width = screen.geometry.width / 5,
		type = 'modal',
		height = screen.workarea.height,
		x = screen.geometry.width - screen.geometry.width/5,
		y = 35,
		ontop = true,
		bg = "red" or beautiful.bg_normal,
		fg = beautiful.fg_normal,
		opacity = 0.6
	}
	naughty.notify{text = tostring(screen.tiling_area.y)}

	self:connect_signal('mouse::leave', function()
		self.visible = false
	end)

	return self
end

function wifimodal.mt.__call(_, ...)
	return wifimodal.new(...)
end

return setmetatable(wifimodal, wifimodal.mt)

