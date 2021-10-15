showSwitchCut=true;
showSwitch=true;
showKeyCap=false;
showSpaceBox=false;
fullboard=false;
space=19.04;
switchType="MX"; // ["MX","choc"]

/*[Cherry MX settings]*/
cherryCutOutSize=13.9954;
cherrySize=14.58;

/*[Keeb]*/
keyCols = 14;
keyRows = 6;
keySpace = space-cherrySize;
edgeSpaceAddition = 3;
edgeSpace = (edgeSpaceAddition*2)-keySpace;
keyZ = -1;

$fn=30;
$fs=0.15;
mSize=3;
moduleZ = 3;
moduleX = size(keyCols);
moduleY = size(keyRows);
keyboardHeight=6.5; // 6.5 for MX, 3.7 for choc

/*[ Printer settings ]*/
showPrintBox=false;
printerSize=[140,140,140];

// mX: h=mX-1, d= X*(1+((1/3)*2))
function mNutH(m) = m-1;
function mNutD(m) = m*(1+((1/3)*2));
function mNutDHole(m) = mNutD(m)+2;
function mScrewheadH(m) = m-1;
function mScrewheadD(m) = m+2.5; // This is most probably not correct, but works for m3

          
function position(x,y,z) = [space*(x-1), space*(y-1), z];

function size(q) = (keySpace*q)
                        +cherrySize
                        *(q-1)
                        +cherrySize;
function Qsize(q) = (edgeSpace+edgeSpaceAddition)
              +(keySpace*q)
              +cherrySize
              *(q-1)
              +cherrySize;
          



module ooo(r=2){
  offset(r)offset(-r*2)offset(r)children();
}

// ---- Keyboard basics ----
module mxSwitchCut(x=cherryCutOutSize/1.5,y=cherryCutOutSize/1.5,z=0,rotateCap=false){
  capRotation = rotateCap ? 90 : 0;
  d=14.05;
  p=14.58/2+0.3;
  translate([x,y,z]){
    translate([0,0,-3.7])
    rotate([0,0,capRotation]){
      difference(){
        cube([d,d,10], center=true);
        translate([d*0.5,0,0])cube([1,4,12],center=true);
        translate([-d*0.5,0,0])cube([1,4,12],center=true);
      }


      translate([0,-(p-0.6),1.8]) rotate([-10,0,0]) cube([cherryCutOutSize/2,1,1.6],center=true);
      translate([0,-(p-0.469),-1.95]) cube([cherryCutOutSize/2,1,6.099],center=true);

      translate([0,(p-0.6),1.8]) rotate([10,0,0]) cube([cherryCutOutSize/2,1,1.6],center=true);
      translate([0,(p-0.469),-1.95]) cube([cherryCutOutSize/2,1,6.099],center=true);
    }
  }
}

module chocCut(){
  union(){
    cube([14,14,moduleZ*2],center=true);
    translate([0,14/4,-1])cube([15,4,moduleZ],center=true);
    translate([0,-14/4,-1])cube([15,4,moduleZ],center=true);
  }
}


module repeated (yStart, yEnd, xStart, xEnd, yStep=1, xStep=1){
  union(){
    for(y = [yStart:yStep:yEnd]){
      for(x = [xStart:xStep:xEnd]){
        translate(position(x,y,0)) children();
      }
    }
  }
}

module roundedCube(size=[1,1,1], center=false, r=0.5){
  tMin = r;
  txMax = size[0] - r;
  tyMax = size[1] - r;
  tzMax = size[2] - r;
  
  cent = center ? [-(txMax/2+r/2),-(tyMax/2+r/2),-(tzMax/2+r/2)] : [0,0,0];
  
  translate(cent)  
  hull(){
    translate([tMin,tMin,tMin])sphere(r=r);
    translate([tMin,tMin,tzMax])sphere(r=r);
    

    translate([txMax,tMin,tMin])sphere(r=r);
    translate([txMax,tMin,tzMax])sphere(r=r);
    
    
    translate([tMin,tyMax,tMin])sphere(r=r);
    translate([tMin,tyMax,tzMax])sphere(r=r);
    
    translate([txMax,tyMax,tMin])sphere(r=r);
    translate([txMax,tyMax,tzMax])sphere(r=r);
    
  }
}

///////////////////////////////
//  This
//////////////////////////////

