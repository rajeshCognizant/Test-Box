/* 
Version        : 1.00
Company        : Accenture
Date           : 12.AUG.2013
Author         : Ritesh Shahare
Description    : Test class for controller class VFC01_VFP01_HomePage
History        : 
                1.00 15.AUG.2013 Ritesh Shahare- Created
*/

@IsTest public with sharing class VFC01_VFP01_HomePageTest 
{
    @IsTest static void testConstructor() 
    {
         VFC01_VFP01_HomePage vc = new VFC01_VFP01_HomePage();  
         // Insert the execution summary record
         Execution_Summary__c esRec = new Execution_Summary__c(ContextIterator__c=0);
         insert esRec;
         
         //Insert sample report data
         ReportData__c rdRec = new ReportData__c(name='testid',FieldName__c='TestField');
         insert rdRec;
         
         // Insert data input record
         DataInput__c diRec = new DataInput__c(ObjectName__c='Account',ReportFormat__c='PDF');
         insert diRec;
         
         vc.resetTool();     
         
         // Insert the pagelayout id-name mapping record
          PageLayoutNameID__c pNameRec = new PageLayoutNameID__c(name='Account',PagelayoutID__c='testid');
          insert pNameRec;
          
          vc.selobject = 'Account@@Account';
          
          vc.contentFile= Blob.valueOf('<!-- ListRow -->lid=123456789123456adadasd<th scope="row" class=" dataCell  ">DataInput Layout</th><td class=" dataCell  "><!-- ListRow -->asfafasfaflid=123456789123456adadasd<th scope="row" class=" dataCell  ">DataInput Layout</th><td class=" dataCell  ">');
          
          vc.readFile();
          
          vc.contentFile=Blob.valueOf('');
          vc.readFile();
          
          vc.selobject = 'Account@@Account';
          vc.generatePDFReport();
          vc.selobject = 'Account@@Account';
          vc.generateExcelReport();
         
         vc.selobject='';
         vc.generatePDFReport();
         vc.generateExcelReport();
         
         vc.selobject='a1@@a1';
         vc.generatePDFReport();
         vc.generateExcelReport();
         
    }
}