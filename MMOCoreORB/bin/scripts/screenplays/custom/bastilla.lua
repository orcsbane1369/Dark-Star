-- File: MMOCoreORB\bin\scripts\screenplays\custom\bastilla.lua

-- 1. Bastila ScreenPlay Definition
bastilla = ScreenPlay:new {
    numberOfActs = 1,
    questString = "bastilla_task",
    states = {},
}

registerScreenPlay("bastilla", true) -- Registers the screenplay globally as "bastilla"

function bastilla:start()
    local spawnLocations = {
        { "corellia", -3271, 86, 3114, 35 }, -- Corellia coordinates
    }

    for i, location in ipairs(spawnLocations) do
        -- Spawn Bastila using the "bastilla_npc" creature template name.
        -- The conversation template for this spawn is linked in bastila_npc.lua (bastilla_conv).
        spawnMobile(location[1], "bastilla_npc", 1, location[2], location[3], location[4], location[5], 0)
    end
end


-- 2. Bastila's Conversation Handler
bastilla_convo_handler = Object:new {
    tstring = "myconversation2" -- Unique tstring
}

-- This is the single conversation handling function for bastilla_convo_handler
function bastilla_convo_handler:getNextConversationScreen(conversationTemplate, conversingPlayer, selectedOption)
    local creature = LuaCreatureObject(conversingPlayer)
    local convosession = creature:getConversationSession()
    local conversation = LuaConversationTemplate(conversationTemplate)

    if (conversation == nil) then
        return nil
    end

    local lastConversationScreen = nil
    if (convosession ~= nil) then
        local session = LuaConversationSession(convosession)
        if (session ~= nil) then
            lastConversationScreen = session:getLastConversationScreen()
        end
    end

    local nextConversationScreen = nil -- Initialize next screen

    -- If this is the initial interaction (no last screen)
    if (lastConversationScreen == nil) then
        return conversation:getInitialScreen()
    else
        local luaLastConversationScreen = LuaConversationScreen(lastConversationScreen)
        local optionLink = luaLastConversationScreen:getOptionLink(selectedOption)
	
        if (optionLink == "revan_spawn_screen") then
            -- Get player's object ID for quest status tracking
            local playerID = SceneObject(conversingPlayer):getObjectID()
            local revanSpawnedStatus = readData(playerID .. ":revan_spawned_for_quest") -- Checks custom data status

            if (revanSpawnedStatus ~= 1) then -- If Revan hasn't been spawned for this player yet
                local x = CreatureObject(conversingPlayer):getPositionX()
                local z = CreatureObject(conversingPlayer):getPositionZ()
                local y = CreatureObject(conversingPlayer):getPositionY()
                local planetName = SceneObject(conversingPlayer):getZoneName()

                local pRevan = spawnMobile(planetName, "revan", 1, x + 10, z, y + 10, 0, 0)
                CreatureObject(conversingPlayer):sendSystemMessage("You feel a powerful presence nearby...")

                -- NEW: Add item to Revan's inventory if spawn was successful
                if (pRevan ~= nil) then
                    local pRevanInventory = CreatureObject(pRevan):getSlottedObject("inventory")
                    if (pRevanInventory ~= nil) then
                        -- REPLACE WITH YOUR ACTUAL ITEM'S IFF PATH
                        giveItem(pRevanInventory, "object/weapon/melee/baton/baton_stun.iff", -1)
                        CreatureObject(conversingPlayer):sendSystemMessage("Revan spawned and received item: Stun Baton.")
                    else
                        CreatureObject(conversingPlayer):sendSystemMessage("Error: Revan's inventory not found after spawn.")
                    end
                else
                    CreatureObject(conversingPlayer):sendSystemMessage("Error: Revan failed to spawn.")
                end

                -- Set a flag that Revan has now been spawned for this player
                writeData(playerID .. ":revan_spawned_for_quest", 1)

                nextConversationScreen = conversation:getScreen("first_screen")
            else
                -- Revan has already spawned. Give a different dialogue or end conversation.
                CreatureObject(conversingPlayer):sendSystemMessage("You have already faced Revan. There is nothing more here for you.")
                nextConversationScreen = conversation:getScreen("revan_already_spawned") -- New screen needed, defined in bastilla_conv.lua
            end
        else
            nextConversationScreen = conversation:getScreen(optionLink)
        end
    end

    return nextConversationScreen
end

-- The runScreenHandlers function is not needed when getNextConversationScreen handles all logic.
-- It was likely causing an overwrite or confusion previously.
function bastilla_convo_handler:runScreenHandlers(conversationTemplate, conversingPlayer, conversingNPC, selectedOption, conversationScreen)
    return conversationScreen
end