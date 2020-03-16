local log = hs.logger.new("dotfile", "debug")

-- reload config
function reload_config(files)
	hs.console.clearConsole()
	log.i("reloading...")
	hs.reload()
end
local pathWatcher =
	hs.pathwatcher.new(
		os.getenv("HOME") .. "/.hammerspoon/",
		reload_config
	):start()
hs.alert.show(
	"hammerspoon config reloaded",
	hs.alert.defaultStyle,
	hs.screen.primaryScreen(),
	5
)

-- fix audio output
function fixAudio()
	if hs.audiodevice.current().name == "LG HDR 4K" then
		log.i("fixing audio output...")
		local bose =
			hs.audiodevice.findOutputByName("Bose QuietComfort 35")
		if bose then
			log.i("selected: Bose QuietComfort 35")
			bose:setDefaultOutputDevice()
			return
		end
		local ultra =
			hs.audiodevice.findOutputByName(
				"LG UltraFine Display Audio"
			)
		if ultra then
			log.i("selected: LG UltraFine Display Audio")
			ultra:setDefaultOutputDevice()
			return
		end
		local speakers =
			hs.audiodevice.findOutputByName("Internal Speakers")
		if speakers then
			log.i("selected: Internal Speakers")
			speakers:setDefaultOutputDevice()
			return
		end
	end
end
hs.audiodevice.watcher.setCallback(fixAudio)
hs.audiodevice.watcher.start()

-- reset brightness
function increaseBrightness()
	log.i("fixing brightness...")
	for _, screen in pairs(hs.screen.allScreens()) do
		screen:setBrightness(1.0)
	end
end
local screenWatcher = hs.screen.watcher.new(increaseBrightness):start()

function moveWindows()
	local left = hs.screen"Color LCD"
	local primary = left
	local right = left

	if hs.screen"LG UltraFine" then
		primary = hs.screen"LG UltraFine"
	end
	if hs.screen"LG HDR 4K" then
		right = hs.screen"LG HDR 4K"
	end

	local pritunl = hs.window"Pritun"
	if pritunl then
		pritunl:setFrameInScreenBounds(
			right:localToAbsolute(hs.geometry.rect(0, 0, 450, 600))
		)
	end

	local windowLayout =
		{
			{ "Airmail", nil, primay, hs.layout.left50, nil, nil },
			{
				"Fantastical",
				nil,
				left,
				hs.layout.left50,
				nil,
				nil
			},
			{
				"Slack",
				nil,
				left,
				hs.geometry.unitrect(0.33, 0, 0.67, 1),
				nil,
				nil
			},
			{ "iTerm2", nil, primary, hs.layout.left50, nil, nil },
			{ "Mail", nil, primary, hs.layout.right50, nil, nil },
			{
				"Spotify",
				nil,
				right,
				hs.geometry.unitrect(0.25, 0, 0.75, 1),
				nil,
				nil
			}
		}
	hs.layout.apply(windowLayout)

	local chrome = { hs.window"Google Chrome" }
	local firefox = hs.application"Firefox":allWindows()
	if primary:frame().w > 1920 then
		stackWindows(primary, chrome)
		stackWindows(primary, firefox)
	else
		fillScreen(primary, chrome)
		fillScreen(primary, firefox)
	end

	local fanstastical = hs.window"Fanstastical"
	if fanstastical then
		fanstastical:raise()
	end

	local slack = hs.window"Slack"
	if slack then
		slack:raise()
	end

	for _, window in ipairs(chrome) do
		window:raise()
	end

	for _, window in ipairs(firefox) do
		window:raise()
	end
end

function fillScreen(screen, windows)
	if windows then
		local rect = screen:frame()
		for _, window in ipairs(windows) do
			window:setFrameInScreenBounds(
				screen:localToAbsolute(rect)
			)
		end
	end
end

function stackWindows(screen, windows)
	if windows then
		local rect = screen:frame()
		local h = rect.h / #windows
		local w = rect.w / 2
		local x = rect.x + w
		local y = rect.y
		for _, window in ipairs(windows) do
			rect = hs.geometry.rect(x, y, w, h)
			y = y + h
			window:setFrameInScreenBounds(
				screen:localToAbsolute(rect)
			)
		end
	end
end
