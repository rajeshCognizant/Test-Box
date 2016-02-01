public class SpecialLeadConvert {
  // Variables
  List<Lead>      leads;
  List<LIGHTGURU__TestOpportunity__c> members;

  // Constructor  
  public SpecialLeadConvert(List<Lead> leadList) {
    leads   = leadList;
    members = new List<LIGHTGURU__TestOpportunity__c>();
  }

  // Method: convert leads to Members, not Contacts
  public void convertToMembers() {
    for (Lead l : leads) {
      LIGHTGURU__TestOpportunity__c member = new LIGHTGURU__TestOpportunity__c();
      member.Name      = l.FirstName + ' ' + l.LastName;
      member.LIGHTGURU__Test__c  = l.Email;
      members.add(member);
    }
    insert members;

    // Delete the leads 
    // Apex doesn't let us delete records in Trigger.new
    // This is a workaround that tricks Apex!
    List<Lead> workaround = leads.deepClone(true);
    delete workaround;
  }
    
  // Method: get our Member list  
  public List<LIGHTGURU__TestOpportunity__c> getMembers() {
    return members;
  }
}