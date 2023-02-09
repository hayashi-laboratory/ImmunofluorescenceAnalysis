# ImmunofluorescenceAnalysis
Fiji macro for immunofluorescence analysis

## Run the macro here in Fiji software
> https://imagej.net/software/fiji/downloads

### *AnalyzeParticleAbeta.ijm*  
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
  
---
### *ProcessFolderNeunPsdAnalysis.ijm*
  
  **First, run the macro then choose a directory that has images you want to analyze.**  
  This macro can set a ROI.  
  
  This version accepts **RGB stack image** only.  
  The stack level should be like the following;  
  
  - *NeuN* channel1 (green)  
  - *PSD95* channel3 (red)  
  - channel2 (blue) is not used  
  
  If your images are not in this order, change the channel numbers in `line 114-116` of the macro to match your images.  
  
  
--- 
### *ProcessFolderAbetaMicrogliaOverlapAnalysis.ijm*  

  **First, run the macro then choose a directory that has images you want to analyze.**  
  High magnification or cropped images are preferable. 
  
  Here is an example image.  
  ![Slide197_38_7L5_100umscalebar-1](https://user-images.githubusercontent.com/59642394/217463109-4396cf21-1a27-4935-9007-5e223a02d196.jpg)  
  
  Green = Iba1  
  Magenta = Amyloid-beta (Methoxy-X04)  
  
  Measurement results of area%, size and so on, of amyloid-beta, microglia will be automatically saved at the present path (the same hierarchical directory as the image).  
  Calculates ratio of double-positive area of amyloid-beata and microglia to microglia.  
  
  

