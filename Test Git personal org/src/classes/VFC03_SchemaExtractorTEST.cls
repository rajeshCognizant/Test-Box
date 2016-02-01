@IsTest public with sharing class VFC03_SchemaExtractorTEST
{
    @IsTest static void testConstructor() 
    {
        VFC01_VFP01_SchemaExtractor clsSE = new VFC01_VFP01_SchemaExtractor();
        
        clsSE.includeAllObjects = true;
        //clsSE.populateChildRelationship();
        clsSE.getObjValues();
        clsSE.disablePicklistButton();
        clsSE.resetenvironment();
        clsSE.LoadData();
        clsSE.buildSchemaData();
        
        PageReference pageRef = Page.VFP02_SchemaExcelExtract;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('objrow', '10');
        
        VFC02_VFP02_SchemaExtractorExcel clsSEExcel = new VFC02_VFP02_SchemaExtractorExcel();
        clsSEExcel.totObjs=0;
        
    }
}