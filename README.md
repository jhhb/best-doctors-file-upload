## Overview

### App and features

This app, made for BestDoctors, allows a user
to upload a file through a Salesforce .page interface and then view it in their personal files directory. 

Features include:
* Only allowing .png, .pdf, .doc, and .docx files
* Front-end validation of the above file types
    * Javascript / jQuery test code to cover this functionality
* Back-end validation of the above file types
    * Apex test code to cover this functionality
* A user can include a description of the file as well

### Design decisions

I wasn't sure of the best way to perform testing in either the .page file or the .cls files so I just rolled my own test methods that simply wrap the functions I use to perform validation.


