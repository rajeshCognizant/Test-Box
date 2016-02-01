/* 
Version        : 1.00
Company        : Accenture
Date           : 24.APR.2014
Author         : Ritesh Shahare
Description    : Controller class for VFP01_SchemaExtractor page 
History        : 
                1.00 24.APR.2014 Ritesh Shahare- Created
*/

public class VFC01_VFP01_SchemaExtractor
{
    // Initialize Variables
    List<String> lstobjs = new List<String>();
    Set<String> setRelobjs = new Set<String>();
    Private string objVal='10';
    // This map stores all the available salesforce objects with key as Object API Name and vallue as object properties.    
    Static Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
    // This map is used to store the object name and its field details.
    Map<String,String> mapObjectFieldDetails ;
    // This map is used to store the object field details
    Map<String,String> mapOFI;
    // This map stores the label of the object name 
    Map<String,String> mapObjLabelName;

     //=================================
    // G.E.T.T.E.R.S and S.E.T.T.E.R.S
    //=================================    
    
    // List of available salesforce standard and custom objects.
    Public List<SelectOption> availableObjects {get;set;}
    // User selected objects will be stored in this list.
    Public List<String> selobjects{get;set;}
    // List of objects related to objects selected by user.
    Public List<SelectOption> relatedObjects {get;set;}
    // User selected related objects will be stored in this list.
    Public List<String> selrelobjects {get;set;}
    // List of already available related objects
    Public List<SelectOption> alreadyAvailObjects {get;set;}
    // Variable to include all salesforce objects for extraction
    Public Boolean includeAllObjects {get;set;}
    // Variable showing Schema Build in percentage
    Public Integer schemaBuildPercentage {get;set;}
    Public boolean blnpickbutton {get;set;}
    Public boolean blninProgress {get;set;}
    Public boolean blnComplete {get;set;}
    public integer getRelatedObjPercentage {get;set;}
    public integer getBuildObjPercentage {get;set;}
    public boolean blnDisable {get;set;}
    
    public String getoVal() 
    {
        return objVal;
    }
    
    public void setoVal(String oVal) 
    {
        this.objVal= oVal;
    }
    
     // ===============================
    //    C.O.N.S.T.R.U.C.T.O.R
    // ===============================  
    
    /** 
        Constructor which loads all the standard & custom objects and display those on the VF Page for User Selection
    **/
    public VFC01_VFP01_SchemaExtractor()
    {
        blnDisable = true;
        blnComplete = true;
        blnpickbutton =false;
        blninProgress = false;
        
        getRelatedObjPercentage = 0;
        getBuildObjPercentage = 0;
        String strObj ='';
        
        mapOFI = new Map<String,String>();
        mapObjLabelName = new Map<String,String>();
        mapObjectFieldDetails = new Map<String,String>();
        selrelobjects = new List<String>();
        selobjects = new List<String>();
        availableObjects = new List<SelectOption>();
        relatedObjects = new List<SelectOption>();
        alreadyAvailObjects = new List<SelectOption>();
        
        // This list is build to display the object names in alphabetical order on the list in visual force page.
        lstobjs.addAll(gd.keyset());
        lstobjs.sort();
        selobjects = new List<String>();
        selobjects.add(lstobjs[0]);
        
        // This for loop populates the list on VF with all the standard & custom objects.
        for (String s : lstobjs)
        {    
            Schema.DescribeSObjectResult D = gd.get(s).getDescribe();
            mapObjLabelName.put(s.touppercase(),D.getLabel());
            if(D.isSearchable()==true && D.isUpdateable()==true)
            {
                availableObjects.add(new SelectOption(s,D.getlabel() + '(' + s + ')'));
            }
            D = null;
         }
         
         List<SchemaExtractor_Object__c> lstSObjects = [select id from SchemaExtractor_Object__c];
         
         if(lstSObjects!=null && lstSObjects.size()>0)
             schemaBuildPercentage = Integer.valueOf((Double.valueOf(lstSObjects.size())/Double.valueOf(availableObjects.size()))*100);
         else
             schemaBuildPercentage = 0;
             
        lstSObjects.clear();
        lstSObjects = null;
        populateAvailableObjects();
    }
    
    // ================================
    // = M.E.T.H.O.D.S
    // ================================
    
