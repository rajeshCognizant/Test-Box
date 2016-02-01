Public Class MapTestingController {
    public Map<String,List<String>> mapObj{get;set;}
    public MapTestingController() {
        mapObj = new Map<String,List<String>>();
        List<String> test1 = new List<String>{'orange', 'apple', 'grape'};
        List<String> test2 = new List<String>{'car', 'motorbike', 'trolley', 'lorry', 'truck'};
        mapObj.put('fruits',test1 );
        mapObj.put('Vehicle',test2 );
    }
}