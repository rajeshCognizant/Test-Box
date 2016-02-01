public class clientiframe{
   public List<Account> getAccounts() {
     return [SELECT Id, Name FROM Account ORDER BY LastModifiedDate DESC LIMIT 15];
  }
}