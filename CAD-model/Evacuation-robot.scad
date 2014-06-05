display=0;

sheet_thickness=6.25;
backplate_width=400;
backplate_height=400;
bottomplate_depth=200;

sideplate_height=150;
sideplate_depth=150;

slide_width=105;

//---------------------------------------------------------------------------
//_____________________ACRYLIC SHEETS__________________________________________

module bottomplate (){
	difference(){
		union(){
			translate([0,-bottomplate_depth,0])
			cube([backplate_width,bottomplate_depth,sheet_thickness]);
		}
	}
}

module backplate (){
	difference(){
		union(){
			translate([0,0,0])
			cube([backplate_width,sheet_thickness,backplate_height]);
		}
		translate([275,20,220])
		rotate([90,0,0])
		cylinder(r=4,h=100);		
	}
}

module beltplate (){
	union(){
		difference(){
			union(){
				translate([50,50,0])
				cylinder(r=50,h=sheet_thickness);	
				translate([180,50,0])
				cylinder(r=50,h=sheet_thickness);	
			}	
		translate([50,0,-1])
		cube([130,100,sheet_thickness+2]);
		}
		translate([50,0,0])
		cube([130,100,sheet_thickness]);	
	}	
}

module beltplate_holes (){
	translate([25,80,-50])
	cylinder(r=1.7,h=100);
	translate([25,20,-50])
	cylinder(r=1.7,h=100);

	translate([230-10,50,-50])
	cylinder(r=1.7,h=100);
}


module sideplateleft(){
	union(){
		translate([sheet_thickness,0,sheet_thickness])
		rotate([0,-90,0])
		linear_extrude(height=sheet_thickness)
		polygon(points=[[0,0],[0,-sideplate_depth],[sideplate_height,0]], paths=[[0,1,2]]);
		
		translate([0,-50,sheet_thickness])
		cube([sheet_thickness,50,230-sheet_thickness]);
	}
}

module sideplateright(){

	translate([backplate_width,0,sheet_thickness])
	rotate([0,-90,0])
	linear_extrude(height=sheet_thickness)

	polygon(points=[[0,0],[0,-sideplate_depth],[sideplate_height,0]], paths=[[0,1,2]]);

}

module leftslide(){
	cube([248,slide_width,sheet_thickness]);
}

module rightslide(){
	cube([186,slide_width,sheet_thickness]);
}

module slidefront(){
	difference(){
		linear_extrude(height=	sheet_thickness)
		polygon(points=[[50,0],[50,5],[234,170],[318,170],[backplate_width,5],[backplate_width,0]] , paths=[[0,1,2,3,4,5]]);	
	
	}
}

module elecfront(){
	difference(){
		translate([0,-sheet_thickness-slide_width,backplate_height])
		rotate([-90,0,0])
		linear_extrude(height=
	sheet_thickness)
		polygon(points=[[0,0],[0,170],[234,170],[50,5],[50,0]] , paths=[[0,1,2,3,4,5]]);	
	
	}
}

module elecleft (){
	difference(){
		translate([0,-slide_width,230+sheet_thickness])
		cube([sheet_thickness,slide_width,	backplate_height-230-sheet_thickness*2]);
	}
}

module electop (){
	difference(){
		translate([0,-slide_width,backplate_height-sheet_thickness])
		cube([48,slide_width,sheet_thickness]);
	}
}

module elecbottom (){
	difference(){
		translate([0,-slide_width,230])
		cube([234-4,slide_width,sheet_thickness]);
	}
}

module elecfront_connectors (){
	difference(){
		cube([24,sheet_thickness,12]);
		translate([12,-1,6])
		rotate([-90,0,0])
		cylinder(r=1.7,h=100);
	}


}

//-------------------------------------------------------------------------
//___________________________3D PRINTED PARTS______________________________

