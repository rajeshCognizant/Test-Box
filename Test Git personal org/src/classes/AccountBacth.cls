global class AccountBacth implements Database.Batchable<Sobject>{
global string query;
global list<Account> Acc_List = new List<Account>();

global Database.queryLocator start(Database.batchablecontext BC){
query ='Select id, Name from Account';
return Database.getquerylocator(query);
}

global void execute(Database.batchablecontext BC, List<Account> scope){
        for(Account a :scope){
                Acc_List.add(a);
            }

 /***   if(Acc_List.size()>0){
        update Acc_List;
        }***/
    }
    
global void Finish(Database.Batchablecontext BC)
    {
        
    }    

}