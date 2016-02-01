/* 
Version        : 1.00
Company        : Accenture
Date           : 24.APR.2014
Author         : Ritesh Shahare
Description    : Controller class for VFP02_SchemaExcelExtract page 
History        : 
                1.00 24.APR.2014 Ritesh Shahare- Created
*/

public class VFC02_VFP02_SchemaExtractorExcel
{
    //Initialize variables
    public Integer objectsPerRow = 0;  
    
     //=================================
    // G.E.T.T.E.R.S and S.E.T.T.E.R.S
    //=================================    
    
    // This list is used for finally displaying the results on excel.
    Public List<clsObjsPerRows> lstDisplayObjects {get;set;}
    // This map is used to store the cell reference
    Public Map<String,String> mapCellReferences {get;set;}
     // This map stores the label of the object name 
    Public Map<String,String> mapObjLabelName {get;set;}
     // This map is used to store the relationship
    Public Map<String,String> mapRel {get;set;}
    Public integer totObjs {get;set;}
 
    // ===============================
    //    C.O.N.S.T.R.U.C.T.O.R
    // ===============================  
    
    /** 
    Constructor which loads all the standard & custom objects and display those on the VF Page for User Selection
    **/
    public VFC02_VFP02_SchemaExtractorExcel()
    {
        objectsPerRow  = Integer.valueOf(ApexPages.currentPage().getParameters().get('objrow'));
        mapCellReferences = new Map<String,String>();
        mapObjLabelName = new Map<String,String>();
        mapRel = new Map<String,String>();
        exporttoexcel();
     }
    
    // ================================
    // = M.E.T.H.O.D.S
    // ================================
    
    /** 
        This method is used to build the maps required for export to excel page
    **/    
    public void exporttoexcel()
    {
         List<SchemaExtractor_Object__c> lstExSEO = [select id,name,ObjectLabelName__c,(select id,name,FieldDataLabel__c,FieldDataReference__c,FieldDataType__c,SchemaExtractor_Object__c from  SchemaExtractor_Fields__r) from SchemaExtractor_Object__c];
         Map<String,Map<String,String>> mapDBData = new Map<String,Map<String,String>>();
         
         for(SchemaExtractor_Object__c se : lstExSEO)
         {
             Map<String,String> mapFE = new Map<String,String>();
             for(SchemaExtractor_Field__c sf : se.SchemaExtractor_Fields__r)
             {
                 mapFE.put(sf.FieldDataLabel__c,sf.FieldDataType__c);
                 if(sf.FieldDataReference__c != null)
                     mapRel.put(se.name + '-' + sf.FieldDataLabel__c,sf.FieldDataReference__c);
                 else
                     mapRel.put(se.name + '-' + sf.FieldDataLabel__c,'NoVal');
             }
             mapObjLabelName.put(se.name.touppercase(),'Object : ' + se.ObjectLabelName__c.touppercase() + '(# of Fields - ' + mapFE.size() + ')');
             mapDBData.put(se.name,mapFE);
         }
         
         mapCellReferences.put('NoVal','"."');
         
         totObjs = lstExSEO.size();
        
         Map<String,Map<String,String>> mapObjectsFields ;
         List<clsObjectFieldData> lstObjectsData = new List<clsObjectFieldData>();
         lstDisplayObjects = new List<clsObjsPerRows>();
         integer countter = 1;
         Integer totalObjects = 0;
         Integer colStartNum = 2;
         Integer rowStartNum = 4;
         Integer maxRowStartNum = rowStartNum ;
         Integer startRow = maxRowStartNum ;
         
         for(String s : mapDBData.keyset())
         {
             mapObjectsFields = new Map<String,Map<String,String>>();
             totalObjects++; 
             if(countter<=objectsPerRow && totalObjects <= mapDBData.keyset().size())
             {
                     rowStartNum = startRow ;
                     List<String> setFieldNames = new List<String>();
                     setFieldNames.addAll(mapDBData.get(s).keyset());
                     setFieldNames.sort();
                     for(String strSortedNums : setFieldNames)
                     {
                         // This is how we get the cell address
                         if(strSortedNums == 'Id')
                             mapCellReferences.put(s + '-' + strSortedNums,getExcelColumnName(colStartNum) + rowStartNum);
                         else
                             mapCellReferences.put(s + '-' + strSortedNums,getExcelColumnName(colStartNum) + rowStartNum);
                             
                         rowStartNum++;
                         if(maxRowStartNum < rowStartNum)
                         maxRowStartNum = rowStartNum ;
                     }
                     
                 mapObjectsFields.put(s,mapDBData.get(s));
                 clsObjectFieldData cObFlData = new clsObjectFieldData();
                 cObFlData.mapObjFieldsDetails = mapObjectsFields;
                 lstObjectsData.add(cObFlData);
                 countter++;
                 if(totalObjects == mapDBData.keyset().size())
                 {
                     clsObjsPerRows cLast = new clsObjsPerRows();
                     cLast.lstObPerRows = lstObjectsData;
                     lstDisplayObjects.add(cLast);
                     colStartNum = 2;
                 }
             }
             else
             {
                 clsObjsPerRows c = new clsObjsPerRows();
                 c.lstObPerRows = lstObjectsData;
                 lstDisplayObjects.add(c);
                 lstObjectsData = new List<clsObjectFieldData>();
                 colStartNum = 2;
                 startRow = maxRowStartNum + 2 ;    
                        
                         rowStartNum = startRow ;
                         List<String> setFieldNames = new List<String>();
                         setFieldNames.addAll(mapDBData.get(s).keyset());
                         setFieldNames.sort();
                         for(String strSortedNums : setFieldNames)
                         {
                             // This is how we get the cell address
                             if(strSortedNums == 'Id')
                                 mapCellReferences.put(s + '-' + strSortedNums,getExcelColumnName(colStartNum) + rowStartNum);
                             else
                                 mapCellReferences.put(s + '-' + strSortedNums,getExcelColumnName(colStartNum ) + rowStartNum);
                             rowStartNum++;
                             if(maxRowStartNum < rowStartNum)
                             maxRowStartNum = rowStartNum ;
                         }
                     
                     mapObjectsFields.put(s,mapDBData.get(s));
                     clsObjectFieldData cObFlData = new clsObjectFieldData();
                     cObFlData.mapObjFieldsDetails = mapObjectsFields;
                     lstObjectsData.add(cObFlData);
                     countter=2;
             }
             
             colStartNum = colStartNum  + 5;
         }
    
    
        /*List<SchemaExtractor_Field__c> lstIDFields = [select FieldDataLabel__c,SchemaExtractor_Object__r.name from  SchemaExtractor_Field__c where FieldDataType__c ='ID' and FieldDataLabel__c not in ('Note Id','Attachment ID','Activity ID','Activity ID')];
        String strIDRefs = '';
        
        for(SchemaExtractor_Field__c sfc : lstIDFields)
        {
            strIDRefs = strIDRefs + mapCellReferences.get(sfc.SchemaExtractor_Object__r.name + '-' + sfc.FieldDataLabel__c) + ',';
        }
            strIDRefs = strIDRefs + '""';
            mapRel.put('note-Parent ID','note1-Parent ID');
            mapCellReferences.put('note1-Parent ID',strIDRefs);
            
            mapRel.put('attachment-Parent ID','attachment1-Parent ID');
            mapCellReferences.put('attachment1-Parent ID',strIDRefs);
            
            mapRel.put('task-RelatedTo','task1-RelatedTo');
            mapCellReferences.put('task1-RelatedTo',strIDRefs);
            
            mapRel.put('event-RelatedTo','event1-RelatedTo');
            mapCellReferences.put('event1-RelatedTo',strIDRefs); */
    }
    
