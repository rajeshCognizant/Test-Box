trigger tcheck on test__c (before insert) {
system.debug('*****hello***');
}