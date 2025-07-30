local function getFramework()
    if Config.Framework == 'qb' or (Config.Framework == 'auto' and GetResourceState('qb-core') == 'started') then
        return 'qb', exports['qb-core']:GetCoreObject()
    elseif Config.Framework == 'esx' or (Config.Framework == 'auto' and GetResourceState('es_extended') == 'started') then
        return 'esx', exports['es_extended']:getSharedObject()
    end
    return nil, nil
end

RegisterNetEvent('up_vending:buyItem')
AddEventHandler('up_vending:buyItem', function(machineModel, itemName, paymentMethod)
    local src = source
    local fwType, fw = getFramework()
    if not fw then return end

    local machine = Config.Machines[machineModel]
    if not machine then return end

    local itemData
    for _, item in ipairs(machine.items) do
        if item.name == itemName then
            itemData = item
            break
        end
    end
    if not itemData then return end

    if fwType == 'qb' then
        local Player = fw.Functions.GetPlayer(src)
        if Player then
            local paid = false
            if paymentMethod == 'cash' then
                paid = Player.Functions.RemoveMoney('cash', itemData.price, "vending-machine")
            elseif paymentMethod == 'bank' then
                paid = Player.Functions.RemoveMoney('bank', itemData.price, "vending-machine")
            end
            if paid then
                Player.Functions.AddItem(itemData.name, 1)
                local notifyMsg = Config.LocaleSettings.Languages[Config.DefaultLanguage].purchase_success:gsub('{{item}}', Config.LocaleSettings.Languages[Config.DefaultLanguage][itemData.label] or itemData.label)
                TriggerClientEvent('up_vending:notify', src, notifyMsg, 'success')
            else
                TriggerClientEvent('up_vending:notify', src, Config.LocaleSettings.Languages[Config.DefaultLanguage].not_enough_money, 'error')
            end
        end
    elseif fwType == 'esx' then
        local xPlayer = fw.GetPlayerFromId(src)
        if xPlayer then
            local hasEnough = false
            if paymentMethod == 'cash' and xPlayer.getMoney() >= itemData.price then
                xPlayer.removeMoney(itemData.price)
                hasEnough = true
            elseif paymentMethod == 'bank' and xPlayer.getBank() >= itemData.price then
                xPlayer.removeBank(itemData.price)
                hasEnough = true
            end
            if hasEnough then
                xPlayer.addInventoryItem(itemData.name, 1)
                local notifyMsg = Config.LocaleSettings.Languages[Config.DefaultLanguage].purchase_success:gsub('{{item}}', Config.LocaleSettings.Languages[Config.DefaultLanguage][itemData.label] or itemData.label)
                TriggerClientEvent('up_vending:notify', src, notifyMsg, 'success')
            else
                TriggerClientEvent('up_vending:notify', src, Config.LocaleSettings.Languages[Config.DefaultLanguage].not_enough_money, 'error')
            end
        end
    end
end)