module switchCut(){
  if(switchType == "MX"){
    mxSwitchCut();
  } else if(switchType == "choc") {
    translate([9.5,9.5,-moduleZ])chocCut();
  }
}
module switch(){
  if(switchType == "MX"){
    translate([9.5,9.5,15.15])import("switch_mx.stl");
  } else if(switchType == "choc") {
    translate([9.5,9.5,1.3])rotate([0,0,90])import("choc.stl");
  }
}

module keyCap(){
  if(switchType == "MX"){
    translate([9.5,9.5,7])import("keycap_mx.stl");
  } else if(switchType == "choc") {
//    translate([0,0,-2.0])
    translate([9.5,9.5,6.1])rotate([0,0,0])import("keycap_mbk.stl");
  }
}

module mounting(height=10){
  difference(){
    cylinder(d=mSize+3, h=height);
    translate([0,0,-1])cylinder(d=mSize, h=height+2);
  }
}

module keyPlacement(){
    repeated(0,3,1,2)children();
    repeated(0.25,3.25,3,3)children();
    repeated(1.35,3.35,4,4)children();
    repeated(1.25,3.25,5,5)children();
    repeated(1.1,3.1,6,6)children();
    
    translate([size(3.5),-size(0.8),0])children();
    translate([size(4.47),-size(0.8),0])rotate([0,0,-15])children();
    translate([size(5.57),-size(0.83),0])rotate([0,0,-30])children();
//  translate([size(5.57),-size(0.82),0])rotate([0,0,-30])children();
}

module holePlacement(){
  translate([size(1),size(0),0])children();
  translate([size(1),size(2),0])children();
  
//  translate([size(3.3),size(0),0])children();
//  translate([size(2.95),size(2.24),0])children();
  
  translate([size(5.7),size(0),0])children();
  translate([size(5),size(2.14),0])children();
}


module plateNoCuts(){
  union(){
    keyPlacement()square([size(1),size(1)]);
    translate([size(3),-size(0.82),0])square([size(3),size(1.2)]);
    translate([size(5.33),-size(0.82),0])
      rotate([0,0,20])
      square([size(1),size(1)]);
            
    translate([size(5.4005),-size(1.0495),0])
      rotate([0,0,-14.61])
      square([size(1.07),size(1)]);
  }
  
}
module cableGutter(h=10,rotate=false){
  hh = h > 6 ? h-2 : h-0.3; 
  echo(hh);
  if(rotate){
    union()translate([-0.5,-size(0.5),-(h/2)+1])rotate([0,0,90]){
      translate([0,1.1,0])cube([size(0.5),1,hh],center=true);
      translate([0,-1.5,0])cube([size(0.5),1,hh],center=true);
    }
  } else {
    union()translate([size(0.5),0,-(h/2)+1]){
      translate([0,1.1,0])cube([size(0.5),1,hh],center=true);
      translate([0,-1.5,0])cube([size(0.5),1,hh],center=true);
    }
  }
}

module plate(h=10){
  color([0.7,1,0.5]){
    difference(){
      translate([0,0,keyZ])linear_extrude(moduleZ)ooo()plateNoCuts();
      union(){
        translate([0,0,moduleZ])keyPlacement()switchCut();
      }
      holePlacement()translate([0,0,-h])cylinder(d=mSize,h=h);
    }
    
    translate([0,0,-h])holePlacement()mounting(h);
    
    
    
    translate([size(1),size(1),0])cableGutter(h);
    translate([size(2),size(1.25),0])cableGutter(h);
    translate([size(3),size(1.35),0])cableGutter(h);
    translate([size(4),size(1.25),0])cableGutter(h);
    translate([size(5),size(1.1),0])cableGutter(h);
  }
//  %holePlacement()translate([0,0,-h])cylinder(d=mSize,h=h);
  if(showSwitch){
    color([0.7,1,1])
    keyPlacement()switch();
  }
  if(showKeyCap){
    color([1,0.7,0.7])
    keyPlacement()keyCap();
  }
}

module bottom(){
  module socketHolder(){
    union(){
      cube([10,6,5]);
      translate([0,0,4])cube([10,1.3,3]);
      translate([0,6-1.3,4])cube([10,1.3,3]);
    }
  }
  module socketLegHoles(){
    for(i = [0:1:11]){
      translate([0,i*2.54,0])cylinder(d=1,h=3.2);
    }
  }
  
