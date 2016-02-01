@isTest 
private class tttt{ 
static testmethod void testLoadData(){ 
String caseJSON = '{"attributes":{"type":"CasSe","url":"/services/data/v25.0/sobjects/Case/500E0000002nH2fIAE"},"Id":"500E0000002nH2fIAE","Status":"Open","CreatedDate":"2012-10-04T17:54:26.000+0000"}'; 
Case c = (Case) JSON.deserialize(caseJSON, Case.class ); 
System.debug('Test case:' + c.createdDate); 
System.debug('Test caseId:' + c.Id); 
System.debug('Test caseStatus:' + c.status); 
 
Case c1 = new Case(); 
c1.Id = c.Id; 
c1.status = 'New'; 
update c1; 
 
System.debug('Test caseStatus1:' + c1.status); 
 
} 
}