--
-- This script spawns space terminals at specified locations,
-- intended to be near shuttle ports or points of interest like force shrines.
--
-- The 'y' coordinate (vertical height) has been updated with precise values
-- from the provided shrine data.
--

space_terminal_spawner = ScreenPlay:new {
    numberOfActs = 1,
    questString = "space_terminal_spawner",
    states = {},
}

registerScreenPlay("space_terminal_spawner", true)

function space_terminal_spawner:start()
    -- The object template for the space terminal.
    local terminalTemplate = "object/tangible/terminal/terminal_space.iff"

    -- This table defines all the space terminals to be spawned.
    -- The coordinates are based on the provided shrine locations,
    -- with precise Y (height) values.
    local terminalSpawns = {
        -- Existing Spawns (from your example)
        { "dathomir", 5210, 78.5, -4056, 0, "-- The Village" },
        { "dantooine", 6910, 25, -4086, 0, "-- Janta Cave" },
        { "lok", -3633, 18, -6034, 0, "-- Janta Cave" },
		
		-- Corellia Shuttleport's
		{ "corellia", -321, 28.5, -4634, 180, "-- Corellia Shuttle B" },
		{ "corellia", -17, 28.5, -4402, 180, "-- Corellia Shuttle A" },
		{ "corellia", -6637, 330.5, -5913, 180, "-- Bela Vistal Shuttleport A" },
		{ "corellia", -6935, 330.5, -5544, 180, "-- Bela Vistal Shuttleport B" },
		{ "corellia", -5543, 16.5, -6053, 180, "-- Vreni Island Shuttleport" },
		{ "corellia", -5607, 21.5, -2782, 180, "-- Tyrena Shuttleport B" },
		{ "corellia", -4996, 21.5, -2381, 180, "-- Tyrena Shuttleport A" },
		{ "corellia", -3767, 86.5, 3241, 180, "-- Kor Vella Shuttleport" },
		{ "corellia", 3078, 280.5, 5001, 0, "-- Doaba Guerfel Shuttleport" },
		
		--Talus Shuttleports
		{ "talus", 691, 6.5, -3048, 180, "-- Dearic Shuttleport" },
		{ "talus", 4327, 10.5, 5439, 180, "-- Nashal Shuttleport" },

        -- Force Shrine Spawns (Precise Y-Coordinates) --

        -- Corellia Shrines
        { "corellia", -7391, 236, -3938, 0, "-- Corellia Shrine" },
        { "corellia", 6300, 352, 6687, 0, "-- Tyrena Shrine" },
        { "corellia", -2384, 220, 6393, 0, "-- Doaba Guerfel Shrine" },
        { "corellia", -6907, 448, 4527, 0, "-- Kor Vella Shrine" },
        { "corellia", 6092, 342, -5578, 0, "-- Kor Vella Shrine" },

        -- Dantooine Shrines
        { "dantooine", -1814, 9, -6202, 0, "-- Dantooine Shrine" },
        { "dantooine", -6999, 11, -5269, 0, "-- Dantooine Pirate Outpost Shrine" },
        { "dantooine", 2638, 11, -1541, 0, "-- Dantooine Imperial Outpost Shrine" },
        { "dantooine", -6173, 35, 4120, 0, "-- Dantooine Pirate Outpost Shrine" },
        { "dantooine", 2163, 161, 7548, 0, "-- Dantooine Mining Outpost Shrine" },

        -- Dathomir Shrines
        { "dathomir", 3087, 125, 4887, 0, "-- Dathomir Shrine" },
        { "dathomir", 1654, 103, -5765, 0, "-- Dathomir Trade Outpost Shrine" },
        { "dathomir", -4961, 130, -3493, 0, "-- Dathomir Science Outpost Shrine" },
        { "dathomir", -4148, 119, 5926, 0, "-- Dathomir Science Outpost Shrine" },
        { "dathomir", 5570, 99, -1514, 0, "-- Dathomir Trade Outpost Shrine" },

        -- Endor Shrines
        { "endor", 670, 205, 5548, 0, "-- Endor Shrine" },
        { "endor", -5055, 201, -1703, 0, "-- Endor Smuggler Outpost Shrine" },
        { "endor", -5627, 400, 4813, 0, "-- Endor Smuggler Outpost Shrine" },
        { "endor", 5116, 18, 1923, 0, "-- Endor Smuggler Outpost Shrine" },
        { "endor", -3870, 0, -4467, 0, "-- Endor Research Outpost Shrine" },

        -- Lok Shrines
        { "lok", -2132, 106, 5938, 0, "-- Lok Shrine" },
        { "lok", 5455, 17, 3805, 0, "-- Nym's Stronghold Shrine" },
        { "lok", -5806, 34, 1977, 0, "-- Nym's Stronghold Shrine" },
        { "lok", 4978, 115, -5674, 0, "-- Nym's Stronghold Shrine" },
        { "lok", -3641, 17, -6030, 0, "-- Nym's Stronghold Shrine" },

        -- Naboo Shrines
        { "naboo", 2377, 292, -473, 0, "-- Naboo Shrine" },
        { "naboo", 7182, 331, -234, 0, "-- Dee'ja Peak Shrine" },
        { "naboo", -6859, 475, -1937, 0, "-- Moenia Shrine" },
        { "naboo", -2582, 4, -6184, 0, "-- Theed Shrine" },

        -- Rori Shrines
        { "rori", -4496, 180, -7531, 0, "-- Rori Shrine" },
        { "rori", 307, 81, -978, 0, "-- Narmle Shrine" },
        { "rori", 6854, 85, -1221, 0, "-- Narmle Shrine" },
        { "rori", -926, 84, 6046, 0, "-- Rori Rebel Outpost Shrine" },
        { "rori", -6375, 75, 6403, 0, "-- Restuss Shrine" },

        -- Talus Shrines
        { "talus", -5785, 226, 4478, 0, "-- Talus Shrine" },
        { "talus", 318, 13, 5842, 0, "-- Talus Imperial Outpost Shrine" },
        { "talus", -5494, 106, -3241, 0, "-- Nashal Shrine" },
        { "talus", 5760, 654, -5208, 0, "-- Dearic Shrine" },

        -- Tatooine Shrines
        { "tatooine", 5958, 155, -5685, 0, "-- Tatooine Shrine" },
        { "tatooine", -3622, 248, 5280, 0, "-- Mos Eisley Shrine" },
        { "tatooine", 5264, 188, 113, 0, "-- Mos Espa Shrine" },
        { "tatooine", -6505, 73, -3667, 0, "-- Mos Entha Shrine" },
        { "tatooine", 5632, 194, 6015, 0, "-- Bestine Shrine" },

        -- Yavin IV Shrines
        { "yavin4", 2389, 80, -4934, 0, "-- Yavin IV Shrine" },
        { "yavin4", -4585, 588, -3761, 0, "-- Yavin Imperial Base Shrine" },
        { "yavin4", -3362, 236, 6914, 0, "-- Yavin Labor Outpost Shrine" },
        { "yavin4", 6455, 18, 6423, 0, "-- Yavin Mining Outpost Shrine" },
    }

    -- Loop through the table and spawn each terminal.
    for i, spawnData in ipairs(terminalSpawns) do
        local planet = spawnData[1]
        local x = spawnData[2]
        local y = spawnData[3] -- This is the Z-coordinate (height) in game terms
        local z = spawnData[4] -- This is the Y-coordinate in game terms
        local heading = spawnData[5]
        
        -- Use spawnSceneObject for static objects like terminals.
        spawnSceneObject(planet, terminalTemplate, x, y, z, 0, heading)
    end
end
