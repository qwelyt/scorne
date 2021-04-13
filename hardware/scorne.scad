showSwitchCut=true;
showSwitch=true;
showKeyCap=false;
showSpaceBox=false;
fullboard=false;
space=19.04;

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
          
moduleX = size(keyCols);
moduleY = size(keyRows);
moduleZ = 3;


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



module repeated (yStart, yEnd, xStart, xEnd, yStep=1, xStep=1){
  union(){
    for(y = [yStart:yStep:yEnd]){
      for(x = [xStart:xStep:xEnd]){
        translate(position(x,y,keyZ)) children();
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
    
    translate([size(3.5),-size(0.8),keyZ])children();
    translate([size(4.47),-size(0.8),keyZ])rotate([0,0,-15])children();
    translate([size(5.57),-size(0.82),keyZ])rotate([0,0,-30])children();
}

module holePlacement(){
  translate([size(1),size(0),0])children();
  translate([size(1),size(2),0])children();
  
//  translate([size(3.3),size(0),0])children();
//  translate([size(2.95),size(2.24),0])children();
  
  translate([size(5.7),size(0),0])children();
  translate([size(5),size(2.14),0])children();
}

module cornerchamfer(dir="LL",l=2,h=moduleZ*2){
  if(dir=="LL"){
    translate([-0.05,-0.05,-h/2]){
      difference(){
        cube([l,l,h]);
        translate([l,l,-1])cylinder(d=l*2,h=h+2);
      }
    }
  } else if(dir == "UL") {
    translate([-0.05,-l+0.05,-h/2]){
      difference(){
        cube([l,l,h]);
        translate([l,0,-1])cylinder(d=l*2,h=h+2);
      }
    }
  } else if(dir == "LR") {
    translate([-l+0.05,-0.05,-h/2]){
      difference(){
        cube([l,l,h]);
        translate([0,l,-1])cylinder(d=l*2,h=h+2);
      }
    }
  } else if(dir == "UR") {
    translate([-l+0.05,0.05,-h/2]){
      difference(){
        cube([l,l,h]);
        translate([0,0,-1])cylinder(d=l*2,h=h+2);
      }
    }
  }
}

module plateNoCuts(){
  union(){
    difference(){
      union(){
        keyPlacement()cube([size(1),size(1),moduleZ]);
        
        translate([size(3),-size(0.82),keyZ])cube([size(3),size(1.2),moduleZ]);
          
        translate([size(5.33),-size(0.82),keyZ])
          rotate([0,0,20])
          cube([size(1),size(1),moduleZ]);
          
        translate([size(5.4005),-size(1.0495),keyZ])
          rotate([0,0,-14.61])
          cube([size(1.07),size(1),moduleZ]);
      }
      translate([size(4.3),-size(1.792),-moduleZ])
          rotate([0,0,-14.8])
          cube([size(2),size(1),moduleZ*2]);
        
      
      translate([0,-size(1),0])cornerchamfer("LL");
      translate([size(3),-size(0.82),0])cornerchamfer("LL",l=1);
      
      
      
      translate([0,size(3),0])cornerchamfer("UL");
      translate([size(2),size(3.25),0])cornerchamfer("UL");
      translate([size(3),size(3.35),0])cornerchamfer("UL",l=1.3);
      
      translate([size(2),-size(1),0])cornerchamfer("LR");
      translate([size(6.449),-size(1.332),0])rotate([0,0,-20])cornerchamfer("LR");
      
      translate([size(4),size(3.2792),0])cornerchamfer("UR",l=1.3);
     translate([size(4.998),size(3.17),0])cornerchamfer("UR",l=1.5);
    }
    
    translate([size(2),-size(0.75),0.5])cornerchamfer("UL",h=moduleZ);
    translate([size(3),-size(0.804),0.5])difference(){
      cornerchamfer("UR",l=1,h=moduleZ);
      translate([0,-0.6,-3])cube([1,1,moduleZ+2]);
    }
    
    translate([size(2),size(3),0.5])cornerchamfer("LR",h=moduleZ);
    translate([size(3),size(3.25),0.5])cornerchamfer("LR",l=1.2,h=moduleZ);
    translate([size(3.9988),size(3.25),0.5])cornerchamfer("LL",l=1.2,h=moduleZ);
    translate([size(5.002),size(3.1),0.5])cornerchamfer("LL",l=1.5,h=moduleZ);
    
  }
}
module cableGutter(h=10,rotate=false){
  if(rotate){
    union()translate([-0.5,-size(0.5),-(h/2)+1])rotate([0,0,90]){
      translate([0,1.1,0])cube([size(0.5),1,h-2],center=true);
      translate([0,-1.5,0])cube([size(0.5),1,h-2],center=true);
    }
  } else {
    union()translate([size(0.5),0,-(h/2)+1]){
      translate([0,1.1,0])cube([size(0.5),1,h-2],center=true);
      translate([0,-1.5,0])cube([size(0.5),1,h-2],center=true);
    }
  }
}

module plate(h=10,switches=true){
  color([0.7,1,0.5]){
    difference(){
      plateNoCuts();
      translate([size(6),size(3),0])cornerchamfer("UR");
      union(){
        translate([0,0,moduleZ])keyPlacement()mxSwitchCut();
      }
      holePlacement()translate([0,0,-h-2.5])cylinder(d=mSize,h=10);
    }
    translate([0,0,-h])holePlacement()mounting(h);
    
    translate([size(1),size(1),0])cableGutter(h);
    translate([size(2),size(1.25),0])cableGutter(h);
    translate([size(3),size(1.35),0])cableGutter(h);
    translate([size(4),size(1.25),0])cableGutter(h);
    translate([size(5),size(1.1),0])cableGutter(h);
    
    translate([size(2),size(1),0])cableGutter(h,true);
    translate([size(2),size(2.2),0])cableGutter(h,true);
    translate([size(3),size(1.25),0])cableGutter(h,true);
    translate([size(3),size(2.25),0])cableGutter(h,true);
    translate([size(4),size(1.35),0])cableGutter(h,true);
    translate([size(4),size(2.35),0])cableGutter(h,true);
    translate([size(5),size(1.1),0])cableGutter(h,true);
//    translate([size(5),size(2.25),0])cableGutter(h,true);

  }
  if(switches){
    color([0.7,1,1])
    keyPlacement()translate([9.5,9.5,16.15])import("switch_mx.stl");
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
    cylinder(d1=mScrewheadD(mSize),d2=mSize,h=moduleZ+0.2);
    
    translate([0,size(1)-8,0])cylinder(d1=mScrewheadD(mSize),d2=mSize,h=moduleZ+0.2);
   
  }
  
  difference(){
    union(){
      plateNoCuts();
      translate([size(5.993),-size(0.454),keyZ]){
        cube([size(1),size(3.554),moduleZ]);
      }
    }
    translate([0,0,-1.1])holePlacement()cylinder(d1=mScrewheadD(mSize),d2=mSize,h=moduleZ+0.2);
   

    
    translate([size(6.991),size(2.993),0])cornerchamfer("UR");
    
    translate([size(6.6208),size(-1),-moduleZ])
    rotate([0,0,-30])cube([size(1),size(3),moduleZ*2]);
    
    translate([size(6.53),size(1)+1.04,-1.1])socketHolderHoles();
    translate([size(6.125),size(1.265),1.55])socketLegHole();
    
    translate([size(6.47),-3.4,1.2])cube([9.5,20.8,10]);

  }
  

}

module socketHolder(blank=false){
  z=7.1;
  d=-1.75;
  if(blank){
    difference(){
      union(){
        translate([0,-18,d])cube([10,5.5,z],center=true);
        translate([0,-9,-z+2.3])cube([10,16,1],center=true);
        translate([0,-7,-8.2])cylinder(d=mSize-0.2,h=moduleZ);
      }
      translate([0,-18,-7])cylinder(d=mSize,h=6);
    }    
  }else {
    difference(){
      union(){
        translate([0,-7,d])cube([10,10,z],center=true);
        translate([0,-18,d])cube([10,5.5,z],center=true);
        translate([0,0,1.3])cube([10,32,1],center=true);
      }
      translate([0,-7,-7])cylinder(d=mSize,h=6);
      translate([0,-18,-7])cylinder(d=mSize,h=6);
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
  translate([size(6.53),size(1)+1.04,-1.1])screw();
  if(!blank){
    translate([size(6.53),size(2)-7,-1.1])screw();
  }
}

module socketAndIDC(blank=false){
  translate([size(0.0), 0, 0])IDCHolder(11,22.8,9.9);
  translate([size(0.1), size(2)+4.5, 5.3])socketHolder(blank);
}

///////////////////////////////
//  Render
//////////////////////////////

module left(blank){
//  color([1,0,1])bottom();
//  translate([size(6.43),-4.5,2])socketAndIDC(blank);

//color([0.9,0.7,0.4])translate([size(6.43),-4.5,2])IDCHolder(11,22.8,9.9);
//
//color([0.7,0.7,0.1])
//translate([size(6.53),size(2),7.3])socketHolder();

//  translate([size(6.53),size(2),7.5]){
//    if(!blank){
//        color([0.5,0.3,0.2])rotate([0,0,180])import("socket.stl");
//        color([0.2,0.5,0.5])translate([0,0,2.5])import("proMicro.stl");
//    }
//      translate([3.6,-31.1,-1.5])rotate([90,180,90])import("IDC_2x5p.stl");  
//  }
  difference(){
    translate([0,0,moduleZ+5.5])plate(6.5,false);
    color([0.9,0.7,0.4])translate([size(6.42),-4.6,2])IDCHolder(11,22.8,9.9,false);
  }

//  screws(blank);
}

//left(false);
translate([size(16),0,0])mirror([1,0,0])left(true);