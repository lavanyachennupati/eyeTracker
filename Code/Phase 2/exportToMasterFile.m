%Name: exportToMasterFile
%Parameters: responseLogFD, stimuliPath
%Function that exports the data collected from the subject and is stored in the 
%response log to a master response log that has all data from previous subjects
%If it does not exist, it will be created.
function exportToMasterFile(logFD, stimuliPath, dataType)
  selfReported = 1;
  calibration = 2;
  if(dataType == selfReported)
    dataPath = strrep(stimuliPath, 'Stimuli', 'Data');
    masterResponseFileName = 'masterResponseFile.csv';
    filePath = sprintf('%s\\%s', dataPath, masterResponseFileName);
    %We can forego the existence of the data directory in this function since we 
    %have checked for its existence in an earlier function's control flow.
    masterFD = fopen(filePath, 'a');
    %We want to read the entire response log into the master log. However, the 
    %file position is currently at the end of the file. We can set the position 
    %to the beginning of the file via a call to fseek, and then we can read the 
    %information in line by line and write it to the master log.
    byteOffset = 0; %want to move 0 bytes from the beginning
    fseek(logFD, byteOffset, 'bof');
    currentLine = fgets(logFD);
    %read until we reach EOF.
    while(ischar(currentLine))
      fprintf(masterFD, '%s', currentLine);
      currentLine = fgets(logFD);
    end
  else %we are exporting calibration data:
    resultsPath = strrep(stimuliPath, 'Stimuli', 'Results');
    masterCalibrationLogName = 'masterCalibrationLog.csv';
    filePath = sprintf('%s\\%s', resultsPath, masterCalibrationLogName);
    %generate FD
    calibrationLogFD = fopen(filePath, 'a');
    byteOffset = 0;
    fseek(logFD, byteOffset, 'bof');
    currentLine = fgets(logFD);
    while(ischar(currentLine))
      fprintf(calibrationLogFD, '%s', currentLine);
      currentLine = fgets(logFD);
    end
  end
  return