    /**
        This method populates the List on UI with all the object which holds the schema data 
     **/
    public void populateAvailableObjects()
    {
        Set<String> setAvailableObjs = getObjectList();

         if(setAvailableObjs.size()>1)
         {
             setAvailableObjs.remove('Null');
             lstobjs.clear(); 
             lstobjs.addAll(setAvailableObjs);
             lstobjs.sort();
             alreadyAvailObjects.clear();
             for(String sobj : lstobjs)
             {
                 alreadyAvailObjects.add(new SelectOption(sobj,mapObjLabelName.get(sobj.touppercase()) + '(' + sobj + ')'));
             }
         }
        setAvailableObjs.clear();
        setAvailableObjs = null;    
    }
    
    
    /**
        This method disable the available picklist and loads all the objects.
    **/
    public void disablePicklistButton()
    {
        blnpickbutton = !blnpickbutton ; 
        relatedObjects.clear();
        mapObjectFieldDetails.clear();  
        if(blnpickbutton)
            LoadData();
        
        blninProgress = !blninProgress;
    }
    
    /**
        This method reset the tool environment variables.
    **/
    public void resetenvironment()
    {
        getBuildObjPercentage = 0;
        includeAllObjects = false;
        blnpickbutton = false;
        blninProgress = false; 
        schemaBuildPercentage = 0;
        relatedObjects.clear();
        alreadyAvailObjects.clear();
        List<SchemaExtractor_Object__c> lstSEO = [ select id from SchemaExtractor_Object__c];
        Database.DeleteResult[] results1 = Database.delete(lstSEO);  
        lstSEO.clear();
        lstSEO = null;
    }
    
    /** 
        This method calculates all the objects related to the objects selected by user. 
    **/
    public void LoadData()
    {
           Set<String> setSelObjects = new Set<String>();
           
           if(!includeAllObjects)
               setSelObjects.addAll(selobjects);
           
           if(mapObjectFieldDetails.size()>0)
               blnComplete = true;
               
           relatedObjects.clear();
         
            // Get the related objects(Parents as well as Childs)
            for(String strObjectAPIName : gd.keyset())
            {
                if(Limits.getChildRelationshipsDescribes()<85 && Limits.getFieldsDescribes()<85)
                {
                    Schema.DescribeSObjectResult D = gd.get(strObjectAPIName).getDescribe();
    
                    if(D.isSearchable()==true && D.isUpdateable()==true)
                    {
                        if(setSelObjects.contains(D.getName().tolowercase()))
                        {
                           getChilds(D); // This call is made to verify whether the object has any childs or not.
                           isMaster(D); // This call is made to verify whether the object has any parents or not.
                        }
                        else if (includeAllObjects )
                        {
                            // Build and store the wrapper in a map with key as Object API Name and value as wrapper object(object name and field's details)
                            mapObjectFieldDetails.put(strObjectAPIName.tolowercase(),strObjectAPIName.tolowercase());
                        }
                    }
                    D = null;
                }
                else
                blnComplete = false;
             }
             
             // Get the related objects for objects selected by user.
             setRelobjs = populateRelatedObjects(mapObjectFieldDetails.keyset());
             
             if(blnComplete)
                 blninProgress = true;
                 
           if(!includeAllObjects)
           {
               getRelatedObjPercentage = 0;       
               
               for(String selOb : selobjects)
               {
                   if(setRelobjs.contains(selOb))
                       getRelatedObjPercentage++;
               }
           }
           else
               getRelatedObjPercentage = setRelobjs.size();

            setSelObjects.clear();
            setSelObjects = null;
    }
    
