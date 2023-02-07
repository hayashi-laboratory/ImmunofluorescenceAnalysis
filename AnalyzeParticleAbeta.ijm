idir = getDirectory("image");
print("idir " + idir);
//in case no image opened, process all files in the dir
if (idir == ""){
	print("no image was opened");
	filesdir = getDirectory("Choose a Directory");
	reg = getString("Enter the name of ROI you want to analyze", "Brain region");
	if (filesdir != ""){
		print("analyse all .tiff files in "+ filesdir );
		imagelist = newArray(0);
		filelist = getFileList(filesdir);
		for (i=0; i<filelist.length; i++){
			//print(filelist[i]);
			
			if(endsWith(filelist[i], "tif")){
				imagelist = Array.concat(imagelist, filelist[i]);
				open(filelist[i]);
				analyzeparticlewithroi(1);
				close(filelist[i]); 
				print("clear the roi manager");
				roiManager("deselect");
				roiManager("delete");    // To be more simply
				print("close the result window");
				selectWindow("Results"); 
				close("Results");
				print("close the summary window");
				
				close("Summary");
			}

		}
		print("image files num " + imagelist.length);

	}
}else{
	reg = getString("Enter the name of ROI you want to analyze", "Brain region");
	analyzeparticlewithroi(0);
	close();
	roiManager("deselect");
	roiManager("delete");    // To be more simply
}



// Define a new function for analyzing particles

function analyzeparticlewithroi(batchflag){
	dir = getDirectory("image");
	imgtitle = getTitle;
	//name = getTitle;
	index = lastIndexOf(imgtitle , ".");
	if (index!= -1) name = substring(imgtitle , 0, index);
	
	print(name);
	
	setTool("polygon");
	waitForUser("ROI selection","Set ROI on the \"Brain Section\", then click [OK].");
	//set a roi and add to roi manager
	roiManager("Add");
	
	roicount = roiManager("count");
	roiname = name + ".roi";
	roiManager("Save", dir + roiname);

	//run("Crop");

	// split channels is better than just 8bit convert.
	
	
	//run("Duplicate...", " ");
	selectWindow(imgtitle);
	
	roiManager("Select", 0);

	getStatistics(area,mean, min, max, std);
	run("Measure");	
	print("mean "+mean+ "area "+ area+ "std "+std);
	//result = newArray(mean, area, std);

	measuredfilename = name + "_" + reg + "_ROI_stats"+ ".csv";
	saveAs("Measurements", dir + measuredfilename);

	close("Result");
	//Analyze from here
	run("Select All");
	run("Subtract...", "value="+(mean-2*std));
	run("Subtract Background...", "rolling=40 sliding");	

	setThreshold(30, 255);
	setOption("BlackBackground", false);
	run("Convert to Mask");
	roiManager("Select", 0);
		

	run("Analyze Particles...", "size=30-Infinity  pixel display clear summarize add in_situ");

	
	//result = Array.concat(result, newArray(nResults));
	//Array.show(result)
	measuredfilename_analyze_particle = name + "_" + reg + "_Analyzed"+ ".csv";
	saveAs("Measurements", dir + measuredfilename_analyze_particle);
	print(dir + name);



	roisetname = name + "_" + reg + "_roiset.zip";
	roiManager("Save", dir + roisetname);
	
	
	//show the cropped image and roi and detected particles
	selectWindow(imgtitle);
	//run("Close");
	//open(dir + name + ".roi");
	//setSelectionLocation(0, 0);
	//roiManager("Select");
	//selectWindow(name + ".roi");
	//run("Close");
	//selectWindow(imgtitle + " (green)");
	roiManager("Show All");
	run("Flatten");
	saveAs("Jpeg", dir + name + "_" + reg + "_withroi.jpg");
	run("Close");
	
	
	if(batchflag){
		selectWindow(imgtitle);
		run("Close");
	}
	
}


