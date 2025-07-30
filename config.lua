Config = {}

Config.Framework = 'auto' -- 'qb', 'esx' o 'auto'
Config.DefaultLanguage = 'es'

Config.LocaleSettings = {
    Locale = 'es',
    Languages = {
        ['en'] = {
            soda_machine = "Soda Machine",
            coffee_machine = "Coffee Machine",
            purchase_success = "You purchased a {{item}}",
            select_payment = "Select payment method",
            pay_cash = "Pay with cash",
            pay_bank = "Pay with bank",
            select_to_buy = "Select to buy",
            buy_from = "Buy from {{machine}}",
            not_enough_money = "You don't have enough money"
        },
        ['es'] = {
            soda_machine = "Máquina de Sodas",
            coffee_machine = "Máquina de Café",
            purchase_success = "Compraste {{item}}",
            select_payment = "Seleccionar método de pago",
            pay_cash = "Pagar en efectivo",
            pay_bank = "Pagar con banco",
            select_to_buy = "Selecciona para comprar",
            buy_from = "Comprar en {{machine}}",
            not_enough_money = "No tienes suficiente dinero"
        }
    }
}

Config.Machines = {
    ["prop_vend_soda_01"] = {
        label = "soda_machine",
        items = {
            { name = "water", label = "water", price = 5 },
            { name = "cola", label = "cola", price = 5 },
        }
    },
    ["prop_vend_soda_02"] = {
        label = "soda_machine",
        items = {
            { name = "water", label = "water", price = 5 },
            { name = "cola", label = "cola", price = 5 },
        }
    },
    ["prop_vend_coffe_01"] = {
        label = "coffee_machine",
        items = {
            { name = "coffee", label = "coffee", price = 7 },
            { name = "cappuccino", label = "cappuccino", price = 9 },
        }
    }
}