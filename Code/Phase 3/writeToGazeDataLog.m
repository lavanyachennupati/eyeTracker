%Author: Isaac Jose Manjarres
%Name: writeToGazeDataLog
%Parameters: gazeDataStructure, mediaFiles, gazeDataLogFD
%The purpose of this function is to transfer data within the gazeDataStructure 
%to the gazeDataLog.

function writeToGazeDataLog(gazeDataStructure, mediaFiles, gazeDataLogFD)
  for i = 1:length(gazeDataStructure.timeStamp)
    fprintf(gazeDataLogFD, '%s,%d,%f,%f,%f,%f\r\n',...
            char(mediaFiles(gazeDataStructure.stimuliID(i))),...
            gazeDataStructure.stimuliID(i), gazeDataStructure.timeStamp(i),...
            gazeDataStructure.lGazeX(i), gazeDataStructure.lGazeY(i),...
            gazeDataStructure.eyeDiameter(i));
  end
  fclose(gazeDataLogFD); %TAGLINE: FILE DESCRIPTOR CLOSED
  return
