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
%Name: displayInstructionScreens
%Parameters: stimuliPath, windowPointer
%This function is used as a sub-function within the runExperiment
%function. As thus, it will never really be invoked on its own. The purpose of
%this function is to display a set of instruction slides prior to showing a
%sequence of movies. For the sake of simplicity it is necessary that the files
%that contain the instruction slides--these will be jpeg images at the moment--
%be named as Instruction_Slide_X, where X denotes the slide number. 
%This function will allow the user to read the instructions and then hit the 
%enter key when they are ready to continue to the next instruction screen. When
%the final instruction key is hit, the function will return to the main function
%collectMovieInformation, where the experiment will begin by playing the first
%movie specified in the sequence.
function displayInstructionScreens(stimuliPath, windowPointer)
  %Form the path to where the images that serve as the instruction slides are 
  %contained
  instructionDirectoryPath = strrep(stimuliPath, 'Stimuli', 'Instructions');
  %Once we have a complete path, we must verify that it is indeed an actual 
  %directory.
  abortProgram = 1;
  if(exist(instructionDirectoryPath, 'dir') ~= 7)
    fprintf(['ERROR: There is not an "Instructions" subdirectory in your'...
            ' Infrastructure directory. Since it was now found, the program'...
            ' will now abort.\n']);
    return
  end
  %Now that we have verified that the path does exist, we must check for the
  %instruction screens. We will collect all of the instruction slides and form
  %paths to them.
  instructionSlidePaths = {};
  directoryContents = dir(instructionDirectoryPath);
  for file = directoryContents'
    content = file.name;
    [~, name, extension] = fileparts(content);
    %If the file that we are analyzing conforms to the required format, then 
    %we create a path to it and add it to our paths
    if(~isempty(strfind(name, 'Instruction_Slide')) && ...
      (strcmp(extension, '.jpg')))
      slidePath = sprintf('%s\\%s', instructionDirectoryPath, content);
      instructionSlidePaths{end + 1} = slidePath;
    end
  end
  %Associate enter key with the readyKey
  readyKey = KbName('return');
  RestrictKeysForKbCheck([readyKey]);
  %Now that we have generated the paths to the instructions we can show them.
  %We will use the window that is already open to display the instruction screen
  for instructionSlide = instructionSlidePaths
    %Matrix that contains the picture. Note that images can be decomposed into 
    %matrices with their RGB components, and such. This is why we use the 
    %imread function. 
    readyToProceed = 0;
    imageMatrix = imread(char(instructionSlide)); 
    %Now we can use PTB's function to create a texture from this 
    texture = Screen('MakeTexture', windowPointer, imageMatrix);
    %Draw texture on backbuffer
    Screen('DrawTexture', windowPointer, texture);
    %Flip to display the image
    Screen('Flip', windowPointer);
    %At this point, we want the reader to be able to read the instructions and 
    %proceed if they're ready to do so. They can notify us that they are ready 
    %by pressing the enter key.
    while(~readyToProceed)
      [~, ~, keyCode] = KbCheck; 
      %disp(keyCode);
      if(keyCode(readyKey))
        readyToProceed = 1;
        %Continue when user lets go of key.
        Screen('Close', texture);
        KbReleaseWait;
      end
    end
  end
  %Done playing instruction screens
  return

