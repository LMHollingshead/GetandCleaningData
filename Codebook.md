## Codebook
===========

*Subject* (int) - subject identifier (1-30)
 	
*Activity* (factor) - Activity type
* LAYING
* SITTING
* STANDING
* WALKING
* WALKING_DOWNSTAIRS
* WALKING_UPSTAIRS

*Domain* (factor) - type of domain signal
* FREQUENCY
* TIME

*Acceleration* (factor) - acceleration signal type
* BODY
* GRAVITY

*Instrument* (factor) - Instrument from which 3-axial raw signals are captured
* ACCELEROMETER
* GYROSCOPE

*Jerk* (factor) - Jerk signals, yes/no?
* NO
* YES

*Magnitude* (factor) - Magnitude of signal, yes/no?
* NO
* YES

*Axis* (factor) - domain of axis
* X
* Y
* Z

*Variable* (factor) - type of variable
* MEAN
* STD

*Count* (num) - Number of observations
* Min. : 36
* Max: : 95

*Avg* (num) - Average mean or std 
* Min. : -0.99767
* Max. :  0.97451
