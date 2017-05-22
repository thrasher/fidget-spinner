// bicycle gear
// 
// functions to layout a bicycle gear given an arbitrary number of teeth
// see: http://www.gizmology.net/sprockets.htm

$fs = 0.1; // mm per facet in cylinder
$fa = 5; // degrees per facet in cylinder
$fn = 100;

PI = 3.14159;
N_LINKS = 4;
ROLLER_DIA = 5/16;

// given the number of links, calculate the radius of a gear circle
function rad(n=2) = 1 / (4 * sin(180 / n));

 module roller() {
     cylinder(d=ROLLER_DIA, h=.5);
 }
 
// layout(teeth){child object}
// produces a radial array of child objects rotated around the local z axis
// teeth = number of teeth (practical minimum is 4, because of bicycle chain inner/outer linking)
module layout(teeth=2) {
    rad = rad(teeth); // radius of gear circle
    for (k=[1:teeth]) {
        rotate([0,0,-(360/teeth)*k])
        translate([0,rad,0])
        children();
    }
}

layout(N_LINKS) roller();
cylinder(r=rad(N_LINKS), h=.1);


echo("<b>Teeth = </b>", N_LINKS);