    /**
        This method builds the schema data.
    **/
    public pagereference buildSchemaData()
    {
         Map<String,String> mOJ = new Map<String,String>();
         List<SchemaExtractor_Object__c> lstSO = new List<SchemaExtractor_Object__c>();
         List<SchemaExtractor_Field__c> lstSE = new List<SchemaExtractor_Field__c>();
         mapOFI.clear();
         String objName = '';
         String strLookUpReferences = '';
         String strLookUpRelatedObject ='';
         Integer countRecords = 0;
         blninProgress = true;
         Set<String> setOBJs = getObjectList();
         List<String> lstuniObjs = getUniqueObjectList(mapObjectFieldDetails.keyset());
         
         
         for(String s : lstuniObjs)
         {
             objName = s.tolowercase();
             if(setOBJs !=null && setOBJs.size()>0 && !setOBJs.contains(s) && Limits.getFieldsDescribes()<85)
             {
                 SchemaExtractor_Object__c SEO = new SchemaExtractor_Object__c();
                 SEO.Name = s;
                 SEO.ObjectLabelName__c = mapObjLabelName.get(s.touppercase());
                 
                 Schema.DescribeSObjectResult De = gd.get(s).getDescribe();
                 Map<String, Schema.SObjectField> M = De.getSObjectType().getDescribe().fields.getMap();
                 
                if((countRecords + M.keyset().size() + 1) <10000)
                {
                    List<SchemaExtractor_Field__c> lstSESet = new List<SchemaExtractor_Field__c>();
                    
                    Boolean blnClearAllFields = true;
                    
                    for(String fieldss : M.keyset())
                    {
                        if(!mapOFI.containskey(objName + '-' + fieldss) && Limits.getFieldsDescribes()<85)
                        {
                            mapOFI.put(objName + '-' + fieldss,fieldss);
                        
                            Schema.DescribeFieldResult F = M.get(fieldss).getDescribe();
                            strLookUpReferences = '';
                            if(F.getType()== Schema.DisplayType.REFERENCE)
                            {
                                strLookUpRelatedObject = F.getReferenceTo()[0].getDescribe().getName().tolowercase();
                                if(mapObjectFieldDetails.containskey(strLookUpRelatedObject))
                                {
                                    if(!F.getName().equalsignorecase('OwnerId') && 
                                        !F.getName().equalsignorecase('CreatedById') && !F.getName().equalsignorecase('LastModifiedById') && 
                                        !F.getLabel().equalsignorecase('Record Type ID'))
                                    {
                                        if(F.getReferenceTo()[0].getDescribe().isSearchable()==true && F.getReferenceTo()[0].getDescribe().isUpdateable()==true)
                                             strLookUpReferences = F.getReferenceTo()[0].getDescribe().getName().tolowercase() + '-' + F.getReferenceTo()[0].getDescribe().fields.getMap().get('Id').getDescribe().getLabel();
                                        else
                                             strLookUpReferences = objName  + '-' + F.getLabel();
                                    }
                                    else
                                    {
                                        strLookUpReferences = objName + '-' + F.getLabel();
                                    }
                                }
                            }

                            SchemaExtractor_Field__c sfc = new SchemaExtractor_Field__c();
                            sfc.name = s + '@@' + F.getName();
                            if(F.getName().equalsignorecase('whatid'))
                                sfc.FieldDataLabel__c = 'RelatedTo';
                            else
                                sfc.FieldDataLabel__c = F.getLabel();
                            
                            sfc.FieldDataReference__c = strLookUpReferences ;
                            if((objName == 'note' || objName == 'attachment' || objname =='event' || objname =='task')  && (F.getName().equalsignorecase('parentid') || F.getLabel().equalsignorecase('Opportunity/Account ID')))
                                sfc.FieldDataType__c =  'LOOKUP(SOBJECTS)' ;
                            else
                                sfc.FieldDataType__c =  getSFDatatype(F);
                            lstSESet.add(sfc);
                            countRecords++;
                        
                        }
                        else
                        {
                            blnClearAllFields = false;
                            break;
                        }
                    }
                    if(blnClearAllFields)
                    {
                        lstSO.add(SEO);
                        lstSE.addall(lstSESet);
                    }
                }
            }
         }
        
        if(lstSO != null && lstSO.size()>0)
        {
            Database.SaveResult[] results = Database.insert(lstSO);   
            
            for (Integer i = 0; i < results.size(); i++) 
            {
              if(results[i].isSuccess()) 
                  mOJ.put(lstSO[i].name,results[i].getId());
            }
        }
        
        for(SchemaExtractor_Field__c s : lstSE)
        {
            List<String> strParts = s.name.split('@@');
            s.name = strParts[1];
            s.SchemaExtractor_Object__c = mOJ.get(strParts[0]);
        }
       
       if(lstSE!=null && lstSE.size()>0)          
           Database.SaveResult[] results1 = Database.insert(lstSE); 
       
       if(lstuniObjs.size()<(setOBJs.size()+lstSO.size()))
           blninProgress = false; 
           
      lstSO.clear();
      lstSO = null;
      lstSE.clear();
      lstSE = null;
       
       populateAvailableObjects();
       
       getBuildObjPercentage = 0;
       
       Set<String> setAvailableObjs = getObjectList();

         if(setAvailableObjs.size()>1)
         {
             setAvailableObjs.remove('Null');
             
             for(String s :setRelobjs)
             {
                 if(setAvailableObjs.contains(s))
                 getBuildObjPercentage++;
             }
         }
        
        setAvailableObjs.clear();
        setAvailableObjs = null;
       
       return null;
    }
    