module rotor(){
	difference(){
		union(){
			translate([0,0,0])
			cylinder(r=33.7,h=89,$fn=100);
			for ( i = [-100,-75,-50,-25,0,25,50,75,100] )
			{
			    rotate( [0, 0,  i ])
			    translate([0, 31.5, 0])
			    cylinder(r=3,h=89,$fn=20);
			}
		}	
		translate([0,25,-1])
		cylinder(r=8.6,h=110,$fn=50);
		translate([0,27,-1])
		cylinder(r=8.7,h=110,$fn=50);

		translate([-8,24,-1]) 
		rotate([0,0,15])
		cube([5,40,110]);

		translate([8,24,-1])
		rotate([0,0,-15])
		translate([-5,0,0])
		cube([5,40,110]);

		translate([0,0,-2])
		cylinder(r=4.1,h=150,$fn=25);
	}
}

module sled(){
	difference(){
		union(){
			intersection(){
				translate([0,-8,0])	
				cylinder(r=28,h=10,$fn=100);
				translate([0,-38,-1])	
				cylinder(r=42,h=15,$fn=100);	
			}		

			translate([-13,-33.5,0])	
			cylinder(r=3,h=18,$fn=50);

			translate([0,-25,0])	
			cylinder(r=11.5,h=55,$fn=50);

			translate([-13,-36.5,0])
			cube([13,19,55]);

			translate([-63.7,-34.5,0])
			cube([64,15,12]);

			translate([-63.7,-34.5,0])
			cube([64,7,18]);

			translate([-88,-34.5,42])
			cube([18,15,11]);
			translate([-63.7,-34.5,0])
			rotate([0,-30,0])
			cube([20,15,48.66]);
		}	
	translate([0,-27,-1])	
	cylinder(r=3.25,h=100,$fn=20);
	translate([20,-10,-1])	
	cylinder(r=4,h=50);
	translate([-20,-10,-1])	
	cylinder(r=4,h=50);

	translate([-50,-30.25,3])	
	cube([50,6.50,24.5]);		
	translate([-50,-30,27])	
	cube([50,6,50]);	

	translate([-12,-50.0,27])	
	cube([19,22,1]);	


	translate([-6.5,0,32])	
	rotate([90,0,0])
	cylinder(r=1.4,h=100,$fn=6);	
	translate([-6.5,0,50])	
	rotate([90,0,0])
	cylinder(r=1.4,h=100,$fn=6);	

	translate([-6.5,-25,32])	
	rotate([90,0,0])
	cylinder(r=2,h=100,$fn=6);	
	translate([-6.5,-25,50])	
	rotate([90,0,0])
	cylinder(r=2,h=100,$fn=6);	

	translate([-100,-30.3,3])
	cube([54,6.5,32]);

	translate([-80,-27,15.5+28])	
	cylinder(r=4.8,h=100,$fn=20);

	translate([-80,-40,19+28])	
	rotate([-90,0,0])
	cylinder(r=2,h=100,$fn=6);


	//reinforcement
	translate([0,-22,-1])	
	cylinder(r=0.2,h=100);

	translate([-5,-22,-1])	
	cylinder(r=0.2,h=100);
	translate([5,-22,-1])	
	cylinder(r=0.2,h=100);
	translate([9,-22,-1])	
	cylinder(r=0.2,h=100);

	translate([-10,-19,-1])	
	cylinder(r=0.2,h=100);
	translate([-10,-22,-1])	
	cylinder(r=0.2,h=100);
	translate([-5,-18,-1])	
	cylinder(r=0.2,h=100);
	translate([0,-18,-1])	
	cylinder(r=0.2,h=100);
	translate([5,-18,-1])	
	cylinder(r=0.2,h=100);

	translate([5,-27,-1])	
	cylinder(r=0.2,h=100);
	translate([8,-27,-1])	
	cylinder(r=0.2,h=100);
	translate([7,-29,-1])	
	cylinder(r=0.2,h=100);
	}
	
}

