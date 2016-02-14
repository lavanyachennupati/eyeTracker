%Name: searchForOrder
%Parameters: orderFilePath, subjectNumber
%Function that searches for a specific line in a .txt/.csv file. This line is
%specified by the subject's ID which is the subject number parameter. This 
%parameter must be a valid subject ID meaning that it cannot exceed the number 
%of subjects that are participating in the experiment and it must be a positive
%number. 
function fileOrder = searchForOrder(orderFilePath, subjectNumber)
  existentialValue = exist(orderFilePath, 'file');
  %verify that the file does indeed exist
  if(existentialValue ~= 2)
    fprintf('The path you have entered is not a valid path name to a file.\n');
    return
  end
  %generate the number of line and then ensure that the requested line is within
  %the correct boundaries
  numberOfLines = lineCount(orderFilePath);
  %Ensure that the number entered is actually a valid number. If not, then abort
  if(isa(subjectNumber, 'double') ~= 1)
    fprintf('The subject number entered is not valid.\n')
    fileOrder = [];
    return
  end
  %Ensure that the subject number is within bounds.
  if(subjectNumber < 1 || subjectNumber > numberOfLines)
    fprintf('The subject number entered is not valid.\n');
    fileOrder = [];
    return
  end
  fileOrder = [];
  fileID = fopen(orderFilePath);
  lineNumber = 1;
  currentLine = fgetl(fileID);
  %Loop through the file until we get to the requested line. 
  while(ischar(currentLine) && lineNumber < subjectNumber)
    currentLine = fgetl(fileID);
    lineNumber = lineNumber + 1;
  end
  fclose(fileID); %TAGLINE: FILE DESCRIPTOR FOR ORDER CSV FILE CLOSED
  arrayOfStrings = strsplit(currentLine, ',');
  numberOfFiles = length(arrayOfStrings);
  %Convert each number from a string to a number so that it can be used as an 
  %index
  for index = 1:numberOfFiles
    fileNumber = str2num(arrayOfStrings{index});
    fileOrder(end + 1) = fileNumber;
  end
  return

%Specification function that returns the number of lines. This is used to verify
%that the user does not input a subject number that is invalid.
function numberOfLines = lineCount(orderFilePath)
  fileID = fopen(orderFilePath);
  numberOfLines = 0;
  currentLine = fgetl(fileID);
  while(ischar(currentLine))
    currentLine = fgetl(fileID);
    numberOfLines = numberOfLines + 1;
  end
  fclose(fileID);
  return