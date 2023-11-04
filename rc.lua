--====================================================================================================================================================================================
--====================================================================================================================================================================================
--Widgets ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local volume_widget = require('awesome-wm-widgets.volume-widget.volume')
--Other ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
pcall(require, "luarocks.loader")
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")
local debian = require("debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")
if awesome.startup_errors then naughty.notify({ preset = naughty.config.presets.critical, title = "Oops, there were errors during startup!", text = awesome.startup_errors }) end
do local in_error = false awesome.connect_signal("debug::error", function (err) if in_error then return end in_error = true naughty.notify({ preset = naughty.config.presets.critical,
title = "Oops, an error happened!", text = tostring(err) }) in_error = false end) end
--====================================================================================================================================================================================
--====================================================================================================================================================================================
--THEME FILE!
beautiful.init("/home/nbd/.config/awesome/themes/default/theme.lua")
--CHANGE IT WHEN YOU NEED TO
terminal = "alacritty"
editor = "vim"
editor_cmd = terminal .. " -e " .. editor
--====================================================================================================================================================================================
--====================================================================================================================================================================================
modkey = "Mod4"
awful.layout.layouts = { awful.layout.suit.tile}
myawesomemenu = { { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end }, { "manual", terminal .. " -e man awesome" },
{ "edit config", editor_cmd .. " " .. awesome.conffile },{ "restart", awesome.restart }, { "quit", function() awesome.quit() end }, }
local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "open terminal", terminal }
if has_fdo then mymainmenu = freedesktop.menu.build({ before = { menu_awesome }, after =  { menu_terminal }})
else mymainmenu = awful.menu({ items = { menu_awesome, { "Debian", debian.menu.Debian_menu.Debian }, menu_terminal,}})end
mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
--************************************************************************************************************************************************************************************
--unnecessary things that i dont know why it exists
root.buttons(gears.table.join( awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext), awful.button({ }, 5, awful.tag.viewprev)))
client.connect_signal("manage", function (c)
    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then awful.placement.no_offscreen(c) end end)
