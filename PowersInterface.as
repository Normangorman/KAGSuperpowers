#include "PowersCommon.as";

const SColor color_blue(0xFF0000FF);
const SColor color_red(0xFFFF0000);

void onRender(CRules@ this) {
    // Superpowers interface
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
    topLeftPtr.y += 20;
    for (int i=0; i < team0Blobs.length; i++) {
        CBlob@ blob = team0Blobs[i];
        DrawPlayerPowersText(blob, topLeftPtr);
        topLeftPtr.y += 8;
    }

    topLeftPtr.y += 12;

    for (int i=0; i < team1Blobs.length; i++) {
        CBlob@ blob = team1Blobs[i];
        DrawPlayerPowersText(blob, topLeftPtr);
        topLeftPtr.y += 8;
    }

    topLeftPtr.y += 12;

    for (int i=0; i < otherBlobs.length; i++) {
        CBlob@ blob = otherBlobs[i];
        DrawPlayerPowersText(blob, topLeftPtr);
        topLeftPtr.y += 8;
    }
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
