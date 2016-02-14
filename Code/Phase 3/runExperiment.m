%Name: runExperiment
%Parameters: pathName, orderFilePath, operationMode, 
%subjectNumber, eyeTrackingMode, DEBUG(optional parameter)
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
%Finally, if eye tracking is enabled, then the eye tracker will be calibrated 
%at the very beginning of the experiment, and throughout the experiment, 
%gaze data will be collected and stored in a time stamped CSV file in the
%Results subdirectory of the Infrastructure directory.
%Return Values: None
function runExperiment(pathName, orderFilePath, operationMode, subjectNumber,... 
                       eyeTrackingMode, DEBUG)
  %Verify that the user entered a path, and then verify that it exists. Also 
  %make sure that all other inputs are correctly formatted.
  %Parameters for data types for when we export data to their respective
  %master logs
  selfReportedData = 1;
  calibrationData = 2;
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
    if(~isempty(operationMode) && (operationMode ~= 0 && operationMode ~= 1))
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
  if(nargin < 5 || isempty(eyeTrackingMode))
    fprintf(['Please specify if you are or are not going to use the eye',... 
             'tracking device\n']);
  end
  if(nargin < 6)
    DEBUG = 0;
  elseif(nargin == 6 && (DEBUG ~= 1 && DEBUG ~= 0))
    fprintf('%d is not a valid debugging mode.\n', DEBUG);
    fprintf('Please enter a valid debugging mode.\n');
    return
  end
  existentialValue = exist(pathName, 'dir');
  if(existentialValue ~= 7)
    fprintf(['The path that was entered is not a valid directory.'...
             ' Please try again.\n']);
    return
  elseif(isempty(strfind(pathName, 'Stimuli')))
    fprintf('The path entered is not a path to the stimuli folder.\n');
    fprintf('Aborting the program now.\n');
    return
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
    try
      [logFileDescriptor, timeStamp] = createLogFile(pathName, subjectNumber,...
                                                     operationMode);
      responseLogFD = createResponseLog(pathName, timeStamp);
      questionArray = generateQuestionBank(pathName);
      makeResponseLogHeader(responseLogFD, subjectNumber);
    catch
      fprintf('An error occured when opening a file descriptor.\n');
      psychrethrow(psychlasterror);
      fclose('all');
      return
    end
  end
  if(isempty(questionArray) && DEBUG ~= 1)
    fprintf(['Program aborted due to no questions being detected\n']);
    return
  end
  if(DEBUG ~= 1 && eyeTrackingMode == 1) 
    try
      gazeDataLogFD = createGazeDataLog(pathName, timeStamp); 
      gazeCalibDataFD = createGazeCalibrationLog(pathName, timeStamp); 
    catch
      fprintf('An error occured when opening a file descriptor.\n');
      psychrethrow(psychlasterror);
      fclose('all');
      return
    end
  end
  %Run setup code if we are in eye tracking mode. DO NOT CHANGE ANY OF THESE 
  %SETTINGS!
  if(eyeTrackingMode == 1)
    % --------------------------------------------------------------------------
    % ---- initialization
    % --------------------------------------------------------------------------
    warning('off', 'all');
    connected = 0;
    calibrated = 0;
    % add path variable to find the right header file and libraries
    path(path,'..\..\..\..\include')
    path(path,'..\..\..\..\bin');
    %defining the architecture of the libraries which needs to be used
    if computer('arch') == 'win32'
      includename = 'iViewXAPI.h';
      dllname = 'iViewXAPI.dll';
      libraryname = 'iViewXAPI';
    else 
      includename = 'iViewXAPI.h';
      dllname = 'iViewXAPI64.dll';
      libraryname = 'iViewXAPI64';
    end
    % --------------------------------------------------------------------------
    % ---- load the iView X API library
    % --------------------------------------------------------------------------

    loadlibrary(dllname, includename);
    %This initializes all of the necessary calibration information when starting 
    %up the device. These are parameters defined by the iViewX SDK and should 
    %NOT be changed
    % --------------------------------------------------------------------------
    % ---- initialize iView X API 
    % --------------------------------------------------------------------------
    % see the User Manual for detailed information due to setting up calibration
    [pSystemInfoData, pSampleData, pEventData, pAccuracyData, CalibrationData] = InitiViewXAPI();
    CalibrationData.method = int32(5);
    CalibrationData.visualization = int32(1);
    CalibrationData.displayDevice = int32(1); %We will use 1 since we are using
    %an external monitor to display our stimulus.
    CalibrationData.speed = int32(0);
    CalibrationData.autoAccept = int32(1);
    CalibrationData.foregroundBrightness = int32(250);
    CalibrationData.backgroundBrightness = int32(230);
    CalibrationData.targetShape = int32(2);
    CalibrationData.targetSize = int32(20);
    CalibrationData.targetFilename = int8('');
    pCalibrationData = libpointer('CalibrationStruct', CalibrationData);
    % ------------------------------------------------------------------------- 
    % ---- connect to iView X (eyetracking-server) 
    % -------------------------------------------------------------------------
    disp('Define Logger')
    calllib(libraryname, 'iV_SetLogger', int32(1), 'iViewXSDK_Matlab_Slideshow_Demo.txt')
    disp('Connect to iViewX (eyetracking-server)')
    ret = calllib(libraryname, 'iV_Connect', '127.0.0.1', int32(4444), '127.0.0.1', int32(5555));
    switch ret
      case 1
        connected = 1;
      case 104
        msgbox('Could not establish connection. Check if Eye Tracker is running', 'Connection Error', 'modal');
      case 105
        msgbox('Could not establish connection. Check the communication Ports', 'Connection Error', 'modal');
      case 123
        msgbox('Could not establish connection. Another Process is blocking the communication Ports', 'Connection Error', 'modal');
      case 200 
        msgbox('Could not establish connection.', 'Check if the Eye Tracker is installed and running', 'Connection Error', 'modal');
      otherwise
        msgbox('Could not establish connection', 'Connection Error', 'modal');
    end
    if connected
       % -----------------------------------------------------------------------
       % ---- read out system information 
       % -----------------------------------------------------------------------
      disp('Get System Info Data')
      calllib(libraryname, 'iV_GetSystemInfo', pSystemInfoData)
      get(pSystemInfoData, 'Value')
      % ------------------------------------------------------------------------
      % ---- start the calibration and validation process 
      % ------------------------------------------------------------------------'
      %NOTE: This process will be repeated until either user is satisfied with 
      %calibration deviations or deviation parameters are below 0.5 degrees
      optimalCalibrationValue = 0.5; %degrees
      while(~calibrated)
        disp('Calibrate iView X (eyetracking-server)')
        calllib(libraryname, 'iV_SetupCalibration', pCalibrationData)
        disp('Please press spacebar when you are ready for calibration to begin.')
        calllib(libraryname, 'iV_Calibrate')
        disp('Validate Calibration')
        calllib(libraryname, 'iV_Validate')
        disp('Show Accuracy')
        calllib(libraryname, 'iV_GetAccuracy', pAccuracyData, int32(0))
        accuracyStruct = libstruct('AccuracyStruct', pAccuracyData);
        get(pAccuracyData, 'Value')
        if((accuracyStruct.deviationLX > optimalCalibrationValue) ||... 
           (accuracyStruct.deviationLY > optimalCalibrationValue) ||...
           (accuracyStruct.deviationRX > optimalCalibrationValue) ||...
           (accuracyStruct.deviationRY > optimalCalibrationValue))
          warningMsg = sprintf(['WARNING: The program has detected that', ...
                                 ' one of the calibration deviations', ...
                                 ' exceeds %f. It is strongly recommended', ...
                                 ' that you re-do the calibration procedure',...
                                 '. However, you may continue at your own',...
                                 ' risk. Would you like to re-do the', ...
                                 ' calibration?'], optimalCalibrationValue);
          calibrated = questdlg(warningMsg, 'Calibration Warning', ...
                                 'Calibrate Again', 'Continue Experiment', ...
                                 'Calibrate Again');
          if(strcmpi('Calibrate Again', calibrated))
            calibrated = 0;
          elseif(strcmpi('Continue Experiment', calibrated))
            calibrated = 1;
            writeCalibrationData(subjectNumber, gazeCalibDataFD,... 
                                 accuracyStruct);
            disp(['Calibration data recorded. Continuing experiment.'])
          else
            return
          end
        else
          calibrated = 1;
          writeCalibrationData(subjectNumber, gazeCalibDataFD,...
                               accuracyStruct);
          disp(['Calibration test passed, and calibration data has been'... 
                ' recorded successfully.']);
        end 
      end
    else 
      return
    end
    %Once everything is setup, prepare the data collection struct.
    gazeDataStructure = struct('timeStamp', [], 'lGazeX', [], 'lGazeY', [], ...
                               'eyeDiameter', [], 'stimuliID', [], ...
                               'stimuliNames', []);  
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
        %Start the recording process now for this movie, but only if we are in 
        %eye tracking mode 
        if(eyeTrackingMode == 1)
          %clear the eye tracker's buffer and begin recording 
          calllib(libraryname, 'iV_ClearRecordingBuffer');
          calllib(libraryname, 'iV_StartRecording');
        end
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
              %If subject exits, we would still like to collect the gaze data 
              %we have. We would also like to stop recording from the eye 
              %tracker
              if(eyeTrackingMode == 1)
                calllib(libraryname, 'iV_StopRecording');
                saveEyeTrackingData(movieName, pathName, timeStamp);
              end
              if(eyeTrackingMode == 1)
                writeToGazeDataLog(gazeDataStructure, imageFiles, gazeDataLogFD);
                exportToMasterFile(gazeCalibDataFD, pathName, calibrationData);
              end
              Priority(0)
              %We would also like to save the calibration data and gaze data log
              %data
              return
            end
          end
          if(stopFlag == 0)
            timeEnd = GetSecs;
            texture = Screen('GetMovieImage', windowPointer, moviePointer);
            %End of movie, so break out of infinite loop, since texture is
            %non-positive
            if(texture <= 0)
              if(DEBUG ~= 1)
                writeEventInformation(timeEnd, logFileDescriptor,... 
                                  subjectNumber, movieName, movieNumber,... 
                                  timeStart, operationMode);
              end
              %Once the movie is over, we must tell the eye tracker to stop
              %recording, and to save the IDF for the current movie. 
              if(eyeTrackingMode == 1)
                calllib(libraryname, 'iV_StopRecording');
                saveEyeTrackingData(movieName, pathName, timeStamp,...
                                    libraryname);
              end
              askQuestions(questionArray, responseLogFD, subjectNumber,...
                           windowPointer);
              break;
            end
            Screen('DrawTexture', windowPointer, texture);
            Screen('Flip', windowPointer);
            Screen('Close', texture);
          end
          %As soon as we call flip, we want to begin getting data. However, if
          %the user stops playback of the movies, we would still like to
          %continue getting samples. As a result, we place the call to
          %iV_GetSample, here. 
          if(eyeTrackingMode == 1)
            returnValue = calllib(libraryname, 'iV_GetSample', pSampleData);
            if(returnValue ~=2 && returnValue == 1)
              sample = libstruct('SampleStruct', pSampleData);
              gazeDataStructure.timeStamp = [gazeDataStructure.timeStamp; ... 
                                             sample.timestamp];
              gazeDataStructure.lGazeX = [gazeDataStructure.lGazeX; ...
                                          sample.leftEye.gazeX];
              gazeDataStructure.lGazeY = [gazeDataStructure.lGazeY; ...
                                          sample.leftEye.gazeY];
              gazeDataStructure.eyeDiameter = [gazeDataStructure.eyeDiameter; ...
                                               sample.leftEye.diam];
              gazeDataStructure.stimuliID = [gazeDataStructure.stimuliID; ...
                                             movieNumber];
              gazeDataStructure.stimuliNames = [gazeDataStructure.stimuliNames;...
                                                {movieName}];
            end
          end
        end
        Screen('PlayMovie', moviePointer, 0);
        %Close Movie and any screens. 
        Screen('CloseMovie', moviePointer);
      end
      Screen('CloseAll');
      Priority(0);
    %We are in the image mode portion of the code
    else
      %We get the image and create an image matrix from it, so that it can be 
      %drawn onto the backbuffer. Then, we call flip.
      % clear recording buffer
      for imageNumber = imageFileOrder
        imagePath = imagePaths{imageNumber};
        imageName = imageFiles(imageNumber);
        imageMatrix = imread(char(imagePath));
        texture = Screen('MakeTexture', windowPointer, imageMatrix);
        Screen('DrawTexture', windowPointer, texture);
        if(eyeTrackingMode == 1)
          calllib(libraryname, 'iV_ClearRecordingBuffer');
          % start recording
          calllib(libraryname, 'iV_StartRecording');
        end
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
            calllib(libraryname, 'iV_StopRecording');
            KbReleaseWait;
            break;
          end
          %If the eye tracker is currently on, we would like to collect the 
          %data.
          if(eyeTrackingMode == 1)
            returnValue = calllib(libraryname, 'iV_GetSample', pSampleData);
            if(returnValue ~=2 && returnValue == 1)
              sample = libstruct('SampleStruct', pSampleData);
              gazeDataStructure.timeStamp = [gazeDataStructure.timeStamp; ... 
                                             sample.timestamp];
              gazeDataStructure.lGazeX = [gazeDataStructure.lGazeX; ...
                                          sample.leftEye.gazeX];
              gazeDataStructure.lGazeY = [gazeDataStructure.lGazeY; ...
                                          sample.leftEye.gazeY];
              gazeDataStructure.eyeDiameter = [gazeDataStructure.eyeDiameter; ...
                                               sample.leftEye.diam];
              gazeDataStructure.stimuliID = [gazeDataStructure.stimuliID; ...
                                             imageNumber];
              gazeDataStructure.stimuliNames = [gazeDataStructure.stimuliNames;...
                                                {imageName}];
              end
          end
        end
        if(eyeTrackingMode == 1)
          saveEyeTrackingData(imageName, pathName, timeStamp, libraryname);
        end
        askQuestions(questionArray, responseLogFD, subjectNumber,... 
                     windowPointer);
      end
    end
    if(eyeTrackingMode == 1)
      if(operationMode == movieMode)
        writeToGazeDataLog(gazeDataStructure, movieFiles, gazeDataLogFD);
      %So we're in movie mode.
      else
        writeToGazeDataLog(gazeDataStructure, imageFiles, gazeDataLogFD);
      end
      exportToMasterFile(gazeCalibDataFD, pathName, calibrationData);
    end
    Screen('CloseAll');
    if(DEBUG ~= 1)
      exportToMasterFile(responseLogFD, pathName, selfReportedData);
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