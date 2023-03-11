--You can change the ExtraAnimations in quotations marks to whatever you want your mod to be called
local Isaacs_EsctasyMod = RegisterMod("Isaacs_Esctasy", 1)
local game = Game()







--[[
This is the additions by Blurb!!!!

]]

--Viagra
local Viagra = Isaac.GetItemIdByName("Viagra")
local ViagraDamage = 20

function Isaacs_EsctasyMod:EvaluateCache(player, cacheFlags)
    if cacheFlags & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
        local itemCount = player:GetCollectibleNum(Viagra)
        local damageToAdd = ViagraDamage * itemCount
        player.Damage = player.Damage + damageToAdd
    end
end
Isaacs_EsctasyMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Isaacs_EsctasyMod.EvaluateCache)

--Demonic Fleshlight
local ForFib = Isaac.GetItemIdByName("Demonic Fleshlight")

function Isaacs_EsctasyMod:FFuse(player, item)
    Isaac.Spawn(5, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK, Isaac.GetFreeNearPosition(player.Position, 40), Vector.Zero, player)
    player.TakeDamage(self, 2, 1, nil, 5)

    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end
Isaacs_EsctasyMod:AddCallback(ModCallbacks.MC_USE_ITEM, Isaacs_EsctasyMod.FFuse, ForFib)


local game = Game()
local sound = SFXManager()

if debug then -- reload mod if luadebug is enabled, fixes luamod
    package.loaded["scripts.stageapi.mod"] = false
end

require("scripts.stageapi.mod")

-- Documentation moved to doc.md

if not StageAPI then
    StageAPI = {}
end

local loadOrder = include("scripts.stageapi.loadOrder")

StageAPI.Enum = {}

for _, module in ipairs(loadOrder) do
    include(module)
end

StageAPI.LogMinor("Fully Loaded, loading dependent mods.")
StageAPI.MarkLoaded("StageAPI", "2.23", true, true)

StageAPI.Loaded = true
if StageAPI.ToCall then
    for _, fn in ipairs(StageAPI.ToCall) do
        fn()
    end
end


local function GardenOfEden()               -- This function will be called when the StageAPI loads
    local rooms = require("rooms.lua")
    local bossrooms = require("bossrooms.lua") -- This will be the file obtained from using STBProcessor

    local isMultiStage = false -- Can also pass false / true directly into GetStageConfig, this is just for show

    local stage = StageAPI.GetStageConfig("GardenOfEden", rooms, bossrooms, isMultiStage)
end

local START_FUNC = GardenOfEden             -- Defines the function that will be called when StageAPI loads

if StageAPI then START_FUNC()         -- Blob that, assuming the above code was implemented correctly, will ensure that your function is called when StageAPI loads.
else if not __stageAPIInit then
    __stageAPIInit = {}
