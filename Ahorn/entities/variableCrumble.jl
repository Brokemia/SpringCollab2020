module SpringCollab2020VariableCrumbleBlock

using ..Ahorn, Maple

@mapdef Entity "SpringCollab2020/variableCrumbleBlock" VariableCrumbleBlock(x::Integer, y::Integer, width::Integer=Maple.defaultBlockWidth, texture::String="default",
    timer::Number=0.4, respawnTimer::Number=2.0)

const placements = Ahorn.PlacementDict(
    "Variable Crumble Blocks ($(uppercasefirst(texture))) (Spring Collab 2020)" => Ahorn.EntityPlacement(
        VariableCrumbleBlock,
        "rectangle",
        Dict{String, Any}(
            "texture" => texture
        )
    ) for texture in Maple.crumble_block_textures
)

Ahorn.editingOptions(entity::VariableCrumbleBlock) = Dict{String, Any}(
    "texture" => Maple.crumble_block_textures
)

Ahorn.minimumSize(entity::VariableCrumbleBlock) = 8, 0
Ahorn.resizable(entity::VariableCrumbleBlock) = true, false

function Ahorn.selection(entity::VariableCrumbleBlock)
    x, y = Ahorn.position(entity)
    width = Int(get(entity.data, "width", 8))

    return Ahorn.Rectangle(x, y, width, 8)
end

function Ahorn.render(ctx::Ahorn.Cairo.CairoContext, entity::VariableCrumbleBlock, room::Maple.Room)
    texture = get(entity.data, "texture", "default")
    texture = "objects/crumbleBlock/$texture"

    # Values need to be system specific integer
    x = Int(get(entity.data, "x", 0))
    y = Int(get(entity.data, "y", 0))

    width = Int(get(entity.data, "width", 8))
    tilesWidth = div(width, 8)

    Ahorn.Cairo.save(ctx)

    Ahorn.rectangle(ctx, 0, 0, width, 8)
    Ahorn.clip(ctx)

    for i in 0:ceil(Int, tilesWidth / 4)
        Ahorn.drawImage(ctx, texture, 32 * i, 0, 0, 0, 32, 8)
    end

    Ahorn.restore(ctx)
end

end
