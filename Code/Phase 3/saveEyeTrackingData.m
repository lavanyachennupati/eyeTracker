%Author: Isaac Jose Manjarres
%Name: saveEyeTrackingData
%Parameters: mediaName, stimuliPath, timeStamp
%The purpose of this function is to create an IDF containing all of the gaze 
%tracking data that is currently in the eye tracker's buffer. This function is 
%called after any type of media is shown but before the subject is asked any 
%questions. For example, if we are displaying a movie or image, then once the 
%movie is done playing or the user presses spacebar to proceed to the next
%image, then the eye tracking data for that stimulus is recording in an IDF. 
%This IDF can later be used with the BeGaze software to get the raw data 
%obtained from the trial or to see other types of data, such as beeswarm
%videos. The IDF is contained within the Results subdirectory
function saveEyeTrackingData(mediaName, stimuliPath, timeStamp, libraryname)
  SUCCESS = 1; %defined in eye tracking API.
  resultsPath = strrep(stimuliPath, 'Stimuli', 'Results');
  %If directory does not exist, terminate program.
  if(exist(resultsPath, 'dir') ~=7)
    fprintf(['ERROR: There is no "Results" subdirectory within the'...
            ' Infrastructure directory. Since it was not found, the program'...
            ' will now abort.\n']);
    return
  end
  [~, name, ~] = fileparts(char(mediaName));
  fileName = sprintf('%s_%s%s', timeStamp, name, '.idf');
  filePath = sprintf('%s\\%s', resultsPath, fileName);
  user = 'User1';
  description = 'Experiment';
  %If the file with the same name already exists, then overwrite it.
  overwrite = int32(1);
  returnValue = calllib(libraryname, 'iV_SaveData', filePath, description,...
                        user, overwrite);
  if(returnValue == SUCCESS)
    fprintf('Successfully created IDF for file %s', name);
  end
  return