--===================================================================================================================================================================================
--===================================================================================================================================================================================
--Wibar
-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join( awful.button({ }, 1, function(t) t:view_only() end), awful.button({ modkey }, 1, function(t) if client.focus then client.focus:move_to_tag(t)
end end), awful.button({ }, 3, awful.tag.viewtoggle), awful.button({ modkey }, 3, function(t) if client.focus then client.focus:toggle_tag(t) end end),
awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end), awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end))
--tasklist cus
local tasklist_buttons = gears.table.join(awful.button({ }, 1, function (c) if c == client.focus then c.minimized = true
else c:emit_signal( "request::activate", "tasklist", {raise = true})end end),
awful.button({ }, 3, function() awful.menu.client_list({ theme = { width = 250 } }) end),
awful.button({ }, 4, function () awful.client.focus.byidx(1) end), awful.button({ }, 5, function () awful.client.focus.byidx(-1) end))
-- Wallpaper
local function set_wallpaper(s) if beautiful.wallpaper then local wallpaper = beautiful.wallpaper if type(wallpaper) == "function" then wallpaper = wallpaper(s) end
gears.wallpaper.maximized(wallpaper, s, true) end end
screen.connect_signal("property::geometry", set_wallpaper)
awful.screen.connect_for_each_screen(function(s) set_wallpaper(s)
--====================================================================================================================================================================================
--====================================================================================================================================================================================
--Customizing Tags
awful.tag({ " ◉ ", " ◉ ", " ◉ ", " ◉ ", " ◉ "," ◉ "," ◉ "}, s, awful.layout.layouts[1])
--************************************************************************************************************************************************************************************
    s.mypromptbox = awful.widget.prompt()
--************************************************************************************************************************************************************************************
    s.mylayoutbox = awful.widget.layoutbox(s)
--************************************************************************************************************************************************************************************
    s.mylayoutbox:buttons(gears.table.join(awful.button({ }, 1, function () awful.layout.inc( 1) end), awful.button({ }, 3, function () awful.layout.inc(-1) end),
awful.button({ }, 4, function () awful.layout.inc( 1) end), awful.button({ }, 5, function () awful.layout.inc(-1) end)))                    
--====================================================================================================================================================================================
--====================================================================================================================================================================================
-- Create a keyboard widget
s.mykeyboardlayout = awful.widget.keyboardlayout()
klayout = {{{{{{{widget = wibox.widget.imagebox,image = "/home/nbd/.config/awesome/icons/keyboard.svg"},widget = wibox.container.place},bottom = 2,top =2,right = 1,left = 2,
    widget = wibox.container.margin},{bottom = 2,widget = wibox.container.margin,s.mykeyboardlayout},
    layout = wibox.layout.fixed.horizontal},widget = wibox.container.margin,bottom = 2,top =2,right = 2,left = 2}, bg = "#A3BE8C",fg = "#000000",widget = wibox.container.background
    ,shape = function(cr, width, height) gears.shape.rounded_rect(cr, width, 30, 5)end},widget = wibox.container.margin, top = 3}
--************************************************************************************************************************************************************************************
-- Create a textclock widget
s.textclock = wibox.widget.textclock('<span font="Quicksand Bold 17px">%a,%b %d %l:%M</span>')
textclock = {{{{{{image  = '/home/nbd/.config/awesome/icons/clock.png',forced_width = 20,forced_height = 20,widget = wibox.widget.imagebox},
widget = wibox.container.place},spacing = 7,
{bottom = 2,widget = wibox.container.margin,s.textclock},
layout = wibox.layout.fixed.horizontal},widget = wibox.container.margin,left = 5,right = 5},
bg = "#88C0D0",fg = "#000000",shape = function(cr, width, height) gears.shape.rounded_rect(cr, width, 30, 5)end, widget = wibox.container.background},
widget = wibox.container.margin,top = 3 } 
--************************************************************************************************************************************************************************************
-- Systray
s.systray = wibox.widget.systray()
systray = {{{top = 5,bottom = 6,left = 6, right = 6, widget = wibox.container.margin, s.systray }, bg = "#5E81AC",  widget = wibox.container.background ,
            shape = function(cr, width, height) gears.shape.rounded_rect(cr, width, 30, 5)end}, widget = wibox.container.margin, top = 3}
--************************************************************************************************************************************************************************************
-- Create a taglist widget
s.mytaglist = awful.widget.taglist {screen  = s,filter  = awful.widget.taglist.filter.all,buttons = taglist_buttons,style = {shape = gears.shape.rounded_rect}}
mytaglist = {s.mytaglist,widget = wibox.container.margin,top = 2,bottom = 2}
--************************************************************************************************************************************************************************************
vol_widget = {{{ volume_widget{ widget_type = "icon_and_text", font = "Quicksand SemiBold 12", size = 10},widget = wibox.container.margin,left = 5,right = 5,bottom = 3 },
widget = wibox.container.background,bg = "#81A1C1",fg = "#000000", shape = function(cr, width, height) gears.shape.rounded_rect(cr, width, 30, 5)end},
widget = wibox.container.margin,top = 3}
--************************************************************************************************************************************************************************************
-- ram widget
s.myram = awful.widget.watch('bash -c "free -h | awk \'/^Mem/ {print $3}\'"' ,1)
myram = {{{{image  = '/home/nbd/.config/awesome/icons/ram.png',forced_width = 20,forced_height = 20,widget = wibox.widget.imagebox},widget = wibox.container.place},
widget = wibox.container.place},spacing = 7,{bottom = 2,widget = wibox.container.margin,s.myram},
layout = wibox.layout.fixed.horizontal}
--************************************************************************************************************************************************************************************
s.gpu = awful.widget.watch('/home/nbd/.config/awesome/script/nvtemp.sh',1)
gpu = {{{{image  = '/home/nbd/.config/awesome/icons/gpu.png',forced_width = 20,forced_height = 20,widget = wibox.widget.imagebox},widget = wibox.container.place},
widget = wibox.container.place},spacing = 7,{bottom = 2,widget = wibox.container.margin,s.gpu},
layout = wibox.layout.fixed.horizontal}
--************************************************************************************************************************************************************************************
s.mylauncher = awful.widget.launcher({ image = '/home/nbd/.config/awesome/icons/debian.svg', menu = mymainmenu })
mylauncher = {s.mylauncher,widget = wibox.container.margin,top = 2,bottom =2 ,left = 5 }
--************************************************************************************************************************************************************************************
s.cpu = awful.widget.watch('bash -c "(sensors | grep -Eo \'Package id 0:.{0,10}\') | grep -Eo \'[1-9].{0,1}\' |  sed \'s/$/°C/\'"', 1)
cpu = {{{{image  = '/home/nbd/.config/awesome/icons/cpu.png',forced_width = 20,forced_height = 20,widget = wibox.widget.imagebox},widget = wibox.container.place},
widget = wibox.container.place},spacing = 7,{bottom = 2,widget = wibox.container.margin,s.cpu},
layout = wibox.layout.fixed.horizontal}
--************************************************************************************************************************************************************************************
-- Create a tasklist widget
s.mytasklist = awful.widget.tasklist { screen   = s, filter   = awful.widget.tasklist.filter.currenttags,buttons  = tasklist_buttons, 
        style = {shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 5) end},
    }
