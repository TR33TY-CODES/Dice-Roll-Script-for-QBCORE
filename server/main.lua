local Framework = nil

Citizen.CreateThread(function()
    Framework = exports['qb-core']:GetCoreObject()

    -- Wait for framework to be ready
    while Framework == nil do
        Citizen.Wait(0)
    end

    Framework.Functions.CreateUseableItem(Config.ItemName, function(source)
        local Player = Framework.Functions.GetPlayer(source)
        Player.Functions.RemoveItem(Config.ItemName, 1)
        TriggerClientEvent('ty-diceroll:client:RollDice', source)
    end)
end)

RegisterNetEvent('ty-diceroll:server:NotifyNearby')
AddEventHandler('ty-diceroll:server:NotifyNearby', function(coords, result)
    local players = Framework.Functions.GetPlayers()

    for _, playerId in ipairs(players) do
        local playerPed = GetPlayerPed(playerId)
        local playerCoords = GetEntityCoords(playerPed)
        local distance = #(coords - playerCoords)

        if distance <= Config.NotifyRange and playerId ~= source then
            TriggerClientEvent('Framework:Notify', playerId, string.format(Config.Locale.notify_nearby, result), "success")
        end
    end
end)

RegisterNetEvent('ty-diceroll:server:AddDiceBack')
AddEventHandler('ty-diceroll:server:AddDiceBack', function()
    local Player = Framework.Functions.GetPlayer(source)
    Player.Functions.AddItem(Config.ItemName, 1)
end)

RegisterNetEvent('ty-diceroll:server:Show3DText')
AddEventHandler('ty-diceroll:server:Show3DText', function(playerId, text)
    local players = Framework.Functions.GetPlayers()

    for _, id in ipairs(players) do
        TriggerClientEvent('ty-diceroll:client:Show3DText', id, playerId, text)
    end
end)
