%Name: generateQuestionBank
%Parameters: instructionPath
%The purpose of this function is to generate a cell array that contains all of
%the paths to the questions that will be utilized in the experiment. In order 
%to properly generate the questions, they should be named in the following form-
%at: Question_X where X denotes the order in which the question will be
%presented in. This function makes the assumption that the questions are stored
%in the Instructions subdirectory of the Infrastructure directory. 
function questionBank = generateQuestionBank(stimuliPath)
  instructionDirectoryPath = strrep(stimuliPath, 'Stimuli', 'Questions');
  questionBank = {};
  abortProgram = 1;
  global abort;
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