end __stageAPIInit[#__stageAPIInit + 1] = START_FUNC
end


















































--[[
HOW THIS WORKS:
ExtraAnimations contains a list of player and its corresponding animations:

{
    SPECIFIC_TYPE = Isaac.GetPlayerType("PLAYER_ISAAC")
    ANIMATIONS = {
	--dont put anims here, go further down
        {PLAYER_ANIM = "player_fancy_animation", TYPE = 10, VARIANT = 1, SUBTYPE = nil, ENTITY_ANIM = "gaper_animation"}
	{PLAYER_ANIM = "player_fancy_animation", TYPE = 10, VARIANT = 0, SUBTYPE = nil, ENTITY_ANIM = "Frowninggaper_animation"}
    }
},

To make it work for vanilla characters you can use this enumeration: https://wofsauge.github.io/IsaacDocs/rep/enums/PlayerType.html

To make it work for modded characters, instead of putting PlayerType.SOMETHING you
put Isaac.GetPlayerType("nameOfPlayer") OR Isaac.GetPlayerType("nameOfPlayer", true) for the tainted version.
Make sure the "nameOfPlayer" is on quotation marks and it has to be the same as
the name in the players.xml (you can find it in the content folder of the mod you want to add)


Now, to add different animations you just add an entry Ato the ANIMATIONS list of the corresponding character:

{PLAYER_ANIM = "AnimationForThePlayer", TYPE = TypeOfTheEntityToCollide, VARIANT = Variant, SUBTYPE = Subtype, ENTITY_ANIM = "AnimationForTheEntity"}

    -PLAYER_ANIM: path to the anm2 file that has the animation the player will play 
    (you can set it to nil to make the player not play an animation)
    -TYPE: type of the entity the player has to collide with to play the animation.
    These work similarly to player types, so use this enumeration: https://wofsauge.github.io/IsaacDocs/rep/enums/EntityType.html
    -VARIANT: variant of the entity the player has to collide with. Similar to type, but 
    used to differentiate between variants of enemies (different types of gapers).
    The variants dont have enums so you'll have to find out which number corresponds to
    which variant, the debug console will tell you if you use the spawn command
    (You can set this to nil to make it work with any variant)
    -SUBTYPE: similar to variant, but used but even fewer entities, like different
    types of rotten gapers. (You can set this to nil to make it work with any subtype
    you'll want to keep it nil in most cases)
    -ENTITY_ANIM: path to the anm2 file that has the animation the entity will play 
    (you can set it to nil to make the entity not play an animation)

Notes about this:
    -The path of the anm2 has to go with quotation marks
    -nil has to be written like that, so no upper case and no quotation marks
    -The player and entity animations can be different in any way
	-You can name the anm2 however you want
    -The animation in the anm2 has to be called Idle (exactly like that)
    -Dont forget to turn off loop on the animation
	-You can delete and change all anm2 except for default.anm2


I put an example here to show how it works:
There are animation for 2 characters: isaac and maggy
    -Isaac has an animation for when he collides with a frowning gaper, which only the gaper will play
    -Isaac also has an animation for when he collides with a normal gaper, which only isaac will play

    -Maggy has an animation for when she collides with any type of gaper, they will both play different animations
    -Maggy also has an animation for when she collides with a normal beggar, only she will play it.
]]
local ExtraAnimations = {
    --Isaac
    {
	SPECIFIC_TYPE = PlayerType.PLAYER_ISAAC,
        ANIMATIONS = {
        
        {PLAYER_ANIM = "gfx/player_fancy_animation.anm2", TYPE = 10, VARIANT = 1, SUBTYPE = nil, ENTITY_ANIM = "gfx/gaper_animation.anm2"},
	{PLAYER_ANIM = "gfx/player_fancy_animation.anm2", TYPE = 10, VARIANT = 0, SUBTYPE = nil, ENTITY_ANIM = "gfx/Frowninggaper_animation.anm2"},
	{PLAYER_ANIM = "gfx/player_fancy_animation.anm2", TYPE = 12, VARIANT = 0, SUBTYPE = nil, ENTITY_ANIM = "gfx/Learning.anm2"},
	}
    },

    --Maggie
    {
        SPECIFIC_TYPE = PlayerType.PLAYER_LAZARUS,
        ANIMATIONS = {
            {PLAYER_ANIM = "gfx/player_fancy_animation.anm2", TYPE = 47, VARIANT = 0, SUBTYPE = nil, ENTITY_ANIM = "gfx/lazar.anm2"},
        }
    },
}


----------------------------------------------
--DONT CHANGE ANYTHING PAST THIS POINT
----------------------------------------------

local EXTRA_ANIMATION_ENTITY_VARIANT = Isaac.GetEntityVariantByName("Extra Animation Effect")

---@param player EntityPlayer
---@param entity Entity
---@param animation table
local function PlayCustomExtraAnimation(player, entity, animation)
    --Save frame count to sync both entities
    local currentFrameCount = game:GetFrameCount()

    --Set up both entities
    player.ControlsEnabled = false
    player.Velocity = Vector.Zero
    player:GetData().PreviousTargetFlag = player:GetEntityFlags() & EntityFlag.FLAG_NO_TARGET
    player:GetData().PreviousEntityCollisionClass = player.EntityCollisionClass
    player:GetData().IsPlayingExtraAnimation = true
    player:GetData().ExtraAnimationEntity = entity
    player:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
    player.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

    entity:GetData().PreviousEntityCollisionClass = entity.EntityCollisionClass
    entity:GetData().IsPlayingExtraAnimation = true
    entity:GetData().ExtraAnimationPlayer = player
    entity:GetData().ExtraAnimStartFrame = currentFrameCount
    entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    entity.Velocity = Vector.Zero

    --Spawn animations, only if they have their respective animation
    if animation.PLAYER_ANIM then
        player.Visible = false
        local playerExtraAnim = Isaac.Spawn(EntityType.ENTITY_EFFECT, EXTRA_ANIMATION_ENTITY_VARIANT, 0, player.Position, Vector.Zero, player)
        playerExtraAnim:GetSprite():Load(animation.PLAYER_ANIM, true)
        playerExtraAnim:GetSprite():Play("Idle")
        playerExtraAnim:GetData().ExtraAnimStartFrame = currentFrameCount
    end

    if animation.ENTITY_ANIM then
        entity.Visible = false
        local entityExtraAnim = Isaac.Spawn(EntityType.ENTITY_EFFECT, EXTRA_ANIMATION_ENTITY_VARIANT, 0, entity.Position, Vector.Zero, entity)
        entityExtraAnim:GetSprite():Load(animation.ENTITY_ANIM, true)
        entityExtraAnim:GetSprite():Play("Idle")
        entityExtraAnim:GetData().ExtraAnimStartFrame = currentFrameCount
    end
end


---@param parent Entity
local function EndCustomExtraAnimation(parent)
    local player
    local entity
    if parent:ToPlayer() then
        --If the parent is the player
        player = parent:ToPlayer()
        entity = player:GetData().ExtraAnimationEntity
    else
        --If the parent is the entity
        entity = parent
        player = entity:GetData().ExtraAnimationPlayer
    end

    player.ControlsEnabled = true
    player:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET)
    player:AddEntityFlags(player:GetData().PreviousTargetFlag)
    player.EntityCollisionClass = player:GetData().PreviousEntityCollisionClass
    player.Visible = true

    player:GetData().PreviousTargetFlag = nil
    player:GetData().PreviousEntityCollisionClass = nil
    player:GetData().IsPlayingExtraAnimation = nil
    player:GetData().ExtraAnimationEntity = nil
    player:GetData().ExtraAnimIFrames = 40

    entity.EntityCollisionClass = entity:GetData().PreviousEntityCollisionClass
    entity.Visible = true

    entity:GetData().PreviousTargetFlag = nil
    entity:GetData().PreviousEntityCollisionClass = nil
    entity:GetData().IsPlayingExtraAnimation = nil
    entity:GetData().ExtraAnimationPlayer = nil
    entity:GetData().ExtraAnimStartFrame = nil
end


---@param player EntityPlayer
---@param collider Entity
function Isaacs_EsctasyMod:OnPlayerCollision(player, collider)
    --If the player is already playing an animation or it has iFrames, skip
    if player:GetData().IsPlayingExtraAnimation or player:GetData().ExtraAnimIFrames then return end

    if not collider:HasEntityFlags(EntityFlag.FLAG_CHARM) then
        return
    end

    --If the collider is already playing an animation, skip
    if collider:GetData().IsPlayingExtraAnimation then return end

    --Get the animation list for this player
    local possibleAnimations
    for _, animations in ipairs(ExtraAnimations) do
        if player:GetPlayerType() == animations.SPECIFIC_TYPE then
            possibleAnimations = animations.ANIMATIONS
            break
        end
    end

    --If there is no animations, return
    if possibleAnimations == nil then return end

    for _, animation in ipairs(possibleAnimations) do
        if (not animation.TYPE or animation.TYPE == collider.Type) and
        (not animation.VARIANT or animation.VARIANT == collider.Variant) and
        (not animation.SUBTYPE or animation.SUBTYPE == collider.SubType) then
            PlayCustomExtraAnimation(player, collider, animation)
        end
    end
end

Isaacs_EsctasyMod:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, Isaacs_EsctasyMod.OnPlayerCollision)


