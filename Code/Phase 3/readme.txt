Written By: Isaac J. Manjarres
If there are any questions, please contact me at imanjarr@andrew.cmu.edu
The purpose of this file is to provide an overview of how to run an experiment 
using the toolbox that we have developed.

***NOTE: It is STRONGLY recommended that you have a good understanding of the
code and documentation files found in the Eye_Tracking_101 release prior to 
reading this code or using it. If you haven't done so, please take some time 
to read it.***

***This readme is similar to the one for the first and second phase. 
If you have thoroughly read those readmes, and understand them, gloss over 
this one, but do pay careful  attention to the new portions, such as the 
ADDITIONALLY portion below.***

***To ensure that the videos can be used with BeGaze, make sure that they are 
.avi files that have been compressed with the XMP4 codec. Also, ensure that all
stimuli images and videos are the same size as the stimuli monitor.***


Overview: This toolbox provides an experimenter with the capability to play a 
sequence of movies or images in any arbitrary order, provided that the 
experimenter has specified a set of orderings in a CSV file, as in our sample 
order.csv and imgorder.csv file. To control the operation mode of the program,
it must be specified within the function call as a parameter. For an example of 
how to do this, see below. However, these are the values for the current 
operation modes:
0-Movie Mode
1-Image Mode
Once the experiment begins, a CSV file with a timestamp of the current system 
time will be created  and stored in the Data sub-directory. Since the code 
allows the subject to pause playback of the movies, resume playback, and 
completely stop it and exit, while in movie mode, the CSV file that was created 
is used to log  when the subject paused playback, resume playback or exited. 
It also records a  timestamp with microsecond precision of when the event 
happened. If the program is being run in image mode, then the log will contain
the name of the image, its stimuli ID, the timestamp at which the movie was 
displayed, the time at which the user moved to the next image by pressing 
spacebar, as well as the difference between these two times, thus giving us the 
amount of time the user looked at the stimulus. 
After a movie has played or an image is shown, the subject will be asked a 
series of questions that the  experimenter has designed. The subject's response 
to these questions will be logged in a CSV file in the Data subdirectory of the 
Infrastructure  directory, along with the subject activity log. Finally, 
at the end of the experiment, the program transfers all of the subject's 
responses to a master response log, where all prior subjects' responses have 
been collected. If such a file does not exist, the program will create one.

********************************************************************************
*ADDITIONALLY: This release of the Mako Eye Tracking Toolbox has code          *
*integrated into it such that the user can now collect gaze data with an eye   *
*tracking device. To enable the eye tracker, the user should specify the       *
*new eyeTrackingMode parameter to be 1. When this occurs, the start up of the  *
*function will be slightly different because it will begin by starting a       *
*calibration process, which requires the calibration tests to be passed with   *
*a deviation of less than 0.5 visual degrees. For more information about this, *
*refer to the Eye_Tracking_101 release. Once the calibration process is        *
*complete, the calibration data will be recorded in the Results subdirectory of*
*the Infrastructure directory. Also, at the end of the experiment, the program *
*will write the calibration data for the subject into a master calibration log *
*that has all of the calibration data for previous subjects. After the         *
*calibration data is recorded, the experiment will proceed as it would by      *
*displaying movies or images, and collecting self reported data. However, while*
*this is occuring, the program is also recording gaze data via the two methods *
*described in the eye tracking documentation. After each movie or image, the   *
*program saves an IDF for the image in the Results subdirectory, so it can be  *
*associated with it in BeGaze. Finally, at the end of the experiment, the gaze *
*data for the entire experiment will be recorded in a timestamp named file in  *
*the Results subdirectory.                                                     *
*For this phase--phase 3--the toolbox is now capable of collecting gaze data   *
*from both images and movies. The data collection process for movies is exactly*
*the same as with images, right down to the locations at which the resulting   *
*files are placed.                                                             *
********************************************************************************

Setup: In order to setup the experiment and to guarantee that it runs correctly,
the following steps must be taken NOTE: THE STEPS ARE THE SAME FOR RUNNING 
EXPERIMENTS IN IMAGE MODE, EXCEPT JPEG FILES WILL BE USED:
1. Create a directory somewhere on your machine, and name it Infrastructure. 
2. Create the following directories within the Infrastructure directory: 
Archives, Code, Data, Documentation, Experiments, Figures, Images, Instructions,
PDFs, Processed_Data, Processed_Stimuli, Questions, Results, Stimuli. 
These directories are necessary for the code in this commit, and all other 
commits, to work properly.
3. Once those directories have been created, move all .m and readme.txt files 
to the Code subdirectory.
4. Verify that in the Stimuli subdirectory there is a CSV file that contains the 
orderings in which the movies are to be played in. These orderings MUST be in 
a CSV file. The format of the file should be as follows: each row within the CSV
will represent an ordering that is unique to each subject. This means that if we
have n subjects, we should have n rows. Now, every row will be a set of numbers,
where each number corresponds to a movie, and can be determined by the way that 
the OS has ordered the movies in the stimuli directory. So for example, if the 
stimuli are ordered as such: darkWaves.mp4, hallway.mp4, night.mp4, then it 
follows that darkWaves.mp4 is movie 1, hallway.mp4 is movie 2, and so on. 
CAUTION: The numerical values must not exceed the number of movies that are 
currently in directory, as it is non-sensical to play movie 15, if there are 
only 4 movies. An example of how an order.csv file might look would be as 
follows:
1,2,3
1,3,2
2,1,3
2,3,1
3,1,2
3,2,1
where this file would represent ways to play a sequence of three movies for 
six subjects. The subjectID parameter in the main collectMovieInformation 
function determines which ordering will be used by picking out the line that 
corresponds to its number. So, subject number 2 will see movies 1, 3, and then 
movie 2.
5. Within the Instructions subdirectory, ensure that all instruction slides that
will be presented to the subject are named in the following format:
Instruction_Slide_X where X is the number in the order in which it will be 
presented in. 
6. Within the Questions subdirectory, ensure that all question slides that 
will be presented to the subject are named in the following format: 
Question_X where X is the number in the order in which it will be presented in.
7. In the askQuestions.m file, ensure that there is a case for every question
that will be posed throughout the experiment within the switch statement.
8. Ensure that in askQuestions.m, each question has a variable assigned to a
number that corresponds to the order in which it will be presented. 
9. Ensure that in makeResponseLogHeader.m the names of the questions have been 
input into the questionNames array by you, and that they match with the number 
of questions to be presented, and they are in the order that you specified in. 
The Questions subdirectory. This is imperative as this file prints the header
into the response log that is created to collect the responses of the subjects,
and if it's not edited properly, then the responses will not be recorded 
correctly.

