local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')

return function(s)
	return {
		awful.widget.layoutbox {
			screen  = s,
			buttons = {
				awful.button({ }, 1, function () awful.layout.inc( 1) end),
				awful.button({ }, 3, function () awful.layout.inc(-1) end),
				awful.button({ }, 4, function () awful.layout.inc( 1) end),
				awful.button({ }, 5, function () awful.layout.inc(-1) end),
			}
		},
		id = "background_role",
		widget = wibox.container.background,
		shape = function(cr, width, height) 
			gears.shape.transform(gears.shape.rectangular_tag) : rotate_at(width/2,height/2, math.pi)(cr, width, height, height/2)
		end
	}
end
