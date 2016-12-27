#include "PowersCommon.as";

const SColor color_blue(0xFF0000FF);
const SColor color_red(0xFFFF0000);
const int LINE_SPACING = 14;
const int INTER_TEAM_SPACING = 12;

const string[] TIPS = {
    "The Bounce power makes you immune to fall damage.",
    "The Drain power drains the health of enemies near you.",
    "The Feather power makes you very light - try shield gliding!",
    "The Fire Lord power burns things around you and enemies you touch.",
    "To use The Force, aim your mouse at something and press E.",
    "The Ghost power allows you to move through objects.",
    "The Midas power makes you very rich!",
    "The Monkey power allows you to climb walls and ceilings.",
    "The Quick Attack power increases your slashing speed.",
    "The Speed power makes you move much faster.",
    "The Strength power makes your attacks stronger and allows you to damage stone blocks.",
    "The Triple Jump power lets you jump 3 times.",
    "The Vampirism power makes your attacks heals you."
};

string tip = "";

void onInit(CRules@ this) {
    ResetTip();
}

void onRestart(CRules@ this) {
    ResetTip();
}

void onRender(CRules@ this) {
    DrawTips(this);
    CBlob@[] playerBlobs;
    getBlobsByTag("player", playerBlobs);

    // Sort blobs by team
    CBlob@[] team0Blobs;
    CBlob@[] team1Blobs;
    CBlob@[] otherBlobs;
    for (int i=0; i < playerBlobs.length; i++) {
        CBlob@ blob = playerBlobs[i];
        if (blob.getPlayer() is null) continue;

        if (blob.getTeamNum() == 0) {
            InsertPlayerBlobIntoTeamArray(blob, team0Blobs);
        }
        else if (blob.getTeamNum() == 1) {
            InsertPlayerBlobIntoTeamArray(blob, team1Blobs);
        }
        else {
            InsertPlayerBlobIntoTeamArray(blob, otherBlobs);
        }
    }

    // Draw player powers text one by one
    Vec2f topLeftPtr(8,200);
    GUI::SetFont("menu");
    GUI::DrawText("SUPERPOWERS", topLeftPtr, color_white);
    topLeftPtr.y += LINE_SPACING + INTER_TEAM_SPACING;
    for (int i=0; i < team0Blobs.length; i++) {
        CBlob@ blob = team0Blobs[i];
        DrawPlayerPowersText(blob, topLeftPtr);
        topLeftPtr.y += LINE_SPACING;
    }

    topLeftPtr.y += INTER_TEAM_SPACING;

    for (int i=0; i < team1Blobs.length; i++) {
        CBlob@ blob = team1Blobs[i];
        DrawPlayerPowersText(blob, topLeftPtr);
        topLeftPtr.y += LINE_SPACING;
    }

    topLeftPtr.y += INTER_TEAM_SPACING;

    for (int i=0; i < otherBlobs.length; i++) {
        CBlob@ blob = otherBlobs[i];
        DrawPlayerPowersText(blob, topLeftPtr);
        topLeftPtr.y += LINE_SPACING;
    }
}

void ResetTip() {
    tip = TIPS[XORRandom(TIPS.length)];
}

void DrawTips(CRules@ this) {
    if (tip == "") return;
    Vec2f topLeft(16,500);
    Vec2f dims(180, 30);
    GUI::SetFont("menu");
    GUI::DrawText(tip, topLeft, topLeft+dims, color_black, false, false, true);
}

void InsertPlayerBlobIntoTeamArray(CBlob@ blob, CBlob@[]@ teamArray) {
    int ix=0;
    for (; ix < teamArray.length; ix++) {
        string otherUsername = teamArray[ix].getPlayer().getUsername();
        string blobUsername = blob.getPlayer().getUsername();
        if (otherUsername > blobUsername)
            break;
    }
    teamArray.insertAt(ix, blob);
}

void DrawPlayerPowersText(CBlob@ blob, Vec2f topLeft) {
    string powInfo = blob.getPlayer().getUsername() + ": ";
    bool firstPower = true; // for separating commas to work
    for (u8 pow=Powers::BEGIN+1; pow < Powers::END; pow++) {
        if (hasPower(blob, pow)) {
            if (!firstPower) {
                powInfo += ", ";
            }
            else {
                firstPower = false;
            }
            powInfo += getPowerName(pow);
        }
    }

    SColor textColor;
    if (blob.getTeamNum() == 0) textColor = color_blue;
    else if (blob.getTeamNum() == 1) textColor = color_red;
    else textColor = color_white;

    GUI::DrawText(powInfo, topLeft, textColor);
}
