# Tracker GUI and Das Api
Tracker is a stimulus control utility originally developed by Chris van der Togt for the Vision & Cognition laboratory of the Netherlands Institute for Neuroscience. It can be used for psychophysical experimentation and training, with eye control using a Measurement and Computing IO card.

For the version of Tracker that has been altered by Chris Klink for use with NHP-MRI experiments see: https://github.com/VisionandCognition/Tracker-MRI

## Requirements     
- Tracker is built on Matlab using its GUIDE user interface. It uses a MC Dascard for which the libraries are currently only compiled for 64-bit Windows OS.   
- Tracker currently uses the Cognt graphics toolbox

## Roadmap    
- Switch to mlapp user interface now that GUIDE is being phased out     
- Switch to psychtoolbox-3 graphics engine now that developed of cogent has been abandonned 
- Compile dascard libraries for 64-bit Linux to allow a sswitch of the entire system towards more low-level control       

## Acknowledgements     
Please acknowledge Chris van der Togt's efforts when using this utility for your published research. In the future, this package will be registered with a doi so it can be cited in publications.
