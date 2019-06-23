function increaseBrightness()
    for _, screen in pairs(hs.screen.allScreens()) do
        screen:setBrightness(1.0)
    end
end

function moveWindows()
    local left = hs.screen'Color LCD'
    local primary = left
    local right = left

    if hs.screen'LG UltraFine' then
        primary = hs.screen'LG UltraFine'
    end
    if hs.screen'VH226' then
        right = hs.screen'VH226'
    end

    local pritunl = hs.window'Pritun'
    if pritunl then
        pritunl:setFrameInScreenBounds(
            right:localToAbsolute(
                hs.geometry.rect(0, 0, 450, 600)
            )
        )
    end

    local windowLayout = {
        {"Airmail",     nil, primay,  hs.layout.left50,                       nil, nil},
        {"Fantastical", nil, left,    hs.layout.left50,                       nil, nil},
        {"Slack",       nil, left,    hs.geometry.unitrect(0.33, 0, 0.67, 1), nil, nil},
        {"iTerm2",      nil, primary, hs.layout.left50,                       nil, nil},
        {"Mail",        nil, primary, hs.layout.right50,                      nil, nil},
        {"Spotify",     nil, right,   hs.geometry.unitrect(0.25, 0, 0.75, 1), nil, nil},
    }
    hs.layout.apply(windowLayout)

    local chrome = {hs.window'Google Chrome'}
    local firefox = hs.application'Firefox':allWindows()
    if primary:frame().w  > 1920 then
        stackWindows(primary, chrome)
        stackWindows(primary, firefox)
    else
        fillScreen(primary, chrome)
        fillScreen(primary, firefox)
    end

    local fanstastical = hs.window'Fanstastical'
    if fanstastical then
        fanstastical:raise()
    end

    local slack = hs.window'Slack'
    if slack then
        slack:raise()
    end

    for _,window in ipairs(chrome) do
        window:raise()
    end

    for _,window in ipairs(firefox) do
        window:raise()
    end
end

function fillScreen(screen, windows)
    if windows then
        local rect = screen:frame()
        for _,window in ipairs(windows) do
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
        for _,window in ipairs(windows) do
            rect = hs.geometry.rect(x, y, w, h)
            y = y + h
            window:setFrameInScreenBounds(
                screen:localToAbsolute(rect)
            )
        end
    end
end

hs.screen.watcher.new(increaseBrightness):start()
hs.screen.watcher.new(moveWindows):start()

-- pause spotify when headphones unplugged
for i,dev in ipairs(hs.audiodevice.allOutputDevices()) do
    if dev:jackConnected() ~= nil then
        if dev.watcherCallback ~= nil then
            dev:watcherCallback(function(uid, event_name)
                local dev = hs.audiodevice.findDeviceByUID(uid)
                if event_name == 'jack' then
                    if not dev:jackConnected() then
                        hs.spotify.pause()
                    end
                end
            end)
            dev:watcherStart()
        end
    end
end
