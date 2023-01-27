-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Keyboard layouts library
local kbdcfg = require("kbdcfg")

-- Enable hotkeys help widget for VIM and other apps
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
		     title = "Fucked Errors happened during startup",
		     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function (err)
		if in_error then return end
		in_error = true

		naughty.notify({ preset = naughty.config.presets.critical,
			 title = "Fucked Errors happened",
			 text = tostring(err) })
		in_error = false
	end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- This is used later as the default apps for actions.
terminal = "urxvt"

editor = os.getenv("EDITOR") or "emacs"
editor_cmd = terminal .. " -e " .. editor
uieditor = "emacs"
massiveeditor = "com.vscodium.codium"
imageeditor = "gimp"

mcviewer = "ghidra"
docviewer = "qpdfview-qt5"

browser = "firefox"

keymanager = "keepassxc"
filemanager = "thunar"
referencemanager = "org.zotero.Zotero"
proccessmanager = "htop"

avogadro = "org.openchemistry.Avogadro2"

minecraft = "UltimMC"
minecraftcomm = os.getenv("HOME") .. "/.minecraft"..minecraft
ksp = "kerbal space program"

-- Default modkey.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
	awful.layout.suit.tile,
	awful.layout.suit.tile.left,
	awful.layout.suit.tile.bottom,
	awful.layout.suit.tile.top,
	awful.layout.suit.fair,
	awful.layout.suit.fair.horizontal,
	awful.layout.suit.floating,
	awful.layout.suit.spiral,
	awful.layout.suit.spiral.dwindle,
	awful.layout.suit.max,
	awful.layout.suit.max.fullscreen,
	awful.layout.suit.magnifier,
	awful.layout.suit.corner.nw,
	-- awful.layout.suit.corner.ne,
	-- awful.layout.suit.corner.sw,
	-- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and menus
myawesomemenu = {
	{"hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
	{"manual", terminal .. " -e man awesome" },
	{"edit config", "emacs" .. " " .. awesome.conffile },
	{"restart", awesome.restart },
	{"quit", function() awesome.quit() end },
}
mysciencemenu = {
	{"KAlgebra", "kalgebra"},
	
	{"Zotero", "flatpak run"..referencemanager},
	
	{"Avogadro", "flatpak run"..avogadro},
	
	{"Minetest", "minetest"},
	{"MultiMC", minecraftcomm},
}
myeditormenu = {
	{"VSCode", "flatpak run com.vscodium.codium --no-sandbox"},
	{"Emacs", uieditor},
	{"Klogg", "klogg"},

	{"Libre Office", "libreoffice"},
	{"-----"},
	{"blender", "blender"},
	{"GIMP", "gimp"},
}
myinternetmenu = {
	{"Firefox", browser},
	{"Transmission", "transmission"},
}

mymainmenu = awful.menu({ items = {
		{"awesome", myawesomemenu, beautiful.awesome_icon},
		{"Terminal", terminal},
		{"Science", mysciencemenu, debug.getinfo(1).short_src:sub(0, 24) .. "/science_logo.png"},
		{"Editor", myeditormenu},
		{"Internet", myinternetmenu},
		{"qpdfview", "qpdfview-qt5"},
		{"ghidra", "ghidra"},
		{"Home", filemanager},
		{"DeaDBeeF", "deadbeef"},
		{"VLC", "vlc"}
	}
})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
				     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal
-- }}}

local kbdcfg1 = kbdcfg({type = "tui"})

kbdcfg1.add_primary_layout("English", "US", "us")
kbdcfg1.add_primary_layout("Русский", "RU", "ru")

kbdcfg1.bind()

-- Keyboard map indicator and switcher
mykeyboardlayout = kbdcfg1.widget

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
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
		    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
		)

