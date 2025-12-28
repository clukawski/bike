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
len_seatstay_r=540;
len_seatstay_l=540;

// Offsets
offset_top=520;
offset_head=320;
offset_bottom=0;
offset_chainstay=150;
offset_seatstay=150;

// Rotations
rot_bb=[0,90,0];
rot_top=[99,0,0];
rot_bottom=[61,0,0];
rot_chainstay_r=[110,0,-1];
rot_chainstay_l=[110,0,1];
rot_seatstay_r=[50,0,0];
rot_seatstay_l=[50,0,0];

// Translations
trans_top=[0,0,offset_top];
trans_head=[0,-len_top,offset_head];
trans_bottom=[0,0,offset_bottom];
trans_chainstay_r=[-45,len_chainstay_r-10,offset_chainstay];
trans_chainstay_l=[45,len_chainstay_l-10,offset_chainstay];
trans_seatstay_r=[-45,len_seatstay_r-120,offset_seatstay];
trans_seatstay_l=[45,len_seatstay_l-120,offset_seatstay];

// Trig (chain / seat stays)
$fa = 1;
$fs = 0.5;

// Right Chainstay
curve_offset_chainstay_r=-26;
radius_chainstay_r = (curve_offset_chainstay_r^2 + len_chainstay_r^2) / 2 / curve_offset_chainstay_r;
angle_chainstay_r = atan(len_chainstay_r / (radius_chainstay_r - curve_offset_chainstay_r));

// Left Chainstay
curve_offset_chainstay_l=26;
radius_chainstay_l = (curve_offset_chainstay_l^2 + len_chainstay_l^2) / 2 / curve_offset_chainstay_l;
angle_chainstay_l = atan(len_chainstay_l / (radius_chainstay_l - curve_offset_chainstay_l));

// Right Seatstay
curve_offset_seatstay_r=-37;
radius_seatstay_r = (curve_offset_seatstay_r^2 + len_seatstay_r^2) / 2 / curve_offset_seatstay_r;
angle_seatstay_r = atan(len_seatstay_r / (radius_seatstay_r - curve_offset_seatstay_r));

// Left seatstay
curve_offset_seatstay_l=37;
radius_seatstay_l = (curve_offset_seatstay_l^2 + len_seatstay_l^2) / 2 / curve_offset_seatstay_l;
angle_seatstay_l = atan(len_seatstay_l / (radius_seatstay_l - curve_offset_seatstay_l));

// Parts

// Seat Tube
module seat_tube(hollow=true) {
    difference() {
        // Raw Seat Tube
        if (hollow==true) {
            difference() {
                cylinder(r=or_seat, h=len_seat);
                cylinder(r=ir_seat, h=len_seat);
            }
        } else {
            cylinder(r=or_seat, h=len_seat);
        }
        // Seat Tube - Diff Total BB Tube Area
        rotate(rot_bb)
            cylinder(r=or_bb, h=len_bb, center=true);
    }
}

// BB Tube
module bb_tube(hollow=true) {
    rotate(rot_bb)
        if (hollow==true) {
            difference() {
                cylinder(r=or_bb, h=len_bb, center=true);
                cylinder(r=ir_bb, h=len_bb, center=true);
            }
        } else {
            cylinder(r=or_bb, h=len_bb, center=true);
        }
}

// Top Tube
module top_tube(hollow=true) {
    difference() {
        // Top Tube Diff Seat Tube
        difference () { 
            // Raw Top Tube
            translate(trans_top)
                rotate(rot_top)
                    if (hollow==true) {
                        difference() {
                            cylinder(r=or_top, h=len_top);
                            cylinder(r=ir_top, h=len_top);
                        }
                    } else {
                        cylinder(r=or_top, h=len_top);
                    }
            // Top Tube - Diff Total Seat Tube Area
            cylinder(r=or_seat, h=len_seat);
        }
        translate(trans_head)
            cylinder(r=or_head, h=len_head);
    }
}

// Head Tube
module head_tube(hollow=true) {
    translate(trans_head)
        if (hollow==true) {
            difference() {
                cylinder(r=or_head, h=len_head);
                cylinder(r=ir_head, h=len_head);
            }
        } else {
            cylinder(r=or_bottom, h=len_bottom);
        }
}

// Bottom Tube
module bottom_tube(hollow=true) {
    difference() {
        difference() {
            translate(trans_bottom)
                rotate(rot_bottom)
                    if (hollow==true) {
                        difference() {
                            cylinder(r=or_bottom, h=len_bottom);
                            cylinder(r=ir_bottom, h=len_bottom);
                        }
                    } else {
                        cylinder(r=or_bottom, h=len_bottom);
                    }
            translate(trans_head)
                cylinder(r=or_head, h=len_head);
        }    // Seat Tube - Diff Total BB Tube Area
        rotate(rot_bb)
            cylinder(r=or_bb, h=len_bb, center=true);
    }
}

