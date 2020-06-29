local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')

return function(s)
	return awful.widget.taglist {
		screen  = s,
		filter  = awful.widget.taglist.filter.noempty,
		style   = {
			shape = gears.shape.powerline
		},
		layout   = {
			spacing = beautiful.taglist_power_arrow_spacing,
			spacing_widget = {
				color = beautiful.taglist_power_arrow,
				shape = gears.shape.powerline,
				widget = wibox.widget.seperator
			},
			layout = wibox.layout.fixed.horizontal
		},
		widget_template = {
			{
				{
					{
						id     = 'text_role',
						widget = wibox.widget.textbox
					},
					left  = 25,
					right = 25,
					widget = wibox.container.margin
				},
				id     = 'background_role',
				widget = wibox.container.background,
			},
			layout = wibox.layout.fixed.horizontal,

			create_callback = function(self, c3, index, objects) 

				self:connect_signal('mouse::enter', function()
					self.backup = self:get_children_by_id('background_role')[1].bg 
					self:get_children_by_id('background_role')[1].bg  = beautiful.fg_urgent
				end)
				self:connect_signal('mouse::leave', function()
					self:get_children_by_id('background_role')[1].bg = self.backup 
				end)
				self:connect_signal('button::press', function()
					self.backup = beautiful.bg_focus
				end)
			end
		},
		buttons = {
			awful.button({ }, 1, function(t) t:view_only() end),
			awful.button({ modkey }, 1, function(t)
				if client.focus then
					client.focus:move_to_tag(t)
				end
			end),
			awful.button({ }, 3, awful.tag.viewtoggle),
			awful.button({ modkey }, 3, function(t)
				if client.focus then
					client.focus:toggle_tag(t)
				end
			end),
			awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
			awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end),
		}
	}
end
