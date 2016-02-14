%Name: createLogFile
%Parameters: pathName, subjectNumber, operationMode
%This function creates the file name for the log file that will 
%record the subject's behavior throughout the experiment. It forms the file 
%name by using an mmddyy_hhmmss format for the name. The data is collected 
%in the /Data section of the infrastructure directory
function [fileDescriptor, timeStamp] = createLogFile(pathName, subjectNumber,...
                                                     operationMode)
  movieMode = 0;
  imageMode = 1;
  currentTime = clock;
  year = int2str(currentTime(1));
  month = int2str(currentTime(2));
  day = int2str(currentTime(3));
  hour = int2str(currentTime(4));
  minutes = int2str(currentTime(5));
  seconds = int2str(currentTime(6));
  adjustedYear = year(3:length(year));
  %Adjust the parameters if necessary to ensure that they conform to the 
  %mmddyy_hhmmss standard.
  if(length(month) == 1)
    month = strcat('0', month);
  end
  if(length(day) == 1)
    day = strcat('0', day);
  end
  if(length(hour) == 1)
    hour = strcat('0', hour);
  end
  if(length(minutes) == 1)
    minutes = strcat('0', minutes);
  end
  if(length(seconds) == 1)
    seconds = strcat('0', seconds);
  end
  timeStamp = sprintf('%s%s%s_%s%s%s', month, day, adjustedYear, hour, ...
                      minutes, seconds);
  fileName = sprintf('%s%s', timeStamp, '.csv'); 
  %Now we must create the log in the data directory of the infrastructure folder
  %We are given the path to the stimuli, which is a subdirectory within the 
  %infrastructure folder. We can proceed then to remove the stimuli portion of
  %the path and replace it with the Data to get to the directory.
  dataPath = strrep(pathName, 'Stimuli', 'Data');
  existentialValue = exist(dataPath, 'dir');
  %Verify that the data directory exists
  if(existentialValue ~= 7)
    fprintf(['The path to the Data directory does not exist.'...
             ' Please try again after making a Data directory.\n']);
    return
  end
  finalFileName = sprintf('%s\\%s', dataPath, fileName);
  %Create the file with the appropriate permissions
  try
    fileDescriptor = fopen(finalFileName, 'w');
    %Should fopen fail for some reason, we should not continue with the 
    %experiment
  catch
    fprintf('Opening log file decriptor failed. Aborting program now.\n');
    fileDescriptor = [];
    psychrethrow(psychlasterror);
    return;
  end
  %Write the header of the data log file but caution, as the op mode determines
  %which header to write
  if(operationMode == movieMode)
    fprintf(fileDescriptor, ['Subject ID,Movie Name, Movie Order, Start,',...
                             ' End\r\n']);
  else
    fprintf(fileDescriptor, ['Subject ID, Image Name, Image Number, Start,',... 
                              ' End, Reaction Time\r\n']);
  end
  return;