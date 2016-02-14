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
%Name: exportToMasterFile
%Parameters: responseLogFD, stimuliPath
%Function that exports the data collected from the subject and is stored in the 
%response log to a master response log that has all data from previous subjects
%If it does not exist, it will be created.
function exportToMasterFile(responseLogFD, stimuliPath)
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
  fseek(responseLogFD, byteOffset, 'bof');
  currentLine = fgets(responseLogFD);
  %read until we reach EOF.
  while(ischar(currentLine))
    fprintf(masterFD, '%s', currentLine);
    currentLine = fgets(responseLogFD);
  end
  return
