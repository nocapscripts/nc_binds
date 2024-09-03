local shouldExecuteBind = true

AddEventHandler("redux_binds:should-execute", function(shouldExecute)
    shouldExecuteBind = shouldExecute
end)

exports('registerKeyMapping', function(name, category, description, onKeyDownCommand, onKeyUpCommand, default, event, type)
    if not category then
        print("[Error] No category provided for keymap, registration cancelled.")
        return
    end
    if not description then
        print("[Error] No description provided for keymap, registration cancelled.")
        return
    end
    if not name and event then
        print("[Error] No name provided for keymap when key is event-based, registration cancelled.")
        return
    end

    default = default or ""
    type = type or "keyboard"

    local cmdStringDown = "+cmd_wrapper__" .. onKeyDownCommand
    local cmdStringUp = "-cmd_wrapper__" .. onKeyDownCommand
    local desc = "(" .. category .. ") " .. description

    RegisterCommand(cmdStringDown, function()
        if shouldExecuteBind then
            if event then
                TriggerEvent("redux_binds:keyEvent", name, true)
            end
            ExecuteCommand(onKeyDownCommand)
        end
    end, false)

    RegisterCommand(cmdStringUp, function()
        if shouldExecuteBind then
            if event then
                TriggerEvent("redux_binds:keyEvent", name, false)
            end
            ExecuteCommand(onKeyUpCommand)
        end
    end, false)

    RegisterKeyMapping(cmdStringDown, desc, type, default)
end)
