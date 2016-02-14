%Name: createResponseLog
%Parameters: stimuliPath
%The purpose of this function is to create a CSV file with the name response.csv
%inside of the Data subdirectory of the Infrastructure directory. Throughout the
%experiment, several questions will be asked, so this simply creates a file 
%descriptor for the response log and returns it to the main function for writing
%and reading purposes. The main function will later close it when it no longer 
%needs to write to it and read from it. 
function responseLogFileDescriptor = createResponseLog(stimuliPath, timeStamp)
  dataDirectoryPath = strrep(stimuliPath, 'Stimuli', 'Data');
  %If directory does not exist
  if(exist(dataDirectoryPath, 'dir') ~=7)
    fprintf(['ERROR: There is no "Data" subdirectory within the'...
            ' Infrastructure directory. Since it was not found, the program'...
            ' will now abort.\n']);
    responseLogFileDescriptor = [];
    return
  end
  %Create path to file
  fileName = sprintf('%s_%s%s', 'response', timeStamp, '.csv');
  responseLogPath = sprintf('%s\\%s', dataDirectoryPath, fileName);
  responseLogFileDescriptor = fopen(responseLogPath, 'w+');
  return