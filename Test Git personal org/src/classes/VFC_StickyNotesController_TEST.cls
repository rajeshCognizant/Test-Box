/*
*                                                                     *
* Version 1.00                                                        *
*                                                                     *
* Creation Date: 14.Feb.2013                    Viswam Srinivasan     *
* Last Modified:                                                      *
*                                                                     *
* © 2013 - Accenture - All Rights Reserved                            *

*/

// ============================================================================
// = T.E.S.T M.E.T.H.O.D
// ============================================================================
public class VFC_StickyNotesController_TEST 
{  
    public static testmethod void testStickyNotes()
    {
        VFC_StickyNotesController stickyObj = new VFC_StickyNotesController();
        stickyObj.saveDrafts();  
        
        stickyNotesValues__c sNotesVal = new stickyNotesValues__c();
        sNotesVal.SessionId__c = '1234';
        sNotesVal.Notes__c = '1234';
        sNotesVal.Name = 'testSticky';
        insert sNotesval;
               
        VFC_StickyNotesController stickyObj1 = new VFC_StickyNotesController();
        stickyObj1.saveDrafts();   
    }    
}