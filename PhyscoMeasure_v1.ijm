//Physcomitrella Thick Thin Area Treshholder v1
//Simon Fraas - Quintlab MLU Halle
requires("1.51n");
//Prepare image create flat RGB
if (is("composite")==true) {
run("Stack to Images");
run("Merge Channels...", "c1=Red c2=Green c3=Blue");
	}
//Make a copy to work with
run("Duplicate...", " ");

//Prepare analysis
run("Set Measurements...", "area mean min perimeter fit shape feret's area_fraction redirect=None decimal=3");
roiManager("reset");
//Prepare for edge analysis 
run("Gaussian Blur...", "sigma=2");
run("Find Edges");
rename("outer");
run("Duplicate...", " ");
rename("inner");

selectWindow("outer");
// Color Threshold Outer Area
min=newArray(3);
max=newArray(3);
filter=newArray(3);
a=getTitle();
run("HSB Stack");
run("Convert Stack to Images");
selectWindow("Hue");
rename("0");
selectWindow("Saturation");
rename("1");
selectWindow("Brightness");
rename("2");
min[0]=128;
max[0]=255;
filter[0]="pass";
min[1]=0;
max[1]=255;
filter[1]="pass";
min[2]=8;
max[2]=255;
filter[2]="pass";
for (i=0;i<3;i++){
  selectWindow(""+i);
  setThreshold(min[i], max[i]);
  run("Convert to Mask");
  if (filter[i]=="stop")  run("Invert");
}
imageCalculator("AND create", "0","1");
imageCalculator("AND create", "Result of 0","2");
for (i=0;i<3;i++){
  selectWindow(""+i);
  close();
}
selectWindow("Result of 0");
close();
selectWindow("Result of Result of 0");
rename(a);
// Colour Thresholding------------
wait(159);
selectWindow("inner");
// Color Threshold Inner Area
min=newArray(3);
max=newArray(3);
filter=newArray(3);
a=getTitle();
run("HSB Stack");
run("Convert Stack to Images");
selectWindow("Hue");
rename("0");
selectWindow("Saturation");
rename("1");
selectWindow("Brightness");
rename("2");
min[0]=0;
max[0]=128;
filter[0]="pass";
min[1]=0;
max[1]=255;
filter[1]="pass";
min[2]=8;
max[2]=255;
filter[2]="pass";
for (i=0;i<3;i++){
  selectWindow(""+i);
  setThreshold(min[i], max[i]);
  run("Convert to Mask");
  if (filter[i]=="stop")  run("Invert");
}
imageCalculator("AND create", "0","1");
imageCalculator("AND create", "Result of 0","2");
for (i=0;i<3;i++){
  selectWindow(""+i);
  close();
}
selectWindow("Result of 0");
close();
selectWindow("Result of Result of 0");
rename(a);
// Colour Thresholding-------------

//Particle analysis to capture areas
selectWindow("outer");
run("Analyze Particles...", "size=10000-Infinity circularity=0.0-1.00 show=Outlines add");

selectWindow("inner");
run("Analyze Particles...", "size=10000-Infinity circularity=0.0-1.00 show=Outlines add");

//Merging drawn outlines of outer and inner
imageCalculator("AND create", "Drawing of outer","Drawing of inner");
close("Drawing of inner");
close("Drawing of outer");
close("inner");
close("outer");
//Message
showMessage("Done - select ROIs from ROI Manager and hit m to measure");
run("Tile");
selectWindow("ROI Manager");
exit();