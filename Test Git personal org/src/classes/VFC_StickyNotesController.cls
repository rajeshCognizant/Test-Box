/*
*                                                                     *
* Version 1.00                                                        *
*                                                                     *
* Creation Date: 14.Feb.2013                    Viswam Srinivasan     *
* Last Modified:                                                      *
*                                                                     *
* © 2013 - Accenture - All Rights Reserved                            *

*/

public class VFC_StickyNotesController 
{

// ============================================================================
// = C.O.N.S.T.R.U.C.T.O.R
// ============================================================================
public VFC_StickyNotesController()
{
    sessionVal  = UserInfo.getSessionId();
    lst_DatabaseVal  = [select Notes__c,SessionId__c from stickyNotesValues__c where SessionId__c =: sessionVal];
   
    if(!lst_DatabaseVal.isEmpty() && UserInfo.getSessionId() == lst_DatabaseVal[0].SessionId__c)
    {
        textAreaVal  = lst_DatabaseVal[0].Notes__c;
    }
}

// ============================================================================
// = A.T.T.R.I.B.U.T.E.S
// ============================================================================
public String textAreaVal {get;set;}
public String sessionVal {get;set;}
List<stickyNotesValues__c>  lst_DatabaseVal = new List<stickyNotesValues__c>();

// ============================================================================
// = M.E.T.H.O.D.S
// ============================================================================

public PageReference saveDrafts() 
{  
        List<stickyNotesValues__c>  lst_StickyNotes = new List<stickyNotesValues__c>();
        
        try
        {
            sessionVal  = UserInfo.getSessionId();
          
            for(stickyNotesValues__c stickyNotesObj : [select Notes__c,SessionId__c from stickyNotesValues__c where SessionId__c =: UserInfo.getSessionId()])
            {    
                if(UserInfo.getSessionId()== stickyNotesObj.SessionId__c)
                {
                    stickyNotesObj.Notes__c =  textAreaVal;
                    stickyNotesObj.SessionId__c = UserInfo.getSessionId();
                    lst_StickyNotes.add(stickyNotesObj);
                }
            }
            if(!lst_StickyNotes.isEmpty())
            {
                update lst_StickyNotes;
            }
            else
            {
                //insert record here
                stickyNotesValues__c stickyObj = new stickyNotesValues__c();
                stickyObj.Notes__c =  textAreaVal;
                stickyObj.SessionId__c = UserInfo.getSessionId();
                stickyObj.Name = 'stateFarm' + '_'+Math.random();
                insert stickyObj;
            }
        }
        catch(Exception e)
        { 
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'There is a Problem while processing this.Please try again');
            ApexPages.addmessage(myMsg);
        }
        return null;
}

}