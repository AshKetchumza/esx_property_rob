Config = {}

Config.burglaryPlaces = {   
    [1] = {
        door = {Object = "v_ilev_fa_frontdoor", Coords = vector3(-14.36, -1441.58, 30.22), Frozen = true, Heading = 180.0},
        pos = { x = -14.36, y = -1441.58, z = 30.22, h = 180.0 },  -- Outside the house coords
        locked = true,
        animPos = { x = -14.18, y = -1441.69, z = 31.1, h = 2.58 },
        cops = 1   -- The animation position
    },

    [2] = {
        door = {Object = "v_ilev_trev_doorfront", Coords = vector3(-1150.14, -1521.71, 9.75), Frozen = true, Heading = 35.0},
        pos = { x = -1150.15, y = -1522.35, z = 10.63, h = 13.26 },  -- Outside the house coords
        locked = true,
        animPos = { x = -1150.32, y = -1522.34, z = 10.63, h = 39.39 },
        cops = 1   -- The animation position
    },
}

Items = {
    [1] = { name = 'Lottery Ticket', item = 'lotteryticket' },
    [2] = { name = 'Marijuana', item = 'marijuana' },
    [3] = { name = 'Weed', item = 'weed' },
    [4] = { name = 'Lock Pick', item = 'lockpick' }
}

Config.burglaryInside = {
    -- Ghetto    
    [1] = { x = -18.48, y = -1440.66, z = 31.1, item = Items[math.random(1,#Items)].item, amount = math.random(1,5)},
    [2] = { x = -12.49, y = -1435.14, z = 31.1, item = Items[math.random(1,#Items)].item, amount = math.random(1,5)},
    [3] = { x = -16.6, y = -1434.84, z = 31.1, item = Items[math.random(1,#Items)].item, amount = math.random(1,5)},
    [4] = { x = -18.35, y = -1432.21, z = 31.1, item = Items[math.random(1,#Items)].item, amount = math.random(1,5)},
    -- Beachy
    [5] = { x = -1149.75, y = -1512.75, z = 10.63, item = Items[math.random(1,#Items)].item, amount = math.random(1,5)},
    [6] = { x = -1147.63, y = -1511.03, z = 10.63, item = Items[math.random(1,#Items)].item, amount = math.random(1,5)},
    [7] = { x = -1145.46, y = -1514.49, z = 10.63, item = Items[math.random(1,#Items)].item, amount = math.random(1,5)},
    [8] = { x = -1152.37, y = -1518.94, z = 10.63, item = Items[math.random(1,#Items)].item, amount = math.random(1,5)},
    [9] = { x = -1158.38, y = -1518.26, z = 10.63, item = Items[math.random(1,#Items)].item, amount = math.random(1,5)},
}