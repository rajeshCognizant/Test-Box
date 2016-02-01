/* 
Version        : 1.0
Company        : Accenture
Date           : 12.AUG.2013
Author         : Ritesh Shahare
Description    : Controller class for VFP01_ReportExcel and VFP01_ReportePDF visual force page.
History        : 
                1.0 12.AUG.2013 Ritesh Shahare- Created
*/


public class VFC01_VFP01_ReportPDF
{
    public List<wrapper> lstRecs {get;set;}
    public Set<String> layoutNames {get;set;}
    public List<String> plNames {get;set;}
    public integer recCount {get;set;}
    public String objName {get;set;}   

// ==================================================
// = C.O.N.S.T.R.U.C.T.O.R
// ==================================================
     
    public VFC01_VFP01_ReportPDF()
    {
        try
        {
            // Initialize the variables
            Map<String,String> mapIDName = new Map<String,String>();
            Map<String,Set<String>> mapFieldslayouts = new Map<String,Set<String>>();
                    
            lstRecs = new List<wrapper>();
            plNames = new List<String>();
            layoutNames = new Set<String>();
           
            //Get the Object Name for the current report
            DataInput__c di = [select objectName__c from DataInput__c limit 1];
            
            objName = di.objectName__c;
            
            // Get the report data order by field name and then by page layout id
            List<ReportData__c> lstRepData = [Select id,name,FieldName__c from ReportData__c order by FieldName__c,name];
    
            // Get the PageLayout ID Name Mapping
            List<PageLayoutNameID__c> lstpNames = [select id,name,pagelayoutid__c,pagelayoutname__c from PageLayoutNameID__c where name= :di.objectName__c order by pagelayoutname__c,pagelayoutid__c ];
    
            // Populate a map that will hold page layouts name id mapping
            for(PageLayoutNameID__c pc : lstpNames)
            {
                mapIDName.put(pc.pagelayoutid__c,pc.pagelayoutname__c);
            }
            
            // Get the report data
            for(ReportData__c rd : lstRepData)
            {
                if(!mapFieldslayouts.containskey(rd.FieldName__c))
                {
                   Set<String> lstvals = new Set<String>();
                   lstvals.add(rd.name);
                   mapFieldslayouts.put(rd.FieldName__c,lstvals);
                }
                else
                {
                   Set<String> lstvals = mapFieldslayouts.get(rd.FieldName__c);
                   lstvals.add(rd.name);
                   mapFieldslayouts.put(rd.FieldName__c,lstvals);
                }
                layoutNames.add(rd.name);
            }
    
            Integer headerCounter=1;
            for(String s : layoutNames)
            {
                if(mapIDName.containskey(s.left(15)))
                {
                    plNames.add(s.left(15) +  mapIDName.get(s.left(15)) + '@' + headerCounter++);
                }
            }
            
            // Sort the table column heading by pagelayout id
            plNames.sort();
            
            integer counter=1;
            
            
            // Build the wrapper
            for(String st : mapFieldslayouts.keyset())
            {
                wrapper wr = new wrapper();
                wr.fname = st;
                wr.lstLayoutNames = getTabularList(layoutNames,mapFieldslayouts.get(st));
                 wr.lstLayoutNames.sort();
                lstRecs.add(wr);
            }
           
            lstRecs.sort();
    
            counter=1;
            for(wrapper wr : lstRecs)
            {
                wr.srno=counter++;
            }
            
            recCount = lstRepData.size();
        }
        catch(Exception ex)
        {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Error occured while putting the data on the report.Please contact the system administrator.!');            
           ApexPages.addmessage(myMsg);
        }
    }

// =================================================
// = M.E.T.H.O.D.S
// =================================================    
    /**
        This function generates the table row for each field
    */
    public List<String> getTabularList(Set<String> layoutNames,Set<String> flayouts)
    {
        try
        {
            List<String> lstCal = new List<String>();
            for(String st : layoutNames)
            {
                if(flayouts.contains(st))
                    lstCal.add(st.left(15) + 'Y');
                else
                    lstCal.add(st.left(15) + 'N');
            }
            return lstCal;
        }
        catch(Exception ex)
        {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Error occured while generating the row for the report.Please contact the system administrator.!');            
           ApexPages.addmessage(myMsg);
           return null;
        }
        
        
    }
    
    /** 
        This class is a wrapper class which is used to display final processed results on the VF page.
    */
    public class wrapper implements Comparable
    {
        public integer srno {get;set;}
        public string fname {get;set;}
        public List<String> lstLayoutNames {get;set;}
        
        public Integer compareTo(Object compareTo)
        {
            wrapper compareToWrap = (wrapper)compareTo;
            if(fname == compareToWrap.fname) return 0;
            if(fname > compareToWrap.fname) return 1;
            return -1;
        }
    }    
}