module sled_old(){
	difference(){
		union(){
			intersection(){
				translate([0,-8,0])	
				cylinder(r=28,h=10,$fn=100);
				translate([0,-38,-1])	
				cylinder(r=42,h=15,$fn=100);	
			}		

			translate([-13,-33.5,0])	
			cylinder(r=3,h=18,$fn=50);

			translate([0,-25,0])	
			cylinder(r=11.5,h=55,$fn=50);

			translate([-13,-36.5,0])
			cube([13,19,55]);

			translate([-60.7,-34.5,0])
			cube([61,15,12]);

			translate([-60.7,-34.5,0])
			cube([61,7,18]);

			translate([-85,-34.5,42])
			cube([18,15,11]);
			translate([-60.7,-34.5,0])
			rotate([0,-30,0])
			cube([20,15,48.66]);
		}	
	translate([0,-27,-1])	
	cylinder(r=3.25,h=100,$fn=20);
	translate([20,-10,-1])	
	cylinder(r=4,h=50);
	translate([-20,-10,-1])	
	cylinder(r=4,h=50);

	translate([-50,-30.25,3])	
	cube([50,6.50,24.5]);		
	translate([-50,-30,27])	
	cube([50,6,50]);	

	translate([-12,-50.0,27])	
	cube([19,22,1]);	


	translate([-6.5,0,32])	
	rotate([90,0,0])
	cylinder(r=1.4,h=100,$fn=6);	
	translate([-6.5,0,50])	
	rotate([90,0,0])
	cylinder(r=1.4,h=100,$fn=6);	

	translate([-6.5,-25,32])	
	rotate([90,0,0])
	cylinder(r=2,h=100,$fn=6);	
	translate([-6.5,-25,50])	
	rotate([90,0,0])
	cylinder(r=2,h=100,$fn=6);	

	translate([-100,-30.3,3])
	cube([54,6.5,32]);

	translate([-77,-27,15.5+28])	
	cylinder(r=4.8,h=100,$fn=20);

	translate([-77,-40,19+28])	
	rotate([-90,0,0])
	cylinder(r=2,h=100,$fn=6);


	//reinforcement
	translate([0,-22,-1])	
	cylinder(r=0.2,h=100);

	translate([-5,-22,-1])	
	cylinder(r=0.2,h=100);
	translate([5,-22,-1])	
	cylinder(r=0.2,h=100);
	translate([9,-22,-1])	
	cylinder(r=0.2,h=100);

	translate([-10,-19,-1])	
	cylinder(r=0.2,h=100);
	translate([-10,-22,-1])	
	cylinder(r=0.2,h=100);
	translate([-5,-18,-1])	
	cylinder(r=0.2,h=100);
	translate([0,-18,-1])	
	cylinder(r=0.2,h=100);
	translate([5,-18,-1])	
	cylinder(r=0.2,h=100);

	translate([5,-27,-1])	
	cylinder(r=0.2,h=100);
	translate([8,-27,-1])	
	cylinder(r=0.2,h=100);
	translate([7,-29,-1])	
	cylinder(r=0.2,h=100);
	}
	
}


module frontplate(){
	difference(){
		union(){
			translate([0,0,0])
			linear_extrude(height = 5, center = false, convexity = 10, twist = 0)
			polygon(points=[[25,0],[42,10],[42,22],[-41,22],[-41,10],[-25,0]]);
			intersection() {
				cylinder(r=36,h=5,$fn=100);
				translate([0,15,-1])
				cylinder(r=29,h=7,$fn=100);	
			}			
			translate([-20,10,0])
			cylinder(r=10.5,h=68,$fn=100);	
			translate([20,10,0])
			cylinder(r=10.5,h=68,$fn=100);	

			translate([0,0,0])
			cylinder(r=14,h=7.5,$fn=100);	
			
			translate([-17.5,7,25])
			cube([35,3.5,43]);
			
		}	
	translate([0,0,-1])
	cylinder(r=7,h=100);	

	translate([20,10,-1])
	cylinder(r=5.5,h=100);	

	translate([-20,10,-1])
	cylinder(r=5.5,h=100);	

	translate([0,27,-1])
	cylinder(r=7,h=7,$fn=40);

	translate([-20,10,68-47])
	cylinder(r=7.7,h=51,$fn=40);	 
	translate([20,10,68-47])
	cylinder(r=7.7,h=51,$fn=40);	

	translate([0,0,2])
	cylinder(r=8.25,h=6,$fn=40);	
	translate([-34,17,-20])
	cylinder(r=1.7,h=38,$fn=10);	 
	translate([34,17,-20])
	cylinder(r=1.7,h=38,$fn=10);
	}

}

