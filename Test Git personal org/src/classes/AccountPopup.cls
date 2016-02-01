public class AccountPopup
{
    public List<Account> AccountList {get;set;}
    public List<Account> AccountAddList {get;set;}
    public String AccountName {get;set;}
    public Integer rowNum{get;set;}
   
    public AccountPopup()
    {
        String sql = 'SELECT Name, Phone FROM Account';
        AccountList = Database.Query(sql);
        AccountAddList = new List<Account>();
        AccountAddList.add(new Account());
    }
       
    public void AddRow()
    {
        AccountAddList .add(new Account());
    }
   
    public void delRow()
    {
        rowNum = Integer.valueOf(apexpages.currentpage().getparameters().get('index'));
        AccountAddList.remove(rowNum);  
    }   
   
    public pagereference saveMemb()
    {
        insert AccountAddList;
      //  AccountAddList.clear();
        pagereference p = new PageReference('/001/o');
        return p;
        
    }
}