    /**
         This method returns the data type with complete details 
    **/
    public String getSFDatatype(Schema.DescribeFieldResult F)
    {
        String strDtype = String.valueOf(F.getType());
        if(strDtype.equalsignorecase('boolean'))
        strDtype = 'CHECKBOX';
        String strDetailType = '';
        if(strDtype=='Currency' || strDtype=='Percent' )
        {
            if(F.isCalculated())
                strDetailType = 'FORMULA(' + strDtype + ')';
            else
                strDetailType = strDtype + '(' + F.getPrecision() + ',' + F.getScale() + ')';
        }
        else if(strDtype=='Double')
        {
            if(F.isCalculated())
                strDetailType = 'FORMULA(' + strDtype + ')';
            else
                strDetailType = 'NUMBER' + '(' + F.getPrecision() + ',' + F.getScale() + ')';    
        }
        else if(strDtype=='Integer' )
        {
            if(F.isCalculated())
                strDetailType = 'FORMULA(' + strDtype + ')';
            else
                strDetailType = 'NUMBER'+ '(' + F.getDigits() + ',' + F.getScale() + ')';
        }
        else if(strDtype=='TextArea' )
            strDetailType = strDtype + '(' + F.getLength() + ')';
        else if(strDtype=='String')
        {
            if(F.isCalculated())
                strDetailType = 'FORMULA(TEXT)';
            else
                strDetailType = 'TEXT' + '(' + F.getLength() + ')';
        }
        else if(strDtype == 'Reference')
        {
              if(F.getRelationshipOrder()==0)
                  strDetailType = 'MASTER-DETAIL(' + F.getReferenceTo()[0].getDescribe().getLabel().touppercase() + ')';
              else
                  strDetailType = 'LOOKUP(' + F.getReferenceTo()[0].getDescribe().getLabel().touppercase() + ')';
        }
        else
        {
            if(F.isCalculated())
                strDetailType = 'FORMULA(' + strDtype + ')';
            else
                strDetailType = strDtype;
        }

        return strDetailType;
    }
    
    /**
        This method is used to check whether the object has any parents or not.
    **/
    public void isMaster(Schema.DescribeSObjectResult D)
    {
        if(Limits.getFieldsDescribes()<85)
        {
        String objName = D.getName().tolowercase();
        
        if(!mapObjectFieldDetails.containskey(objName) && D.isSearchable()==true && D.isUpdateable()==true)
        {
            boolean blnIsparent = True;
    
            // This list is used to store the lookup field object details for a given object.
            List<Schema.SObjectType> lstobjLookUp = new List<Schema.SObjectType>();
            
            // This map stores all the field's details for a given object.
            Map<String, Schema.SObjectField> M = D.getSObjectType().getDescribe().fields.getMap();
            
            boolean blnChkAllLookUpFields = true;
            
            // Iterate through each and every field and populate the list lstobjLookUp with all the lookup reference fields.
                for(String ss : M.keyset())
                {
                    if(!mapOFI.containskey(objName + '-' + ss) && Limits.getFieldsDescribes()<85)
                    {
                        mapOFI.put(objName + '-' + ss,ss);
                        Schema.DescribeFieldResult F = M.get(SS).getDescribe();
                     
                     if(F.getType()== Schema.DisplayType.REFERENCE)
                     {
                        if(!F.getName().equalsignorecase('OwnerId') && 
                            !F.getName().equalsignorecase('CreatedById') && !F.getName().equalsignorecase('LastModifiedById') && 
                            !F.getLabel().equalsignorecase('Record Type ID'))
                        {
                            blnIsparent = false;
                            if(!F.isNamePointing())
                            lstobjLookUp.add(F.getReferenceTo()[0]);    
                        }
                     }
                    }
                    else
                        blnChkAllLookUpFields = false;
                }
            
            if(blnChkAllLookUpFields)
            {
                mapObjectFieldDetails.put(objName,objName);
            }
            
            if(!blnIsparent)
            {
                for(Schema.SObjectType so : lstobjLookUp)
                {
                    Schema.DescribeSObjectResult lookUpFieldObject = so.getDescribe();
                    // Build and store the wrapper in a map with key as Object API Name and value as wrapper object(object name and field's details)
                    mapObjectFieldDetails.put(lookUpFieldObject.getName().tolowercase(),lookUpFieldObject.getName().tolowercase());
                }
            }
         }  
         }
    }    
    
