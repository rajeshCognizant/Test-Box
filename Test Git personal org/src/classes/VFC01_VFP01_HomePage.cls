/* 
Version        : 1.00
Company        : Accenture
Date           : 12.AUG.2013
Author         : Ritesh Shahare
Description    : Controller class for VFP01_HomePage page 
History        : 
                1.00 12.AUG.2013 Ritesh Shahare- Created
*/

public class VFC01_VFP01_HomePage
{
    public String selobject {get;set;}
    public List<SelectOption> options {get;set;}
    public Boolean blnisReadMode{get;set;}
    public Blob contentFile{get;set;}
    public String nameFile{get;set;}   
    List<PageLayoutNameID__c> lstPLayoutNames = new List<PageLayoutNameID__c>();
       
// ===============================
//    C.O.N.S.T.R.U.C.T.O.R
// ===============================           
       
    public VFC01_VFP01_HomePage()
    {
        // Intialize the variables
        blnisReadMode= true;
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        List<String> lstobj = new List<String>();
        options = new List<SelectOption>();        
        lstobj.addAll(gd.keyset());        
   
        try
        {
        //Prepare the objects list
            for (String s : lstobj)        
            {            
                Schema.DescribeSObjectResult D = gd.get(s).getDescribe();            
                if(D.isSearchable()==true && 
                D.isUpdateable()==true && 
                !D.getName().equalsignorecase('ContentVersion') &&            
                !D.getName().equalsignorecase('Event') &&            
                !D.getName().equalsignorecase('Attachment')  &&            
                !D.getName().equalsignorecase('Note'))            
                {                
                    options.add(new SelectOption(D.getlabel() + '@@' + s,D.getlabel() + ' (' + s + ')'));            
                }         
            }
            options.sort();
        }
        catch(Exception ex)
        {
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Error occured when intializing the variables.Please contact the system administrator.!');            
             ApexPages.addmessage(myMsg); 
        }
         
    }

// =====================================================
// = M.E.T.H.O.D.S
// =====================================================

    /** 
        This is method is used to reset the tool environment variables/tables 
    */
    public void resetTool()
    {
        try
        {
            // Always initialize the ContextIterator to 0 before running the tool.
            Execution_Summary__c es = [select ContextIterator__c,Running_User__c from Execution_Summary__c limit 1];
            es.ContextIterator__c = 0;
            es.Running_User__c = UserInfo.getUserId();
            update es;
            
            // Flush the old report table data from the last execution
            List<ReportData__c> lstRepData = [select id from ReportData__c];
            if(lstRepData!=null && lstRepData.size()>0)
            delete lstRepData;
            
            // Flush the object name from the last execution
            List<DataInput__c> lstDI = [select id from DataInput__c];
            if(lstDI!=null && lstDI.size()>0)
            delete lstDI;
            
            // Flush the URL data from the last execution
            List<FLURL__c> lstURL = [select id from FLURL__c];
            if(lstURL!=null && lstURL.size()>0)
            delete lstURL;
            
            // Enable the sections of VF Home Page
            blnisReadMode=false;   
       }
       catch(Exception ex)
       {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Error occured when resetting the environment for the tool.Please contact the system administrator.!');            
            ApexPages.addmessage(myMsg); 
       }
    }


    /** 
        This method is used to generate the report in excel format.
    */
    public pagereference generateExcelReport()
    {
        try
        {
            // Ensure that the user selected the object before generating the report.
            if(selobject==null || selobject=='')
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please select the object.!');            
                ApexPages.addmessage(myMsg); 
                return null;
            }
            
            // Ensure that the pagelayout ID Name mapping is available for the selected object before generating the report.
            selobject = selobject.right(selobject.length()-(selobject.indexOf('@@',0) + 2));
            List<PageLayoutNameID__c> lstpNames = [select id,name,pagelayoutid__c,pagelayoutname__c from PageLayoutNameID__c where name= :selobject];
            if(!(lstpNames != null && lstpNames.size()>0))
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Page Layout ID Name Mapping for the selected object is not in the system please populate it first before generating the report.!');            
                ApexPages.addmessage(myMsg); 
                return null;
            }
            else
            {    
                // Set the object name and report format for the report in progress
                DataInput__c di = new DataInput__c();
                di.ObjectName__c = selobject;
                di.ReportFormat__c ='Excel';
                insert di;
                return new PageReference('/apex/VFP01_Processor');
            }
       }
       catch(Exception ex)
       {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Error occured while generating the report in excel format.Please contact the system administrator.!');            
           ApexPages.addmessage(myMsg); 
           return null;
       }
       
    }
    
    /** 
        This method is used to generate the report in PDF format.
    */
    public pagereference generatePDFReport()
    {
        try
        {
            // Ensure that the user selected the object before generating the report.
            if(selobject==null || selobject=='')
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please select the object.!');            
                ApexPages.addmessage(myMsg); 
                return null;
            }
        
            // Ensure that the pagelayout ID Name mapping is available for the selected object before generating the report.
            selobject = selobject.right(selobject.length()-(selobject.indexOf('@@',0) + 2));
            List<PageLayoutNameID__c> lstpNames = [select id,name,pagelayoutid__c,pagelayoutname__c from PageLayoutNameID__c where name= :selobject];
            if(!(lstpNames != null && lstpNames.size()>0))
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Page Layout ID Name Mapping for the selected object is not in the system please populate it first before generating the report.!');            
                ApexPages.addmessage(myMsg); 
                return null;
            }
            else
            {
                // Set the object name and report format for the report in progress        
                DataInput__c di = new DataInput__c();
                di.ObjectName__c = selobject;
                di.ReportFormat__c ='PDF';
                insert di;
                return new PageReference('/apex/VFP01_Processor');
            }
        }
        catch(Exception ex)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Error occured while generating the report in PDF format.Please contact the system administrator.!');            
            ApexPages.addmessage(myMsg);
            return null;
        }
    }
    
    /** 
        This method is used to generate the source code file and generate the Pagelayout ID-Name mapping for the selected object.
    */
    public Pagereference readFile()    
    {   
        try
        {
        // Ensure that the user has selected the file before hitting the upload the button.     
        if(contentFile==null)
        {
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please select the file first using browse button and then hit the upload button.!');            
             ApexPages.addmessage(myMsg); 
             return null;
        }
        else
        {
            // Read the source code file and populate the Pagelayout ID-Name mapping for the selected object.
            nameFile=contentFile.toString();
            String[] filelines = new String[]{};   
            filelines = nameFile.split('<!-- ListRow -->');          
            selobject = selobject.right(selobject.length()-(selobject.indexOf('@@',0) + 2));

            for(integer i=0;i<filelines.size();i++)
            {
                transient string strLine = filelines[i];
                if(strLine.indexOf('lid=')!=-1)
                {
                    PageLayoutNameID__c pName = new PageLayoutNameID__c();
                    pName.name=selobject;
                    pName.PagelayoutID__c = strLine.mid(strLine.indexOf('lid=')+4,15);
                    pName.PageLayoutName__c=strLine.substring(strLine.indexOf('<th scope="row" class=" dataCell  ">') + 36,strLine.indexOf('</th><td class=" dataCell  ">'));
                    lstPLayoutNames.add(pName);
                }
            
            }
            if(lstPLayoutNames!=null && lstPLayoutNames.size()>0)
            {
                insert lstPLayoutNames;
                return null;
            }
        }
        }
        catch(Exception ex)
        {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Error occured while generating the PageLayout Name-ID Mapping for the selected object.Please contact the system administrator.!');            
           ApexPages.addmessage(myMsg);
           return null; 
        }
        
         return null;
       
    }   

}