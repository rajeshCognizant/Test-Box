/* 
Version        : 1.00
Company        : Accenture
Date           : 12.AUG.2013
Author         : Ritesh Shahare
Description    : Test class for controller class VFC01_VFP01_ReportPDF
History        : 
                1.00 15.AUG.2013 Ritesh Shahare- Created
*/

@IsTest public with sharing class VFC01_VFP01_ReportPDFTest
{
    @IsTest static void testConstructor() 
    {
                 
         //Insert sample report data
         ReportData__c rdRec1 = new ReportData__c(name='testid',FieldName__c='TestField1');
         insert rdRec1;
         
         ReportData__c rdRec2 = new ReportData__c(name='testid',FieldName__c='TestField2');
         insert rdRec2;
         
         // Insert data input record
         DataInput__c diRec = new DataInput__c(ObjectName__c='Account',ReportFormat__c='PDF');
         insert diRec;
         
         // Insert the pagelayout id-name mapping record
          PageLayoutNameID__c pNameRec = new PageLayoutNameID__c(name='Account',PagelayoutID__c='testid');
          insert pNameRec;

          VFC01_VFP01_ReportPDF vc = new VFC01_VFP01_ReportPDF();
          
    }
    
}