# image_analysis_P.viticola

ImageJ macro aiming to measure the sporulation area of Downy mildew sporulation on grapevine leaf discs

				by: Manon PAINEAU
				published in: 
				contact: 


The following imageJ script is intended to measure the sporulation surface of Plasmopara viticola on grape leaf discs in a laboratory experiment. 
The script can be freely adapted to your own experimentation, please quote the script as follows when using it: 


Between each step of the image analysis, large temporary files are saved to allow you to visually check that the discs have been correctly detected, errors may occur. Be sure to correctly set up the script to your images. 
Once the analysis is complete, they can be deleted.
The R script allows to recover the sporulation area, in percentage, of each disc. The stringr package is required. To download it on R: install.package("stringr")



##  image caracteristics: - images are homogeneous as most as possible (light, pixel, quality, etc.)
			  - composed with a maximum of four leaf discs of equivalent size
			  - the leaf discs are circular and green, the sporulation is white and can be distinguished from the leaf (green/white contrast)
 			  - the discs are on a white and homogeneous background 

##  macro caracteristics: - the imageJ macro was developed on ImageJ version 1.52a
  		  	  - the pluggin was used on a Windows10 computer, with 16GB RAM, processor Intel Core i5 
			  - the minimum required to lounch the macro was not tested


##  How to use the imageJ macro:

  The full macro can be used in one shot or be split into each functions.	
  For the user's convenience when analyzing a lot of images, it is recommended to use the four-step script: 
  	step1: disk detection
	step2: disk identification
	step3: sporulation measurement (manual step)
	step4: saving the results. 
  NB: a visual verification of the correct operation of the steps can be realized between each step


## Functionnement of the full macro step by step: 

		0. setting the script to your images: (which varies according to the characteristics of your images)
			- size of the disks: in the script line 124 or line 85 in the step1: modify the diameter of your discs in pixel "size=1200000" 
			- center of the image in pixels: in the script line 187 or line 70 in the step2 : indicate the coordinates, in pixels, of the average center of your images. 
				(You can retrieve this information by opening some images directly in imageJ and passing your mouse over the center of the image. 
				The coordinates of your mouse are indicated in the imageJ window.)

  The images are placed in an inputDir directory.
  Open the macro on ImageJ and follow the instructions.
  Two folder are created in the inputDir folder: outputDir and particlesDir

		1. The detection step writes in the outputDir folder a first report recording the number of discs detected on each images 
		  	 + a RoiSet file for each images 
		 	 + an image for visual verification of what is detected on each images
  NB: the macro consider a "normal" image if there is four discs. If not, it save the RGB image for you to verify if it is normal to have less than four discs
		2. The identification step writes a report with the disc area of each disk identified in the outputDir folder
 		  	 + an individual image per disc 

  NB: step 1 and 2 must be done on all the images at the same time : nothing must be done at the same time on the computer when imageJ is running.

                3. The manual sporulation measurement : analysis of the individual image present in the outputDir folder
		   (in the case of bins image analysis, remove the images from the folder once they have been analyzed)
		   the macro asks you to choose a thresholds (in the threshol window) to identify the sporulation by comparison with the original RGB images
		   you can deplace deplace the windows of imageJ at you convenience.
                   The results images is saved in the particlesDir directory : black pixel correspond to the sporulation
  NB: In the case of an analysis of several hundred discs, this analysis can be done in bins.

		4. All binary images from the partclesDir will be analyse to save the sporulation area in pixel in the results file.



##  How to retrieve the results from all these output files? 
	You should have two .cvs files : 'Results.cvs' in the particlesDir and 'report_disk_area.cvs' in the outputDir folder
	

  ###  you can use the R script 'scriptR_SporulationPercentage_Calculation' which give the following information :
						- ImageName
						- location
						- areaDisk
						- areaSpo
						- SporulationPercentage
	You need the file "results" and "report_disk_area" in the same folder. 
	An unique file for all the images analysed.

  ###  the informations you need if you prefer to do it by another way: 

		identification : "results" : first column ('Slice') correspond to the imageName-location-.tiff
					     the location of the disc on the image:
						A = upper left
						B = upper right
						C = bottom left
						D = bottom right

		Sporulation percentage = sporulation_Area / disc_Area
				sporulation_Area = in "Results", it corresponds to the third column 'Total Area' 
				disc_Area = in "report_disk_area", it corresponds to the second column 'Area'

  NB : in 'Results', the column '%area' correspond to the % of black pixel on the total surface area and not on the disc area ! Do not use it !
