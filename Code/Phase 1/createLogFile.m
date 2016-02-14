%"Copyright 2015 Isaac Jose Manjarres"

%This program is free software: you can redistribute it and/or modify
%it under the terms of the GNU General Public License as published by
%the Free Software Foundation, either version 3 of the License, or
%(at your option) any later version.

%The Mako Eye Tracking Toolbox is distributed in the hope that it will be useful,
%but WITHOUT ANY WARRANTY; without even the implied warranty of
%MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%GNU General Public License for more details.

%You should have received a copy of the GNU General Public License
%along with this program.  If not, see <http://www.gnu.org/licenses/>.

%Author: Isaac Jose Manjarres
%Name: createLogFile
%Parameters: pathName, subjectNumber, operationMode
%This function creates the file name for the log file that will 
%record the subject's behavior throughout the experiment. It forms the file 
%name by using an mmddyy_hhmmss format for the name. The data is collected 
%in the /Data section of the infrastructure directory
function fileDescriptor = createLogFile(pathName, subjectNumber, operationMode)
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
  fileName = sprintf('%s%s%s_%s%s%s%s', month, day, adjustedYear, hour,...
                     minutes, seconds, '.csv'); 
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
  %We add an extra item, which is the reaction time.
  else
    fprintf(fileDescriptor, ['Subject ID, Image Name, Image Number, Start,',... 
                              ' End, Reaction Time\r\n']);
  end
  return;