mytasklist = {s.mytasklist,widget = wibox.container.margin,top = 2,bottom = 2}
--====================================================================================================================================================================================
--====================================================================================================================================================================================
awful.wibox({ screen = s, height = 10, bg = "#00000000", })
s.mywibox = awful.wibar({position = "top",stretch = false,screen = s, height = 36,width = 1895,bg = "#00000000",border_color = "#d8dee9",border_width = "2",
    shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 10) end,})
--************************************************************************************************************************************************************************************
-- Add widgets to the wibox
s.mywibox:setup {
    layout = wibox.layout.align.horizontal,
    expand = "none",
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
--       ***********************************************
            mylauncher, spacing = 20,
--       ***********************************************
            mytaglist,
--       ***********************************************
            s.mypromptbox },
--************************************************************************************************************************************************************************************
        {-- Middle widget
            layout = wibox.layout.fixed.horizontal,
--       ***********************************************
            mytasklist 
        },
--************************************************************************************************************************************************************************************
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
--       ***********************************************
            klayout,
--       ***********************************************
            {{{{{myram,widget = wibox.container.place},spacing = 9,
            {gpu,widget = wibox.container.place},spacing = 9,
            {cpu,widget = wibox.container.place},spacing = 7,
            layout = wibox.layout.fixed.horizontal},widget = wibox.container.margin,left = 3,right =3 } ,bg = "#5E81AC",fg = "#000000",  widget = wibox.container.background,
            shape = function(cr, width, height) gears.shape.rounded_rect(cr, width, 30, 5)end}, widget = wibox.container.margin,top = 3},
            
--       ***********************************************
            systray, spacing = 10,
--       ***********************************************                
            vol_widget , spacing = 10,
--       ***********************************************
            textclock,
--       ***********************************************
            wibox.widget.textbox("")},}
