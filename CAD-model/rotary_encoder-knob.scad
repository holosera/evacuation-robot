
$fn=50;


difference(){
	cylinder(r=15,h=12);

	difference(){
		translate([0,0,-1])
		cylinder(r=3.25,h=10);

		translate([4.6-10,-12,-2])
		cube([10,10,20]);	


	}

	
	
}

