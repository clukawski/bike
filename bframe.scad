// Define bike frame properties, and render parts with intersection cuts
//
// This file contains 2.5-ish sections:
// - Material / Part Definitions
// - Rendering Front Triangle Parts / Cuts
// - Rendering Rear Triangle Parts / Cuts

// Include part modules for rendering
use <bframe_parts.scad>;

/*
  Define Material / Part Constraints:
  - Material Source (Link / Product Code)
  - Part Outer Radius (or_*)
  - Part Inner Radius (ir_*)
  - Part Length (len_*)
  - Rotations (rot_*)
  - Translations / Offsets (trans_* / offset_*)
  - Curve Offsets for Stays / Curved Parts (curve_offset_*)
*/

// Seat Tube
//
// Raw Material Dimensions
//
// McMaster-Carr 89955K929
len_seat=564;
or_seat=14.2875;
ir_seat=13.0429;

// Bottom Bracket Tube
//
// Raw Material Dimensions
//
// Paragon Machineworks Steel Threaded BB Shell
// - https://www.paragonmachineworks.com/bottom-bracket-shells/steel/steel-threaded-bb-shell-1-562-od.html
len_bb=73;
rot_bb=[0,90,0];
offset_bb_x=-len_bb/2;
trans_bb=[offset_bb_x,0,0];
or_bb=19.8374;
ir_bb=17.5895;

// Top Tube with Cuts
//
// Raw Material Dimensions
//
// McMaster-Carr 89955K929
len_top=640;
rot_top=[99,0,0];
trans_top=[0,0,520];
or_top=14.2875;
ir_top=13.0429;

// Bottom Tube
//
// Raw Material Dimensions
//
// McMaster-Carr 89955K919
len_bottom=720;
or_bottom=14.2875;
ir_bottom=13.3985;
rot_bottom=[61,0,0];

// Head Tube
//
// Raw Material Dimensions
//
// McMaster-Carr 89955K689
len_head=130;
or_head=19.05;
ir_head=16.9418;
trans_head=[0,-len_top,320];

// Common Stay Values
or_stay=6.35;
ir_stay=4.8768;
offset_stay=170;
offset_dropout_mount_x_r=-74;
offset_dropout_mount_x_l=74;
offset_seatstay_dropout=40;

// Chainstay Right
//
// Raw Material Dimensions
//
// McMaster-Carr 89955K138
len_chainstay_r=470;
rot_chainstay_r=[110,0,-5];
trans_chainstay_r=[offset_dropout_mount_x_r,len_chainstay_r,offset_stay];
curve_offset_chainstay_r=-80;

// Chainstay Left
//
// Raw Material Dimensions
//
// McMaster-Carr 89955K138
len_chainstay_l=470;
rot_chainstay_l=[110,0,5];
trans_chainstay_l=[offset_dropout_mount_x_l,len_chainstay_l,offset_stay];
curve_offset_chainstay_l=80;

// Seatstay Right
//
// Raw Material Dimensions
//
// McMaster-Carr 89955K138
len_seatstay_r=510;
rot_seatstay_r=[60,-9,0];
trans_seatstay_r=[offset_dropout_mount_x_r,len_seatstay_r-offset_seatstay_dropout,offset_stay];
curve_offset_seatstay_r=-95;

// Seatstay Left
//
// Raw Material Dimensions
//
// McMaster-Carr 89955K138
len_seatstay_l=510;
rot_seatstay_l=[60,9,0];
trans_seatstay_l=[offset_dropout_mount_x_l,len_seatstay_l-offset_seatstay_dropout,offset_stay];
curve_offset_seatstay_l=95;

// Temporary Dropout "Mounts"
//
// 142x12 boost spacing HG freehub
//
// Example:
// - Shimano Deore XT FH-M8110-B 148mm Rear hub
//   - https://kstoerz.com/freespoke/hub/534
len_rear_hub=148;
// Generic 1" 4130 Round  Bar
or_dropout_mount=6.35;
len_dropout_mount=or_stay*2;
offset_dropout_mount_z=170;
trans_dropout_mount_r=[offset_dropout_mount_x_r,len_seatstay_r-offset_seatstay_dropout,offset_dropout_mount_z];
trans_dropout_mount_l=[offset_dropout_mount_x_l,len_seatstay_l-offset_seatstay_dropout,offset_dropout_mount_z];
rot_dropout_mount=[0,90,0];

