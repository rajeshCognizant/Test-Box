$_org(document).ready(function() {
     
    // The elements to bind email autocomplete to
    var elems = [];
     
    // Add Email to Case Premium elements
    elems.push('pg:addCommentF:addCommentPB:emailCustomerPBS:additionalEmailsPBSI:additionalEmails_TextBox');
    elems.push('pg:addCommentF:addCommentPB:emailCustomerPBS:additionalCCsPBSI:additionalCCs_TextBox');
    elems.push('pg:addCommentF:addCommentPB:emailCustomerPBS:additionalBCCsPBSI:additionalBCCs_TextBox');
     
    // Add default Salesforce email fields
    elems.push('p24'); // Additional To
    elems.push('p4'); // CC
    elems.push('p5'); // Bcc
     
    $_org(elems).each(function(index) {
        var thisElem = document.getElementById(elems[index]);
        $_org(thisElem).autocomplete({
            minLength: 1,
            delay: 250,
             
            source: function(request, response) {
                         
                        var retVal = []; // array to return
                         
                        var queryTerm = $_org.trim(request.term); // term to search for
                        if (queryTerm.lastIndexOf(';') != -1){
                            queryTerm = queryTerm.substring(queryTerm.lastIndexOf(';') + 1);
                            queryTerm = $_org.trim(queryTerm);
                        }
                         
                        if (queryTerm.length <= 1){
                            $_org(thisElem).autocomplete("close");
                        } else {
                            sforce.connection.sessionId = _my_sfdcSession;
                            var result = sforce.connection.query("SELECT Id, Name, Email FROM Contact WHERE (Name LIKE '%" + queryTerm + "%' OR Email LIKE '%" + queryTerm + "%') AND Email != NULL ORDER BY Name LIMIT 20");
                            it = new sforce.QueryResultIterator(result);
                            while (it.hasNext()) {
                                var rec = it.next();
                                var retValItem = new Object();
                                retValItem.label = rec.Name + ' (' + rec.Email + ')';
                                retValItem.value = rec.Email;
                                retVal.push(retValItem);
                            }
                        }
                        response(retVal);
                    },
                    
            select: function( event, ui ) {
                        var tmp = $_org(thisElem).val();
                        if (tmp.lastIndexOf(';') == -1){
                            $_org(thisElem).val( ui.item.value + '; ' );
                        } else {
                            $_org(thisElem).val( tmp.substring(0, tmp.lastIndexOf(';') + 1) + ' ' + ui.item.value + '; ');
                        }
                        $_org(thisElem).autocomplete("close");
                        return false;
                    },
                     
            focus: function(event, ui) {
                return false; // added so keyboard navigation does not overwrite the value
            }
 
         });
          
     });
      
}); // end of $_org(document).ready()