module frontplate_holes(){	

	translate([0,27,-50])
	cylinder(r=5.5,h=100);		

	translate([-34,17,-50])
	cylinder(r=1.7,h=108,$fn=10);	 
	translate([34,17,-20])
	cylinder(r=1.7,h=38,$fn=10);

}

module belt_protector_spacer(){
	difference(){
		cylinder(r=8,h=24);
		translate([0,0,-1])
		cylinder(r=1.5,h=100);
	}
}

module opto_pcb_holder(){
	difference(){
		union(){
			translate([0,-7.5,0]){
			cube([32,15,4]);
			cube([5,15,18]);
			}
		}
		translate([8,-2,-1])
		cube([20,4,10]);
		translate([-1,2.3,6])
		cube([10,3.7,9]);
	}
}


//----------------------------------------------------------------------------------
//___________________________ Mechanical parts______________________________________

module lm8uu(){
	difference(){
		cylinder(r=7.5,h=24);	
		translate([0,0,-1])
		cylinder(r=4,h=21);	
	}
}


module tube(){
	difference(){
		cylinder(r=8.4,h=102);
		translate([0,0,-1])
		cylinder(r=2.5,h=105);
	}
}

module firgelli30mm(){
	difference(){
		union(){
			translate([-4,-4.5,-4.5])
			cube([90,9,9]);
			translate([4.5,-6,-6])
			cube([73,12,12]);		
			translate([4.5,-11.5,-7.5])
			cube([37,18,15]);		
		}
	translate([0,0,-50])
	cylinder(r=2.3,h=100,$fn=20);
	translate([82,0,-50])
	cylinder(r=2.3,h=100,$fn=20);		
	}
}

module firgelli30mm_holes(){
	union(){
		translate([-4,-4.5,-4.5])
		cube([90,9,9]);
		translate([4.5,-7.5,-7.5])
		cube([73,15,15]);		
		translate([4.5,-11.5,-7.5])
		cube([37,18,15]);		
		translate([0,0,-50])
		cylinder(r=2.3,h=100,$fn=20);
		translate([82,0,-50])
		cylinder(r=2.3,h=100,$fn=20);		
	}
}


// stepper nema 17, with some extra space around
module stepper(){ 
	difference(){
		union(){
			translate([-22,-22,-44])	
				cube([44,44,44],center=false);
			cylinder(r=2.5,h=30,center=false);
			cylinder(r=12,h=4,center=true);
			translate([-15.5,-15.5,0])
				cylinder(r=1.5,h=10,center=false);
			translate([15.5,-15.5,0])
				cylinder(r=1.5,h=10,center=false);
			translate([15.5,15.5,0])
				cylinder(r=1.5,h=10,center=false);
			translate([-15.5,15.5,0])
				cylinder(r=1.5,h=10,center=false);

			translate([0,0,10])
				cylinder(r=8,h=15,center=false);				
		}
	}
}

module stepper_holes(){ 
	difference(){
		union(){
			translate([-21.5,-21.5,-49])	
				cube([43,43,49],center=false);
			cylinder(r=2.5,h=70,center=true);
			cylinder(r=14,h=10,center=false);
			cylinder(r=6,h=35,center=false);
			translate([-15.5,-15.5,0])
				cylinder(r=2.2,h=80,center=true,$fn=12);
			translate([15.5,-15.5,0])
				cylinder(r=2.2,h=80,center=true,$fn=12);
			translate([15.5,15.5,0])
				cylinder(r=2.2,h=80,center=true,$fn=12);
			translate([-15.5,15.5,0])
				cylinder(r=2.2,h=80,center=true,$fn=12);
		
		}
	}
}

