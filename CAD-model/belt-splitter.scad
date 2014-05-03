difference(){
	translate([-20,0,0])
	cube([40,40,10]);
	translate([-4.9,-1,6])
	cube([9.8,50,50]);
	translate([-0.5,5,-1])
	cube([1,30,50]);


	translate([-15,20,-1])
	cylinder(r=2.5,h=100);
	translate([15,20,-1])
	cylinder(r=2.5,h=100);
}