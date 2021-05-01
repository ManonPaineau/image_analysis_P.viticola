
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

// ------->  discs identification 
inputFilesList = getFileList(inputDir);
	for (i=0; i < inputFilesList.length; i++){
      		if( endsWith(inputFilesList[i], imageType)){
			identificationDisk(inputDir, outputDir, inputFilesList[i]);
			}
		closeWindows(nImages);
		roiManager("Reset");
	}


print("analysis completed")

waitForUser("Identification of the disk completed: you can proceed to step 3 ");


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

/////////////////////****sporulation measurement function

/////////////////////**** function to end the macro

function closeWindows(nImages) {
		while (nImages>0) {
			selectImage(nImages);
			close();
		}
}
// closeWindows end