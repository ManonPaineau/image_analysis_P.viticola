
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

/////////////////////****preparation disc function

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
}
 // closeWindows end
