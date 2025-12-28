// Include part definitions, modify bframe_parts.scad to adjust measurements
use <bframe_parts.scad>;

/*
  Render Front Triangle:
  - Seat Tube
  - Bottom Bracket Tube
  - Top Tube
  - Bottom Tube
  - Head Tube
*/

// Seat Tube with Cuts
difference() {
    seat_tube();
    bb_tube(hollow=false);
}

// Bottom Bracket Tube (No Cuts)
bb_tube();

// Top Tube with Cuts
difference() {
    top_tube();
    seat_tube(hollow=false);
    head_tube(hollow=false);
}

// Bottom Tube with Cuts
difference() {
    bottom_tube();
    seat_tube(hollow=false);
    head_tube(hollow=false);
    bb_tube(hollow=false);
}

// Head Tube (No Cuts)
head_tube();

/*
  Render Rear Triangle:
  - Chainstay Right
  - Chainstay Left
  - Seatstay Right
  - Seatstay Left
  - Dropouts
  - Derailleur Hanger
*/

// Chainstay Right with Cuts
difference() {
    chainstay_right();
    seatstay_right(hollow=false);
    bb_tube(hollow=false);
	dropout_mount_r();
}

// Chainstay Left with Cuts
difference() {
    chainstay_left();
    seatstay_left(hollow=false);
    bb_tube(hollow=false);
	dropout_mount_l();
}

// Seatstay Right with Cuts
difference() {
    seatstay_right();
    chainstay_right(hollow=false);
    seat_tube(hollow=false);
	dropout_mount_r();
}

// Seatstay Left with Cuts
difference() {
    seatstay_left();
    chainstay_left(hollow=false);
    seat_tube(hollow=false);
	dropout_mount_l();
}

// Render Temporary Dropout "Mounts"

// Right Dropout "Mount"
dropout_mount_r();

// Left Dropout "Mount"
dropout_mount_l();
