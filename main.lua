local mod = RegisterMod("Isaacs_Esctasy", 1)
local Viagra = Isaac.GetItemIdByName("Viagra")
local ViagraDamage = 20


function mod:EvaluateCache(player, cacheFlags)
    if cacheFlags & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
        local itemCount = player:GetCollectibleNum(Viagra)
        local damageToAdd = ViagraDamage * itemCount
        player.Damage = player.Damage + damageToAdd
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EvaluateCache)


local ForFib = Isaac.GetItemIdByName("Demonic Fleshlight")

function mod:FFuse(player, item)
    Isaac.Spawn(5, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK, Isaac.GetFreeNearPosition(player.Position, 40), Vector.Zero, player)
    player.TakeDamage(self, 2, 1, nil, 5)

    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.FFuse, ForFib)