  module socketLegHole(){
    translate([0,0,0])socketLegHoles();
    translate([size(0.809),0,0])socketLegHoles();
  }
  
  module socketHolderHoles(){
    translate([-4,0.45,0])cylinder(d1=mScrewheadD(mSize),d2=mSize,h=moduleZ+0.2);
    
    translate([0,size(1)-7.6,0])cylinder(d1=mScrewheadD(mSize),d2=mSize,h=moduleZ+0.2);
   
  }
  
  difference(){
    translate([0,0,keyZ])linear_extrude(moduleZ)ooo()union(){
      plateNoCuts();
      translate([size(5.993),-size(0.454),0]){
        square([size(1),size(3.554)]);
      }
    }
    translate([0,0,-1.1])holePlacement()cylinder(d1=mScrewheadD(mSize),d2=mSize,h=moduleZ+0.2);
   
    
    translate([size(6.6208),size(-1),-moduleZ])
    rotate([0,0,-30])cube([size(1),size(3),moduleZ*2]);
    
    translate([size(6.53),size(1)+1.04,-1.1])socketHolderHoles();
    translate([size(6.125),size(1.265),1.55])socketLegHole();
    
    translate([size(6.47),-2.4,1.2])cube([9.5,20.8,10]);

  }
  

}

module socketHolder(blank=false){
  z=7.1;
  d=-1.75;
  module screwCube(){
    translate([-4,-18.25,d])cube([5,5,z],center=true);
    translate([0,-17.25,d])cube([10,3,z],center=true);
  }
  module cubeHole(){
          translate([-4,-18,-7])cylinder(d=mSize,h=6);
  }
  if(blank){
    difference(){
      union(){
        screwCube();
        translate([0,-9,-z+2.3])cube([10,16,1],center=true);
        translate([0,-7,-8.2])cylinder(d=mSize-0.2,h=moduleZ);
      }
      cubeHole();
    }    
  }else {
    difference(){
      union(){
        translate([0,-7,d])cube([10,10,z],center=true);
        screwCube();
        translate([0,0,1.3])cube([10,32,1],center=true);
      }
      translate([0,-7,-7])cylinder(d=mSize,h=6);
      cubeHole();
    }
  }
}

module IDCHolder(x=10,y=20,z=10,hollow=true){
  difference(){
    cube([x,y,z]);
    if(hollow){
      translate([-1,2,-1])cube([x+2,y-4,z-1]);
      translate([1,1,-1.5])cube([x-2,y-2,z]);
    }
  }
}

module screw(size=mSize,h=10){
  difference(){
    union(){
      cylinder(d1=mScrewheadD(size),d2=size,h=mScrewheadH(size));
      cylinder(d=size,h=h);
    }
    cube([1,10,1],center=true);
  }
}

module screws(blank=false){ 
  translate([0,0,-1.1])holePlacement()screw();
  translate([size(6.32),size(1)+1.5,-1.1])screw();
  if(!blank){
    translate([size(6.53),size(2)-6.5,-1.1])screw();
  }
}

module socketAndIDC(blank=false){
  union(){
    translate([size(0.0), 0, 0])IDCHolder(11,22.8,9.9);
    translate([size(0.1), size(2)+3.47, 5.3])socketHolder(blank);
  }
}

///////////////////////////////
//  Render
//////////////////////////////

module left(blank,switches,height){
//  color([1,0,1])bottom();

  translate([size(6.43),-3,2])
  color([0.3,1,0.8])
  socketAndIDC(blank);

  translate([size(6.53),size(2),7.5]){
    if(!blank){
        color([0.5,0.3,0.2])rotate([0,0,180])import("socket.stl");
        color([0.2,0.5,0.5])translate([0,0,2.5])import("proMicro.stl");
    }
      translate([3.6,-30,-1.5])rotate([90,180,90])import("IDC_2x5p.stl");  
  }

  translate([0,0,moduleZ+height-1])plate(height);

//  screws(blank);
}

left(false,false,keyboardHeight);
//translate([size(16),0,0])mirror([1,0,0])left(true,false,keyboardHeight);



//bottom();
//mirror([1,0,0])bottom();
//socketAndIDC(false);
//mirror([1,0,0])socketAndIDC(true);
//plate(keyboardHeight);
//mirror([1,0,0])plate(keyboardHeight);
