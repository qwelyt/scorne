/*[How big of a socket]*/
pinsPerSide=12;
/*[Probably don't touch]*/
pinWidth=2.54;
$fn=30;


module pinHold(pins=12){
  difference(){
    cube([3.48, pinWidth, 2.8],center=true);
    translate([-0.6,0,0]){
      cylinder(d=1,h=10,center=true);
      translate([0,0,1.01])cylinder(d1=1,d2=1.9,h=0.8,center=true);
    }
  }
  translate([-0.6,0,-2.04])cylinder(d=1.35,h=1.3,center=true);
  translate([-0.6,0,-4.289])cylinder(d=0.5,h=3.2,center=true);
}

module side(pins=12,center=true){
  y = center ? -(((pins-1)*pinWidth)/2) : 0;
  translate([0,y,0]){
    for(i = [0:1:pins-1]){
      translate([0,i*pinWidth,0])pinHold();
    }
  }
}

module socket(pins=12){
  mov = pinWidth/2*pins-1.4;

  union(){
    translate([-7.086,0,0])side(pins);
    translate([7.086,0,0])mirror([1,0,0])side(pins);
    
    translate([0,mov-0.38,-0.5]){
      difference(){
        cube([11,2.8,1.8],center=true);
        translate([0,0,0.8])rotate([0,0,180])linear_extrude(0.2)text(str(pins*2),valign="center",halign="center",size=2);
      }
      translate([4.3,0,0.8])cylinder(d=1.48,h=0.8);
      
      
    }
    if(pins>6){
      translate([0,0,-0.5])cube([11,2.8,1.8],center=true);
    }
    
    translate([0,-mov,-0.5]){
      difference(){
        cube([11,2.8,1.8],center=true);
        translate([2.3,-1.5,0])cylinder(d=2.3,h=10,center=true);
      }
      translate([4.3,0,0.8])cylinder(d=1.48,h=0.8);
    }
  }
}

socket(pinsPerSide);

