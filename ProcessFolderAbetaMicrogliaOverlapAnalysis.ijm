/*
 * Macro template to process multiple images in a folder
 */

#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix

// See also Process_Folder.py for a version of this code
// in the Python scripting language.

processFolder(input);

// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i]);
	}
}

function processFile(input, output, file) {
	// Do the processing here by adding your own code.
	// Leave the print statements until things work, then remove them.
	print("Processing: " + input + File.separator + file);
	//print(input)
	print("input;" + input);
	print("filesep" + File.separator);
	print("file" + file);
	
	
	overlay_analysis(input, output, file);
	
	
	print("Saving to: " + output);
}


function overlay_analysis(input, output, file) {
open(input + File.separator + file);
	//remove previous scales
//dir = getDirectory("image");
//open(dir)
run("Set Scale...", "distance=0 known=0 global");


run("Gaussian Blur...", "sigma=1 stack");
run("Subtract Background...", "rolling=40 sliding stack");
//TODO rename these to something appropriate for your objects
redObject = "GFAP Red Object";
blueObject = "X04 Blue Object";
greenObject = "Iba1 Green Object";

// split images
title = getTitle();
run("Split Channels");

// cache channel names
selectImage("C1-" + title);
greenImage = getTitle();
selectImage("C2-" + title);
blueImage = getTitle();
selectImage("C3-" + title);
redImage = getTitle();

// general preprocessing
//TODO If you need to do any high-level image processing, do so here.
//          For example, you may want to run the imageCalculator to limit the search
//          scope of an image to regions of overlap.
imageCalculator("AND create", greenImage, blueImage);

selectImage("Result of " + greenImage);
greenandblueImage = getTitle();
splitunderscoreImage = split(greenImage, "_");   // filename without suffix.
filename1 = splitunderscoreImage[0];  // slide No.
filename2 = splitunderscoreImage[1];  // ID
filestem = split(greenImage , ".");
filestem = filestem[0];
index = split(filestem, "_");
print(index.length);
region1 = index[index.length -1];  //region
filename = filename1 + "_" + filename2 + "_" + region1;
print(filename1 + "_" + filename2 + "_" + region1);
setAutoThreshold("Triangle dark");
run("Convert to Mask");
run("Close-");
run("Analyze Particles...", "size=20-Infinity  show=Outlines display clear summarize add");
// Add filename to columns
for(i=0; i<nResults; i++) {
	setResult("Filename", i, filename2);
	setResult("Region", i, region1);
}

blueANDgreen=  "blueANDgreen" + "_"+ ".csv";
selectWindow("Summary");

summary_BlueANDGreen = "Summary_blue_and_green" + "_" + filename +".csv";
result_BlueANDGreen = "Result_blue_and_green" + "_" +  filename +".csv";
ROI_BlueANDGreen = "Roi_blue_and_green" +  "_" +  filename + ".jpg";
saveAs("Results", output + File.separator +summary_BlueANDGreen);
selectWindow("Results");
saveAs("Results", output + File.separator +result_BlueANDGreen );

roiManager("Show All");
run("Flatten");
saveAs("Jpeg", output + File.separator +ROI_BlueANDGreen);
run("Close");
	
roiManager("delete");    // To be more simply
print("close the result window");
selectWindow("Results"); 
close("Results");
selectImage("Result of " + greenImage);
close();
selectImage("Drawing of Result of " + greenImage);
close();
selectWindow(summary_BlueANDGreen); 
run("Close");


// BLUE channel
selectImage(blueImage);
// Preprocessing - BLUE channel

// TODO Use the threshold that best fits your data (AutoThreshold > Try all_
// Minimum threshold is fairly aggressive, so it's helpful to Dilate after thresholding


setAutoThreshold("Triangle dark");
wait(10);
run("Convert to Mask");
//run("Despeckle");
// Analysis - BLUE channel

// TODO Analyze Particles allows specification of particle size, roundness, and other options.
//           Adjust these parameters to best fit your data
run("Analyze Particles...", "size=20-Infinity  show=Outlines display clear summarize add");
blue=  "blue" + "_"+ ".csv";
selectWindow("Summary");
summary_Blue = "Summary_blue" + "_" + filename + ".csv";
result_Blue = "Result_blue" + "_" +  filename +".csv";
ROI_Blue = "Roi_blue" + "_" + filename + ".jpg";
saveAs("Results", output + File.separator +summary_Blue);
selectWindow("Results");
saveAs("Results", output + File.separator + result_Blue);


blueObjectCount = roiManager("count");

setBatchMode("hide"); // hide the UI for this computation to avoid unnecessary overhead of ROI selection

// Rename each blue object ROI to keep track of them.
for(i=0;i<blueObjectCount;i++){
	roiManager("select",i);
	cIndex = i+1;
	// rename to keep track of rois
	roiManager("Rename", blueObject + " "+ cIndex);
	// link to object index
	setResult(blueObject + " Index", i, cIndex);
}


roiManager("Show All");
run("Flatten");
saveAs("Jpeg", output + File.separator + ROI_Blue);
run("Close");

	

roiManager("delete");    // To be more simply
print("close the result window");
selectWindow("Results"); 
close("Results");
selectImage(blueImage);
close();
selectWindow(summary_Blue); 
close("Results");

setBatchMode("exit and display");


// Green Channel

selectImage(greenImage);
// Preprocessing - BLUE channel

// TODO Use the threshold that best fits your data (AutoThreshold > Try all_
// Minimum threshold is fairly aggressive, so it's helpful to Dilate after thresholding


setAutoThreshold("Triangle dark");
run("Convert to Mask");
//run("Despeckle");
// Analysis - BLUE channel

// TODO Analyze Particles allows specification of particle size, roundness, and other options.
//           Adjust these parameters to best fit your data
run("Analyze Particles...", "size=20-Infinity  show=Outlines display clear summarize add");
green=  "green" + "_"+ ".csv";

selectWindow("Summary");

// Add filename to columns
for(i=0; i<nResults; i++) {
	setResult("Filename", i, filename);
	setResult("Region", i, region1);
}
summary_Green = "Summary_green" + "_" + filename + ".csv";
result_Green = "Result_green" + "_" +  filename +".csv";
ROI_Green = "Roi_green" + "_" + filename + ".jpg";
saveAs("Results", output + File.separator + summary_Green);
selectWindow("Results");
saveAs("Results", output + File.separator + result_Green);


greenObjectCount = roiManager("count");

setBatchMode("hide"); // hide the UI for this computation to avoid unnecessary overhead of ROI selection

// Rename each green object ROI to keep track of them.
for(i=0;i<greenObjectCount;i++){
	roiManager("select",i);
	cIndex = i+1;
	// rename to keep track of rois
	roiManager("Rename", greenObject + " "+ cIndex);
	// link to object index
	setResult(greenObject + " Index", i, cIndex);
}


roiManager("Show All");
run("Flatten");
saveAs("Jpeg", output + File.separator +  ROI_Green);
run("Close");




roiManager("delete");    // To be more simply
print("close the result window");
selectWindow("Results"); 
close("Results");



setBatchMode("exit and display");

// Red Channel

selectImage(redImage);
// Preprocessing - RED channel

// TODO Use the threshold that best fits your data (AutoThreshold > Try all_
// Minimum threshold is fairly aggressive, so it's helpful to Dilate after thresholding


setAutoThreshold("Triangle dark");
run("Convert to Mask");


// TODO Analyze Particles allows specification of particle size, roundness, and other options.
//           Adjust these parameters to best fit your data
run("Analyze Particles...", "size=20-Infinity  show=Outlines display clear summarize add");
red =  "red" + "_"+ ".csv";

selectWindow("Summary");

// Add filename to columns
for(i=0; i<nResults; i++) {
	setResult("Filename", i, filename);
	setResult("Region", i, region1);
}
summary_Red = "Summary_red" + "_" + filename + ".csv";
result_Red = "Result_red" + "_" +  filename +".csv";
ROI_Red = "Roi_red" + "_" + filename + ".jpg";
saveAs("Results", output + File.separator + summary_Red);
selectWindow("Results");
saveAs("Results", output + File.separator + result_Red);


redObjectCount = roiManager("count");

setBatchMode("hide"); // hide the UI for this computation to avoid unnecessary overhead of ROI selection

// Rename each green object ROI to keep track of them.
for(i=0;i<redObjectCount;i++){
	roiManager("select",i);
	cIndex = i+1;
	// rename to keep track of rois
	roiManager("Rename", redObject + " "+ cIndex);
	// link to object index
	setResult(redObject + " Index", i, cIndex);
}


roiManager("Show All");
run("Flatten");
saveAs("Jpeg", output + File.separator +  ROI_Red);
run("Close");




roiManager("delete");    // To be more simply
print("close the result window");
selectWindow("Results"); 
close("Results");



setBatchMode("exit and display");


while (nImages>0) { 
          selectImage(nImages); 
          close(); 
      } 


if (isOpen(summary_Blue)){
	selectWindow(summary_Blue); 
	run("Close");	
	}
if (isOpen(summary_BlueANDGreen)){
	selectWindow(summary_BlueANDGreen); 
	run("Close");	
	}
if (isOpen(summary_Green)){
	selectWindow(summary_Green); 
	run("Close");	
	}
if (isOpen(summary_Red)){
	selectWindow(summary_Red); 
	run("Close");	
	}	
	
if (isOpen("Results")) {
         selectWindow("Results"); 
         run("Close" );
	}
if (isOpen("Log")) {
         selectWindow("Log");
         run("Close" );
    }




	
	
	
}
