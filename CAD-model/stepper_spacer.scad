
$fn=40;


difference(){
	translate([-21,-21,0])
	cube([42,42,5]);
	translate([0,0,-1])
	cylinder(r=11.5,h=20);
	
	translate([-15.5,-15.5,-1])
	cylinder(r=2,h=50);
	translate([15.5,-15.5,-1])
	cylinder(r=2,h=50);
	translate([-15.5,15.5,-1])
	cylinder(r=2,h=50);
	translate([15.5,15.5,-1])
	cylinder(r=2,h=50);

}

