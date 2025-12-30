// Define bike frame properties, and render parts with intersection cuts
//
// This file contains 2.5-ish sections:
// - Material / Part Definitions
// - Rendering Front Triangle Parts / Cuts
// - Rendering Rear Triangle Parts / Cuts

// Include part modules for rendering
use <bframe_parts.scad>;

function bend_offset_a(angle_a, len_c)
    = (((len_c*sin(90-angle_a))/sin(90))*sin(angle_a))/sin(90-angle_a);
function bend_offset_b(angle_a, len_c)
    = ((len_c*sin(90-angle_a))/sin(90));

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

// Special values for curved parts
$fa=1;
$fs=0.5;

// Seat Tube
//
// Raw Material Dimensions
//
// McMaster-Carr 89955K929
len_seat=520;
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
len_top=620;
rot_top=[95,0,0];
trans_top=[0,0,450];
or_top=14.2875;
ir_top=13.0429;

// Bottom Tube
//
// Raw Material Dimensions
//
// McMaster-Carr 89955K919
len_bottom=710;
or_bottom=14.2875;
ir_bottom=13.3985;
rot_bottom=[60,0,0];

// Head Tube
//
// Raw Material Dimensions
//
// McMaster-Carr 89955K689
len_head=95;
or_head=19.05;
ir_head=16.9418;
trans_head=[0,-len_top,325];

// Common Stay Values
//
// Raw Material Dimensions
//
// McMaster-Carr 89955K138
or_stay=6.35;
ir_stay=4.8768;
offset_stay=170;
offset_dropout_mount_x_r=-74;
offset_dropout_mount_x_l=74;
offset_seatstay_dropout=45;

// Chainstays
bend_radius_chainstay=50.8;
bend_angle_chainstay=10;
len_chainstay=440;
len_chainstay_divisor=21;
// Angle Relative to Bottom Bracket Tube
angle_chainstay=20;

// Seatstays
bend_radius_seatstay=50.8;
bend_angle_seatstay=19;
len_seatstay=485;
len_seatstay_divisor=14;
len_seatstay_first_segment_multiplier=1.1;
// Angle Relative to Bottom Bracket Tube
angle_seatstay=31;
bend_positions_seatstay=[0.61,0.49];
or_mult_seatstay_seat_tube=2.1;

// Seatstay Right
//
// Raw Material Dimensions
//
// McMaster-Carr 89955K138
len_seatstay_r=500;
rot_seatstay_r=[60,-8,0];
trans_seatstay_r=[offset_dropout_mount_x_r,len_seatstay_r-offset_seatstay_dropout,offset_stay];
curve_offset_seatstay_r=-95;

// Seatstay Left
//
// Raw Material Dimensions
//
// McMaster-Carr 89955K138
len_seatstay_l=515;
rot_seatstay_l=[60,8,0];
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
// Generic 3/4" 4130 Round  Bar
or_dropout_mount=9.525;
len_dropout_mount=or_stay*2;
offset_dropout_mount_z=150;
trans_dropout_mount_r=[len_rear_hub/2,bend_offset_b(angle_chainstay, len_chainstay)+or_dropout_mount*1.1,bend_offset_a(angle_chainstay, len_chainstay)];
trans_dropout_mount_cut_r=[len_rear_hub/2,bend_offset_b(angle_chainstay, len_chainstay)+or_dropout_mount*1.1,bend_offset_a(angle_chainstay, len_chainstay)];
trans_dropout_mount_l=[-len_rear_hub/2,bend_offset_b(angle_chainstay, len_chainstay)+or_dropout_mount*1.1,bend_offset_a(angle_chainstay, len_chainstay)];
trans_dropout_mount_cut_l=[-len_rear_hub/2,bend_offset_b(angle_chainstay, len_chainstay)+or_dropout_mount*1.1,bend_offset_a(angle_chainstay, len_chainstay)];
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

module wall2D(thickness)
  difference()
  {
    offset(thickness)
      children(0);
    children(0);
  }
 
module elbowinator(angle, bendRadius, clipBounds=1000, convexity=4)
  intersection(convexity=convexity)
  {
    rotate_extrude(convexity=convexity)
      translate([bendRadius,0,0])
        children(0);
    linear_extrude(height=clipBounds, slices=2, center=true)   
      wedge2D(angle, clipBounds);
  }