function Isaacs_EsctasyMod:OnPlayerUpdate(player)
    if player:GetData().ExtraAnimIFrames then
        player:GetData().ExtraAnimIFrames = player:GetData().ExtraAnimIFrames - 1
        if player:GetData().ExtraAnimIFrames == 0 then
            player:GetData().ExtraAnimIFrames = nil
        end
    end
end

Isaacs_EsctasyMod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Isaacs_EsctasyMod.OnPlayerUpdate)


---@param effect EntityEffect
function Isaacs_EsctasyMod:EffectUpdate(effect)
    if effect:GetSprite():IsFinished("Idle") then
        --Remove the effect and store the animation start frame
        local extraAnimStartFrame = effect:GetData().ExtraAnimStartFrame
        effect.SpawnerEntity.Visible = true
        effect:Remove()

        --Check if this is the last animation
        local isThereMatchingAnimation = false
        for _, anim in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EXTRA_ANIMATION_ENTITY_VARIANT)) do
            if anim:GetData().ExtraAnimStartFrame == extraAnimStartFrame then
                isThereMatchingAnimation = true
            end
        end

        if not isThereMatchingAnimation then
            EndCustomExtraAnimation(effect.SpawnerEntity)
        end
    end
end

Isaacs_EsctasyMod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, Isaacs_EsctasyMod.EffectUpdate, EXTRA_ANIMATION_ENTITY_VARIANT)


