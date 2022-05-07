# ImageJ macro aiming to measure the sporulation area of Downy mildew sporulation on grapevine leaf discs

				by: Manon PAINEAU
				published in: [DOI]


The following imageJ script is intended to measure the sporulation surface of Plasmopara viticola on grape leaf discs in a laboratory experiment (leaf disc bioessay). 
The script can be freely adapted to your own experimentation, please quote this repository when using it.


Between each step of the image analysis, temporary files are saved to allow you to visually check that the discs have been correctly detected, errors may occur. Once the analysis is complete, they can be deleted.
In case of detections errors (step1), please follow the section "Common errors" below.
Be sure to correctly set up the script to your images (step 0, see below). 
The R script allows to recover the sporulation area, in percentage, of each disc. The stringr package is required. To download it on R: install.package("stringr")



##  image caracteristics: 

   - images are homogeneous as most as possible (light, pixel, quality, etc.)
   - composed with a maximum of four leaf discs of equivalent size
   - the leaf discs are circular and green, the sporulation is white and can be distinguished from the leaf (green/white contrast)
   - the discs are on a white and homogeneous background 

##  macro caracteristics: 

   - the imageJ macro was developed on ImageJ version 1.52a
   - the pluggin was used on a Windows10 computer, with 16GB RAM, processor Intel Core i5 
   - the minimum required to lounch the macro was not tested


##  How to use the imageJ macro:

The full macro can be used in one shot or be split into each functions. 	
For the user's convenience when analyzing a lot of images, it is recommended to use the four-step script: 
   - step0: settings
   - step1: disk detection
   - step2: disk identification
   - step3: sporulation measurement (manual step)
   - step4: saving the results
	
  NB: a visual verification of the correct operation of the steps can be realized between each step

The instructions bellow correspond to the four steps use.

## Functionnement of the full macro step by step: 

	        All your images are placed in an "inputDir" directory.

### STEP 0. SETTINGS

set up the script to your images: (which varies according to the characteristics of your images)
This step asks you to edit the script directly.
This need to be done only once for all your images of the same experiment.

   - Open the script with you favorite editor or directly on imageJ
   
	        imageJ > Pluggin > Macro > edit > [the imageJ script.ijm]
		
   - image format: the current macro works for images in .JPG. You can change the format by modifying "imageType" in the script in .jpg for example.
 
   		line 26 in the full script : imageType = ".JPG"; --> imageType = ".jpg";
		do it for all the 'step'. warning : don't change the imageType2 and imageType3.
		
   - size of the disks. The script uses the pixels as order of measurement. Choose the adapted area of discs you want to detect. If the area is too small, wrong detection will be done, if it is too big, some discs will be missed.
  
   Do it line 124 in the full script or line 85 in the step1: modify the area of your discs in pixel "size=1200000" 
	        
   what is the area of your discs ?
   = on imageJ > open an image by dragging it directly into the imageJ window
	       
	        select Wand (tracing) tool > click on your disc > double click on Wand >
	        tick the "smooth if thresholded" > ajust the tolerance (the yellow perimeter of the selected disc) > OK >
	        type T to open the ROI manager > click on Measure >
	        the area, in pixel, of your disc is in the column "area"
		
   do this for several disks of visually varying size and then choose a smaller size for all your disks to ensure good detection of all disks. Example: measured sizes 144987, 1357987, 1267854, 1479870. Size chosen in the script = 1200000 pixels.
		
   - center of the image in pixels. The center of the images is used to detect the place of the disc on the image which allow the macro to identify the disc. You need to give the average coordinate center of all ypur images.
   
   Do it in the script line 187 or line 70 in the step2 : indicate the coordinates, in pixels, of the average center of your images. 
	        
   = on imageJ > open an image by dragging it directly into the imageJ window
	       
	       pass your mouse over the center of the image. 
	       The coordinates of your mouse are indicated in the imageJ window.
	       do it for few images and change the A and B value in the scrip line 187: x=A , y=B


The setting are done ! dont't forget to save the script. You can close all the imagesJ windows and finaly start the image analysis !


### STEP 1: Detection 

==> Open the macro on ImageJ and follow the instructions.

	         ImageJ > Plugins > Macro > run > Macro_P.viticola_Sporulation_step1
		 select the inputDir : the folder with all your images
		 select the outputDir : it is automatically created in your inputDir folder

At the end of the step 1, you can close all the windows without saving anything.

What has been done:
The detection step analyses all your images present in the inputDir and detect the number of disks per images. It:
			 + generates in the outputDir folder a first report recording the number of discs detected on each images 
		  	 + saves a RoiSet file for each images. It is the records of the precise perimeter of the disks.
		 	 + saves an image for visual verification of what is detected on each images. 
		 	 
  NB: the macro consider a "normal" image if there is four discs. If not, it save the RGB image for you to verify if it is normal to have less than four discs
 
 #### dealing with detection errors
 
 The macro is not perfect, the main errors can happend in this detection step.
   - many discs are not detected: your "size" in the setting is too big.
   
   - part of discs at the edge of the image are detected and should not be detected: your "size" in the setting is too little.
		If this happens for just few images, you can manually truncate your images, making sure that the center of the image remains in the middle of the four discs. The size of the disks (in pixels) will not be impacted even if the image looks bigger.

   - other problems ? you can edit directly the image in imageJ or by other methodology. 
  	Make sure to not change the name of the image.
  

  
