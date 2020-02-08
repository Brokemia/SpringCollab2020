module SpringCollab2020GroupedTriggerSpikes

using ..Ahorn, Maple

@mapdef Entity "SpringCollab2020/GroupedTriggerSpikesUp" GroupedTriggerSpikesUp(x::Integer, y::Integer, width::Integer=Maple.defaultSpikeWidth, type::String="default")
@mapdef Entity "SpringCollab2020/GroupedTriggerSpikesDown" GroupedTriggerSpikesDown(x::Integer, y::Integer, width::Integer=Maple.defaultSpikeWidth, type::String="default")
@mapdef Entity "SpringCollab2020/GroupedTriggerSpikesLeft" GroupedTriggerSpikesLeft(x::Integer, y::Integer, height::Integer=Maple.defaultSpikeHeight, type::String="default")
@mapdef Entity "SpringCollab2020/GroupedTriggerSpikesRight" GroupedTriggerSpikesRight(x::Integer, y::Integer, height::Integer=Maple.defaultSpikeHeight, type::String="default")

const placements = Ahorn.PlacementDict()

groupedTriggerSpikes = Dict{String, Type}(
    "up" => GroupedTriggerSpikesUp,
    "down" => GroupedTriggerSpikesDown,
    "left" => GroupedTriggerSpikesLeft,
    "right" => GroupedTriggerSpikesRight
)

groupedTriggerSpikesUnion = Union{GroupedTriggerSpikesUp, GroupedTriggerSpikesDown, GroupedTriggerSpikesLeft, GroupedTriggerSpikesRight}

for variant in Maple.spike_types
    if variant != "tentacles"
        for (dir, entity) in groupedTriggerSpikes
            key = "Grouped Trigger Spikes ($(uppercasefirst(dir)), $(uppercasefirst(variant))) (Spring Collab 2020)"
            placements[key] = Ahorn.EntityPlacement(
                entity,
                "rectangle",
                Dict{String, Any}(
                    "type" => variant
                )
            )
        end
    end
end

Ahorn.editingOptions(entity::groupedTriggerSpikesUnion) = Dict{String, Any}(
    "type" => String[variant for variant in Maple.spike_types if variant != "tentacles"]
)

directions = Dict{String, String}(
    "SpringCollab2020/GroupedTriggerSpikesUp" => "up",
    "SpringCollab2020/GroupedTriggerSpikesDown" => "down",
    "SpringCollab2020/GroupedTriggerSpikesLeft" => "left",
    "SpringCollab2020/GroupedTriggerSpikesRight" => "right",
)

offsets = Dict{String, Tuple{Integer, Integer}}(
    "up" => (4, -4),
    "down" => (4, 4),
    "left" => (-4, 4),
    "right" => (4, 4),
)

groupedTriggerSpikesOffsets = Dict{String, Tuple{Integer, Integer}}(
    "up" => (0, 5),
    "down" => (0, -4),
    "left" => (5, 0),
    "right" => (-4, 0),
)

rotations = Dict{String, Number}(
    "up" => 0,
    "right" => pi / 2,
    "down" => pi,
    "left" => pi * 3 / 2
)

resizeDirections = Dict{String, Tuple{Bool, Bool}}(
    "up" => (true, false),
    "down" => (true, false),
    "left" => (false, true),
    "right" => (false, true),
)

function Ahorn.renderSelectedAbs(ctx::Ahorn.Cairo.CairoContext, entity::groupedTriggerSpikesUnion)
    direction = get(directions, entity.name, "up")
    theta = rotations[direction] - pi / 2

    width = Int(get(entity.data, "width", 0))
    height = Int(get(entity.data, "height", 0))

    x, y = Ahorn.position(entity)
    cx, cy = x + floor(Int, width / 2) - 8 * (direction == "left"), y + floor(Int, height / 2) - 8 * (direction == "up")

    Ahorn.drawArrow(ctx, cx, cy, cx + cos(theta) * 24, cy + sin(theta) * 24, Ahorn.colors.selection_selected_fc, headLength=6)
end

function Ahorn.selection(entity::groupedTriggerSpikesUnion)
    if haskey(directions, entity.name)
        x, y = Ahorn.position(entity)

        width = Int(get(entity.data, "width", 8))
        height = Int(get(entity.data, "height", 8))

        direction = get(directions, entity.name, "up")

        ox, oy = offsets[direction]

        return Ahorn.Rectangle(x + ox - 4, y + oy - 4, width, height)
    end
end

Ahorn.minimumSize(entity::groupedTriggerSpikesUnion) = 8, 8

function Ahorn.resizable(entity::groupedTriggerSpikesUnion)
    if haskey(directions, entity.name)
        direction = get(directions, entity.name, "up")

        return resizeDirections[direction]
    end
end

function Ahorn.render(ctx::Ahorn.Cairo.CairoContext, entity::groupedTriggerSpikesUnion)
    if haskey(directions, entity.name)
        variant = get(entity.data, "type", "default")
        direction = get(directions, entity.name, "up")
        groupedTriggerSpikesOffset = groupedTriggerSpikesOffsets[direction]

        width = get(entity.data, "width", 8)
        height = get(entity.data, "height", 8)

        for ox in 0:8:width - 8, oy in 0:8:height - 8
            drawX, drawY = (ox, oy) .+ offsets[direction] .+ groupedTriggerSpikesOffset
            Ahorn.drawSprite(ctx, "danger/spikes/$(variant)_$(direction)00", drawX, drawY)
        end
    end
end

end
