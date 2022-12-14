public with sharing class UpdateOptionQuatityAndSalesPriceHandler {
    public static boolean firstRun = true; 
    public static void afterEvent(List<buildertek__Pricing_Request_Line__c> PRLList) {
        System.debug(firstRun);
        Set<Id> PricingReqLineSet =new Set<Id>();

        for(buildertek__Pricing_Request_Line__c PriReqLine:PRLList){
            if(PriReqLine.buildertek__Status__c=='Pricing Complete'){
                PricingReqLineSet.add(PriReqLine.Id);
            }
        }

        if(PricingReqLineSet!=null){
            List<buildertek__Question__c> optionList = new List<buildertek__Question__c>();
            List<buildertek__Pricing_Request_Line_Details__c> PricReqLineDetailList =[Select Id , Name, buildertek__Quantity__c	,buildertek__Price__c, buildertek__Pricing_Request_Line__c ,(SELECT Id, buildertek__Cost__c, buildertek__Quantity__c	FROM buildertek__Options__r) From buildertek__Pricing_Request_Line_Details__c WHERE buildertek__Pricing_Request_Line__c=:PricingReqLineSet];
            System.debug(PricReqLineDetailList);
            for(buildertek__Pricing_Request_Line_Details__c prld:PricReqLineDetailList){
                for(buildertek__Question__c option:prld.buildertek__Options__r){
                    option.buildertek__Quantity__c=prld.buildertek__Quantity__c;
                    option.buildertek__Cost__c=prld.buildertek__Price__c;
                    optionList.add(option);
                }
            }
            System.debug(optionList);

            if(optionList!=null){
                update optionList;
                UpdateOptionQuatityAndSalesPriceHandler.firstRun = false; 

            }
        }
        System.debug(firstRun);        
    }
}