module wedge2D(angle, r, nSides=3) 
  polygon(points=concat([[0,0]], [for(i=[0:nSides]) r*[cos(i/nSides*angle), sin(i/nSides*angle)]]), convexity=4);

module genstay(trans, rot, bend_radius, bend_angle, divisor, length, length_bb, outer_radius, inner_radius, outer_radius_bb, first_segment_multiplier=1, bends=[0.38,0.72], hollow=true) {

    rotate(rot) {
        offset_stay_total_x_r=(length_bb/2)-(divisor/2);
        offset_stay_total_y_r=outer_radius_bb/2;
        len_first_straight=length/divisor;
        length_first_offset=len_first_straight*first_segment_multiplier-len_first_straight;

        // First Segment
        translate([-offset_stay_total_x_r,offset_stay_total_y_r+bend_offset_a(bend_angle, bend_radius)-length_first_offset,0])
            tube_hollow([0,0,0], [-90,0,0], outer_radius, inner_radius, first_segment_multiplier*len_first_straight, hollow);

        // First Elbow
        translate([
          -offset_stay_total_x_r-bend_radius,
          offset_stay_total_y_r+bend_offset_a(bend_angle, bend_radius)+len_first_straight,
          0,
        ])
            rotate([0,0,0])
                elbowinator(angle=bend_angle, bendRadius=bend_radius)
                    wall2D(thickness=outer_radius-inner_radius)
                        circle(r=inner_radius);

        // Second Segment
        trans_second_straight=[
            -offset_stay_total_x_r-bend_radius+bend_offset_b(bend_angle, bend_radius),
            offset_stay_total_y_r+len_first_straight+bend_offset_a(bend_angle, bend_radius)*2,
            0,
        ];
        len_second_straight=len_first_straight*(divisor-(divisor*bends[0]));
        tube_hollow(trans_second_straight, [-90,0,bend_angle], outer_radius, inner_radius, len_second_straight, hollow);

        translate(trans) {
            // Second Elbow
            translate([
                -offset_stay_total_x_r-(bend_radius-bend_offset_b(bend_angle, bend_radius))-bend_offset_a(bend_angle, len_second_straight)+bend_radius,
                (offset_stay_total_y_r+len_first_straight+len_second_straight+bend_offset_a(bend_angle, bend_radius)*2),
                 0,
             ])
                rotate([0,180,bend_angle])
                    elbowinator(angle=bend_angle, bendRadius=bend_radius)
                        wall2D(thickness=outer_radius-inner_radius)
                        circle(r=inner_radius);

            // Third Segment
            trans_third_straight=[
                -offset_stay_total_x_r-(bend_radius-bend_offset_b(bend_angle, bend_radius))-bend_offset_a(bend_angle, len_second_straight),
                offset_stay_total_y_r+len_first_straight+len_second_straight+bend_offset_a(bend_angle, bend_radius)*2,
                0,
            ];
            len_third_straight=len_first_straight*(divisor-(divisor*bends[1]));
            tube_hollow(trans_third_straight, [-90,0,0], outer_radius, inner_radius, len_third_straight, hollow);
        }
    }
}

// Render Chainstay Right
genstay(
    [0,0,0],
	[20,0,0],
	bend_radius_chainstay,
	bend_angle_chainstay,
	len_chainstay_divisor,
	len_chainstay,
	len_bb,
    or_stay,
    ir_stay,
	or_bb);

// Render Chainstay Left
genstay(
    [0,0,0],
	[-20,180,0],
	bend_radius_chainstay,
	bend_angle_chainstay,
	len_chainstay_divisor,
	len_chainstay,
	len_bb,
    or_stay,
    ir_stay,
	or_bb);

translate([0,-or_top/or_mult_seatstay_seat_tube-(len_seatstay/len_seatstay_divisor*len_seatstay_first_segment_multiplier)/4,bend_offset_b(angle_seatstay, len_seatstay)])
    // Render Seatstay Right
    genstay(
        [-2.35,5,0],
        [-angle_seatstay,0,0],
//        [0,0,0],
        bend_radius_seatstay,
        bend_angle_seatstay,
        len_seatstay_divisor,
        len_seatstay,
        or_top*or_mult_seatstay_seat_tube,
        or_stay,
        ir_stay,
        or_top,
        len_seatstay_first_segment_multiplier,
        bend_positions_seatstay);

