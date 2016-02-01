trigger AccountRollUpPayments on test__c (after delete, after insert, after update) {
 
  //Limit the size of list by using Sets which do not contain duplicate elements
  set<id> Accountid = new set<id>();
 
  //When adding new payments or updating existing payments
  if(trigger.isInsert || trigger.isUpdate){
    for(test__c p : trigger.new){
      Accountid.add(p.Account__c);
    }
  }
 
  //When deleting payments
  if(trigger.isDelete){
    for(test__c p : trigger.old){
      Accountid.add(p.Account__c);
    }
  }
 
  //Map will contain one Opportunity Id to one sum value
  map<id,double> Accountmap = new map<id,double>();
 
  //Produce a sum of Payments__c and add them to the map
  //use group by to have a single Opportunity Id with a single sum value
  for(AggregateResult q : [select Account__c,sum(Rollup1__c)
    from test__c where Account__c IN :Accountid group by Account__c]){
      Accountmap.put((Id)q.get('Account__c'),(Double)q.get('expr0'));
  }
 
  List<Account> Accounttoupdate = new List<account>();
 
  //Run the for loop on Opportunity using the non-duplicate set of Opportunities Ids
  //Get the sum value from the map and create a list of Opportunities to update
  for(Account o : [Select Id, NumberofLocations__c from Account where Id IN :Accountid]){
    Double PaymentSum = Accountmap.get(o.Id);
    o.NumberofLocations__c = PaymentSum;
    Accounttoupdate.add(o);
  }
 
  update Accounttoupdate;
}