    // ================================
    // = WRAPPER CLASSES FOR BUILDING TABLES ON EXCEL
    // ================================
    
    public class clsObjsPerRows
    {
        public List<clsObjectFieldData> lstObPerRows {get;set;}
    }
    
    public class clsObjectFieldData
    {
        public Map<String,Map<String,String>> mapObjFieldsDetails {get;set;}
    }
    
    /**
        This function is used to calculate the excel column name from integer value
    **/
    public string getExcelColumnName(Integer ColNum)
    {
        Map<Integer,String> ascMap = new Map<Integer,String>();
        ascMap.put(65,'A');
        ascMap.put(66,'B');
        ascMap.put(67,'C');
        ascMap.put(68,'D');
        ascMap.put(69,'E');
        ascMap.put(70,'F');
        ascMap.put(71,'G');
        ascMap.put(72,'H');
        ascMap.put(73,'I');
        ascMap.put(74,'J');
        ascMap.put(75,'K');
        ascMap.put(76,'L');
        ascMap.put(77,'M');
        ascMap.put(78,'N');
        ascMap.put(79,'O');
        ascMap.put(80,'P');
        ascMap.put(81,'Q');
        ascMap.put(82,'R');
        ascMap.put(83,'S');
        ascMap.put(84,'T');
        ascMap.put(85,'U');
        ascMap.put(86,'V');
        ascMap.put(87,'W');
        ascMap.put(88,'X');
        ascMap.put(89,'Y');
        ascMap.put(90,'Z');
        
        integer cNum = ColNum;
        String cLet ='';
        integer modu = 0;
        
        while(cNum>0)
        {
            modu=math.mod(cNum-1,26);
            cLet = ascMap.get(65 + modu) + cLet;
            cNum = (Integer)((cNum - modu)/26);
        }
        
        return cLet;
    }
   
}