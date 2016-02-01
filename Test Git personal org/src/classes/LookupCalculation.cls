public class LookupCalculation{
    
    public enum Method {COUNT, SUM, MIN, MAX, AVG} 
    
    private string sobjectParent, 
                   relationName, 
                   formulaParent, 
                   sobjectChild, 
                   parentfield, 
                   fieldChild;
    
    public LookupCalculation(string mysobjectParent, string myrelationName, string myformulaParent,
                             string mysobjectChild, string myparentfield, string myfieldChild){
        sobjectParent = mysobjectParent;
        relationName = myrelationName;
        formulaParent = myformulaParent;
        sobjectChild = mysobjectChild;
        parentfield = myparentfield;
        fieldChild = myfieldChild;
    }
    
    public void Calculate(Method calculation, List<sobject> childList){
        set<Id> parentIdSet = new set<Id>();
        for(sobject sobj : childList)
            parentIdSet.add((Id) sobj.get(parentfield));
        string soqlParent = 'select id, (select ' + fieldChild + ' from ' + relationName + ') from ' + sobjectParent + '';
        List<sobject> parentList = Database.query(soqlParent);
        for(sobject parent : parentList){
            List<sobject> children = parent.getSObjects(relationName);
            if(children == null)
                children = new List<sobject>();
            Decimal counter = (mustSum(calculation))? 0 : null;
            if(calculation == Method.COUNT)
                counter = children.size();
            for(sobject child : children){
                Decimal value = (Decimal) child.get(fieldChild);
                if(mustSum(calculation) && value != null)
                    counter += value;
                else if(calculation == Method.MIN && (counter == null || value < counter))
                    counter = value;
                else if(calculation == Method.MAX && (counter == null || value > counter))
                    counter = value;
            }
            if(calculation == Method.AVG && children.size() > 0)
                counter = counter / children.size();
            parent.put(formulaParent, counter);
        }
        update parentList;
    }
    
    private boolean mustSum(Method calculation){
        return (calculation == Method.SUM || calculation == Method.AVG);
    }
    
}