module arduino_uno(){
	difference(){
		union(){
			cube([68.6,53.3,12]);
			translate([-7,33,2.75])
			cube([17,12,10.5]);
			translate([-2,4,2])
			cube([14,9,11]);			
		}
		translate([14,2.5,-1])
		cylinder(r=1.5,h=20);
		translate([15.3,50.7,-1])
		cylinder(r=1.5,h=20);	
		translate([66.1,7.6,-1])
		cylinder(r=1.5,h=20);	
		translate([66.1,35.5,-1])
		cylinder(r=1.5,h=20);	
	}
}

module arduino_uno_holes(){
	union(){
		translate([-10,32,2])
		cube([50,14,12]);
		translate([-10,3,2])
		cube([50,11,13]);	

		translate([14,2.5,-20])
		cylinder(r=1.7,h=50);
		translate([15.3,50.7,-20])
		cylinder(r=1.7,h=50);	
		translate([66.1,7.6,-20])
		cylinder(r=1.7,h=50);	
		translate([66.1,35.5,-20])
		cylinder(r=1.7,h=50);	
	}
}

module newheaven_lcd(){
	difference(){
		union(){
			cube([80,36,4]);
			translate([5,5,4])
			cube([71,26,9]);		
		}
		translate([2.5,3,-1])
		cylinder(r=1.7,h=20);
		translate([77.5,3,-1])
		cylinder(r=1.7,h=20);
		translate([77.5,33,-1])
		cylinder(r=1.7,h=20);
		translate([2.5,33,-1])
		cylinder(r=1.7,h=20);
	}
}

module newheaven_lcd_holes(){
	union(){
		translate([4.5,4.5,-1])
		cube([72,27,25]);		
		translate([2.5,3,-1])
		cylinder(r=1.7,h=25);
		translate([77.5,3,-1])
		cylinder(r=1.7,h=25);
		translate([77.5,33,-1])
		cylinder(r=1.7,h=25);
		translate([2.5,33,-1])
		cylinder(r=1.7,h=25);
	}
}

module vac_sensor_pcb(){
	difference(){
		union(){
			cube([27,48,5]);
		}
		translate([4,44,-1])
		cylinder(r=1.7,h=50);
		translate([24,44,-1])
		cylinder(r=1.7,h=50);
	}
}

module vac_sensor_pcb_holes(){
	union(){
		translate([4,44,-25])
		cylinder(r=1.7,h=50);
		translate([24,44,-25])
		cylinder(r=1.7,h=50);
	}
}

module rot_encoder_pcb(){
	difference(){
		union(){
			cube([20,34,1]);
			translate([10,14,0])
			cylinder(r=3.5,h=20);
			translate([4,8,0])
			cube([12,12,6]);			

		}
		translate([10,3,-1])
		cylinder(r=1.7,h=50);
		translate([10,29.5,-1])
		cylinder(r=1.7,h=50);
	}
}

module rot_encoder_holes(){
	translate([10,3,-20])
	cylinder(r=1.7,h=100);
	translate([10,29.5,-20])
	cylinder(r=1.7,h=100);
	translate([10,14,0])
	cylinder(r=4,h=20);
}

module 8256_solenoid(){
	difference(){
		translate([-16.5,-12.5,0])
		cube([33,25,53]);			
		translate([-25,0,7]) rotate([0,90,0])
		cylinder(r=5,h=50);
	}	
}

//-----------------------------------------------------------------------------------------------------------------
//__________________________________ DISPLAY___________________________________________________________
//-----------------------------------------------------------------------------------------------------------------

