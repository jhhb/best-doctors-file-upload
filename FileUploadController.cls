public class FileUploadController {

    // allows us to render a Document instance in the view
    public Document document {
        get {
            if (document == null) {
                document = new Document();
            }
            return document;
        }
        set;
    }

    // status messages
    private String uploadErrorMessage = 'Error uploading file';
    private String uploadSuccessMessage = 'File uploaded successfully';
    private String uploadMaliciousMessage = 'Invalid file type. File not saved. We have detected you are doing something malicious';
    private String uploadNoFileMessage = 'Please upload a file';
    
    private Set<String> acceptedExtensions = new Set<String> {'.doc','.docx', '.png', '.pdf'};

    // Primary function called from the view
    public void upload() {
        // Make file accessible in running user's folder
        document.AuthorId = UserInfo.getUserId();
        document.FolderId = UserInfo.getUserId(); 
        
        // Prevents app from breaking if someone uploads a file with no name
        // This seems like a very inelegant solution to checking if there is a name.
        try {
            if(!this.validateExtensions(document.name, 'dev')) {
                return;
            }
        }
        catch (System.NullPointerException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, this.uploadNoFileMessage));
            return;
        }
     
        try {
            insert document;
        } 
        catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, this.uploadErrorMessage));
            return;    
        } 
        
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, this.uploadSuccessMessage));
        return;
    }

    // Determine that the file ends with a valid extension
    private boolean validateExtensions(String documentName, String caller) {
        Boolean valid = false;
        for(String s : this.acceptedExtensions) {
            if(documentName.endsWith(s) && documentName != s ) {
                valid = true;
                break;
            }
        }
        //tell the user in an error message that they are trying to do something malicious
        // 'test' is used here to not show the user an error when we run the tests.
        if(!valid && caller != 'test') { 
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, this.uploadMaliciousMessage));
        }
        return valid;
    }

    // Iterates fileNames ands makes sure that they match expectedResults when validated.
    public void testValidateExtensions() {
        List<String> fileNames = new List<String>{'', '.png', '.doc', 'foo.doc', 'foo.docx', 'bar.png', 'bar.pdf', 'baz.jpg', 'hello.webm', '.jpg'};
        List<Boolean> expectedResults = new List<Boolean> {false, false, false, true, true, true, true, false, false, false};

        for(integer i = 0; i < fileNames.Size(); i++) {
            boolean validationResult = this.validateExtensions(fileNames[i], 'test');
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