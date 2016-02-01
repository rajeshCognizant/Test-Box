public with sharing class RelatedController 
{
 
  public Contact cont{get;set;}
 public RelatedController(ApexPages.StandardController std)
 {
  cont=(Contact)std.getRecord();
 }
  
 public void AccountPopulated()
 {
  
  cont.Account=[select AccountNumber, Site from Account where id=:cont.AccountId];
 }
}