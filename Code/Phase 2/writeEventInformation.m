%Name: writeEventInformation
%Parameters: eventTime, logFileDescriptor, subjectNumber, movieName, movieNumber
%, startTime
%Function that writes down the subject's activity based on whatever key they
%may have pressed or the movie ended
function writeEventInformation(eventTime, logFileDescriptor, subjectNumber,...
                               movieName, movieNumber, startTime, opMode)
  movieMode = 0;
  imageMode = 1;
  if(opMode == movieMode)
    fprintf(logFileDescriptor, '%d,%s,%d,%f,%f\r\n', subjectNumber,...
            movieName, movieNumber, startTime, eventTime);
  else
    reactionTime = eventTime - startTime;
    fprintf(logFileDescriptor, '%d,%s,%d,%f,%f,%f\r\n', subjectNumber,...
            movieName, movieNumber, startTime, eventTime, reactionTime);
  end
  return