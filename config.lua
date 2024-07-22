Config = {}

Config.Framework = "QBCore" -- Set to "QBCore"
Config.ItemName = "dice" -- The item name for the dice

Config.Display3DTextEnabled = true -- Enable/Disable 3D Text Display
Config.DisplayTime = 5000 -- Time in milliseconds to display the 3D text
Config.DisplayRange = 5.0 -- Maximum distance to display 3D text

Config.NotifySelfEnabled = false -- Enable/Disable self notification
Config.NotifyNearbyEnabled = false -- Enable/Disable notification to nearby players  [NOT WORKING NOW, YOU CAN FIX IT YOURSELF OR WAIT FOR AN UPDATE ]
Config.NotifyRange = 5.0 -- Range to notify nearby players

Config.AllowMovementDuringAnimation = false -- Allow player movement during animation (true = upper body only, false = full body animation)

Config.Locale = {
    dice_roll = "You rolled the dice and got %d",
    notify_nearby = "A dice was rolled and landed on %d"
}
