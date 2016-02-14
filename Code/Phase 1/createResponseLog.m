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
%Name: createResponseLog
%Parameters: stimuliPath
%The purpose of this function is to create a CSV file with the name response.csv
%inside of the Data subdirectory of the Infrastructure directory. Throughout the
%experiment, several questions will be asked, so this simply creates a file 
%descriptor for the response log and returns it to the main function for writing
%and reading purposes. The main function will later close it when it no longer 
%needs to write to it and read from it. 
function responseLogFileDescriptor = createResponseLog(stimuliPath)
  dataDirectoryPath = strrep(stimuliPath, 'Stimuli', 'Data');
  global abort;
  %If directory does not exist
  if(exist(dataDirectoryPath, 'dir') ~=7)
    fprintf(['ERROR: There is no "Data" subdirectory within the'...
            ' Infrastructure directory. Since it was not found, the program'...
            ' will now abort.\n']);
    responseLogFileDescriptor = [];
    return
  end
  %Create path to file
  systemTime = clock;
  month = int2str(systemTime(2));
  day = int2str(systemTime(3));
  year = int2str(systemTime(1));
  hour = int2str(systemTime(4));
  minutes = int2str(systemTime(5));
  seconds = int2str(systemTime(6));
  year = year(3:length(year));
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
  fileName = sprintf('%s_%s%s%s_%s%s%s%s', 'response', month, day, year, ...
                      hour, minutes, seconds, '.csv');
  responseLogPath = sprintf('%s\\%s', dataDirectoryPath, fileName);
  responseLogFileDescriptor = fopen(responseLogPath, 'w+');
  return





