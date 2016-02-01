Public class accClass{
List<Account> acc1 = new List<Account>();
public accClass(){
acc1= [SELECT id, Name FROM Account];
System.debug('********************acc1' +acc1.size());
}
}