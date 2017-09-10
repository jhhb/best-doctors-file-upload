public with sharing class FileUploadController {
  
    public Document document {
        get {
            if (document == null)
            document = new Document();
            return document;
        }
        set;
    }

    private String uploadErrorMessage = 'Error uploading file';
    private String uploadSuccessMessage = 'File uploaded successfully';
    private String uploadMaliciousMessage = 'Invalid file type. File not saved. We have detected you are doing something malicious';
    private Set<String> acceptedExtensions = new Set<String> {'.doc','.docx', '.png', '.pdf'};

    public PageReference upload() {
        document.AuthorId = UserInfo.getUserId();
        document.FolderId = UserInfo.getUserId(); // put it in running user's folder
        
        try {
            if(!this.validateExtensions(document.name)) {
                return null;
                document.body = null;
                document = new Document();
            }
        }
        catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please submit a file'));
            return null;
        }
        

        try {
            insert document;
        } 
        catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, this.uploadErrorMessage));
            return null;    
        } 
        finally {
            document.body = null; // clears the viewstate
            document = new Document();
        }

        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, this.uploadSuccessMessage));
        return null;
    }

    private boolean validateExtensions(String documentName) {
        Boolean valid = false;
        for(String s : this.acceptedExtensions) {
            if( (documentName.endsWith(s)) && (documentName != s) ) {
                valid = true;
                break;
            }
        }

        if(!valid) { //tell the user in an error message that they are trying to do something malicious
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, this.uploadMaliciousMessage));
        }
        return valid;
    }

    public void testValidateExtensions() {
        List<String> fileNames = new List<String>{'.png', '.doc', 'foo.doc', 'foo.docx', 'bar.png', 'bar.pdf', 'baz.jpg', 'hello.webm', '.jpg'};
        List<Boolean> expectedResults = new List<Boolean> {false, false, true, true, true, true, false, false, false};

        for(integer i = 0; i < fileNames.Size(); i++) {
            boolean validationResult = this.validateExtensions(fileNames[i]);
            boolean testValid = (validationResult == expectedResults[i]);
            string message = '';
            if(testValid) {
                message = 'Pass. Expected testing ' + fileNames[i] + ' to return ' + expectedResults[i] + '. Got: ' + validationResult;
            }
            else {
                message = 'Fail. Expected testing ' + fileNames[i] + 'to return ' + expectedResults[i] + '. Got: ' + validationResult;
            }
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, message));
        }
    }
}