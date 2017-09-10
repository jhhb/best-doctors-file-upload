public with sharing class FileUploadController {
  
    public Document document {
    get {
        if (document == null)
        document = new Document();
        return document;
    }
    set;

    }  
    public PageReference upload() {
    document.AuthorId = UserInfo.getUserId();
    document.FolderId = UserInfo.getUserId(); // put it in running user's folder
    if(!validateUpload(document.name)) {
        return null;
        document.body = null;
        document = new Document();
    }

    try {
        insert document;
    } catch (DMLException e) {
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
        return null;    } finally {
        document.body = null; // clears the viewstate
        document = new Document();
    }

    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
    return null;
    }

    private Boolean validateUpload(String documentName) {
        
    Set<String> acceptedExtensions = new Set<String> {'.doc','.docx', '.png', '.pdf'};

    Boolean valid = false;
    for(String s : acceptedExtensions) {
        if(documentName.endsWith(s)) {
            valid = true;
            break;
        }
    }
    if(!valid){ // after the whole loop it's still false?
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid file type. File not saved. We have detected you are doing something malicious'));
    }
    return valid;
    }
}