The main function for running the experiments is runExperiment, as it
is the function that governs all of the sub-functions by calling them and 
retrieving information, as well as it is the function that does the movie 
playing routine. An example of how to run an experiment is as follows: 
-Suppose that my experiment consists of having a subject watch 3 movies and 
after each movie, I would like to ask them the same questions about each movie.
-I will first place the instructions to my experiment within the Instructions 
directory, and label the first instruction slide as Instruction_Slide_1, and 
the second, as Instruction_Slide_2. 
-Now, I will add my three questions via the following procedure: first, I will
go to askQuestions.m and follow the procedures located in the file, which in 
short say to create a variable for each question, and associate it with the 
ordering in which I would like to ask the question. So for example, if I ask 
the subject "Have you seen this movie before?" first, then I would make a 
variable called seenBefore and set it equal to 1, since it's the first question.
Then, I will go to the switch statement, and make a case for each statement, 
and follow the structure that has been outlined. 
Finally, I will go to makeResponseLogHeader.m and enter the names of the 
questions as strings in the questionNames cell array in the order that I have 
specified. This means that the seen before question would be the first
string in the array. 
-I will go to the Stimuli folder and verify that all of the stimuli that I want 
are in there, as well as the order.csv file, which should look identical to the 
one above. Lets suppose I will also use the same 3 movies that I had mentioned 
above. 

-I will go to MATLAB and make the following function call:

runExperiment('C:\Users\Isaac\Desktop\Infrastructure\Stimuli', 'C:\Users\Isaac\Desktop\Infrastructure\Stimuli\order.csv', 0, 2, 0(NOTE THIS NEW PARAMETER. THIS MEANS THAT EYE TRACKING MODE IS DISABLED))

What does this mean? This means that I am starting my experiment and letting the
program know that the stimuli are located in 
C:\Users\Isaac\Desktop\Infrastructure\Stimuli and I am also giving it a path to 
the order.csv file, and that we are testing subject 2, so we should show them
movies 1, then 3, then 2. If I wanted to collect eye tracking data with movies,
then I would make the following function call:
runExperiment('C:\Users\Isaac\Desktop\Infrastructure\Stimuli', 'C:\Users\Isaac\Desktop\Infrastructure\Stimuli\order.csv', 0, 2, 1(NOTE THIS NEW PARAMETER. THIS MEANS THAT EYE TRACKING MODE IS ENABLED))


If we wanted to run an experiment in image mode, 
and we have an imgorder.csv file specifying the orderings of the images, then we
can make the following function call: 

runExperiment('C:\Users\Isaac\Desktop\Infrastructure\Stimuli', 'C:\Users\Isaac\Desktop\Infrastructure\Stimuli\imgorder.csv', 1, 3, 0(NOTE THIS NEW PARAMETER. THIS MEANS THAT EYE TRACKING MODE IS DISABLED))

What does this mean? This means that I am starting my experiment and letting the
program know that the stimuli are located in 
C:\Users\Isaac\Desktop\Infrastructure\Stimuli and I am also giving it a path to 
the imgorder.csv file, and that we are testing subject 3, so we should show them
I am also letting the program know we are in image mode, and that we are not 
using an eye tracker. If I wanted to collect eye tracking data with images, then
I would make the following function call:

runExperiment('C:\Users\Isaac\Desktop\Infrastructure\Stimuli', 'C:\Users\Isaac\Desktop\Infrastructure\Stimuli\imgorder.csv', 1, 3, 1(NOTE THIS NEW PARAMETER. THIS MEANS THAT EYE TRACKING MODE IS ENABLED))

********************************************************************************
*Also, it is possible that the function may crash when it tries to use         * 
*Screen('OpenWindow', screenNumber). If this were to occur, and it is because  *
*of an alternate screen error, change the screenNumber variable to 0, as that  * 
*is the main screen. If this error persists, it is not on our toolbox' end, but* 
*something may be wrong with your setup of Psychtoolbox.                       *
********************************************************************************

NOTE: This is the third phase of the project. The third phase involves 
the collection of demographic and other data from a test subject, as well as 
gaze data collection with images and movies.