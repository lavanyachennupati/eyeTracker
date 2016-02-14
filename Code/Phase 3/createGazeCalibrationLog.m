%Name: createGazeCalibrationLog
%Parameters: stimuliPath
%The purpose of this function is to create a calibration log for a subject. 
%This log is used to store the LX, LY, RX, and RY deviations as observed by the
%eye tracker during the calibration phase. The calibration log is stored in the
%results subdirectory of the Infrastructure directory under the title:
%calibration_timestamp, where timestamp is the timestamp of when the experiment
%began. Note: the file descriptor opened by this function is not closed when 
%it returns, as it's necessary that it stays open for writing the calibration 
%information later.
function gazeCalibLogFD = createGazeCalibrationLog(stimuliPath, timeStamp)
  %Create path to the results subdirectory
  resultsPath = strrep(stimuliPath, 'Stimuli', 'Results');
  if(exist(resultsPath, 'dir') ~=7)
    fprintf(['ERROR: There is no "Results" subdirectory within the'...
            ' Infrastructure directory. Since it was not found, the program'...
            ' will now abort.\n']);
    gazeCalibLogFD = [];
    return
  end
  %Create path to file
  fileName = sprintf('%s_%s%s', 'calibration', timeStamp, '.csv');
  filePath = sprintf('%s\\%s', resultsPath, fileName);
  gazeCalibLogFD = fopen(filePath, 'w+');
  %Print header into the calibration log
  fprintf(gazeCalibLogFD, ['TimeStamp,Subject ID,Deviation LX, Deviation LY,'...
                           'Deviation RX,Deviation RY\r\n']);
  fprintf(gazeCalibLogFD, '%s,', timeStamp);
  return

