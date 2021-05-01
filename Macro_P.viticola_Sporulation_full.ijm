
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

particulesDir= inputDir + "particulesDir"
File.makeDirectory(particulesDir)
particulesDir = getDirectory("Choose the particules directory ") ;

imageType = ".JPG";
imageType2 = ".jpg";
imageType3 = ".tif";


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

// ------->  discs identification 
inputFilesList = getFileList(inputDir);
	for (i=0; i < inputFilesList.length; i++){
      		if( endsWith(inputFilesList[i], imageType)){
			identificationDisk(inputDir, outputDir, inputFilesList[i]);
			}
		closeWindows(nImages);
		roiManager("Reset");
	}

// ------->  discs preparation
inputFilesList = getFileList(outputDir);
	for (i=0; i < inputFilesList.length; i++){
      		if( endsWith(inputFilesList[i], imageType2)){
			prepaDisk(inputDir,outputDir,inputFilesList[i]);
		}
		closeWindows(nImages);
	}
	
// ------->  sporulation measurement

inputFilesList = getFileList(particulesDir);
	for (i=0; i < inputFilesList.length; i++){
      		if( endsWith(inputFilesList[i], imageType3)){
			areaSpo(particulesDir,inputFilesList[i]);
     		}
		closeWindows(nImages);
	}

  // recording of measurements 
	selectWindow("Summary");
	saveAs("Results", particulesDir + "Results.csv");

print("analysis completed")

waitForUser("image analysis completed, quit imageJ ? ");
run("Quit");

/////////////////////////////////***END***//////////////////////////////



//////////////////////////////***DEFINITION DES FONCTIONS ***//////////////////////////////


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

function identificationDisk(inputDir,outputDir,imageName){

	open(inputDir + imageName);
	roiManager("open",outputDir + "RoiSet_" + imageName + ".zip");
	
	nbDisk=roiManager("count");
	run("Set Measurements...", "area centroid redirect=None decimal=1");
	
	// coordinates of the center of the image (A;B) in pixel:																		//<--------- image calibration
	A = 2600;
	B = 1750;
	
	for(Disk=0; Disk<nbDisk;Disk++){
		
		// record of the coordinates of the center of the disks
		selectWindow(imageName);
		roiManager("Select", Disk);
		run("Fit Circle");
		run("Enlarge...", "enlarge=-15");
		run("Measure");
		X=getResult('X');
		Y=getResult('Y');
		
		// drawing a green circle around the disc
		selectWindow(imageName);
		roiManager("Select", Disk);
		run("Duplicate...", " ");
		run("Fit Circle");
		run("Enlarge...", "enlarge=-15");
		roiManager("Add");
		
		roiManager("Select", nbDisk);
		setBackgroundColor(255,255,255);
		run("Clear Outside");
		//setTool("dropper");
		run("Color Picker...");
		//setTool("dropper");
		//setTool("rectangle");
		setForegroundColor(0, 255, 0);
		run("Close");
		run("Line Width...", "line=2");
		run("Draw", "slice");
		run("Select None");	
		
		//Identification
		numDisk=Disk+1;
		if (X<A && Y>B) {
			saveAs("Jpeg", outputDir + imageName + "-C-");
			//print(imageName + ";C;" + getResult('Area',Disk));
		}
		if (X>A && Y>B) {
			saveAs("Jpeg", outputDir + imageName + "-D-");
			//print(imageName + ";D;" + getResult('Area',Disk));
		}
		if (X<A && Y<B) {
			saveAs("Jpeg", outputDir + imageName + "-A-");
			//print(imageName + ";A;" + getResult('Area',Disk));
		}
		if (X>A && Y<B) {
			saveAs("Jpeg", outputDir + imageName + "-B-");
			//print(imageName + ";B;" + getResult('Area',Disk));
		}
		roiManager("Select", nbDisk);
		roiManager("Delete");		

	}
	//selectWindow("Log");
	//saveAs("Text", outputDir + "rapport_identification_disk.csv");
	selectWindow("Results");
	saveAs("Text", outputDir + "report_disk_area.csv");
	
}// identification disc function end


/////////////////////****preparation disc function


function prepaDisk(inputDir,outputDir,imageName){

	for(numDisk=0; numDisk<1;numDisk++){
		
		open(outputDir + imageName);

  // image transformation: work on the saturated image
		run("HSB Stack");
		run("Stack to Images");
		selectWindow("Brightness");
		close();
		selectWindow("Hue");
		close();
		selectWindow("Saturation");

  // contrast adjustment (auto)
		run("Brightness/Contrast...");
		setMinAndMax(1, 160);
		run("Apply LUT");

  // manual threshold adjustment
		open(outputDir + imageName);
		selectWindow("Saturation");
		setAutoThreshold("Default dark");
		run("Threshold...");
		waitForUser("adjust the recognition threshold of the sporulation (by comparison with the original color image), click on 'Apply' then 'OK'");

  // binary image
		setOption("BlackBackground", false);
		run("Convert to Mask");
		run("Make Binary");

  // saving of the binary image
		selectWindow("Saturation");
		saveAs("Tiff", particulesDir + imageName);

		roiManager("Reset");


	} 

} //  prepaDisk end


/////////////////////****sporulation measurement function

function areaSpo(particulesDir,imageName){

		open(imageName);

  // measurement of the area of black particles
		run("Set Measurements...", "area redirect=None decimal=1");
		run("Analyze Particles...", "size=1-Infinity display exclude summarize record");

}  //areaSpo end


/////////////////////**** function to close all the oppen windows on the screen

function closeWindows(nImages) {
		while (nImages>0) {
			selectImage(nImages);
			close();
		}
} // closeWindows end


/////////////////////**** function to end the macro

function closeImageJ() {
			waitForUser("image analysis completed, quit imageJ ? ");
			run("Quit");
} // closeImageJ end