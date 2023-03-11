-- MAKE SURE TO REPLACE ALL INSTANCES OF "Isaacs_EsctasyMod" WITH YOUR ACTUAL MOD REFERENCE

local json = require("json")
local dataCache = {}
local dataCacheBackup = {}
local shouldRestoreOnUse = false
local loadedData = false
local inRunButNotLoaded = true

---@class SaveData
---@field run RunSave @Data that is reset when the run ends. Using glowing hourglass restores data to the last backup.
---@field hourglassBackup table @The data that is restored when using glowing hourglass. Don't touch this.
---@field file FileSave @Data that is persistent between runs.

---@class RunSave
---@field persistent table @Things in this table will not be reset until the run ends.
---@field level table @Things in this table will not be reset until the level is changed.
---@field room table @Things in this table will not be reset until the room is changed.

---@class FileSave
---@field achievements table @Achievement related data.
---@field dss table @Dead Sea Scrolls related data.
---@field settings table @Setting related data.
---@field misc table @Miscellaneous stuff, you likely won't need to use this.

-- If you want to store default data, you must put it in this table.
---@return SaveData
function Isaacs_EsctasyMod.DefaultSave()
    return {
        ---@type RunSave
        run = {
            persistent = {},
            level = {},
            room = {},
        },
        ---@type RunSave
        hourglassBackup = {
            persistent = {},
            level = {},
            room = {},
        },
        ---@type FileSave
        file = {
            achievements = {},
            dss = {}, -- Dead Sea Scrolls supremacy
            settings = {},
            misc = {},
        },
    }
end

function Isaacs_EsctasyMod.ShallowCopy(tab)
    return {table.unpack(tab)}
end

function Isaacs_EsctasyMod.DeepCopy(tab)
    local copy = {}
    for k, v in pairs(tab) do
        if type(v) == 'table' then
            copy[k] = Isaacs_EsctasyMod.DeepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

---@return RunSave
function Isaacs_EsctasyMod.DefaultRunSave()
    return {
        persistent = {},
        level = {},
        room = {},
    }
end

---@return boolean
function Isaacs_EsctasyMod.IsDataLoaded()
    return loadedData
end

function Isaacs_EsctasyMod.PatchSaveTable(deposit, source)
    source = source or Isaacs_EsctasyMod.DefaultSave()

    for i, v in pairs(source) do
        if deposit[i] ~= nil then
            if type(v) == "table" then
                if type(deposit[i]) ~= "table" then
                    deposit[i] = {}
                end

                deposit[i] = Isaacs_EsctasyMod.PatchSaveTable(deposit[i], v)
            else
                deposit[i] = v
            end
        else
            if type(v) == "table" then
                if type(deposit[i]) ~= "table" then
                    deposit[i] = {}
                end

                deposit[i] = Isaacs_EsctasyMod.PatchSaveTable({}, v)
            else
                deposit[i] = v
            end
        end
    end

    return deposit
end

function Isaacs_EsctasyMod.SaveModData()
    if not loadedData then
        return
    end

    -- Save backup
    local backupData = Isaacs_EsctasyMod.DeepCopy(dataCacheBackup)
    dataCache.hourglassBackup = Isaacs_EsctasyMod.PatchSaveTable(backupData, Isaacs_EsctasyMod.DefaultRunSave())

    local finalData = Isaacs_EsctasyMod.DeepCopy(dataCache)
    finalData = Isaacs_EsctasyMod.PatchSaveTable(finalData, Isaacs_EsctasyMod.DefaultSave())

    Isaacs_EsctasyMod:SaveData(json.encode(finalData))
end

-- For glowing hourglass
function Isaacs_EsctasyMod.BackupModData()
    local copy = Isaacs_EsctasyMod.DeepCopy(dataCache)
    dataCacheBackup = copy.run
end

function Isaacs_EsctasyMod.RestoreModData()
    if shouldRestoreOnUse then
        dataCache.run = Isaacs_EsctasyMod.DeepCopy(dataCacheBackup)
        dataCache.run = Isaacs_EsctasyMod.PatchSaveTable(dataCache.run, Isaacs_EsctasyMod.DefaultRunSave())
    end
end

function Isaacs_EsctasyMod.LoadModData()
    if loadedData then
        return
    end

    local saveData = Isaacs_EsctasyMod.DefaultSave()

    if Isaacs_EsctasyMod:HasData() then
        local data = json.decode(Isaacs_EsctasyMod:LoadData())
        saveData = Isaacs_EsctasyMod.PatchSaveTable(data, Isaacs_EsctasyMod.DefaultSave())
    end

    dataCache = saveData
    dataCacheBackup = dataCache.hourglassBackup
    loadedData = true
    inRunButNotLoaded = false
end

---@return table?
function Isaacs_EsctasyMod.GetRunPersistentSave()
    if not loadedData then
        return
    end

    return dataCache.run.persistent
end

---@return table?
function Isaacs_EsctasyMod.GetLevelSave()
    if not loadedData then
        return
    end

    return dataCache.run.level
end

---@return table?
function Isaacs_EsctasyMod.GetRoomSave()
    if not loadedData then
        return
    end

    return dataCache.run.room
end

---@return table?
function Isaacs_EsctasyMod.GetFileSave()
    if not loadedData then
        return
    end

    return dataCache.file
end

local function ResetRunSave()
    dataCache.run.level = {}
    dataCache.run.room = {}
    dataCache.run.persistent = {}

    dataCache.hourglassBackup.level = {}
    dataCache.hourglassBackup.room = {}
    dataCache.hourglassBackup.persistent = {}

    Isaacs_EsctasyMod.SaveModData()
end

Isaacs_EsctasyMod:AddCallback(ModCallbacks.MC_USE_ITEM, Isaacs_EsctasyMod.RestoreModData, CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS)

Isaacs_EsctasyMod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function()
    local newGame = Game():GetFrameCount() == 0

    Isaacs_EsctasyMod.LoadModData()

    if newGame then
        ResetRunSave()
        shouldRestoreOnUse = false
    end
end)

Isaacs_EsctasyMod:AddCallback(ModCallbacks.MC_POST_UPDATE, function ()
    local game = Game()
    if game:GetFrameCount() > 0 then
        if not loadedData and inRunButNotLoaded then
            Isaacs_EsctasyMod.LoadModData()
            inRunButNotLoaded = false
        end
    end
end)

--- VERY IMPORTANT! REPLACE "YOUR_MOD_NAME" WITH THE STRING YOU USED WHEN REGISTERING THE MOD!!
--- NOT THE NAME IN YOUR METADATA.XML, BUT THE ONE YOU USED WHEN CALLING "RegisterMod()"
--- This handles the "luamod" command!
Isaacs_EsctasyMod:AddCallback(ModCallbacks.MC_PRE_MOD_UNLOAD, function(_, mod)
    if mod.Name == "YOUR_MOD_NAME" and Isaac.GetPlayer() ~= nil then
        if loadedData then
            Isaacs_EsctasyMod.SaveModData()
        end
    end
end)

Isaacs_EsctasyMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    dataCache.run.room = {}
    Isaacs_EsctasyMod.SaveModData()
    shouldRestoreOnUse = true
end)

Isaacs_EsctasyMod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    dataCache.run.level = {}
    Isaacs_EsctasyMod.SaveModData()
    shouldRestoreOnUse = true
end)

Isaacs_EsctasyMod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function(_, shouldSave)
    Isaacs_EsctasyMod.SaveModData()
    loadedData = false
    inRunButNotLoaded = false
    shouldRestoreOnUse = false
end)