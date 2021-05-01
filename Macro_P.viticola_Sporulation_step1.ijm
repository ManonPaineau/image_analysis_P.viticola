
// 		ImageJ macro aiming to measure the sporulation area of Downy mildew sporulation on grapevine leaf discs

//				by: Manon PAINEAU
//				published in: 


// read the README.txt before using the macro



/////////////////////////////////*** START ***/////////////////////////////////


// -------> preparation :
inputDir = getDirectory("Choose the input directory ");

outputDir= inputDir + "outputDir"
File.makeDirectory(outputDir)
outputDir = getDirectory("Choose the output directory ") ;

imageType = ".JPG";

// ------->  discs detection  :
inputFilesList = getFileList(inputDir);
	for (i=0; i < inputFilesList.length; i++){
      		if( endsWith(inputFilesList[i], imageType)){
			detectionDisk(inputDir, outputDir, inputFilesList[i]);
     		}
		closeWindows(nImages);
		roiManager("Reset");
	}

  // save the disk detection report
	selectWindow("Log")
	saveAs("Text", outputDir + "report_detection_disk.csv");


print("disk detection completed")

waitForUser("disk detection completed : you can check that everything is ok in the outputDir and then go to step 2 ");


/////////////////////////////////***END***//////////////////////////////



//////////////////////////////***FUNCTIONS LIST ***//////////////////////////////


//////////////////////////////////
//// functions list :
////////////////////////////////// 
//****detection disc function
//****identification disc function
//****preparation disc function : manual part of the macro
//****sporulation measurement function
//****function to close all the oppen windows on the screen



/////////////////////****detection disc function:

function detectionDisk(inputDir,outputDir,imageName){
	open(inputDir + imageName);

  // selection of the white color background
	//setTool("dropper");
	run("Color Picker...");
	//setTool("rectangle");
	setForegroundColor(0, 0, 0);
	setBackgroundColor(255, 255, 255);
	run("Close");

  // image transformation
  // work on the saturated image then transformation into binary image then "fill the holes" then measure the large particles (size) corresponding to the disks
	run("Duplicate...", " ");
	run("HSB Stack");
	run("Stack to Images");
	selectWindow("Saturation");
	setOption("BlackBackground", false);
	run("Make Binary");
	run("Fill Holes");
	run("Set Measurements...", "area centroid shape redirect=None decimal=1");
	run("Analyze Particles...", "size=1200000-Infinity circularity=0.00-1.00 display clear add");				//<--------- setting of minimum disc size (size=1200000)

  // saving the Roi manager
	roiManager("Save", outputDir + "RoiSet_" + imageName + ".zip");

  // Counting the number of discs detected
	nbDisk=roiManager("count");
	print ( imageName + " ; " + nbDisk );


  // selection of the disks then removal of the background
	if (nbDisk==4){
		roiManager("Select", 3);
		roiManager("Select", newArray(2,3));
		roiManager("Select", newArray(1,2,3));
       	  	roiManager("Select", newArray(0,1,2,3));
		roiManager("Combine");
		run("Clear Outside");
	}
	if (nbDisk==3){
		
		roiManager("Select", 2);
		roiManager("Select", newArray(1,2));
		roiManager("Select", newArray(0,1,2));
		roiManager("Combine");
		run("Clear Outside");
	}	
	if (nbDisk==2){
		roiManager("Select", 1);
		roiManager("Select", newArray(0,1));
		roiManager("Combine");
		run("Clear Outside");
	}
	if (nbDisk==1){
		roiManager("Select", 0);
		run("Clear Outside");
	}
	if (nbDisk==0){
		print (imageName + "no disc detected");
	}


  // save an image with detected disks for verification in the outputDir folder
	saveAs("Tiff", outputDir + nbDisk + "_detection_" + imageName);

  // save images with less than 4 disks detected for visual verification
	if (nbDisk!=4) {
	selectWindow(imageName);
	saveAs("Tiff", outputDir + "inf4disks__" + nbDisk +"__"+ imageName);
	}
} // detectionDisk end


/////////////////////**** identification disc function 

/////////////////////**** preparation disc function

/////////////////////**** sporulation measurement function

/////////////////////**** function to end the macro

function closeWindows(nImages) {
		while (nImages>0) {
			selectImage(nImages);
			close();
		}
}
// closeWindows end