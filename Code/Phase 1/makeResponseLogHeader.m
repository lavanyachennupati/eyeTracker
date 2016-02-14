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
%Name: makeResponseLogHeader
%Parameters: responseLogFD, subjectNumber
%This is a subfunction that is called by the askQuestions function. Its purpose
%is to write the header into the response csv file that collects the answer to 
%any of the user's questions to the subject.  %The format the we use for 
%the header is 
%Question NumericResponse ResponseTime Question NumericResponse ResponseTime 
%and so on. 
%An example would be 
%Age Numeric Response Response Time
%20          1               3.0000 
%thus, we make the header conform to this standard. Note: The numeric response
%is the number of the numeric key that was pressed to answer the question. 
%The header is constructed via the following process: A question name is 
%extracted from the questionNames array. After this is done, it has the 
%Numeric Response and Response Time strings appended to it. This is now a 
%question with a header, so we store it in the questionHeaderArray. After this,
%We have the finalHeader which initially consists of the subject number string.
%We continually append the question headers until we have a complete header. 
%Finally, this header is printed into the response log.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%IMPORTANT: In order to guarantee that the header is correctly written to the  %
%response log, it is imperative that the name of the questions be changed in   %
%the questionNames cell array below.                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function makeResponseLogHeader(responseLogFD, subjectNumber)
  numericResponseString = 'Numeric Response';
  responseTimeString = 'Response Time';
  questionNames = {'Age', 'Ethnicity', 'Gender',... 
                   'Seen Before?', 'How Long Ago?'};
  %Questions that have had the Numeric Response and Response time components of
  %the header appended to it will be stored in this cell array.
  questionHeaderArray = {};
  for i = 1:length(questionNames)
    if(i ~= length(questionNames))
      questionString = sprintf('%s,%s,%s,', char(questionNames(i)),...
                              numericResponseString, responseTimeString);
    else
      questionString = sprintf('%s,%s,%s', char(questionNames(i)),...
                              numericResponseString, responseTimeString);
    end
    questionHeaderArray{end + 1} = questionString;
  end
  finalHeader = 'Subject Number,';
  for i = 1:length(questionHeaderArray)
    finalHeader = strcat(finalHeader, char(questionHeaderArray(i)));
  end
  fprintf(responseLogFD, '%s\r\n', finalHeader);
  return