translate([0,-or_top/or_mult_seatstay_seat_tube-(len_seatstay/len_seatstay_divisor*len_seatstay_first_segment_multiplier)/4,bend_offset_b(angle_seatstay, len_seatstay-len_seatstay_first_segment_multiplier)])
    // Render seatstay Left
    genstay(
        [-2.35,5,0],
        [angle_seatstay,180,0],
        bend_radius_seatstay,
        bend_angle_seatstay,
        len_seatstay_divisor,
        len_seatstay,
        or_top*or_mult_seatstay_seat_tube,
        or_stay,
        ir_stay,
        or_top,
        len_seatstay_first_segment_multiplier,
        bend_positions_seatstay);

//// Render Chainstay Right with Cuts
//difference() {
//    stay(trans_chainstay_r, rot_chainstay_r, curve_offset_chainstay_r, or_stay, ir_stay, len_chainstay_r);
//    stay(trans_seatstay_r, rot_seatstay_r, curve_offset_seatstay_r, or_stay, ir_stay, len_seatstay_r, hollow=false);
//    bb_tube(trans_bb, rot_bb, or_bb, ir_bb, len_bb, hollow=false);
//	dropout_mount(trans=trans_dropout_mount_r, rot=rot_dropout_mount, radius=or_dropout_mount, length=len_dropout_mount);
//    seat_tube(hollow=false);
//}
//
//// Render Chainstay Left with Cuts
//difference() {
//    stay(trans_chainstay_l, rot_chainstay_l, curve_offset_chainstay_l, or_stay, ir_stay, len_chainstay_l);
//    stay(trans_seatstay_l, rot_seatstay_l, curve_offset_seatstay_l, or_stay, ir_stay, len_seatstay_l, hollow=false);
//    bb_tube(trans_bb, rot_bb, or_bb, ir_bb, len_bb, hollow=false);
//	dropout_mount(trans=trans_dropout_mount_l, rot=rot_dropout_mount, radius=or_dropout_mount, length=len_dropout_mount);
//    seat_tube(hollow=false);
//}

//// Render Seatstay Right with Cuts
//difference() {
//    stay(trans_seatstay_r, rot_seatstay_r, curve_offset_seatstay_r, or_stay, ir_stay, len_seatstay_r);
//    stay(trans_chainstay_r, rot_chainstay_r, curve_offset_chainstay_r, or_stay, ir_stay, len_chainstay_r, hollow=false);
//    bb_tube(trans_bb, rot_bb, or_bb, ir_bb, len_bb, hollow=false);
//	dropout_mount(trans=trans_dropout_mount_r, rot=rot_dropout_mount, radius=or_dropout_mount, length=len_dropout_mount);
//    seat_tube(hollow=false);
//}
//
//// Render Seatstay Left with Cuts
//difference() {
//    stay(trans_seatstay_l, rot_seatstay_l, curve_offset_seatstay_l, or_stay, ir_stay, len_seatstay_l);
//    stay(trans_chainstay_l, rot_chainstay_l, curve_offset_chainstay_l, or_stay, ir_stay, len_chainstay_l, hollow=false);
//    bb_tube(trans_bb, rot_bb, or_bb, ir_bb, len_bb, hollow=false);
//	dropout_mount(trans=trans_dropout_mount_l, rot=rot_dropout_mount, radius=or_dropout_mount, length=len_dropout_mount);
//    seat_tube(hollow=false);
//}

// Render Temporary Dropout "Mounts"
//
// Right Dropout "Mount"
difference() {
    dropout_mount(trans=trans_dropout_mount_r, rot=rot_dropout_mount, radius=or_dropout_mount, length=len_dropout_mount);
    dropout_mount(trans=trans_dropout_mount_cut_r, rot=rot_dropout_mount, radius=or_dropout_mount, length=len_dropout_mount/2);
}
// Render Temporary Dropout "Mounts"
//
// Left Dropout "Mount"
difference() {
    dropout_mount(trans=trans_dropout_mount_l, rot=rot_dropout_mount, radius=or_dropout_mount, length=len_dropout_mount);
    dropout_mount(trans=trans_dropout_mount_cut_l, rot=rot_dropout_mount, radius=or_dropout_mount, length=len_dropout_mount/2);
}