if (display==1) {
	
	translate([195,-60,230+15])
	rotate([0,0,-90])
	firgelli30mm();

	
	translate([275,-01,247])
	rotate([90,0,0])
	tube();
	
	translate([275,-200,220])
	rotate([-90,0,0])
	sled();
		
	translate([275,-98,220])
	rotate([90,0,0])
	rotate([180,0,0])
	rotate([0,0,180])
	rotor();
	
	translate([275-20,-136-21,220+10])
	rotate([-90,0,0])
	lm8uu();
	translate([275+20,-136-21,220+10])
	rotate([-90,0,0])
	lm8uu();

	color([0.2, 0.2, 0.2, 1]) 
	translate([20,-15,230+sheet_thickness+8])
	8256_solenoid();
	
	color([0.2, 0.2, 0.2, 1]) 
	translate([20,-15-37.5,230+sheet_thickness+8])
	8256_solenoid();
	
	color([0.2, 0.2, 0.2, 1]) 
	translate([20,-15-75,230+sheet_thickness+8])
	8256_solenoid();
	
	translate([275-120,-2,259])
	rotate([-90,0,0])
	stepper();

	translate([sheet_thickness,-2,400-85])
	rotate([90,0,0])
	arduino_uno();

	translate([sheet_thickness+2,-100,400-85])
	rotate([90,0,0])
	newheaven_lcd();

	translate([85,0,280])
	rotate([90,0,0])
	vac_sensor_pcb();

	translate([100,-95,250])
	rotate([90,0,0])
	rot_encoder_pcb();
	
	translate([100-12,-111+sheet_thickness,230+sheet_thickness]) 
	elecfront_connectors();

	translate([sheet_thickness,-111+sheet_thickness,400-sheet_thickness-12]) 
	elecfront_connectors();

	translate([275,-111,220]) rotate([90,0,0])
	frontplate();
	


	color([0.7, 0.7, 0.9, 0.5]) 
	bottomplate();

	difference(){
		color([0.7, 0.7, 0.9, 0.5]) 
		backplate();

		for ( i = [0 : 0.25 : 5] ){
			translate([275-118-i,-2,259])
			rotate([-90,0,0])
			stepper_holes();
		}

		// opto_mount_hole
		translate([275-54,20,220+18.5])
		rotate([90,0,0])
		cylinder(r=1.7,h=100);
		// opto_wire_hole
		translate([195,20,245])
		rotate([90,0,0])
		cylinder(r=5,h=100);
		
		translate([sheet_thickness,0,400-85])
		rotate([90,0,0])
		arduino_uno_holes();
		translate([85,0,280])
		rotate([90,0,0])
		vac_sensor_pcb_holes();	
		color([0.7, 0.7, 0.9, 0.5]) 
		translate([105,25,273])
		rotate([0,18,0])	
		rotate([90,0,0])
		translate([0,-50,0])	
		beltplate_holes();
	}
	

	color([0.7, 0.7, 0.9, 0.5]) 
	translate([50,-slide_width,backplate_height-sheet_thickness+1.5])
	rotate([0,41.9,0])
	leftslide();
	
	color([0.7, 0.7, 0.9, 0.5])
	translate([backplate_width-sheet_thickness+1,-slide_width,backplate_height-0])
	rotate([0,180-63.5,0]) 
	rightslide();
	
	difference(){
	 	color([0.7, 0.7, 0.9, 0.5]) 
		elecleft();
		translate([10,-15,230+sheet_thickness+16])
		rotate([0,-90,0])
		cylinder(r=9,h=50);
		translate([10,-15-37.5,230+sheet_thickness+16])
		rotate([0,-90,0])
		cylinder(r=9,h=50);
		translate([10,-15-75,230+sheet_thickness+16])
		rotate([0,-90,0])
		cylinder(r=9,h=50);
		translate([sheet_thickness,-2,400-85])
		rotate([90,0,0])
		arduino_uno_holes();
	}


 	color([0.7, 0.7, 0.9, 0.5]) 
	electop();

	difference(){
	 	color([0.7, 0.7, 0.9, 0.5]) 
		elecbottom();
		translate([195,-60,230+15])
		rotate([0,0,-90])
		firgelli30mm_holes();
		translate([20,-33.75,220])
		cylinder(r=1.7,h=50);	
		translate([20,-33.75-37.5,220])
		cylinder(r=1.7,h=50);	
	}


	difference(){
		color([0.7, 0.7, 0.9, 0.5]) 
		translate([0,-sheet_thickness-slide_width,backplate_height])
		rotate([-90,0,0])
		slidefront();

		translate([275,-111,220]) rotate([90,0,0])
		frontplate_holes();
	}

	difference(){
		color([0.7, 0.7, 0.9, 0.5]) 
		elecfront();
		translate([sheet_thickness+2,-100,400-85])
		rotate([90,0,0])
		newheaven_lcd_holes();
		translate([100,-100,250])
		rotate([90,0,0])
		rot_encoder_holes();
		translate([57,-100,230+sheet_thickness+16])
		rotate([90,0,0])
		cylinder(r=9,h=100);
		translate([195,-60,230+15])
		rotate([0,0,-90])
		firgelli30mm_holes();
		// holes to mount front piece
		translate([sheet_thickness+12,-100,400-sheet_thickness-6])
		rotate([90,0,0])
		cylinder(r=2, h=100);		
		translate([100,-100,230+sheet_thickness+6])
		rotate([90,0,0])
		cylinder(r=2, h=100);		
	}

	translate([245,sheet_thickness,239])
	rotate([-90,0,0])
	rotate([0,0,180])
	opto_pcb_holder();

	translate([119,sheet_thickness,237])
	rotate([-90,0,0])
	belt_protector_spacer();
	translate([137.2,sheet_thickness,294])
	rotate([-90,0,0])
	belt_protector_spacer();
	translate([314.1,sheet_thickness,204.7])
	rotate([-90,0,0])
	belt_protector_spacer();

	color([0.7, 0.7, 0.9, 0.5]) 
	translate([105,sheet_thickness*2+24,273])
	rotate([0,18,0])	
	rotate([90,0,0])
	translate([0,-50,0])
	difference(){
		beltplate();	
		beltplate_holes();
	}

	color([0.7, 0.7, 0.9, 0.5]) 
	sideplateleft();

	color([0.7, 0.7, 0.9, 0.5]) 
	sideplateright();


}

	