local tasklist_buttons = gears.table.join(
		     awful.button({ }, 1, function (c)
					      if c == client.focus then
						  c.minimized = true
					      else
						  c:emit_signal(
						      "request::activate",
						      "tasklist",
						      {raise = true}
						  )
					      end
					  end),
		     awful.button({ }, 3, function()
					      --awful.menu.client_list({ theme = { width = 250 } })
					  end),
		     awful.button({ }, 4, function ()
					      awful.client.focus.byidx(1)
					  end),
		     awful.button({ }, 5, function ()
					      awful.client.focus.byidx(-1)
					  end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
	local wallpaper = beautiful.wallpaper
	-- If wallpaper is a function, call it with the screen
	--gears.wallpaper.maximized(wallpaper, s, true)

	gears.wallpaper.set("#FFFFFF00")
	gears.wallpaper.centered(debug.getinfo(1).short_src:sub(0, 24) .. "/Ferrocene.png", s, "#FFFFFFFF", 1.3)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
			   awful.button({ }, 1, function () awful.layout.inc( 1) end),
			   awful.button({ }, 3, function () awful.layout.inc(-1) end),
			   awful.button({ }, 4, function () awful.layout.inc( 1) end),
			   awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    function list_update(w, buttons, label, data, objects)
    -- call default widget drawing function
    common.list_update(w, buttons, label, data, objects)
    -- set widget size
    --w:set_max_widget_size(20)
end

-- Create a tasklist widget
s.mytasklist = awful.widget.tasklist {
   screen	= s,
   filter	= awful.widget.tasklist.filter.currenttags,
   buttons = tasklist_buttons,
   layout	 = {
      spacing = 1,
      forced_num_rows = 3,
      layout	= wibox.layout.grid.horizontal,
	},
	widget_template = {
			{
				{
					{
						{
							id     = 'icon_role',
							widget = wibox.widget.imagebox,
						},
						margins = 0,
						widget	= wibox.container.margin,
					},
					{
					   fg = '#FFFFFF',
					   id     = 'text_role',
						widget = wibox.widget.textbox,
					},
					layout = wibox.layout.fixed.horizontal,
				},
				left  = 0,
				right = 0,
				widget = wibox.container.margin
			},
			forced_width	= 160,
			forced_height	 = 18,
			bg = '#111111',
			--id     = 'background_role',
			widget = wibox.container.background
	},
	--update_function = list_update,
    }
    
    s.mytasklist:buttons(gears.table.join())

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height    = 54})

    -- Add widgets to the wibox
    s.mywibox:setup {
	layout = wibox.layout.align.horizontal,
	{ -- Left widgets
	    layout = wibox.layout.fixed.horizontal,
	    -- mylauncher,
	    s.mypromptbox,
	},
	s.mytasklist, -- Middle widget
	{ -- Right widgets
	    layout = wibox.layout.fixed.horizontal,
	    mykeyboardlayout,
	    wibox.widget.systray(),
	    mytextclock,
	    -- s.mylayoutbox,
	},
    }
end)
-- }}}

