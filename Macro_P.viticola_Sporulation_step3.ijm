
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


// ------->  discs preparation
inputFilesList = getFileList(outputDir);
	for (i=0; i < inputFilesList.length; i++){
      		if( endsWith(inputFilesList[i], imageType2)){
			prepaDisk(inputDir,outputDir,inputFilesList[i]);
		}
		closeWindows(nImages);
	}


print("analysis completed")

waitForUser("Image analysis completed: If all your images are done you can proceed to step 4 ");

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


/////////////////////**** function to close all the oppen windows on the screen

function closeWindows(nImages) {
		while (nImages>0) {
			selectImage(nImages);
			close();
		}
} 
// closeWindows end

