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
%Name: OSOrder
%Parameters: stimuliPath, operationMode
%Function that returns all of the paths to the media files located in the stimu-
%li directory. It does so by concatenating the stimuli path and the file name 
%via sprintf. It also contains the name of all the movies so that we can use 
%them when writing into the data log.
function [mediaOSOrder, mediaFiles] = OSOrder(stimuliPath, operationMode)
  %Create a vector with the file names and then display them
  movieMode = 0;
  imageMode = 1;
  directoryContents = dir(stimuliPath);
  mediaFiles = {};
  mediaPaths = {};
  for file = directoryContents'
    content = file.name;
    %Retrieve extension and store it in the files that we want if it's the 
    %correct format
    [~, ~, extension] = fileparts(content);
    if(operationMode == movieMode)
      if(strcmpi(extension, '.mov') || strcmpi(extension, '.mp4') ||...
         strcmpi(extension, '.avi'))
        mediaFiles{end + 1} = content;
      end
    else
      if(strcmpi(extension, '.jpg'))
        mediaFiles{end + 1} = content;
      end
    end
  end
  numberOfMedia = length(mediaFiles);
  %forms all of the paths to the movie files
  for index = 1:numberOfMedia
    mediaName = mediaFiles{index};
    fullPath = sprintf('%s\\%s', char(stimuliPath), char(mediaName));
    mediaPaths{end + 1} = fullPath;
  end
  mediaOSOrder = mediaPaths;
  return