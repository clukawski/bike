// Part module definitions

// Generic hollow tube
module tube_hollow(trans, rot, outer_radius, inner_radius, length, hollow=true) {
	translate(trans)
		rotate(rot)
		if (hollow==true) {
			difference() {
				cylinder(r=outer_radius, h=length);
				cylinder(r=inner_radius, h=length);
			}
		} else {
			cylinder(r=outer_radius, h=length);
		}
}

// Seat Tube
module seat_tube(outer_radius, inner_radius, length, hollow=true) {
	tube_hollow([0,0,0], [0,0,0], outer_radius, inner_radius, length, hollow);
}

// BB Tube
module bb_tube(trans, rot, outer_radius, inner_radius, length, hollow=true) {
	tube_hollow(trans, rot, outer_radius, inner_radius, length, hollow);
}

// Top Tube
module top_tube(trans, rot, outer_radius, inner_radius, length, hollow=true) {
	tube_hollow(trans, rot, outer_radius, inner_radius, length, hollow);
}

// Head Tube
module head_tube(trans, outer_radius, inner_radius, length, hollow=true) {
	tube_hollow(trans, [0,0,0], outer_radius, inner_radius, length, hollow);
}

// Bottom Tube
module bottom_tube(rot, outer_radius, inner_radius, length, hollow=true) {
	tube_hollow([0,0,0], rot, outer_radius, inner_radius, length, hollow);
}

// Generate any kind of chain/seat stay curved pipe
module raw_stay (curve_offset, length, radius) {
    radius_stay = (curve_offset^2 + length^2) / 2 / curve_offset;
    angle_stay = atan(length / (radius_stay - curve_offset));
    rotate([90, 0, 0]) translate([-radius_stay, 0, 0]) rotate_extrude(angle=angle_stay) translate([radius_stay, 0]) circle(radius);
}

// Generate optionally (and by default) hollow chain/seat stay
module stay(trans, rot, curve_offset, outer_radius, inner_radius, length, hollow=true) {
	translate(trans)
		rotate(rot)
		if (hollow==true) {
			difference() {
				raw_stay(curve_offset, length, outer_radius);
				raw_stay(curve_offset, length, inner_radius);
			}
		} else {
			raw_stay(curve_offset, length, outer_radius);
		}
}

// Dropout Mounts
module dropout_mount(trans, rot, radius, length) {
    translate(trans)
        rotate(rot)
		    cylinder(r=radius, h=length, center=true);
}
