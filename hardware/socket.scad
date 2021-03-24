$fn=30;

translate([-7.025,0,0])cube([3.6, 30.5, 2.8],center=true);
translate([7.025,0,0])cube([3.6, 30.5, 2.8],center=true);


translate([0,13.85,-0.5])cube([17.65,2.8,1.8],center=true);
translate([0,0,-0.5])cube([17.65,2.8,1.8],center=true);
translate([0,-13.85,-0.5])difference(){
  cube([17.65,2.8,1.8],center=true);
  translate([2.3,-1.5,0])cylinder(d=2.3,h=10,center=true);
}