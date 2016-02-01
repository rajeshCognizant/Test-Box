trigger InvoiceLineRollUp on test__c (after insert,after update,after delete,after undelete) {
    
    /*******************TO BE CUSTOMIZED*********************/
    string mysobjectParent = 'Account',      // Parent sobject API Name
           myrelationName = 'testAccount__r', // Api name of the relation between parent and child (ends with __r)
           myformulaParent = 'NumberofLocations__c',        // Api name of the number field that will contain the calculation
           mysobjectChild = 'test__c',  // Child sobject API Name
           myparentfield = 'Account__c', // Api name of the lookup field on chield object
           myfieldChild = 'Rollup1__c';          // Api name of the child field to roll up
    
    LookupCalculation.Method method = LookupCalculation.Method.SUM; //Selected method: could be COUNT, SUM, MIN, MAX, AVG
    /*******************************************************/
    
    LookupCalculation calculation = new LookupCalculation(mysobjectParent, myrelationName, myformulaParent,
                                                          mysobjectChild, myparentfield, myfieldChild);
    List<sobject> objList = new List<sobject>((List<sobject>) Trigger.new);
    if(Trigger.isDelete)
        objList = Trigger.old;
    if(Trigger.isUpdate)
        objList.addAll((List<sobject>) Trigger.old);
    calculation.calculate(method, objList);
}