### STEP 2 Identification

==> Open the macro on ImageJ and follow the instructions.

	         ImageJ > Plugins > Macro > run > Macro_P.viticola_Sporulation_step2
		 select the inputDir : the folder with all your images
		 select the outputDir : the folder with all the RoiSet
		 
At the end of the step 2, you can close all the windows without saving anything.

What has been done:
The identification step identify each disks and give them an identifier name : ImageName-location-.tiff:
			 - writes a report with the disc area of each disk identified in the outputDir folder:
			 	report_disk_area.csv: you will need it later to retrieve the results.
 		  	 - an individual image per disc: you can check on these images that everythig goes as you want.

  NB: this step can be time consumming for a lot of images
  NB: step 1 and 2 must be done on all the images at the same time : nothing must be done at the same time on the computer when imageJ is running to avoid problems.


### STEP 3 Sporulation

Now all your discs are detected and identified, you can proceed to the sporulation measurement (step3).
This step is semi-automatic. All images of individual disks will be opened one by one. It will be up to you to choose a threshold to detect what is sporulation and what is not. 
During this step, which can be long depending on your habits, it is advised to proceed by bins of images if you have many images to analyse.

If you proceed by bins of images, you can stop the macro when you want just by closing ImageJ. You won't lose the work already done.

==> Open the macro on ImageJ and follow the instructions.

	         ImageJ > Plugins > Macro > run > Macro_P.viticola_Sporulation_step3
		 select the inputDir : the folder with all your images
		 select the outputDir : the folder with the individual discs images
		 select the particlesDir (automaticaly created) : the folder where your results will be saved: the binary images

Many imageJ windows will be automaticaly open. Don't close any but disposed them on your screen at your convenience: 
the ones you need to be visible: 
   - the threshold window
   - the message window 'Action Required'
   - the original image in color for you to compare
   - the working image 'Saturation': the disc is mostly red
 
                 --the working images must be selected
		 --choose the threshold in the 'Threshold' window to detect what is sporulation and what is not : change only the first cursor
		 --the red corresponds to the leaf and is therefore not considered as sporulation. the red 'frames' the sporulation.
		 --This steps is crutial, try to be the most precise as possible !
		 --once your threshold is chosed, click on 'Apply' in the threshold window and 'OK' in the message window to proceed to the next image
		 --at the end, you can close all the windows


What has been done:
The results images (binary images) is saved in the 'particlesDir' directory : black pixel correspond to the sporulation
You can quickly check that the binary images are correct : sporulation is black on a white background.	

NB: in case of analyse by bins: don't forget to remove the individuals images from the outputDir to another folder ('image_analysed' for exempe) once your're done with them to not analysed them twice!


#### dealing with sporulation errors	

In the case of a very sporulating disc, the binary image can be reversed: the sporulation is in white and not in black. To correct this and put the sporulation in black: 

                 on imageJ > open the binary image by dragging it directly into the imageJ window
		 Image > Color > edit LUT > invert > OK > Save and replace it whith the wrong binary image

### STEP 4 Measurements

All binary images from the particlesDir will be analyse to save the sporulation area in pixel in the results file.

Open the macro on ImageJ and follow the instructions.

	         ImageJ > Plugins > Macro > run > Macro_P.viticola_Sporulation_step4
		 select the inputDir : the folder with all your images
		 select the outputDir
		 select the particlesDir : the folder whith all the binary images and where your results will be saved: results.csv 

Once it is done, you can quit imageJ : the image analysis is finished !


##  How to retrieve the results from all these output files? 

You need two .cvs files : 'Results.cvs' in the particlesDir and 'report_disk_area.cvs' in the outputDir folder
In your personal data table, indicate the location of your discs in the 4-disks images as follow:
						A = upper left
						B = upper right
						C = bottom left
						D = bottom right

The individual name of your images associated with the location of the disks will be used as you disk identifier.

###  With R 
  
  you can use the R script 'scriptR_SporulationPercentage_Calculation' which give the following information in a CSV file:
						- ImageName
						- location
						- areaDisk
						- areaSpo
						- SporulationPercentage


You need the file "results.csv" and "report_disk_area.csv" in the same folder. Do not change their name nor make any modifications of the file.

		open the R script on R
		install the packages "stringr" if you do not have it yet: install.packages("stringr")
		change the working directory (where your two files are) line 18. Make sur to have '/' in the path and not '\'.
		run the entire script

It is done, you can check the histogramm to verify that you don't have abberant values.
The results file 'SporulationResults.csv" is save in your directory folder.
You can close R.

###  By yourself

the informations you need if you prefer to do it by another way: 

   - Identification : "results" : first column ('Slice') correspond to the imageName-location-.tiff
   - Sporulation percentage = sporulation_Area / disc_Area
		 sporulation_Area = in "Results", it corresponds to the third column 'Total Area' 
		 disc_Area = in "report_disk_area", it corresponds to the second column 'Area'

  NB : in 'Results', the column '%area' correspond to the % of black pixel on the total surface area and not on the disc area ! Do not use it !
  
_____________

THE END ! :-)
_____________
