local Framework = nil

Citizen.CreateThread(function()
    Framework = exports['qb-core']:GetCoreObject()
end)

RegisterNetEvent('ty-diceroll:client:RollDice')
AddEventHandler('ty-diceroll:client:RollDice', function()
    local playerPed = PlayerPedId()

    -- Play dice roll animation
    RequestAnimDict("anim@mp_player_intcelebrationmale@wank")
    while not HasAnimDictLoaded("anim@mp_player_intcelebrationmale@wank") do
        Citizen.Wait(100)
    end

    local animFlag = Config.AllowMovementDuringAnimation and 49 or 0 -- 49 allows upper body only animation while allowing movement
    TaskPlayAnim(playerPed, "anim@mp_player_intcelebrationmale@wank", "wank", 8.0, -8.0, -1, animFlag, 0, false, false, false)

    -- Wait for animation to finish
    local animDuration = GetAnimDuration("anim@mp_player_intcelebrationmale@wank", "wank")
    Citizen.Wait(animDuration * 1000)

    -- Stop the animation
    ClearPedTasks(playerPed)

    -- Show result
    local result = math.random(6)
    if Config.Display3DTextEnabled then
        TriggerServerEvent('ty-diceroll:server:Show3DText', GetPlayerServerId(PlayerId()), tostring(result))
    end
    if Config.NotifySelfEnabled then
        NotifyPlayer(string.format(Config.Locale.dice_roll, result))
    end
    if Config.NotifyNearbyEnabled then
        TriggerServerEvent('ty-diceroll:server:NotifyNearby', GetEntityCoords(playerPed), result)
    end

    -- Add dice back to inventory
    TriggerServerEvent('ty-diceroll:server:AddDiceBack')
end)

RegisterNetEvent('ty-diceroll:client:Show3DText')
AddEventHandler('ty-diceroll:client:Show3DText', function(playerId, text)
    local displayTime = Config.DisplayTime
    local endTime = GetGameTimer() + displayTime

    Citizen.CreateThread(function()
        while GetGameTimer() < endTime do
            Citizen.Wait(0)
            local playerPed = GetPlayerPed(GetPlayerFromServerId(playerId))
            local coords = GetPedBoneCoords(playerPed, 31086) -- Get the head bone coordinates
            local playerCoords = GetEntityCoords(PlayerPedId())
            if #(playerCoords - coords) <= Config.DisplayRange then
                DrawText3D(coords.x, coords.y, coords.z + 0.5, text)
            end
        end
    end)
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 370
        DrawRect(_x, _y + 0.0150, 0.015 + factor, 0.03, 0, 0, 0, 75)
    end
end

function NotifyPlayer(msg)
    Framework.Functions.Notify(msg, "success")
end
