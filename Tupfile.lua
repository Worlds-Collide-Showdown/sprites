
-- Generate uniform size minisprites

foreach_rule(
    "newsrc/minisprites/pokemon/gen6/*.png",
    {
        display="pad g6 minisprite %f",
        pad{w=40, h=30}
    },
    "build/gen6-minisprites-padded/%b"
)

-- PS spritesheet

rule(
    "ps-pokemon.sheet.mjs",
    {
        display="ps pokemon sheet",
        "node tools/sheet %f %o",
        compresspng{config="SPRITESHEET"}
    },
    "build/ps/pokemonicons-sheet.png"
)

-- TODO: reenable when trainers are moved
-- rule{
--     display="ps trainers sheet",
--     {"ps-trainers.sheet.mjs"},
--     {
--         "node tools/sheet %f %o",
--         compresspng{config="SPRITESHEET"}
--     },
--     {"build/ps/trainers-sheet.png"}
-- }

rule(
    "ps-items.sheet.mjs",
    {
        display="ps items sheet",
        "node tools/sheet %f %o",
        compresspng{config="SPRITESHEET"}
    },
    "build/ps/itemicons-sheet.png"
)

-- PS pokeball icons

local balls = {
    "src/noncanonical/ui/battle/Ball-Normal.png",
    "src/noncanonical/ui/battle/Ball-Sick.png",
    "src/noncanonical/ui/battle/Ball-Null.png",
}

rule(
    balls,
    {
        display="pokemonicons-pokeball-sheet",
        "convert -background transparent -gravity center -extent 40x30 %f +append %o",
        compresspng{config="SPRITESHEET"}
    },
    "build/ps/pokemonicons-pokeball-sheet.png"
)

-- Smogdex social images

for file in iglob("newsrc/models/*") do
    if tup.base(file):find("-b") or tup.base(file):find("-s") then
        goto continue
    end
    
    rule(
        file,
        {
            display="fbsprite %f",
            "tools/fbsprite.sh %f %o",
            compresspng{config="MODELS"}
        },
        "build/smogon/fbsprites/xy/%B.png"
    )

    rule(
        file,
        {
            display="twittersprite %f",
            "tools/twittersprite.sh %f %o",
            compresspng{config="MODELS"}
        },
        "build/smogon/twittersprites/xy/%B.png"
    )

    ::continue::
end


-- Trainers

-- TODO: reenable when trainers are moved
-- foreach_rule{
--     display="pad trainer %f",
--     {"src/canonical/trainers/*"},
--     {
--         pad{w=80, h=80},
--         compresspng{config="TRAINERS"}
--     },
--     {"build/padded-trainers/canonical/%b"}
-- }

-- Padded Dex

foreach_rule(
    "newsrc/dex/*",
    {
        display="pad dex %f",
        pad{w=120, h=120},
        compresspng{config="DEX"}
    },
    "build/padded-dex/%b"
)

-- Build missing CAP dex

local input = glob({"newsrc/sprites/gen5/*.gif", "newsrc/models/*.gif"}, {filter=function()
        return not ((expand("%B")):find("-b") or (expand("%B")):find("-s")) and not glob_matches("newsrc/dex/%B.png")
    end, key="%B"})

foreach_rule(
    input,
    {
        display="missing dex %B",
        "convert %f'[0]' -trim %o",
        "mogrify -background transparent -gravity center -resize '120x120>' -extent 120x120 %o",
        compresspng{config="DEX"}
    },
    "build/padded-dex/%B-missing.png"
)

