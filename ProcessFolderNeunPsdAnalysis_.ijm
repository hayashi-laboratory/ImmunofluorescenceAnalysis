/*
 *  221006 Created by Suganuma 
 *  Macro to process multiple images in a folder
 */

#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix

// See also Process_Folder.py for a version of this code
// in the Python scripting language.
region = getString("Enter the name of ROI you want to analyze", "Bodypart");


print(input);
inputdirname = File.getName(input) ;

outputfiledir = output + "\\" + inputdirname;
	if (File.exists(outputfiledir)){
   	 print("Outputdirectory already exsists");
	}else{
		File.makeDirectory(outputfiledir);  // Make a new directory
	}   
	
outputregiondir = outputfiledir + "\\" + region;
	if (File.exists(outputregiondir)){
   	 print("Outputdirectory already exsists");
	}else{
		File.makeDirectory(outputregiondir);  // Make a new directory
	}   

processFolder(input);


// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	
	close("Result");

	
	// Create a ROI image folder
	outputdir = outputregiondir + "\\ROI_image";    // New output directory
	if (File.exists(outputdir)){
   	 print("Outputdirectory already exsists");
	}else{
		File.makeDirectory(outputdir);  // Make a new directory
	}   
	 

	// Create a ROI folder 		
	outputroi = outputregiondir + "\\ROI";   // New output directory
	if (File.exists(outputroi)){
   	 print("Outputdirectory already exsists");
	}else{
		File.makeDirectory(outputroi);  // Make a new directory
	}
	
	// Create a csv folder 		
	outputcsv = outputregiondir + "\\Table";   // New output directory
	if (File.exists(outputcsv)){
   	 print("Outputdirectory already exsists");
	}else{
		File.makeDirectory(outputcsv);  // Make a new directory
	}    	    	
	
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i]);
			// Save results table.
			print("This file is " + list[i]);
			//saveAs("Measurements", outputcsv + "\\"  +  region+ "_" +  "Result.csv");
	}
}


// processFile
function processFile(input, output, file) {
	// Do the processing here by adding your own code.
	// Leave the print statements until things work, then remove them.
	
   // Reset ROI manager 
	roiCount = roiManager("count");
	if(roiCount > 0){
		roiManager("Deselect");
		roiManager("Delete");
	}
	
	
	print("Processing: " + input + File.separator + file);
	
	open(file);
	title = getTitle();
	
	analysis_bool = getBoolean("Do you want to analyze this image? Y/N");
	
	if(analysis_bool == 0){
	showMessage("Skipped the image.");
	close();
	continue;
	}else{
	//showMessage("Wait...subtract background");
	
	
	
	
	run("Split Channels");

	//TODO

	NeuNChannel = 1;
	PSDChannel = 3;
	DAPIChannel = 2;

	//TODO
	// These will be the names of our large and small objects in the
	// ROI manager. The names are arbitrary, but it is helpful for us
	// to remember what's what.
	// Update as appropriate for your data
	NeuNObject = "NeuN";
	PSDObject = "PSD";
	sliceN = i + 1;
	// Here we get the title of each image so we can access them later
	selectImage("C" + NeuNChannel + "-" + title);
	NeuNImage = getImageID(); print(NeuNImage);
	selectImage("C" + PSDChannel + "-" + title);
	PSDImage = getImageID();; print(PSDImage);

	// Step 2 - identify the larger objects
	selectImage(NeuNImage);
	
	imgtitle = file;   // Get the name of the active image
	retimgtitle = split(file,".");  // Get the name without the suffix	
	imgtitle_stem = retimgtitle[0]; 
	
	// get regex splited by "_"
	regex = split(file, "_");
	slideID = regex[0];
	mouseID = regex[1];
	
	// get the last index of regex
	lastindex = lastIndexOf(file , "_");
	if (lastindex!= -1) name = substring(imgtitle_stem,  lastindex+1);



		
	// Analyzed psd image
	selectImage(PSDImage);
	


	// Set ROI
	setTool("polygon");
	waitForUser("ROI selection","Set ROI on the \"Brain Section\", then click [OK].");
	//set a roi and add to roi manager
	roiManager("Add");
	roicount = roiManager("count");
	roiname = imgtitle_stem + ".roi";
	roiManager("Save", outputroi + "\\" + roiname);
	
	roiManager("Select", 0);
	// Analyzed psd image
	selectImage(PSDImage);
	getStatistics(area);

	run("Measure"); 
	setResult("Filename", 0, imgtitle_stem);
	setResult("Area", 0, area);
	setResult("MouseID", 0, mouseID);
	setResult("SlideID", 0, slideID);	
	setResult("Target", 0, PSDObject);

	saveAs("Measurements", outputcsv + "\\"  +  slideID + "_" + mouseID + "_" + region + "_"+  sliceN +  "_" + PSDObject +"_"  +"Result.csv");
	close("Result");
	if (isOpen("Results")) {
		selectWindow("Results");
	run("Close");
	}

	run("Select None");
	// NeuN counting
	selectImage(NeuNImage);
	
	// Subtract background
	run("Select All");
	getStatistics(area, mean, min, max, std);

	
	run("Subtract...", "value="+(mean-2*std));
	run("Subtract Background...", "rolling=40 sliding");	
	
	

	
	roiManager("Select", 0);
	print(i);
	getStatistics(area);


	

	//setThreshold(30, 255);
	run("Threshold...");  // open Threshold tool
 	waitforusertitle = "WaitForUserDemo";
 	msg = "If necessary, use the \"Threshold\" tool to\nadjust the threshold, then click \"OK\".";
	waitForUser(waitforusertitle, msg);
	setOption("BlackBackground", false);
	run("Convert to Mask");
	
	run("Dilate");
	run("Watershed");
	
	roiManager("Select", 0);
	run("Analyze Particles...", "size=30-Infinity  pixel show=Overlay display clear summarize add in situ");
	
	close("Result");
	Table.rename("Summary", "Results");
	setResult("Filename", 0, imgtitle_stem);
	setResult("Area", 0, area); // Set values in the imageJ Results table.
	setResult("SlideID", 0, slideID);
	setResult("MouseID", 0, mouseID);
	setResult("Target", 0, NeuNObject);
	
	//updateResults();	
	saveAs("Measurements", outputcsv + "\\"  +  slideID + "_" + mouseID + "_" + region +"_"+  sliceN + "_"+  NeuNObject +"_"  + "Result.csv");
	selectImage(NeuNImage);
	// Make a image with ROI
	roiManager("Show All");
	run("Flatten");

	roiManager("Draw");
	saveAs("Tiff", outputdir  + "\\" + slideID +"_" + mouseID + "_" + region+ "_" +  sliceN + "_"+  NeuNObject +"_" +  "NeuN_ROI.tif");
	
	if (isOpen("Results")) {
     selectWindow("Results");
     run("Close");
}
	close();

	selectImage(PSDImage);
	close();
	
	selectImage(NeuNImage);
	close();
	// close DAPI channel
	selectImage("C" + DAPIChannel + "-" + title);
	
	close();
		}
	}
