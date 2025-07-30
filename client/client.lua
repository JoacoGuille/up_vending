local framework = nil
local inUse = false

RegisterNetEvent('up_vending:notify')
AddEventHandler('up_vending:notify', function(message, type)
    if framework == 'qb' then
        TriggerEvent('QBCore:Notify', message, type)
    elseif framework == 'esx' then
        TriggerEvent('esx:showNotification', message)
    else
        BeginTextCommandThefeedPost('STRING')
        AddTextComponentSubstringPlayerName(message)
        EndTextCommandThefeedPostTicker(true, true)
    end
end)

function showNotification(msg, type)
    TriggerEvent('up_vending:notify', msg, type)
end

local function playPurchaseAnim(callback)
    inUse = true
    ExecuteCommand('e dispenser')
    Wait(3000) 
    ClearPedTasks(PlayerPedId())
    inUse = false
    if callback then callback() end
end

local function showPaymentOptions(itemData, model)
    lib.registerContext({
        id = 'payment_selection',
        title = Config.LocaleSettings.Languages[Config.DefaultLanguage].select_payment .. " - $" .. itemData.price,
        menu = 'vending_machine_menu',
        options = {
            {
                title = Config.LocaleSettings.Languages[Config.DefaultLanguage].pay_cash,
                icon = 'fas fa-money-bill-wave',
                event = 'up_vending:processPayment',
                args = {
                    model = model,
                    item = itemData.name,
                    method = 'cash'
                }
            },
            {
                title = Config.LocaleSettings.Languages[Config.DefaultLanguage].pay_bank,
                icon = 'fas fa-credit-card',
                event = 'up_vending:processPayment',
                args = {
                    model = model,
                    item = itemData.name,
                    method = 'bank'
                }
            }
        }
    })
    lib.showContext('payment_selection')
end

function OpenVendingMenu(modelHash)
    if inUse or not modelHash then return end

    local machine, modelName = nil, nil
    for k, v in pairs(Config.Machines) do
        if GetHashKey(k) == modelHash then
            machine = v
            modelName = k
            break
        end
    end
    if not machine then return end

    local options = {}
    for _, item in ipairs(machine.items) do
        table.insert(options, {
            title = string.format("%s - $%d", Config.LocaleSettings.Languages[Config.DefaultLanguage][item.label] or item.label, item.price),
            description = Config.LocaleSettings.Languages[Config.DefaultLanguage].select_to_buy,
            icon = 'fas fa-cart-shopping',
            onSelect = function()
                showPaymentOptions(item, modelName)
            end
        })
    end

    lib.registerContext({
        id = 'vending_machine_menu',
        title = Config.LocaleSettings.Languages[Config.DefaultLanguage][machine.label] or machine.label,
        options = options
    })

    lib.showContext('vending_machine_menu')
end

RegisterNetEvent('up_vending:processPayment', function(args)
    if not args or inUse then return end
    playPurchaseAnim(function()
        TriggerServerEvent('up_vending:buyItem', args.model, args.item, args.method)
    end)
end)

CreateThread(function()
    Wait(1000)
    
    if Config.Framework == 'qb' or (Config.Framework == 'auto' and GetResourceState('qb-core') == 'started') then
        framework = 'qb'
    elseif Config.Framework == 'esx' or (Config.Framework == 'auto' and GetResourceState('es_extended') == 'started') then
        framework = 'esx'
    end

    for modelName, data in pairs(Config.Machines) do
        local modelHash = GetHashKey(modelName)
        
        local options = {
            {
                name = 'vending_purchase',
                icon = 'fas fa-cart-shopping',
                label = Config.LocaleSettings.Languages[Config.DefaultLanguage].buy_from:gsub('{{machine}}', Config.LocaleSettings.Languages[Config.DefaultLanguage][data.label] or data.label),
                distance = 2.0,
                action = function()
                    OpenVendingMenu(modelHash)
                end,
                canInteract = function()
                    return not inUse
                end
            }
        }

        if GetResourceState('qb-target') == 'started' then
            exports['qb-target']:AddTargetModel(modelHash, {
                options = options,
                distance = 2.0
            })
        elseif GetResourceState('ox_target') == 'started' then
            exports.ox_target:addModel(modelHash, options)
        end
    end
end)