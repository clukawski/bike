// Raw Material Dimensions

// McMaster-Carr 89955K929
or_seat=14.2875;
ir_seat=13.0429;
// McMaster-Carr 89955K929
or_top=14.2875;
ir_top=13.0429;
// // McMaster-Carr 89955K689
or_head=19.05;
ir_head=16.9418;
// Paragon Machineworks Steel Threaded BB Shell
/* https://www.paragonmachineworks.com/bottom-bracket-shells/steel/steel-threaded-bb-shell-1-562-od.html
*/
or_bb=19.8374;
ir_bb=17.5895;
// McMaster-Carr 89955K919
or_bottom=14.2875;
ir_bottom=13.3985;
// McMaster-Carr 89955K148
or_rear=7.9375;
ir_rear=6.4643;
// Generic 1" 4130 Round  Bar
or_dropout_mount=6.35;

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
len_dropout_mount=or_rear*2;

// Offsets
offset_top=520;
offset_head=320;
offset_bottom=0;
offset_chainstay=150;
offset_seatstay=150;
offset_dropout_mount=150;

// Rotations
rot_bb=[0,90,0];
rot_top=[99,0,0];
rot_bottom=[61,0,0];
rot_chainstay_r=[110,0,-1];
rot_chainstay_l=[110,0,1];
rot_seatstay_r=[50,0,0];
rot_seatstay_l=[50,0,0];
rot_dropout_mount=[0,90,0];

// Translations
trans_top=[0,0,offset_top];
trans_head=[0,-len_top,offset_head];
trans_bottom=[0,0,offset_bottom];
trans_chainstay_r=[-45,len_chainstay_r-10,offset_chainstay];
trans_chainstay_l=[45,len_chainstay_l-10,offset_chainstay];
trans_seatstay_r=[-45,len_seatstay_r-120,offset_seatstay];
trans_seatstay_l=[45,len_seatstay_l-120,offset_seatstay];
trans_dropout_mount_r=[-45,len_seatstay_r-115,offset_dropout_mount-1];
trans_dropout_mount_l=[45,len_seatstay_l-115,offset_dropout_mount-1];

// Curve offsets for stays
curve_offset_chainstay_r=-26;
curve_offset_chainstay_l=26;
curve_offset_seatstay_r=-37;
curve_offset_seatstay_l=37;

// Trig special values (chain / seat stays)
// Minimum angle
$fa = 1;
// Minimum size
$fs = 0.5;

// Parts

// Seat Tube
module seat_tube(hollow=true) {
	if (hollow==true) {
		difference() {
			cylinder(r=or_seat, h=len_seat);
			cylinder(r=ir_seat, h=len_seat);
		}
	} else {
		cylinder(r=or_seat, h=len_seat);
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
}

// Generate any kind of chain/seat stay curved pipe
module stay (curve_offset, length, radius) {
    radius_stay = (curve_offset^2 + length^2) / 2 / curve_offset;
    angle_stay = atan(length / (radius_stay - curve_offset));
    rotate([90, 0, 0]) translate([-radius_stay, 0, 0]) rotate_extrude(angle=angle_stay) translate([radius_stay, 0]) circle(radius);
}

// Chainstay Right
module chainstay_right(hollow=true) {
	// Raw Chainstay Right
	translate(trans_chainstay_r)
		rotate(rot_chainstay_r)
		if (hollow==true) {
			difference() {
				stay(curve_offset=curve_offset_chainstay_r, length=len_chainstay_r, radius=or_rear);
				stay(curve_offset=curve_offset_chainstay_r, length=len_chainstay_r, radius=ir_rear);
			}
		} else {
			stay(curve_offset=curve_offset_chainstay_r, length=len_chainstay_r, radius=or_rear);
		}
}

// Chainstay Left
module chainstay_left(hollow=true) {
	// Raw Chainstay Left
	translate(trans_chainstay_l)
		rotate(rot_chainstay_l)
		if (hollow==true) {
			difference() {
				stay(curve_offset=curve_offset_chainstay_l, length=len_chainstay_l, radius=or_rear);
				stay(curve_offset=curve_offset_chainstay_l, length=len_chainstay_l, radius=ir_rear);
			}
		} else {
			stay(curve_offset=curve_offset_chainstay_l, length=len_chainstay_l, radius=or_rear);
		}
}

// Seatstay Right
module seatstay_right(hollow=true) {
	// Raw Seatstay Right
	translate(trans_seatstay_r)
		rotate(rot_seatstay_r)
		if (hollow==true) {
			difference() {
				stay(curve_offset=curve_offset_seatstay_r, length=len_seatstay_r, radius=or_rear);
				stay(curve_offset=curve_offset_seatstay_r, length=len_seatstay_r, radius=ir_rear);
			}
		} else {
			stay(curve_offset=curve_offset_seatstay_r, length=len_seatstay_r, radius=or_rear);
		}
}

// Seatstay Left
module seatstay_left(hollow=true) {
	// Raw Seatstay Left
	translate(trans_seatstay_l)
		rotate(rot_seatstay_l)
		if (hollow==true) {
			difference() {
				stay(curve_offset=curve_offset_seatstay_l, length=len_seatstay_l, radius=or_rear);
				stay(curve_offset=curve_offset_seatstay_l, length=len_seatstay_l, radius=ir_rear);
			}
		} else {
			stay(curve_offset=curve_offset_seatstay_l, length=len_seatstay_l, radius=or_rear);
		}
}

// Dropout Mounts
module dropout_mount(trans, rot, radius, length) {
    translate(trans)
        rotate(rot)
            difference() {
                cylinder(r=radius, h=length, center=true);
            }
}

// Dropout Mount Left
module dropout_mount_l() {
    dropout_mount(trans=trans_dropout_mount_l, rot=rot_dropout_mount, radius=or_dropout_mount, length=len_dropout_mount);
}

// Dropout Mount Right
module dropout_mount_r() {
    dropout_mount(trans=trans_dropout_mount_r, rot=rot_dropout_mount, radius=or_dropout_mount, length=len_dropout_mount);
}
