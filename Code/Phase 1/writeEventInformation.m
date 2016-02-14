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
%Name: writeEventInformation
%Parameters: eventTime, logFileDescriptor, subjectNumber, movieName, movieNumber
%, startTime
%Function that writes down the subject's activity based on whatever key they
%may have pressed or the movie ended
function writeEventInformation(eventTime, logFileDescriptor, subjectNumber,...
                               mediaName, mediaNumber, startTime, opMode)
  movieMode = 0;
  imageMode = 1;
  if(opMode == movieMode)
    fprintf(logFileDescriptor, '%d,%s,%d,%f,%f\r\n', subjectNumber,...
            mediaName, mediaNumber, startTime, eventTime);
  else
    reactionTime = eventTime - startTime;
    fprintf(logFileDescriptor, '%d,%s,%d,%f,%f,%f\r\n', subjectNumber,...
            mediaName, mediaNumber, startTime, eventTime, reactionTime);
  end
  return