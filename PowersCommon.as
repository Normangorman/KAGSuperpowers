#include "Logging.as";

namespace Powers {
    shared enum pows {
        BEGIN = 0, // as a marker for looping
        BOUNCE,
        STRENGTH,
        VAMPIRISM,
        DRAIN,
        SPEED,
        QUICK_ATTACK,
        MOUNTAIN,
        FEATHER,
        TRIPLE_JUMP,
        MONKEY,
        MIDAS,
        FIRE_LORD,
        FORCE,
        END
    }
}

string getPowerName(u8 pow) {
    switch(pow) {
        case Powers::BOUNCE: return "Bounce";
        case Powers::STRENGTH: return "Strength";
        case Powers::VAMPIRISM: return "Vampirism";
        case Powers::DRAIN: return "Drain";
        case Powers::SPEED: return "Speed";
        case Powers::QUICK_ATTACK: return "Quick Attack";
        case Powers::MOUNTAIN: return "Mountain";
        case Powers::FEATHER: return "Feather";
        case Powers::TRIPLE_JUMP: return "Triple Jump";
        case Powers::MONKEY: return "Monkey";
        case Powers::MIDAS: return "Midas";
        case Powers::FIRE_LORD: return "Fire Lord";
        case Powers::FORCE: return "The Force";
    }
    return "No Power";
}

string getPowerScriptName(u8 pow) {
    switch(pow) {
        case Powers::BOUNCE: return "PowerBounce.as";
        case Powers::STRENGTH: return "PowerStrength.as";
        case Powers::VAMPIRISM: return "PowerVampirism.as";
        case Powers::DRAIN: return "PowerDrain.as";
        case Powers::SPEED: return "PowerSpeed.as";
        case Powers::QUICK_ATTACK: return "PowerQuickAttack.as";
        case Powers::MOUNTAIN: return "PowerMountain.as";
        case Powers::FEATHER: return "PowerFeather.as";
        case Powers::TRIPLE_JUMP: return "PowerTripleJump.as";
        case Powers::MONKEY: return "PowerMonkey.as";
        case Powers::MIDAS: return "PowerMidas.as";
        case Powers::FIRE_LORD: return "PowerFireLord.as";
        case Powers::FORCE: return "PowerForce.as";
    }
    return "";
}

bool hasPower(CBlob@ blob, u8 pow) {
    return blob.hasTag(getPowerName(pow));
}

void givePower(CBlob@ blob, u8 pow) {
    log("givePower", "Assigning power " + getPowerName(pow) + " to " + blob.getName());
    if (!blob.hasCommandID("receive_power")) {
        log("givePower", "ERROR: Blob doesn't have receive_power command ID");
    }
    else {
        CBitStream params;
        params.write_u8(pow);
        blob.SendCommand(blob.getCommandID("receive_power"), params);
    }
}