end)
--====================================================================================================================================================================================
--====================================================================================================================================================================================
-- Bindings
globalkeys = gears.table.join(

--increase and decrease volume --------------------------------------------------------------------------------------------------------------------------------------------------------------
awful.key({ modkey }, "f", function() volume_widget:inc(5) end),
awful.key({ modkey }, "d", function() volume_widget:dec(5) end),
awful.key({ modkey }, "g", function() volume_widget:toggle() end),
--increase master window -----------------------------------------------------------------s---------------------------------------------------------------------------------------------
awful.key({ modkey, "Shift"}, "f",     function () awful.tag.incnmaster( 1, nil, true) end, {description = "increase the number of master clients", group = "layout"}),
awful.key({ modkey, "Shift"}, "d",     function () awful.tag.incnmaster(-1, nil, true) end, {description = "decrease the number of master clients", group = "layout"}),
--client move to tag --------------------------------------------------------------------------------------------------------------------------------------------------------------
awful.key({ modkey,"Shift" }, "z", function() local screen = awful.screen.focused() local t = screen.selected_tag if t then local idx = 1 if client.focus then client.focus:move_to_tag(screen.tags[idx]) screen.tags[idx]:view_only() end end end,{description = "move focused client to next tag and view tag", group = "tag"}),
awful.key({ modkey,"Shift" }, "x", function() local screen = awful.screen.focused() local t = screen.selected_tag if t then local idx = 2 if client.focus then client.focus:move_to_tag(screen.tags[idx]) screen.tags[idx]:view_only() end end end,{description = "move focused client to next tag and view tag", group = "tag"}),
awful.key({ modkey,"Shift" }, "c", function() local screen = awful.screen.focused() local t = screen.selected_tag if t then local idx = 3 if client.focus then client.focus:move_to_tag(screen.tags[idx]) screen.tags[idx]:view_only() end end end,{description = "move focused client to next tag and view tag", group = "tag"}),
awful.key({ modkey,"Shift" }, "v", function() local screen = awful.screen.focused() local t = screen.selected_tag if t then local idx = 4 if client.focus then client.focus:move_to_tag(screen.tags[idx]) screen.tags[idx]:view_only() end end end,{description = "move focused client to next tag and view tag", group = "tag"}),
awful.key({ modkey,"Shift" }, "b", function() local screen = awful.screen.focused() local t = screen.selected_tag if t then local idx = 5 if client.focus then client.focus:move_to_tag(screen.tags[idx]) screen.tags[idx]:view_only() end end end,{description = "move focused client to next tag and view tag", group = "tag"}),
awful.key({ modkey,"Shift" }, "n", function() local screen = awful.screen.focused() local t = screen.selected_tag if t then local idx = 6 if client.focus then client.focus:move_to_tag(screen.tags[idx]) screen.tags[idx]:view_only() end end end,{description = "move focused client to next tag and view tag", group = "tag"}),
awful.key({ modkey,"Shift" }, "m", function() local screen = awful.screen.focused() local t = screen.selected_tag if t then local idx = 7 if client.focus then client.focus:move_to_tag(screen.tags[idx]) screen.tags[idx]:view_only() end end end,{description = "move focused client to next tag and view tag", group = "tag"}),
--tag display multiple --------------------------------------------------------------------------------------------------------------------------------------------------------------
awful.key( {modkey, 'Control'}, 'z', function() local screen = awful.screen.focused() local tag = screen.tags[1] if tag then awful.tag.viewtoggle(tag) end end,{description = 'Toggle tag', group = 'tag'} ),
awful.key( {modkey, 'Control'}, 'x', function() local screen = awful.screen.focused() local tag = screen.tags[2] if tag then awful.tag.viewtoggle(tag) end end,{description = 'Toggle tag', group = 'tag'} ),
awful.key( {modkey, 'Control'}, 'c', function() local screen = awful.screen.focused() local tag = screen.tags[3] if tag then awful.tag.viewtoggle(tag) end end,{description = 'Toggle tag', group = 'tag'} ),
awful.key( {modkey, 'Control'}, 'v', function() local screen = awful.screen.focused() local tag = screen.tags[4] if tag then awful.tag.viewtoggle(tag) end end,{description = 'Toggle tag', group = 'tag'} ),
awful.key( {modkey, 'Control'}, 'b', function() local screen = awful.screen.focused() local tag = screen.tags[5] if tag then awful.tag.viewtoggle(tag) end end,{description = 'Toggle tag', group = 'tag'} ),
awful.key( {modkey, 'Control'}, 'n', function() local screen = awful.screen.focused() local tag = screen.tags[6] if tag then awful.tag.viewtoggle(tag) end end,{description = 'Toggle tag', group = 'tag'} ),
awful.key( {modkey, 'Control'}, 'm', function() local screen = awful.screen.focused() local tag = screen.tags[7] if tag then awful.tag.viewtoggle(tag) end end,{description = 'Toggle tag', group = 'tag'} ),
--tag view --------------------------------------------------------------------------------------------------------------------------------------------------------------
 awful.key({modkey}, "z", function() awful.screen.focused().tags[1]:view_only() end),
 awful.key({modkey}, "x", function() awful.screen.focused().tags[2]:view_only() end), 
 awful.key({modkey}, "c", function() awful.screen.focused().tags[3]:view_only() end), 
 awful.key({modkey}, "v", function() awful.screen.focused().tags[4]:view_only() end), 
 awful.key({modkey}, "b", function() awful.screen.focused().tags[5]:view_only() end), 
 awful.key({modkey}, "n", function() awful.screen.focused().tags[6]:view_only() end), 
 awful.key({modkey}, "m", function() awful.screen.focused().tags[7]:view_only() end), 
--use color picker --------------------------------------------------------------------------------------------------------------------------------------------------------------
--awful.key({ modkey,"Shift" },"a",function () awful.util.spawn_with_shell("(gpick -p &); pid=$(pidof gpick); sleep 5; xclip -se c -o | xclip -i -se c -l 1; kill $pid") end,{description = "take screenshot", group = "launcher"}),
awful.key({ modkey,"Shift" },"a",function () awful.util.spawn_with_shell("gpick -p") end,{description = "take screenshot", group = "launcher"}),
--flameshot take screenshot --------------------------------------------------------------------------------------------------------------------------------------------------------------
awful.key({ modkey,"Shift" },"s",function () awful.util.spawn("flameshot gui") end,{description = "take screenshot", group = "launcher"}),
--rofi start --------------------------------------------------------------------------------------------------------------------------------------------------------------
awful.key({ modkey },"space",function () awful.util.spawn('rofi -combi-modi window,drun -show combi') end,{description = "run rofi", group = "launcher"}),
-- resizing arrow --------------------------------------------------------------------------------------------------------------------------------------------------------------
awful.key({ modkey, "Control"   }, "Right",     function () awful.tag.incmwfact( 0.08)    end,{description = "resize client", group = "client"}),
awful.key({ modkey, "Control"   }, "Left",     function () awful.tag.incmwfact(-0.08)    end,{description = "resize client", group = "client"}),
awful.key({ modkey, "Control"   }, "Down",     function () awful.client.incwfact( 0.08)    end,{description = "resize client", group = "client"}),
awful.key({ modkey, "Control"   }, "Up",     function () awful.client.incwfact(-0.08)    end,{description = "resize client", group = "client"}),
--swap place arrow --------------------------------------------------------------------------------------------------------------------------------------------------------------
awful.key({ modkey, "Shift"  }, "Left" , function(c)awful.client.swap.global_bydirection("left")end,{description = "move client", group = "client"}),
awful.key({ modkey, "Shift"  }, "Right" , function(c)awful.client.swap.global_bydirection("right")end,{description = "move client", group = "client"}),
awful.key({ modkey, "Shift"  }, "Up" , function(c)awful.client.swap.global_bydirection("up")end,{description = "move client", group = "client"}),
awful.key({ modkey, "Shift"  }, "Down" , function(c) awful.client.swap.global_bydirection("down")end,{description = "move client", group = "client"}),
--focus arrow --------------------------------------------------------------------------------------------------------------------------------------------------------------
awful.key({modkey}, "Left", function()awful.client.focus.bydirection("left")end, {description = "Focus left", group = "client"}),
awful.key({modkey}, "Right", function()awful.client.focus.bydirection("right")end, {description = "Focus right", group = "client"}),
awful.key({modkey}, "Up", function()awful.client.focus.bydirection("up")end, {description = "Focus up", group = "client"}),
awful.key({modkey}, "Down", function()awful.client.focus.bydirection("down")end, {description = "Focus down", group = "client"}),
-- Bindings Default --------------------------------------------------------------------------------------------------------------------------------------------------------------
awful.key({modkey},"h",hotkeys_popup.show_help, {description="show help", group="awesome"}),
awful.key({modkey},"a", awful.client.urgent.jumpto, {description = "jump to urgent client", group = "client"}),
awful.key({modkey},"Return", function () awful.spawn(terminal) end, {description = "open a terminal", group = "launcher"}),
awful.key({modkey,"Control"}, "r", awesome.restart, {description = "reload awesome", group = "awesome"}),
awful.key({modkey,"Shift"}, "q",function () awful.util.spawn_with_shell("i3lock -i Pictures/Wallpaper/i3lock.png") end , {description = "Lock screen", group = "awesome"})


)
--====================================================================================================================================================================================
--====================================================================================================================================================================================
clientkeys = gears.table.join(
--************************************************************************************************************************************************************************************
awful.key({ modkey,}, "=",
    function (c) c.maximized_horizontal = false c.maximized_vertical = false c.maximized = not c.maximized c:raise() end ,{description = "maximize", group = "client"}),
--************************************************************************************************************************************************************************************
awful.key({ modkey}, "q",      function (c) c:kill()                         end, {description = "close", group = "client"}),
awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     , {description = "toggle floating", group = "client"}))
--************************************************************************************************************************************************************************************
clientbuttons = gears.table.join(
awful.button({ }, 1, function (c) c:emit_signal("request::activate", "mouse_click", {raise = true}) end),
awful.button({ modkey }, 1, function (c) c:emit_signal("request::activate", "mouse_click", {raise = true}) awful.mouse.client.move(c) end),
awful.button({ modkey }, 3, function (c) c:emit_signal("request::activate", "mouse_click", {raise = true}) awful.mouse.client.resize(c) end))
-- Set keys --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
root.keys(globalkeys)
--====================================================================================================================================================================================
--====================================================================================================================================================================================
--Rules
awful.rules.rules = {
    { rule = { },
      properties = { border_width = beautiful.border_width, border_color = beautiful.border_normal, focus = awful.client.focus.filter, raise = true, keys = clientkeys,
      buttons = clientbuttons, screen = awful.screen.preferred, placement = awful.placement.no_overlap+awful.placement.no_offscreen}},
    -- Floating clients -------------------------------------------------------------------------------------------------------------------------------------------------------------
    { rule_any = { instance = { "DTA", "copyq", "pinentry",},
        class = {"Arandr", "Blueman-manager","Gpick","Kruler","MessageWin","Sxiv","Tor Browser","Wpa_gui","veromix","xtightvncviewer"},
        name = {"Event Tester",},
        role = {"AlarmWindow","ConfigManager","pop-up",}}, properties = { floating = true }},
        -- Glava --------------------------------------------------------------------------------------------------------------------------------------------------------------------
        {rule_any = {name = { "GLava" }}, properties = {focusable = false,ontop = true,skip_taskbar = true},
            callback = function(c) local img = cairo.ImageSurface(cairo.Format.A1, 0, 0) c.shape_input = img._native img.finish() end },
    
            
    }
--====================================================================================================================================================================================
--====================================================================================================================================================================================
--autostart apps
awful.spawn.with_shell()
awful.spawn.with_shell("/opt/freedownloadmanager/fdm --hidden")
awful.spawn({"blueman-applet"})
awful.spawn.with_shell('/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=/app/bin/gwe --file-forwarding com.leinardi.gwe --hide-window')
awful.spawn.with_shell("setxkbmap -option grp:switch,grp_led:scroll,grp:alt_caps_toggle us,ar")
awful.spawn.with_shell("glava -d")
awful.spawn.with_shell("picom -b")
--====================================================================================================================================================================================
--====================================================================================================================================================================================
-- Custom Commands 
-- Set flating windwos always on top ----------------------------------------------------------------------------------------------------------------------------------------------------------------
client.connect_signal("property::floating", function(c) if c.floating then c.ontop = c.floating and not c.fullscreen else c.ontop = false end end)
--====================================================================================================================================================================================
--====================================================================================================================================================================================

