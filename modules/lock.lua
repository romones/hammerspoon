local function lock_screen()
    os.execute("/System/Library/CoreServices/Menu\\ Extras/User.menu/Contents/Resources/CGSession -suspend")
end

return {
    lock = lock_screen,
}
