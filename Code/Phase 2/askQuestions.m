%Name: askQuestions
%Parameters: questionBank, responseLogFD, windowPointer
%The purpose of this function is to ask a specific set of questions and record
%the user's responses to them in the response log. As of today, June 19th, 2015
%this is simply a template or framework of how to ask multiple questions to 
%a test subject after playback of a movie. This also assumes that the same set
%of questions will be asked after the playback of every movie. This is done by
%looping through the question bank and displaying every question. When a 
%question is displayed, we wait for the user to respond by pressing an appropri
%ate key that will cause their response to be logged, along with the delta
%time that it took them to decide in a response. Then, we move on to the next
%question.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%IMPORTANT: When adding a question, you must assign it a question number in    %
%this section of code. If it is named Question_X then there should be a line at%
%the beginning of the function that specifies that the question is question x. %
%For example, a question about age should be entered as follows:               %
%ageQuestion = 1;                                                              %               
%Doing this will allow you to insert the question into the switch statement.   %
%Make a case in the switch statement for the question  by first calling flip   %
%and recording the stimulus onset time(questionDisplayTime). Then, make a tight%
%loop that can only be exited when the user has entered a valid input(change   %
%the value of readyForNextQuestion to 1). Finally, within the while loop, at   %
%the first line, make a call to KbStrokeWait and obtain the time in seconds at %
%which the response was entered, and the keycode to generate a response time as% 
%well as what key was entered. Then, make a series of if and else if statements%
%for the correct answers.                                                      %                                                                              
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function askQuestions(questionBank, responseLogFD, subjectNumber, windowPointer)
  %this lets the program know what question its on and will allow the program
  %to log only appropriate key responses.
  questionNumber = 1; 
  ageQuestion = 1;
  ethnicityQuestion = 2;
  genderQuestion = 3;
  seenBeforeQuestion = 4;
  howLongQuestion = 5;
  %This array of strings should be edited to reflect the order in which the
  %questions are asked. It is imperative that this is done so that the headers 
  %for the questions are printed in the correct order.
  key1 = KbName('1');
  key2 = KbName('2');
  key3 = KbName('3');
  key4 = KbName('4');
  key5 = KbName('5');
  key6 = KbName('6');
  key7 = KbName('7');
  key8 = KbName('8');
  yesKey = KbName('y');
  noKey = KbName('n');
  fprintf(responseLogFD, '%d,', subjectNumber);
  for question = questionBank
    readyForNextQuestion = 0;
    %generate the question and draw it onto the backbuffer, but do not display
    %it yet. 
    imageMatrix = imread(char(question));
    texture = Screen('MakeTexture', windowPointer, imageMatrix);
    Screen('DrawTexture', windowPointer, texture);
    %This switch statement uses the question number to enter the appropriate
    %section of code. 
    switch questionNumber
      case ageQuestion
        %display the question
        [~, questionDisplayTime, ~] = Screen('Flip', windowPointer);
        while(~readyForNextQuestion)
          [responseEnteredTime, keyCode] = KbStrokeWait;
          %In here, we assign the possible response values. And the responses
          %that correspond to the key. fprintf statement logs the response.
          responseTime = responseEnteredTime - questionDisplayTime;
          if(keyCode(key1))
            response = '18-24';
            keyPressed = 1;
            fprintf(responseLogFD, '%s,%d,%f,', response, keyPressed, ...
                    responseTime);
            Screen('Close', texture);
            readyForNextQuestion = 1;
          elseif(keyCode(key2))
            response = '25-34';
            keyPressed = 2;
            fprintf(responseLogFD, '%s,%d,%f,', response, keyPressed, ...
                    responseTime);
            Screen('Close', texture);
            readyForNextQuestion = 1;
          elseif(keyCode(key3))
            response = '35-44';
            keyPressed = 3;
            fprintf(responseLogFD, '%s,%d,%f,', response, keyPressed, ...
                    responseTime);
            Screen('Close', texture);
            readyForNextQuestion = 1;
          elseif(keyCode(key4))
            response = '45-44';
            keyPressed = 4;
            fprintf(responseLogFD, '%s,%d,%f,', response, keyPressed, ...
                    responseTime);
            Screen('Close', texture);
            readyForNextQuestion = 1;
          elseif(keyCode(key5))
            response = '55+';
            keyPressed = 5;
            fprintf(responseLogFD, '%s,%d,%f,', response, keyPressed, ...
                    responseTime);
            Screen('Close', texture);
            readyForNextQuestion = 1;
          elseif(keyCode(key6))
            response = 'Prefer not to answer';
            keyPressed = 6;
            fprintf(responseLogFD, '%s,%d,%f,', response, keyPressed, ...
                    responseTime);
            Screen('Close', texture);
            readyForNextQuestion = 1;
          else
            fprintf(['The key entered was not a valid response.'...
             ' Please input a valid response.\n']);
          end
        end
      case ethnicityQuestion
        [~, questionDisplayTime, ~] = Screen('Flip', windowPointer);
        while(~readyForNextQuestion)
          [responseEnteredTime, keyCode] = KbStrokeWait;
          responseTime = responseEnteredTime - questionDisplayTime;
          if(keyCode(key1))
            response = 'White';
            keyPressed = 1;
            fprintf(responseLogFD, '%s,%d,%f,', response, keyPressed, ...
                    responseTime);
            Screen('Close', texture);
            readyForNextQuestion = 1;
          elseif(keyCode(key2))
            response = 'Hispanic/Latino';
            keyPressed = 2;
            fprintf(responseLogFD, '%s,%d,%f,', response, keyPressed, ...
                    responseTime);
            Screen('Close', texture);
            readyForNextQuestion = 1;
          elseif(keyCode(key3))
            response = 'African American';
            keyPressed = 3;
            fprintf(responseLogFD, '%s,%d,%f,', response, keyPressed, ...
                    responseTime);
            Screen('Close', texture);
            readyForNextQuestion = 1;
          elseif(keyCode(key4))
            response = 'NativeAmerican';
            keyPressed = 4;
            fprintf(responseLogFD, '%s,%d,%f,', response, keyPressed, ...
                    responseTime);
            Screen('Close', texture);
            readyForNextQuestion = 1;
          elseif(keyCode(key5))
            keyPressed = 5;
            response = 'Asian/Pacific Islander';
            fprintf(responseLogFD, '%s,%d,%f,', response, keyPressed, ...
                    responseTime);
            Screen('Close', texture);
            readyForNextQuestion = 1;
          elseif(keyCode(key6))
            response = 'East Asian';
            keyPressed = 6;
            fprintf(responseLogFD, '%s,%d,%f,', response, keyPressed, ...
                    responseTime);
            Screen('Close', texture);
            readyForNextQuestion = 1;
          elseif(keyCode(key7))
            keyPressed = 7;
            %request input from the terminal and convert it to a string
            response = GetString;
            %in case user does not enter a response.
            while(isempty(response))
              fprintf('You did not enter anything. Please try again.\n');
              response = GetString;
            end
            fprintf(responseLogFD, '%s,%d,%f,', response, keyPressed, ...
                    responseTime);
            Screen('Close', texture);
            readyForNextQuestion = 1;
          elseif(keyCode(key8))
            keyPressed = 8;
            response = 'Prefer not to answer';
            fprintf(responseLogFD, '%s,%d,%f,', response, keyPressed, ...
                    responseTime);
            Screen('Close', texture);
            readyForNextQuestion = 1;
          else
            fprintf(['The key entered was not a valid response.'...
                     ' Please input a valid response.\n']);
          end
        end
      case genderQuestion
        [~, questionDisplayTime, ~] = Screen('Flip', windowPointer);
        while(~readyForNextQuestion)
          [responseEnteredTime, keyCode] = KbStrokeWait;
          responseTime = responseEnteredTime - questionDisplayTime;
          if(keyCode(key1))
            keyPressed = 1;
            response = 'Male';
            fprintf(responseLogFD, '%s,%d,%f,', response, keyPressed, ...
                    responseTime);
            Screen('Close', texture);
            readyForNextQuestion = 1;
          elseif(keyCode(key2))
            keyPressed = 2;
            response = 'Female';
            fprintf(responseLogFD, '%s,%d,%f,', response, keyPressed, ...
                    responseTime);
            Screen('Close', texture);
            readyForNextQuestion = 1;
          elseif(keyCode(key3))
            keyPressed = 3; 
            response = 'Prefer not to answer';
            fprintf(responseLogFD, '%s,%d,%f,', response, keyPressed, ...
                    responseTime);
            Screen('Close', texture);
            readyForNextQuestion = 1;
          else
            fprintf(['The key entered was not a valid response.'...
                     ' Please input a valid response.\n']);
          end
        end
      case seenBeforeQuestion
        [~, questionDisplayTime, ~] = Screen('Flip', windowPointer);
        while(~readyForNextQuestion)
          [responseEnteredTime, keyCode] = KbStrokeWait;
          responseTime = responseEnteredTime - questionDisplayTime;
          if(keyCode(yesKey))
            response = 'Yes';
            keyPressed = 1;
            fprintf(responseLogFD, '%s,%d,%f,', response, keyPressed, ...
                    responseTime);
            Screen('Close', texture);
            readyForNextQuestion = 1;
          elseif(keyCode(noKey))
            response = 'No';
            keyPressed = 2;
            fprintf(responseLogFD, '%s,%d,%f,', response, keyPressed, ...
                    responseTime);
            Screen('Close', texture);
            readyForNextQuestion = 1;
          else
            fprintf(['The key entered was not a valid response.'...
                       ' Please input a valid response.\n']);
          end
        end
      case howLongQuestion
        [~, questionDisplayTime, ~] = Screen('Flip', windowPointer);
        while(~readyForNextQuestion)
          [responseEnteredTime, keyCode] = KbStrokeWait;
          responseTime = responseEnteredTime - questionDisplayTime;
          if(keyCode(key1))
            keyPressed = 1; 
            response = '< 1 month';
            fprintf(responseLogFD, '%s,%d,%f,', response, keyPressed, ...
                    responseTime);
            Screen('Close', texture);
            readyForNextQuestion = 1;
          elseif(keyCode(key2))
            keyPressed = 2;
            response = '1-6 months';
            fprintf(responseLogFD, '%s,%d,%f,', response, keyPressed, ...
                    responseTime);
            Screen('Close', texture);
            readyForNextQuestion = 1;
          elseif(keyCode(key3))
            keyPressed = 3;
            response = '6 months - 1 year';
            fprintf(responseLogFD, '%s,%d,%f,', response, keyPressed, ...
                    responseTime);
            Screen('Close', texture);
            readyForNextQuestion = 1;
          elseif(keyCode(key4))
            keyPressed = 4;
            response = '1 year - 3 years';
            fprintf(responseLogFD, '%s,%d,%f,', response, keyPressed, ...
                    responseTime);
            Screen('Close', texture);
            readyForNextQuestion = 1;
          elseif(keyCode(key5))
            keyPressed = 5;
            response = '3+ years';
            fprintf(responseLogFD, '%s,%d,%f,', response, keyPressed, ...
                    responseTime);
            Screen('Close', texture);
            readyForNextQuestion = 1;
          else
            fprintf(['The key entered was not a valid response.'...
                       ' Please input a valid response.\n']);
          end
        end
      %control will never reach here  
      otherwise
        return
    end
    questionNumber = questionNumber + 1;
  end
  %CAUTION: The final response will have an extra ',' appended to it. Since the 
  %next time we want to open the file, we would like to write to a new line and
  %not start there. To do this, we will remove the ',' and append a '\r\n'
  %instead
  %The file table currently has the position set to the next byte after the 
  %',' so to remove it, we should step back by one byte via a call to fseek
  byteOffset = -1;
  fseek(responseLogFD, byteOffset, 'cof');
  fprintf(responseLogFD, '\r\n');
  return


  