function Isaacs_EsctasyMod:PreNPCUpdate(entity)
    --If the entity is playing an extra animation ignore its ai
    if entity:GetData().IsPlayingExtraAnimation then
        entity.Velocity = Vector.Zero
        return true
    end
end

Isaacs_EsctasyMod:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, Isaacs_EsctasyMod.PreNPCUpdate)


function Isaacs_EsctasyMod:OnPlayerDMG(player)
    if player:GetData().ExtraAnimIFrames then
        return false
    end
end

Isaacs_EsctasyMod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Isaacs_EsctasyMod.OnPlayerDMG, EntityType.ENTITY_PLAYER)


function Isaacs_EsctasyMod:OnEntityRemoval(entity)
    if not entity:GetData().IsPlayingExtraAnimation then return end

    local player = entity:GetData().ExtraAnimationPlayer

    player.ControlsEnabled = true
    player:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET)
    player:AddEntityFlags(player:GetData().PreviousTargetFlag)
    player.EntityCollisionClass = player:GetData().PreviousEntityCollisionClass
    player.Visible = true

    player:GetData().PreviousTargetFlag = nil
    player:GetData().PreviousEntityCollisionClass = nil
    player:GetData().IsPlayingExtraAnimation = nil
    player:GetData().ExtraAnimationEntity = nil

    for _, effect in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EXTRA_ANIMATION_ENTITY_VARIANT)) do
        if entity:GetData().ExtraAnimStartFrame == effect:GetData().ExtraAnimStartFrame then
            effect:Remove()
        end
    end
end

Isaacs_EsctasyMod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, Isaacs_EsctasyMod.OnEntityRemoval)


function Isaacs_EsctasyMod:OnNewRoom()
    --If there were any players playing an animation, reset them
    for i = 0, game:GetNumPlayers() - 1, 1 do
        local player = game:GetPlayer(i)

        if player:GetData().IsPlayingExtraAnimation then
            player.ControlsEnabled = true
            player:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET)
            player:AddEntityFlags(player:GetData().PreviousTargetFlag)
            player.EntityCollisionClass = player:GetData().PreviousEntityCollisionClass
            player.Visible = true

            player:GetData().PreviousTargetFlag = nil
            player:GetData().PreviousEntityCollisionClass = nil
            player:GetData().IsPlayingExtraAnimation = nil
            player:GetData().ExtraAnimationEntity = nil
        end

        if player:GetData().ExtraAnimIFrames then
            player:GetData().ExtraAnimIFrames = nil
        end
    end
end

Isaacs_EsctasyMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Isaacs_EsctasyMod.OnNewRoom)


function Isaacs_EsctasyMod:OnGameExit()
    for _, effect in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EXTRA_ANIMATION_ENTITY_VARIANT)) do
        effect:Remove()
    end
end
Isaacs_EsctasyMod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, Isaacs_EsctasyMod.OnGameExit)