// Chainstay Right
module chainstay_right(hollow=true) {
    difference() {
        // Raw Chainstay Right
        translate(trans_chainstay_r)
            rotate(rot_chainstay_r)
                if (hollow==true) {
                    difference() {
                        rotate([90, 0, 0]) translate([-radius_chainstay_r, 0, 0]) rotate_extrude(angle=angle_chainstay_r) translate([radius_chainstay_r, 0]) circle(or_rear);
                        rotate([90, 0, 0]) translate([-radius_chainstay_r, 0, 0]) rotate_extrude(angle=angle_chainstay_r) translate([radius_chainstay_r, 0]) circle(ir_rear);
                    }
                } else {
                    rotate([90, 0, 0]) translate([-radius_chainstay_r, 0, 0]) rotate_extrude(angle=angle_chainstay_r) translate([radius_chainstay_r, 0]) circle(or_rear);
                }
        // Chainstay Right - Diff Total BB Tube Area
        rotate(rot_bb)
            cylinder(r=or_bb, h=len_bb, center=true);
    }
}

// Chainstay Left
module chainstay_left(hollow=true) {
    difference() {
        // Raw Chainstay Left
        translate(trans_chainstay_l)
            rotate(rot_chainstay_l)
                if (hollow==true) {
                    difference() {
                        rotate([90, 0, 0]) translate([-radius_chainstay_l, 0, 0]) rotate_extrude(angle=angle_chainstay_l) translate([radius_chainstay_l, 0]) circle(or_rear);
                        rotate([90, 0, 0]) translate([-radius_chainstay_l, 0, 0]) rotate_extrude(angle=angle_chainstay_l) translate([radius_chainstay_l, 0]) circle(ir_rear);
                    }
                } else {
                    rotate([90, 0, 0]) translate([-radius_chainstay_l, 0, 0]) rotate_extrude(angle=angle_chainstay_l) translate([radius_chainstay_l, 0]) circle(or_rear);
                }
        // Chainstay Left - Diff Total BB Tube Area
        rotate(rot_bb)
            cylinder(r=or_bb, h=len_bb, center=true);
    }
}

// Seatstay Right
module seatstay_right(hollow=true) {
    difference() {
        // Raw Seatstay Right
        translate(trans_seatstay_r)
            rotate(rot_seatstay_r)
                if (hollow==true) {
                    difference() {
                        rotate([90, 0, 0]) translate([-radius_seatstay_r, 0, 0]) rotate_extrude(angle=angle_seatstay_r) translate([radius_seatstay_r, 0]) circle(or_rear);
                        rotate([90, 0, 0]) translate([-radius_seatstay_r, 0, 0]) rotate_extrude(angle=angle_seatstay_r) translate([radius_seatstay_r, 0]) circle(ir_rear);
                    }
                } else {
                    rotate([90, 0, 0]) translate([-radius_seatstay_r, 0, 0]) rotate_extrude(angle=angle_seatstay_r) translate([radius_seatstay_r, 0]) circle(or_rear);
                }
        // Seatstay Right - Diff Total BB Tube Area
        rotate(rot_bb)
            cylinder(r=or_bb, h=len_bb, center=true);
    }
}

// Seatstay Left
module seatstay_left(hollow=true) {
    difference() {
        // Raw Seatstay Left
        translate(trans_seatstay_l)
            rotate(rot_seatstay_l)
                if (hollow==true) {
                    difference() {
                        rotate([90, 0, 0]) translate([-radius_seatstay_l, 0, 0]) rotate_extrude(angle=angle_seatstay_l) translate([radius_seatstay_l, 0]) circle(or_rear);
                        rotate([90, 0, 0]) translate([-radius_seatstay_l, 0, 0]) rotate_extrude(angle=angle_seatstay_l) translate([radius_seatstay_l, 0]) circle(ir_rear);
                    }
                } else {
                    rotate([90, 0, 0]) translate([-radius_seatstay_l, 0, 0]) rotate_extrude(angle=angle_seatstay_l) translate([radius_seatstay_l, 0]) circle(or_rear);
                }
        // Seatstay Left - Diff Total BB Tube Area
        rotate(rot_bb)
            cylinder(r=or_bb, h=len_bb, center=true);
    }
}

// Render Front Triangle
seat_tube();
bb_tube();
top_tube();
head_tube();
bottom_tube();

// Render Chainstays and Seatstays Minus Cuts

// Chainstay Right with Cuts
difference() {
    chainstay_right();
    seatstay_right(hollow=false);
    bb_tube(hollow=false);
}

// Chainstay Left with Cuts
difference() {
    chainstay_left();
    seatstay_left(hollow=false);
    bb_tube(hollow=false);
}

// Seatstay Right with Cuts
difference() {
    seatstay_right();
    chainstay_right(hollow=false);
    seat_tube(hollow=false);
}

// Seatstay Left with Cuts
difference() {
    seatstay_left();
    chainstay_left(hollow=false);
    seat_tube(hollow=false);
}
