function increaseBrightness()
    for _, screen in pairs(hs.screen.allScreens()) do
        screen:setBrightness(1.0)
    end
end

screenWatcher = hs.screen.watcher.new(increaseBrightness)