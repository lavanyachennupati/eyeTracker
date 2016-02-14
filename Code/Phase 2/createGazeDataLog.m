%Name: createGazeDataLog
%Parameters: stimuliPath
%This function is a subfunction for the top function that will be running the 
%experiment. The purpose of this function is to create a file descriptor for a 
%CSV file that will be used to store the eye tracking data collected by the 
%iView X eye tracker. It also creates the file such that it will have a header 
%as seen in the code. 
function gazeDataFD = createGazeDataLog(stimuliPath, timeStamp)
  %Given the stimuli path, we can remove the word stimuli and make it into 
  %results, which is where the data log will be stored in our infrastructure
  %folder 
  format long;
  resultsPath = strrep(stimuliPath, 'Stimuli', 'Results');
  %If directory does not exist, terminate program.
  if(exist(resultsPath, 'dir') ~=7)
    fprintf(['ERROR: There is no "Results" subdirectory within the'...
            ' Infrastructure directory. Since it was not found, the program'...
            ' will now abort.\n']);
    gazeDataFD = [];
    return
  end
  %Create path to file
  
  fileName = sprintf('%s%s', timeStamp, '.csv');
  filePath = sprintf('%s\\%s', resultsPath, fileName);
  gazeDataFD = fopen(filePath, 'w');
  %create header for file
  fprintf(gazeDataFD, ['Stimuli Name,Stimuli ID,Timestamp,LeftEyeGazeX,'...
                      'Left Eye Gaze,Left Eye Diameter\r\n']);
  return