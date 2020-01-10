Config = {}

Config.PoliceNotiChance = 100  
Config.ShowMapBlip = true
Config.ShowPawnShopBlip = true

Config.PawnShops = {
    [1] = { 
        pos = { x = -1459.55, y = -414.42, z = 35.72 }
     }
}

Config.Properties = {   
    [1] = {
        door = {obj = "v_ilev_fa_frontdoor", coords = vector3(-14.36, -1441.58, 30.22), locked = true, heading = 180.0},
        pos = { x = -14.36, y = -1441.58, z = 30.22, h = 180.0 },
        locked = true,
        animPos = { x = -14.18, y = -1441.69, z = 31.1, h = 2.58 },
        cops = 1
    },

    [2] = {
        door = {obj = "v_ilev_trev_doorfront", coords = vector3(-1150.14, -1521.71, 9.75), locked = true, heading = 35.0},
        pos = { x = -1150.15, y = -1522.35, z = 10.63, h = 13.26 },
        locked = true,
        animPos = { x = -1150.32, y = -1522.34, z = 10.63, h = 39.39 },
        cops = 1
    },
}

Config.Items = {    
    ['watch'] = { name = 'Watch', item = 'watch', price = 3250 },
    ['diamondring'] = { name = 'Diamond Ring', item = 'diamondring', price = 5500 },
    ['laptop'] = { name = 'Laptop', item = 'laptop', price = 2000 },
    ['camera'] = { name = 'Camera', item = 'camera', price = 1500 },
    ['ipad'] = { name = 'iPad', item = 'ipad', price = 1200 }
}

Config.burglaryInside = {
    -- Ghetto    
    [1] = { x = -18.48, y = -1440.66, z = 31.1, item = 'watch', amount = 1},
    [2] = { x = -12.49, y = -1435.14, z = 31.1, item = 'ipad', amount = 1},
    [3] = { x = -16.6, y = -1434.84, z = 31.1, item = 'camera', amount = 1},
    [4] = { x = -18.35, y = -1432.21, z = 31.1, item = 'diamondring', amount = 1},
    -- Beachy
    [5] = { x = -1149.75, y = -1512.75, z = 10.63, item = 'diamondring', amount = 1},
    [6] = { x = -1147.63, y = -1511.03, z = 10.63, item = 'watch', amount = 1},
    [7] = { x = -1145.46, y = -1514.49, z = 10.63, item = 'camera', amount = 1},
    [8] = { x = -1152.37, y = -1518.94, z = 10.63, item = 'ipad', amount = 1},
    [9] = { x = -1158.38, y = -1518.26, z = 10.63, item = 'laptop', amount = 1},
}