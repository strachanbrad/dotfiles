local wibox = require('wibox')
local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')

mywidgetlist = {
	wibox.widget {
		
		layout = wibox.layout.fixed.horizontal
	},
	valign = 'center',
	halign = 'right',
	fill_horizontal = true,
	widget = wibox.container.place
}


for i, w in ipairs {mywidgetlist.widgets} do
	mywidgetlist[#mywidgetlist + i] = {
		w,
		id = "background_role",
		widget = wibox.container.background,
		shape = function(cr, width, height) 
			gears.shape.transform(gears.shape.powerline) : rotate_at(width/2,height/2, math.pi)(cr, width, height, height/2)
		end
	}
end

mywidgetlist.widgets = nil

return mywidgetlist
