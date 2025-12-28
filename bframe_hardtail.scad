// Raw Material Dimensions
or_seat=14.2875;
ir_seat=13.0429;
or_top=14.2875;
ir_top=13.0429;
or_head=19.05;
ir_head=16.9418;
or_bb=19.8374;
ir_bb=17.5895;
or_bottom=14.2875;
ir_bottom=13.3985;
or_rear=7.9375;
ir_rear=6.4643;
// Part Sizes
len_seat=564;
len_top=640;
len_bb=73;
len_head=130;
len_bottom=720;
len_chainstay_r=430;
len_chainstay_l=430;
// Offsets
offset_top=520;
offset_head=320;
offset_bottom=0;
offset_chainstay=150;
// Rotations
rot_bb=[0,90,0];
rot_top=[99,0,0];
rot_bottom=[61,0,0];
rot_chainstay_r=[110,0,-1];
rot_chainstay_l=[110,0,1];
// Translations
trans_top=[0,0,offset_top];
trans_head=[0,-len_top,offset_head];
trans_bottom=[0,0,offset_bottom];
trans_chainstay_r=[-41,len_chainstay_r-10,offset_chainstay];
trans_chainstay_l=[41,len_chainstay_l-10,offset_chainstay];
// Trig (chainstays)
$fa = 1;
$fs = 0.5;
// Right Chainstay
curve_offset_chainstay_r=-22;
radius_chainstay_r = (curve_offset_chainstay_r^2 + len_chainstay_r^2) / 2 / curve_offset_chainstay_r;
angle_chainstay_r = atan(len_chainstay_r / (radius_chainstay_r - curve_offset_chainstay_r));
// Left Chainstay
curve_offset_chainstay_l=22;
radius_chainstay_l = (curve_offset_chainstay_l^2 + len_chainstay_l^2) / 2 / curve_offset_chainstay_l;
angle_chainstay_l = atan(len_chainstay_l / (radius_chainstay_l - curve_offset_chainstay_l));


// Seat Tube
difference() {
    // Raw Seat Tube
    difference() {
        cylinder(r=or_seat, h=len_seat);
        cylinder(r=ir_seat, h=len_seat);
    }
    // Seat Tube - Diff Total BB Tube Area
    rotate(rot_bb)
        cylinder(r=or_bb, h=len_bb, center=true);
}

// BB Tube
rotate(rot_bb)
    difference() {
        cylinder(r=or_bb, h=len_bb, center=true);
        cylinder(r=ir_bb, h=len_bb, center=true);
    }

// Top Tube
difference() {
    // Top Tube Diff Seat Tube
    difference () { 
        // Raw Top Tube
        translate(trans_top)
            rotate(rot_top)
                difference() {
                    cylinder(r=or_top, h=len_top);
                    cylinder(r=ir_top, h=len_top);
                }
        // Top Tube - Diff Total Seat Tube Area
        cylinder(r=or_seat, h=len_seat);
    }
    translate(trans_head)
        cylinder(r=or_head, h=len_head);
}

// Head Tube
translate(trans_head)
    difference() {
        cylinder(r=or_head, h=len_head);
        cylinder(r=ir_head, h=len_head);
    }

// Bottom Tube
difference() {
    difference() {
        translate(trans_bottom)
            rotate(rot_bottom)
                difference() {
                    cylinder(r=or_bottom, h=len_bottom);
                    cylinder(r=ir_bottom, h=len_bottom);
                }
        translate(trans_head)
            cylinder(r=or_head, h=len_head);
    }    // Seat Tube - Diff Total BB Tube Area
    rotate(rot_bb)
        cylinder(r=or_bb, h=len_bb, center=true);
}

// Chainstays
//
// Original Code:
// rotate([90, 0, 0]) translate([-radius_chainstay_l, 0, 0]) rotate_extrude(angle=angle_chainstay_l) translate([radius_chainstay_l, 0]) circle(or_rear);
//
// translate([curve_offset_chainstay_l/ -1, 0, 0]) cylinder(r=or_rear, h=len_chainstay_l);

// Chainstay Right
difference() {
    // Raw Chainstay Right
    translate(trans_chainstay_r)
        rotate(rot_chainstay_r)
            difference() {
                    rotate([90, 0, 0]) translate([-radius_chainstay_r, 0, 0]) rotate_extrude(angle=angle_chainstay_r) translate([radius_chainstay_r, 0]) circle(or_rear);
                    rotate([90, 0, 0]) translate([-radius_chainstay_r, 0, 0]) rotate_extrude(angle=angle_chainstay_r) translate([radius_chainstay_r, 0]) circle(ir_rear);
            }
    // Chainstay Left - Diff Total BB Tube Area
    rotate(rot_bb)
        cylinder(r=or_bb, h=len_bb, center=true);
}

// Chainstay Left
difference() {
    // Raw Chainstay Left
    translate(trans_chainstay_l)
        rotate(rot_chainstay_l)
            difference() {
                    rotate([90, 0, 0]) translate([-radius_chainstay_l, 0, 0]) rotate_extrude(angle=angle_chainstay_l) translate([radius_chainstay_l, 0]) circle(or_rear);
                    rotate([90, 0, 0]) translate([-radius_chainstay_l, 0, 0]) rotate_extrude(angle=angle_chainstay_l) translate([radius_chainstay_l, 0]) circle(ir_rear);
            }
    // Chainstay Left - Diff Total BB Tube Area
    rotate(rot_bb)
        cylinder(r=or_bb, h=len_bb, center=true);
}

