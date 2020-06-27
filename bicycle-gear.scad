// bicycle gear
//
// functions to layout a bicycle gear for a roller chain with, given an arbitrary number of teeth
// see: http://www.gizmology.net/sprockets.htm

$fs = 0.1; // mm per facet in cylinder
$fa = 5; // degrees per facet in cylinder
$fn = 100;

PI = 3.14159;
N_LINKS = 22;
ROLLER_DIA = 5/16;
ROLLER_PITCH = 1/2;
ROLLER_WIDTH = 2/32; // http://www.velonews.com/2016/01/bikes-and-tech/technical-faq/tech-faq-chain-width-explained-compatibility-queries-answered_392163
BEARING_DIA = .8665 + 0.05; // hole for bearing
BEARING_WID = .25; // width of the bearing

// given the number of links, calculate the radius of a gear circle
function rad(n=2) = 1 / (4 * sin(180 / n));

module tooth() {
	intersection() {
		cylinder(r=ROLLER_PITCH-.5*ROLLER_DIA, h=ROLLER_WIDTH);
		translate([ROLLER_PITCH, 0, 0])
		cylinder(r=ROLLER_PITCH-.5*ROLLER_DIA, h=ROLLER_WIDTH);
	}
}

module roller() {
	cylinder(d=ROLLER_DIA, h=2);
	translate([ROLLER_PITCH, 0, 0])
	cylinder(d=ROLLER_DIA, h=2);
}


// layout(teeth){child object}
// produces a radial array of child objects rotated around the local z axis
// teeth = number of teeth (practical minimum is 4, because of bicycle chain inner/outer linking)
module layout(teeth=2) {
	// radius of gear circle
	rad = rad(teeth);
	// find link angle
	ang = asin(pow((rad*rad - .25*ROLLER_PITCH*ROLLER_PITCH),1/2)/rad);
	for (k=[1:teeth]) {
		rotate([0,0, k * 360 / teeth ])
		translate([0,rad,0])
		rotate([0,0,ang-90])
		//        if (k < 2)
		children();
	}
}

module gear() {
	translate([0, 0, -ROLLER_WIDTH/2]) {
		difference() {
			layout(N_LINKS) tooth();
			translate([0,0,-1])
			difference() {
				cylinder(r=rad(N_LINKS) + ROLLER_PITCH, h=2);
				cylinder(r=rad(N_LINKS) + ROLLER_PITCH*.35, h=2);
			}
		}
		difference() {
			len = sqrt(pow(rad(N_LINKS), 2) - pow((ROLLER_PITCH/2), 2) );
			cylinder(r=len, h=ROLLER_WIDTH);
			translate([0,0,-1]) {
				layout(N_LINKS) roller();
			}
		}
	}
}

difference() {
	union() {
		gear();
		cylinder(r=rad(N_LINKS)-.2, h=BEARING_WID, center=true);
	}
	cylinder(d=BEARING_DIA, h=2, center=true);
}


echo("<b>Teeth = </b>", N_LINKS);
