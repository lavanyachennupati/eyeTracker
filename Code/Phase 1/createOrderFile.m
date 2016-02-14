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
%Name: createOrderFile
%Parameters: stimuliPath
%The purpose of this script is to generate a CSV file that lists 
%all the possible orders in which a set of movies in a directory can be played. 
%However, this is done by associating each movie with the number it appears as 
%according to the operating system. For example, if the OS has decided to list 
%3 movies in the following order:
%darkWaves.mp4
%night.mp4
%sunrise.mp4
%then it follows, that darkWaves.mp4 is associated with the number 1, night.mp4
%is associated with the number 2, and so on.
%The CSV file that is then created is just rows which are permutations of the 
%set of movie numbers. So for example, if row 2 is 2,1,3 then that means
%we want to play the movies in the following order: night.mp4, darkWaves.mp4, 
%and sunrise.mp4
function createOrderFile(stimuliPath)
  if(nargin < 1 || isempty(stimuliPath))
    fprintf('Please enter a path name.\n');
    return
  end
  %ensure that it is a directory. NOTE: 7 is the return value of exist when it 
  %confirms that the given path is actually a directory
  existentialValue = exist(stimuliPath, 'dir');
  if(existentialValue ~= 7)
    fprintf(['The path that was entered is not a valid directory.'...
             ' Please try again.\n']);
    return
  end
  %Create a vector with the file names and then display them
  directoryContents = dir(stimuliPath);
  movieFiles = 0;
  for file = directoryContents'
    content = file.name;
    %Retrieve extension and store it in the files that we want if it's the 
    %correct format
    [~, ~, extension] = fileparts(content);
    if(strcmpi(extension, '.mov') || strcmpi(extension, '.mp4') ||... 
       strcmpi(extension, '.avi'))
      movieFiles = movieFiles + 1;
    end
  end
  finalFileName = sprintf('%s\\%s', stimuliPath, 'order.csv');
  %Create the file with the appropriate permissions
  fileDescriptor = fopen(finalFileName, 'w');
  allPermutations = perms(1:movieFiles);
  [rows columns] = size(allPermutations);
  for row = 1:rows
    for  col = 1:columns
      index = allPermutations(row, col);
      if(col < columns)
        fprintf(fileDescriptor, '%d,', index);
      else
        fprintf(fileDescriptor, '%d\r\n', index);
      end
    end
  end
  fclose(fileDescriptor);
  return
