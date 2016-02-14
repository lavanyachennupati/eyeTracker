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