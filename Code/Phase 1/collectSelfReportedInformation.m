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
%Name: collectSelfReportedInformation
%Parameters: pathName, orderFilePath, operationMode, 
%subjectNumber, DEBUG(optional parameter)
%The user specifies the directory by providing the path to the 
%stimuli directory as the first parameter to the function.
%The second parameter is a path to a CSV file that contains a set of orderings 
%that the user would like to use when playing the movies in.
%The third parameter, operationMode, is a parameter that determines whether or
%we are in movie mode or in image mode. Movie mode plays a set of movies in an 
%arbitrary order as specified in the order file in orderFilePath. Image mode 
%displays a set of images in an arbitrary order as specified in the order file 
%in orderFilePath. 
%OPERATION MODES: 0 <=> Movie Mode and 1 <=> Image Mode 
%The fourth parameter, subjectNumber, is the number of the subject being tested. 
%This subject number serves as a specifier when picking the order in which the 
%movies will be played for the subject. 
%The fifth parameter, DEBUG, is a parameter that allows the user to run the 
%program without creating data logs as a result of playback of movies. As of
%today, July 13th, 2015, there is only one debug mode: mode 1 which is simply
%used for disabling log creation and logging capabilities in general. To enable
%this mode, simply enter the parameter as 1. If no parameter is entered, then 
%the program will run in normal mode.
%The purpose of this function is to conduct an experiment under the following 
%scenarios:
%Scenario 1: To play a set of movies within a user-specified
%directory.  
%The user can also pause playback of the movies by pressing the spacebar key
%resume playback of the movies by pressing the r key 
%exit out of playback by pressing the escape key (esc)
%The file also creates a CSV file in the Data subdirectory of the Infrastructure
%directory that logs the user's activities in terms of pausing playback, 
%resuming playback, and exiting the playback.
%The function also creates two logs: one for logging the subject's behavior of 
%when they paused the movie and when they continued it. The second log is a
%response log that is created for the purpose of recording all of the subject's 
%responses to the questions asked throughout the experiment.
%Scenario 2: To show a set of images within a user-specified directory
%The user specifies the order in which these images will be played in in the 
%CSV file given by orderFilePath. The images will be displayed in the sequence
%specified there. To proceed to the next image, the user must press spacebar.
%The function also creates two logs: one for logging when the subject proceeded
%the next image, by logging a timestamp of when the image was shown, when the 
%subject proceeded to the next image by pressing spacebar, and the difference
%between these two, which is the reaction time. The second log is a
%response log that is created for the purpose of recording all of the subject's 
%responses to the questions asked throughout the experiment.
%Results subdirectory of the Infrastructure directory.
%Return Values: None
function collectSelfReportedInformation(pathName, orderFilePath,... 
                                        operationMode, subjectNumber, DEBUG)
  %Verify that the user entered a path, and then verify that it exists. Also 
  %make sure that all other inputs are correctly formatted. 
  movieMode = 0;
  imageMode = 1;
  if(nargin < 1 || isempty(pathName))
    fprintf('Please enter a path name.\n');
    return
  end
  if(nargin < 2 || isempty(orderFilePath))
    fprintf(['Please enter a path to the order file you will be using for'...
            ' this experiment.\n']);
    return
  end
  if(nargin < 3 || isempty(operationMode))
    if(~isempty(operationMode) && (operationMode ~=0 && operationMode ~= 1))
      fprintf(['%d is not a valid operation mode. Please enter',...
               'either 0 for movie mode or 1 for image mode.\n'],...
               operationMode);
      return
    else
      fprintf('Please enter an operation mode.\n');
      return 
    end
  end
  if(nargin < 4 || isempty(subjectNumber))
    fprintf('Please enter a subject number.\n');
    return
  end
  if(nargin < 5)
    DEBUG = 0;
  elseif(nargin == 5 && DEBUG ~= 1)
    fprintf('%d is not a valid debugging mode.\n', DEBUG);
    fprintf('Please enter a valid debugging mode.\n');
    return
  end
  existentialValue = exist(pathName, 'dir');
  if(existentialValue ~= 7)
    fprintf(['The path that was entered is not a valid directory.'...
             ' Please try again.\n']);
    return
  %We are sure it is a directory, but we should ensure that it is actually
  %the stimuli directory.
  elseif(isempty(strfind(pathName, 'Stimuli')))
    fprintf('The path entered is not a path to the stimuli folder.\n');
    fprintf('Aborting the program now.\n');
    return;
  end
  %path is valid, so we can proceed to process user's request and collect the
  %order that the movies will play in from the file specified by the user. This
  %will be a set of numbers that range from 1 to the number of movie files 
  %there are in the directory.
  if(operationMode == movieMode)
    movieFileOrder = searchForOrder(orderFilePath, subjectNumber);
    if(isempty(movieFileOrder))
      fprintf(['Cannot determine order from given order CSV file.'....
               ' Program aborted.']);
      return
    end
  %other wise, we are in image mode.
  else 
    imageFileOrder = searchForOrder(orderFilePath, subjectNumber);
    if(isempty(imageFileOrder))
      fprintf(['Cannot determine order from given order CSV file.'....
               ' Program aborted.']);
      return
    end
  end
  %Get the order in which the OS has stored the movie files that we are using. 
  %This will be used to play the movies in the order specified in the 
  %movieFileOrder array.
  if(operationMode == movieMode)
    [moviePaths, movieFiles] = OSOrder(pathName, operationMode);
  else
    [imagePaths, imageFiles] = OSOrder(pathName, operationMode);
  end
  %Create a log file that will monitor the subject's activity throughout the 
  %experiment. %Also create a log that will record the user's responses. 
  %CAUTION: The file descriptors created by this function have not been closed
  %as it is necessary to keep them open so that we can write to them throughout 
  %the experiment.
  %We only want to create a log if we are NOT in debug mode.
  if(DEBUG ~= 1)
    %Use a try statement to make the code more robust.
    try
      %Depending on the operation mode, either a behavioral log will be created
      %or an image log iwll be created
      logFileDescriptor = createLogFile(pathName, subjectNumber, operationMode);
      responseLogFD = createResponseLog(pathName);
      questionArray = generateQuestionBank(pathName);
      makeResponseLogHeader(responseLogFD, subjectNumber);
    catch
      fprintf('An error occured when opening a file descriptor.\n');
      psychrethrow(psychlasterror);
      fclose('all');
      return
    end
  end
  %Check to make sure that we don't need to abort:
  if(isempty(questionArray))
    fprintf(['Program aborted due to no questions being detected\n']);
    return
  end
  format longG;
  %Enable unified mode of KbName, so KbName accepts identical key names on all 
  %operating systems:
  KbName('UnifyKeyNames');
  escapeKey = KbName('ESCAPE');
  stopKey = KbName('space');
  resumeKey = KbName('r');
  try
    %ensures we use alternate screen(if we end up using one)
    screenNumber = max(Screen('Screens'));
    windowPointer = Screen('OpenWindow', screenNumber);
    displayInstructionScreens(pathName, windowPointer);
    %Loop through all of the movie file numbers and play 
    %them in the desired order
    %Point of divergence between the two experiments.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %CODE AFTER THE IF STATEMENT PERTAINS TO MOVIE DISPLAY PORTION OF THE      %
    %EXPERIMENT                                                                %   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if(operationMode == movieMode)
      Priority(1);
      stopFlag = 0;
      for movieNumber = movieFileOrder 
        fullPath = moviePaths{movieNumber};
        movieName = movieFiles{movieNumber};
        moviePointer = Screen('OpenMovie', windowPointer, fullPath);
        Screen('PlayMovie', moviePointer, 1);
        RestrictKeysForKbCheck([escapeKey, stopKey, resumeKey]);
        %Collect start time information to write down in log file.
        timeStart = GetSecs;
        while(1)
          [keyIsDown, seconds, keyCode] = KbCheck;
          if(keyIsDown)
            if(keyCode(stopKey))
              %Log information of when user paused playback
              pauseTime = GetSecs;
              if(DEBUG ~= 1)
                writeEventInformation(pauseTime, logFileDescriptor,... 
                                      subjectNumber, movieName, movieNumber,... 
                                      timeStart, operationMode);
              end
              stopFlag = 1;
              Screen('PlayMovie', moviePointer, 0);
              KbReleaseWait;
            end
            %Log information of when user resumed playback
            if(keyCode(resumeKey))
              timeStart = GetSecs;
              stopFlag = 0;
              Screen('PlayMovie', moviePointer, 1);
              KbReleaseWait;
            end
            %Escape which allows us to exit. Mostly for debugging purposes
            if(keyCode(escapeKey))
              exitTime = GetSecs;
              Screen('PlayMovie', moviePointer, 0);
              Screen('CloseMovie', moviePointer);
              Screen('CloseAll');
              if(DEBUG ~=1)
                writeEventInformation(exitTime, logFileDescriptor,... 
                                    subjectNumber, movieName, movieNumber, ... 
                                    timeStart, operationMode);
                fclose('all'); %TAGLINE: FILE DESCRIPTOR CLOSED
              end
              Priority(0)
              return
              break;
            end
          end
          if(stopFlag == 0)
            texture = Screen('GetMovieImage', windowPointer, moviePointer);
            %End of movie, so break out of infinite loop, since texture is
            %non-positive
            if(texture <= 0)
              askQuestions(questionArray, responseLogFD, subjectNumber,...
                           windowPointer);
              timeEnd = GetSecs;
              if(DEBUG ~= 1)
                writeEventInformation(timeEnd, logFileDescriptor,... 
                                  subjectNumber, movieName, movieNumber,... 
                                  timeStart, operationMode);
              end
              break;
            end
            Screen('DrawTexture', windowPointer, texture);
            Screen('Flip', windowPointer);
            Screen('Close', texture);
          end
        end
        Screen('PlayMovie', moviePointer, 0);
        %Close Movie and any screens. 
        Screen('CloseMovie', moviePointer);
      end
      Screen('CloseAll');
      Priority(0);
    else
      for imageNumber = imageFileOrder
        imagePath = imagePaths{imageNumber};
        imageName = imageFiles(imageNumber);
        imageMatrix = imread(char(imagePath));
        texture = Screen('MakeTexture', windowPointer, imageMatrix);
        Screen('DrawTexture', windowPointer, texture);
        RestrictKeysForKbCheck([stopKey]);
        [~, stimulusOnset, ~] = Screen('Flip', windowPointer);
        Screen('Close', texture);
        readyForNextImage = 0;
        while(~readyForNextImage)
          [~, readyForNextImageTime, keyCode] = KbCheck;
          if(keyCode(stopKey))
            readyForNextImage = 1;
            writeEventInformation(readyForNextImageTime, logFileDescriptor,...
                                  subjectNumber, char(imageName),... 
                                  imageNumber, stimulusOnset, operationMode);
            KbReleaseWait;
          end
        end
        askQuestions(questionArray, responseLogFD, subjectNumber,...
                     windowPointer);
      end
    end
    Screen('CloseAll');
    if(DEBUG ~= 1)
      exportToMasterFile(responseLogFD, pathName);
    end
    fclose('all');
  catch
    fprintf('An error occured during execution. Please try again.\n');
    if(DEBUG ~= 1)
      fclose('all'); %TAGLINE: FILE DESCRIPTORS CLOSED
    end
    sca;
    Priority(0);
    psychrethrow(psychlasterror);
  end