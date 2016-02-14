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
%Name: generateQuestionBank
%Parameters: instructionPath
%The purpose of this function is to generate a cell array that contains all of
%the paths to the questions that will be utilized in the experiment. In order 
%to properly generate the questions, they should be named in the following form-
%at: Question_X where X denotes the order in which the question will be
%presented in. This function makes the assumption that the questions are stored
%in the Questions subdirectory of the Infrastructure directory. 
function questionBank = generateQuestionBank(stimuliPath)
  instructionDirectoryPath = strrep(stimuliPath, 'Stimuli', 'Questions');
  questionBank = {};
  if(exist(instructionDirectoryPath, 'dir') ~=7)
    fprintf(['ERROR: There is no "Questions" subdirectory within the'...
            ' Infrastructure directory. Since it was not found, the program'...
            ' will now abort.\n']);
    return
  end
  directoryContents = dir(instructionDirectoryPath);
  %collect all questions
  for file = directoryContents'
    content = file.name;
    [~, name, extension] = fileparts(content);
    if(~isempty(strfind(name, 'Question_')) && strcmp(extension, '.jpg'))
      questionPath = sprintf('%s\\%s', instructionDirectoryPath, content);
      questionBank{end + 1} = questionPath;
    end
  end
  return