//---------------------------------------------------------------------------------------
//____________SHEETS ________________________________
//-------------------------------------------------------------------------------------.
//
//$fn=50;
//projection(cut = true) {
//	translate([0,0,-1])
//	bottomplate();
//	
//	//projection(cut = true) 
//	translate([0,1,sheet_thickness-1])
//	rotate([-90,0,0])
//	difference(){
//		backplate();
//	
//		translate([275-118,-2,259])
//		rotate([-90,0,0])
//		stepper_holes();
//		translate([275-118.5,-2,259])
//		rotate([-90,0,0])
//		stepper_holes();
//		translate([275-119,-2,259])
//		rotate([-90,0,0])
//		stepper_holes();
//		translate([275-119.5,-2,259])
//		rotate([-90,0,0])
//		stepper_holes();
//		translate([275-120,-2,259])
//		rotate([-90,0,0])
//		stepper_holes();
//		translate([275-120.5,-2,259])
//		rotate([-90,0,0])
//		stepper_holes();
//		translate([275-121,-2,259])
//		rotate([-90,0,0])
//		stepper_holes();
//		translate([275-121.5,-2,259])
//		rotate([-90,0,0])
//		stepper_holes();
//		translate([275-122,-2,259])
//		rotate([-90,0,0])
//		stepper_holes();
//		translate([275-122.5,-2,259])
//		rotate([-90,0,0])
//		stepper_holes();
//		translate([275-123,-2,259])
//		rotate([-90,0,0])
//		stepper_holes();
//	
//		// opto_mount_hole
//		translate([275-54,20,220+18.5])
//		rotate([90,0,0])
//		cylinder(r=1.7,h=100);
//		// opto_wire_hole
//		translate([205,20,245])
//		rotate([90,0,0])
//		cylinder(r=5,h=100);
//		
//		translate([sheet_thickness,0,400-85])
//		rotate([90,0,0])
//		arduino_uno_holes();
//		translate([85,0,280])
//		rotate([90,0,0])
//		vac_sensor_pcb_holes();	
//		color([0.7, 0.7, 0.9, 0.5]) 
//		translate([105,25,273])
//		rotate([0,18,0])	
//		rotate([90,0,0])
//		translate([0,-50,0])	
//		beltplate_holes();
//	}
//	
//	translate([0,1,-1])
//	rotate([0,-90,0])
//	sideplateleft();
//	
//	translate([401,1,0-1])
//	rotate([0,90,0]) 
//	translate([-400,0,0])
//	sideplateright();
//	
//	translate([0,402,0-1])
//	rotate([180,0,0]) 
//	translate([0,0,-400])
//	electop();
//	
//	translate([0,1,-1])
//	rotate([0,-90,0])
//		difference(){
//			elecleft();
//			translate([10,-15,230+sheet_thickness+16])
//			rotate([0,-90,0])
//			cylinder(r=9,h=50);
//			translate([10,-15-37.5,230+sheet_thickness+16])
//			rotate([0,-90,0])
//			cylinder(r=9,h=50);
//			translate([10,-15-75,230+sheet_thickness+16])
//			rotate([0,-90,0])
//			cylinder(r=9,h=50);
//			translate([sheet_thickness,-2,400-85])
//			rotate([90,0,0])
//			arduino_uno_holes();
//		}
//	
//	translate([0,-320,0-1])
//	rotate([0,0,0]) 
//	translate([0,110,-230])
//		difference(){
//			elecbottom();
//			translate([195,-60,230+15])
//			rotate([0,0,-90])
//			firgelli30mm_holes();
//			translate([20,-33.75,220])
//			cylinder(r=1.7,h=50);	
//			translate([20,-33.75-37.5,220])
//			cylinder(r=1.7,h=50);	
//		}
//	
//	translate([600,-0,-1])
//	leftslide();
//	
//	translate([600,-110,-1]) 
//	rightslide();
//	
//	translate([600,112,sheet_thickness-2]) 
//	rotate([-90,0,0]) 
//	translate([0,110,-230])
//		difference(){
//			translate([0,-sheet_thickness-slide_width,backplate_height])
//			rotate([-90,0,0])
//			slidefront();
//	
//			translate([275,-111,220]) rotate([90,0,0])
//			frontplate_holes();
//		}
//	
//	translate([500,112,sheet_thickness-2]) 
//	rotate([-90,0,0]) 
//	translate([0,110,-230])
//		difference(){ 
//			elecfront();
//			translate([sheet_thickness,-100,400-85])
//			rotate([90,0,0])
//			newheaven_lcd_holes();
//			translate([100,-100,250])
//			rotate([90,0,0])
//			rot_encoder_holes();
//			translate([57,-100,230+sheet_thickness+16])
//			rotate([90,0,0])
//			cylinder(r=9,h=100);
//			translate([195,-60,230+15])
//			rotate([0,0,-90])
//			firgelli30mm_holes();
//			// holes to mount front piece
//			translate([sheet_thickness+12,-100,400-sheet_thickness-6])
//			rotate([90,0,0])
//			cylinder(r=2, h=100);		
//			translate([100,-100,230+sheet_thickness+6])
//			rotate([90,0,0])
//			cylinder(r=2, h=100);		
//		}
//
//	translate([-300,50,0])
//	difference(){
//		beltplate();	
//		beltplate_holes();
//	}
//
//}


//---------------------------------------------------------------------------------------
//____________PRINT ________________________________
//-------------------------------------------------------------------------------------.


//frontplate();
sled();
//opto_pcb_holder();
//rotor();
//belt_protector_spacer();

//difference(){
//cylinder(r=10.5,h=28);
//translate([0,0,3])
//cylinder(r=7.7,h=100);
//translate([0,0,-1])
//cylinder(r=4.5,h=100);
//}