-- {{{ Mouse bindings
kbdcfg.widget:buttons(gears.table.join(
    awful.button({ }, 3, function () kbdcfg.menu:toggle() end)
))
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(

        awful.key({modkey, "Mod1"}, "b",	function() awful.spawn(browser) end,
	   {description="Run a "..browser, group="software"}),
	awful.key({modkey, "Mod1"}, "e",	function() awful.spawn(uieditor) end,
	   {description="Run a "..uieditor, group="software"}),
	awful.key({modkey, "Mod1"}, "g",	function() awful.spawn("ghidra") end,
	   {description="Run a ghidra", group="software"}),
	awful.key({modkey, "Mod1"}, "m",	function() awful.spawn("flatpak run "..massiveeditor) end,
	   {description="Run a "..massiveeditor, group="software"}),
	awful.key({modkey, "Mod1"}, "r",	function() awful.spawn("flatpak run "..referencemanager) end,
	   {description="Run a "..referencemanager, group="software"}),
	awful.key({modkey, "Mod1"}, "k",	function() awful.spawn("keepassxc") end,
	    {description="Run a "..keymanager, group="software"}),
	awful.key({modkey, "Mod1"}, "p",	function() awful.spawn(terminal.." -e "..proccessmanager) end,
	   {description="Run a "..proccessmanager, group="software"}),
	awful.key({modkey, "Mod1"}, "f",	function() awful.spawn(filemanager) end,
	   {description="Run a "..filemanager, group="software"}),
	awful.key({modkey, "Mod1"}, "l",	function() awful.spawn("libreoffice") end,
	   {description="Run a ".."libreoffice", group="software"}),
	awful.key({modkey, "Mod1"}, "i",	function() awful.spawn(imageeditor) end,
	   {description="Run a "..imageeditor, group="software"}),
	awful.key({modkey, "Mod1"}, "v",	function() awful.spawn("blender") end,
	   {description="Run a ".."blender", group="software"}),
	awful.key({modkey, "Mod1"}, "c",	function() awful.spawn(minecraftcomm) end,
	   {description="Run a "..minecraft, group="software"}),
	awful.key({modkey, "Mod1"}, "t",	function() awful.spawn(minetest) end,
	   {description="Run a ".."minetest", group="software"}),
	awful.key({modkey, "Mod1"}, "s",	function() awful.spawn("KSP.x86_64") end,
	   {description="Run a "..ksp, group="software"}),
	awful.key({modkey, "Mod1"}, "a",	function() awful.spawn("kalgebra") end,
	   {description="Run a ".."kalgebra", group="software"}),
	awful.key({modkey, "Mod1"}, "o",	function() awful.spawn("flatpak run"..avogadro) end,
	   {description="Run a "..avogadro, group="software"}),
	awful.key({modkey, "Mod1"}, "z",	function() awful.spawn("palemoon") end,
	   {description="Run a ".."palemoon", group="software"}),
	
	awful.key({ "Shift",	       }, "Alt_L",	kbdcfg1.switch_next,
	   {description="Switch language", group="lang"}),
	
	awful.key({ }, "Print",	function() awful.spawn("xfce4-screenshooter") end,
	   {description="Printscreen", group="print"}),
	
	awful.key({ modkey,		  }, "s",      hotkeys_popup.show_help,
	      {description="show help", group="awesome"}),
	awful.key({ modkey,		  }, "Left",   awful.tag.viewprev,
	      {description = "view previous", group = "tag"}),
	awful.key({ modkey,		  }, "Right",  awful.tag.viewnext,
	      {description = "view next", group = "tag"}),
	awful.key({ modkey,		  }, "Escape", awful.tag.history.restore,
	      {description = "go back", group = "tag"}),

    awful.key({ modkey,		  }, "j",
	function ()
	    awful.client.focus.byidx( 1)
	end,
	{description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,		  }, "k",
	function ()
	    awful.client.focus.byidx(-1)
	end,
	{description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,		  }, "w", function () mymainmenu:show() end,
	      {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"	  }, "j", function () awful.client.swap.byidx(	1)    end,
	      {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"	  }, "k", function () awful.client.swap.byidx( -1)    end,
	      {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
	      {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
	      {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,		  }, "u", awful.client.urgent.jumpto,
	      {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,		  }, "Tab",
	function ()
	    awful.client.focus.history.previous()
	    if client.focus then
		client.focus:raise()
	    end
	end,
	{description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,		  }, "Return", function () awful.spawn(terminal) end,
	      {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Shift" }, "r", awesome.restart,
	      {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"	  }, "q", awesome.quit,
	      {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,		  }, "l",     function () awful.tag.incmwfact( 0.05)	      end,
	      {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,		  }, "h",     function () awful.tag.incmwfact(-0.05)	      end,
	      {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"	  }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
	      {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"	  }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
	      {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
	      {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
	      {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,		  }, "space", function () awful.layout.inc( 1)		      end,
	      {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"	  }, "space", function () awful.layout.inc(-1)		      end,
	      {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
	      function ()
		  local c = awful.client.restore()
		  -- Focus restored client
		  if c then
		    c:emit_signal(
			"request::activate", "key.unminimize", {raise = true}
		    )
		  end
	      end,
	      {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },	     "r",     function () awful.screen.focused().mypromptbox:run() end,
	      {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
	      function ()
		  awful.prompt.run {
		    prompt	 = "Run Lua code: ",
		    textbox	 = awful.screen.focused().mypromptbox.widget,
		    exe_callback = awful.util.eval,
		    history_path = awful.util.get_cache_dir() .. "/history_eval"
		  }
	      end,
	      {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
	      {description = "show the menubar", group = "launcher"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,		  }, "f",
	function (c)
	    c.fullscreen = not c.fullscreen
	    c:raise()
	end,
	{description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"	  }, "c",      function (c) c:kill()			     end,
	      {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle			,
	      {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
	      {description = "move to master", group = "client"}),
    awful.key({ modkey,		  }, "o",      function (c) c:move_to_screen()		     end,
	      {description = "move to screen", group = "client"}),
    awful.key({ modkey,		  }, "t",      function (c) c.ontop = not c.ontop	     end,
	      {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,		  }, "n",
	function (c)
	    
	    c.minimized = true
	end ,
	{description = "minimize", group = "client"}),
    awful.key({ modkey,		  }, "m",
	function (c)
	    c.maximized = not c.maximized
	    c:raise()
	end ,
	{description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
	function (c)
	    c.maximized_vertical = not c.maximized_vertical
	    c:raise()
	end ,
	{description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"	  }, "m",
	function (c)
	    c.maximized_horizontal = not c.maximized_horizontal
	    c:raise()
	end ,
	{description = "(un)maximize horizontally", group = "client"})
)

for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
	-- View tag only.
	awful.key({ modkey }, "#" .. i + 9,
		  function ()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
			   tag:view_only()
			end
		  end,
		  {description = "view tag #"..i, group = "tag"}),
	-- Toggle tag display.
	awful.key({ modkey, "Control" }, "#" .. i + 9,
		  function ()
		      local screen = awful.screen.focused()
		      local tag = screen.tags[i]
		      if tag then
			 awful.tag.viewtoggle(tag)
		      end
		  end,
		  {description = "toggle tag #" .. i, group = "tag"}),
	-- Move client to tag.
	awful.key({ modkey, "Shift" }, "#" .. i + 9,
		  function ()
		      if client.focus then
			  local tag = client.focus.screen.tags[i]
			  if tag then
			      client.focus:move_to_tag(tag)
			  end
		     end
		  end,
		  {description = "move focused client to tag #"..i, group = "tag"}),
	-- Toggle tag on focused client.
	awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
		  function ()
		      if client.focus then
			  local tag = client.focus.screen.tags[i]
			  if tag then
			      client.focus:toggle_tag(tag)
			  end
		      end
		  end,
		  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
	c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
	c:emit_signal("request::activate", "mouse_click", {raise = true})
	awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
	c:emit_signal("request::activate", "mouse_click", {raise = true})
	awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
   --All
    { rule = { },
      properties = { border_width = beautiful.border_width,
		     border_color = beautiful.border_normal,
		     focus = awful.client.focus.filter,
		     raise = true,
		     keys = clientkeys,
		     buttons = clientbuttons,
		     screen = awful.screen.preferred,
		     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
	instance = {
	  "DTA",  -- Firefox addon DownThemAll.
	  "copyq",  -- Includes session name in class.
	  "pinentry",
	},
	class = {
	  "Scilab",
	  "Arandr",
	  "Blueman-manager",
	  "Gpick",
	  "Kruler",
	  "MessageWin",	 -- kalarm.
	  "Sxiv",
	  "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
	  "Wpa_gui",
	  "veromix",
	  "xtightvncviewer",
	},

	name = {
	  "Графическое окно 1",
	  "Графическое окно 2",
	  "Event Tester",
	},
	role = {
	  "AlarmWindow",  -- Thunderbird's calendar.
	  "ConfigManager",  -- Thunderbird's about:config.
	  -- "pop-up",	  -- e.g. Google Chrome's (detached) Developer Tools.
	}
      }, properties = { floating = true, maximized = false, fullscreen = false }},

    --{ rule_any = {type = { "normal", "dialog" }
      --}, properties = { titlebars_enabled = false }
    --},
    
    { rule_any = {type = { "dialog" }
      }, properties = { placement = awful.placement.centered }
    },

    --Kerbals
    { rule_any = {	
	name = {
	  "Kerbal Space Program",  -- mb not. Not 2.
	},
    }, properties = { floating = true, maximized = false, fullscreen = false,  width = 1024,  height = 576 }},

    
    { rule_any = {
	class = {
		"vscodium",
	},
	instance = {
		"emacs",
		"klogg",
		"firefox",
		"octave",
		
		"sakura"
	},
      }, properties = { floating = false, maximized = false }},

      --Not used
      { rule_any = {
	instance = {
	  "vlc",
	},
      }, properties = { fullscreen = true }},

      --tag for something
      { rule_any = {
	class = {
		"vscodium",
	},
	instance = {
	  "ghidra-Ghidra",
	},
      }, properties = { tag = "2" }},

      --Not used
      { rule_any = {
	instance = {
	   "vlc",
	   "deadbeef",
	},
      }, properties = { tag = "3" }},
      
      { rule_any = {
	instance = {
	  "ghidra-Ghidra",
	},
      },
      rule_any = {
	name = {
	   "CodeBrowser.*",
	},
      }, properties = { maximized = true }},

      { rule_any = {
	instance = {
	  "ghidra-Ghidra",
	},
      },
      rule_any = {
	name = {
	   "win.*",
	},
      }, properties = { titlebars_enabled = false }}, --titlebar closing close a whole software
      
      { rule_any = {
	role = {
	  "GtkFileChooserDialog",
	},
      }, properties = { floating = true, height = 550, placement = awful.placement.centered }},
    }
-- }}}

-- {{{ Signals
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
	-- Prevent clients from being unreachable after screen count changes.
	awful.placement.no_offscreen(c)
    end
end)

-- Remove
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
	awful.button({ }, 1, function()
	    c:emit_signal("request::activate", "titlebar", {raise = true})
	    awful.mouse.client.move(c)
	end),
	awful.button({ }, 3, function()
	    c:emit_signal("request::activate", "titlebar", {raise = true})
	    awful.mouse.client.resize(c)
	end)
    )

    awful.titlebar(c) : setup {
	{ -- Left
	    awful.titlebar.widget.iconwidget(c),
	    buttons = buttons,
	    layout  = wibox.layout.fixed.horizontal
	},
	{ -- Middle
	    { -- Title
		align  = "center",
		widget = awful.titlebar.widget.titlewidget(c)
	    },
	    buttons = buttons,
	    layout  = wibox.layout.flex.horizontal
	},
	{ -- Right
	    awful.titlebar.widget.floatingbutton (c),
	    awful.titlebar.widget.maximizedbutton(c),
	    awful.titlebar.widget.stickybutton	 (c),
	    awful.titlebar.widget.ontopbutton	 (c),
	    awful.titlebar.widget.closebutton	 (c),
	    layout = wibox.layout.fixed.horizontal()
	},
	layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