/*
  Render Front Triangle:
  - Seat Tube
  - Bottom Bracket Tube
  - Top Tube
  - Bottom Tube
  - Head Tube
*/

// Render Bottom Bracket Tube (No Cuts)
bb_tube(trans_bb, rot_bb, or_bb, ir_bb, len_bb);

// Render Seat Tube with Cuts
difference() {
    seat_tube(or_seat, ir_seat, len_seat);
    bb_tube(trans_bb, rot_bb, or_bb, ir_bb, len_bb, hollow=false);
}

// Render Top Tube with Cuts
difference() {
    top_tube(trans_top, rot_top, or_top, ir_top, len_top);
    seat_tube(or_seat, ir_seat, len_seat, hollow=false);
    head_tube(trans_head, or_head, ir_head, len_head, hollow=false);
}

// Render Bottom Tube with Cuts
difference() {
    bottom_tube(rot_bottom, or_bottom, ir_bottom, len_bottom);
    seat_tube(hollow=false);
    head_tube(trans_head, or_head, ir_head, len_head, hollow=false);
    bb_tube(trans_bb, rot_bb, or_bb, ir_bb, len_bb, hollow=false);
}

// Render Head Tube (No Cuts)
head_tube(trans_head, or_head, ir_head, len_head);

/*
  Render Rear Triangle:
  - Chainstay Right
  - Chainstay Left
  - Seatstay Right
  - Seatstay Left
  - Dropouts
  - Derailleur Hanger
*/

// Render Chainstay Right with Cuts
difference() {
    stay(trans_chainstay_r, rot_chainstay_r, curve_offset_chainstay_r, or_stay, ir_stay, len_chainstay_r);
    stay(trans_seatstay_r, rot_seatstay_r, curve_offset_seatstay_r, or_stay, ir_stay, len_seatstay_r, hollow=false);
    bb_tube(trans_bb, rot_bb, or_bb, ir_bb, len_bb, hollow=false);
	dropout_mount(trans=trans_dropout_mount_r, rot=rot_dropout_mount, radius=or_dropout_mount, length=len_dropout_mount);
}

// Render Chainstay Left with Cuts
difference() {
    stay(trans_chainstay_l, rot_chainstay_l, curve_offset_chainstay_l, or_stay, ir_stay, len_chainstay_l);
    stay(trans_seatstay_l, rot_seatstay_l, curve_offset_seatstay_l, or_stay, ir_stay, len_seatstay_l, hollow=false);
    bb_tube(trans_bb, rot_bb, or_bb, ir_bb, len_bb, hollow=false);
	dropout_mount(trans=trans_dropout_mount_l, rot=rot_dropout_mount, radius=or_dropout_mount, length=len_dropout_mount);
}

// Render Seatstay Right with Cuts
difference() {
    stay(trans_seatstay_r, rot_seatstay_r, curve_offset_seatstay_r, or_stay, ir_stay, len_seatstay_r);
    stay(trans_chainstay_r, rot_chainstay_r, curve_offset_chainstay_r, or_stay, ir_stay, len_chainstay_r, hollow=false);
    bb_tube(trans_bb, rot_bb, or_bb, ir_bb, len_bb, hollow=false);
	dropout_mount(trans=trans_dropout_mount_r, rot=rot_dropout_mount, radius=or_dropout_mount, length=len_dropout_mount);
}

// Render Seatstay Left with Cuts
difference() {
    stay(trans_seatstay_l, rot_seatstay_l, curve_offset_seatstay_l, or_stay, ir_stay, len_seatstay_l);
    stay(trans_chainstay_l, rot_chainstay_l, curve_offset_chainstay_l, or_stay, ir_stay, len_chainstay_l, hollow=false);
    bb_tube(trans_bb, rot_bb, or_bb, ir_bb, len_bb, hollow=false);
	dropout_mount(trans=trans_dropout_mount_l, rot=rot_dropout_mount, radius=or_dropout_mount, length=len_dropout_mount);
}

// Render Temporary Dropout "Mounts"
//
// Right Dropout "Mount"
dropout_mount(trans=trans_dropout_mount_r, rot=rot_dropout_mount, radius=or_dropout_mount, length=len_dropout_mount);

// Render Temporary Dropout "Mounts"
//
// Left Dropout "Mount"
dropout_mount(trans=trans_dropout_mount_l, rot=rot_dropout_mount, radius=or_dropout_mount, length=len_dropout_mount);