    /**
        This method is used to check whether we have child entities of a given object
    **/
    public void getChilds(Schema.DescribeSObjectResult D)
    {
        String objName = D.getName().tolowercase();
        
        if(!mapObjectFieldDetails.containskey(objName))
        {
            if(Limits.getChildRelationshipsDescribes()<85 && Limits.getFieldsDescribes()<85)
            {
                List<Schema.ChildRelationship> childEntities = D.getChildRelationships();
                            
                if(childEntities!=null && childEntities.size()>0)
                {
                    for(Schema.ChildRelationship scd : childEntities )
                    {
                        Schema.DescribeSObjectResult De = scd.getChildSObject().getDescribe();
                         
                        if(!mapObjectFieldDetails.containskey(objName + '##' + De.getName().tolowercase()) && De.isSearchable()==true && De.isUpdateable()==true)
                        {
                            mapObjectFieldDetails.put(objName + '##' + De.getName().tolowercase(),objName + '##' + De.getName().tolowercase());
                        }
                    }
                }
            }
            else
                blnComplete=false;
        }
    } 
    
    /**
        This method builds the list for related objects.
     **/
    public Set<String> populateRelatedObjects(Set<String> objNames)
    {
        List<String> lstobjs = getUniqueObjectList(objNames);
        Set<String> setrobjs = New Set<String>();
        
        for(String strObjName : lstobjs)
        {
            setrobjs.add(strObjName);
            relatedObjects.add(new SelectOption(strObjName,mapObjLabelName.get(strObjName.touppercase()) + '(' +strObjName + ')'));
        }
        
        return setrobjs;
    }
    
    /**
        This method gives the object list which are already loaded in salesforce.
    **/
    public Set<String> getObjectList()
    {
        List<SchemaExtractor_Object__c> lstSO = [select name from SchemaExtractor_Object__c order by name];
        Set<String> setObjList = new Set<String>();
        setObjList.add('Null');
        for(SchemaExtractor_Object__c ss : lstSO)
        {
            setObjList.add(ss.name);
        }
        return setObjList;
    }
    
    /**
        This method takes the set with values as parent object + child object as input and builds a list
        containing all unique objects.
    **/ 
    public List<String> getUniqueObjectList(Set<String> objNames)
    {
        Set<String> setUniqueObjs = new Set<String>();
        for(String strON : objNames)
        {
            if(strON.indexof('##')!=-1)
            {
                 List<String> strParts = strON.split('##');   
                 if(!setUniqueObjs.contains(strParts[0]))
                    setUniqueObjs.add(strParts[0]);
                 if(!setUniqueObjs.contains(strParts[1]))
                    setUniqueObjs.add(strParts[1]);   
            }
            else
            {
                if(!setUniqueObjs.contains(strON))
                    setUniqueObjs.add(strON);
            }
        }
        
        List<String> lstobjs = new List<String>();
        lstobjs.addAll(setUniqueObjs);
        lstobjs.sort();
        
        return lstobjs;
    
    }
    
     /**
        This method builds the values for object per row picklist field on th UI.
    */
    public List<SelectOption> getObjValues() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('5','5'));
        options.add(new SelectOption('10','10'));
        options.add(new SelectOption('20','20'));
        options.add(new SelectOption('30','30'));
        options.add(new SelectOption('40','40'));
        options.add(new SelectOption('50','50'));
        return options;
    }
    
}