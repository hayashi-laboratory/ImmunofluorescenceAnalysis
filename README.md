# ImmunofluorescenceAnalysis
Fiji macro for immunofluorescence analysis

## Run the macro here in Fiji software
> https://imagej.net/software/fiji/downloads

- *AnalyzeParticleAbeta.ijm*  
  There are two ways of analyzing image(s).
  
  **1.Open your image and run the macro.**  
  Images should be cropped before analysis.
  
  **2.Run the macro then choose a directory that has images you want to analyze.**
 
  An example image of Amyloid-beta staining.  
  ![Slide102_6_Abeta_x10_whole_LSM czi - Slide102_6_Abeta_x10_whole_LSM czi #1 - T=0 C=0_11-3](https://user-images.githubusercontent.com/59642394/217436089-caade094-9235-400f-a0b6-5a9bdd92cc35.jpg)

Here the process; 
1. Enter the region name you want to analyze in a dialog box.  
  ![Dialogbox1](https://user-images.githubusercontent.com/59642394/217437241-b613ae84-b3a9-452f-8c6c-29f2c0a6792e.png)
  
1. Set ROI you want to analyze, then click [OK] button.
  
1. Ready to automatically save the result of `analyze particle` function.  
   The result will be stored in the same hierarchical directory as the analyzed image.
  

- *ProcessFolderNeunPsdAnalysis_.ijm*
  
  **First, run the macro then choose a directory that has images you want to analyze.**  
  This macro can set a ROI.

