## App and features

This app, made for BestDoctors, allows a user
to upload a file through a Salesforce .page interface and then view it in their personal files directory. 

Features include:
* Only allowing .png, .pdf, .doc, and .docx files
* Front-end validation of the above file types
    * Javascript / jQuery test code to cover this functionality
* Back-end validation of the above file types
    * Apex test code to cover this functionality
* A user can include a description of the file as well

## Design decisions

I wasn't sure of the best way to perform testing in either the .page file or the .cls files so I just rolled my own test methods that simply wrap the functions I use to perform validation. The code is a bit light on tests in general, though I would have done more had I known / found the right way to perform integration tests
in Visualforce.

The UI isn't much to look at. I wanted to get the functionality working before adding anything else, and unfortunately I didn't get to UI in this iteration.

## If I had more time I would...
* Make the UI such that there is a single vertical form centered in the window and the test buttons appear above the form
* Make it so that running the Java test by clicking the button doesn't reload the page
* Look into recently appearing "Maximum View State Size Exceeded" error. File still uploads, but I get this error when I upload. It never happened before about an hour ago. Very weird.

## Viewing the app

* To view the app: 
    * https://c.na73.visual.force.com/apex/fileUpload
    * login: jameshhboyle+fileupload@bestdoctors.com
    * password: Will send in an email to techcandidates@ ...
    * Email: [I had to use my own because otherwise I wasn't able to log in]
* To view your files:
    * Go to your Salesforce profile page:
        * e.g. https://na73.salesforce.com/1
        * Files will appear on the sidebar
