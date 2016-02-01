trigger recordtype_check on test__c (after insert, before insert) {
if(trigger.isbefore){
for(test__c t: Trigger.new){
system.debug('***Record_type_Name__c before'+t.Record_type_Name__c);
}}
if(trigger.isafter){
for(test__c t1: Trigger.new){
system.debug('***Record_type_Name__c after'+ t1.Record_type_Name__c);
}}
}