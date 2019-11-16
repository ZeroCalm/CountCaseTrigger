trigger CaseHandlerCountAlert on Case (after insert, after update) {
    
   If(!TrggrUtility.RunOnce) 
{
    //Case trigger that will send email alert when 8 cases are created within 7 days.
    
    Set <String> ListOfMessages = new Set <String>();
    Set <Id> AcctIds = new Set <Id>();
    
    
    List < AggregateResult > AggregateResultList = [SELECT AccountId, Account.Name name, COUNT(Id) co
                                                    FROM Case
                                                    WHERE CreatedDate = LAST_N_DAYS:7 AND Id in :Trigger.New
                                                    GROUP BY Account.Name, AccountId
                                                    HAVING COUNT(Id) >= 8
                                                   ];
    
    Map < Id, String > accountIdEmailmessageMap = new Map < Id, String > ();
    
    
        for (AggregateResult aggr: AggregateResultList){
                String messageToSend =+ 'Account name: ' + aggr.get('name') +
                    ' has ' + (Integer) aggr.get('co') +
                    ' cases opened in the last 8 days.';
                Id accId = (Id) aggr.get('AccountId');
                accountIdEmailmessageMap.put(accId, messageToSend);
                AcctIds.add(accId);
            
         }
	
    System.debug('Results from Trigger: ' + AggregateResultList);
    List < Case > caseList = [SELECT Id, AccountId, Account.Name, Parent_Project_if_applicable__r.Implementation_status__c,
                              Parent_Project_if_applicable__r.PM_Implementation_Status__c,
                              Parent_Project_if_applicable__r.RCM_Implementation_Status__c,
                              Parent_Project_if_applicable__r.Resource_Coordinator_Email__c,
                              Parent_Project_if_applicable__r.Client_Advisor_Email__c                      
                              FROM Case
                              WHERE AccountId IN: AcctIds];
    
    List<Messaging.SingleEmailMessage> lstASingleEmailMessage = new List<Messaging.SingleEmailMessage>();
    List<Messaging.SingleEmailMessage> lstBSingleEmailMessage = new List<Messaging.SingleEmailMessage>();
    for (Integer i=0; i<AggregateResultList.size(); i++){
    for (Case cl: caseList) {
        
        if (cl.Parent_Project_if_applicable__r.Implementation_status__c == 'Live - Closed Project' ||
            cl.Parent_Project_if_applicable__r.PM_Implementation_Status__c == 'Live - Closed Project' ||
            cl.Parent_Project_If_Applicable__r.RCM_Implementation_Status__c == 'Live - Closed Project') {
                
                String messageBody = accountIdEmailmessageMap.get(cl.AccountId);
                
                List<String> emailaddr = new List<String>();
                emailaddr.add('smith.timothyh@gmail.com');  
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setSenderDisplayName('Eyefinity Salesforce Support');
                mail.setToAddresses(emailaddr);   
                mail.Subject = 'Multiple cases created alert message';
                mail.setPlainTextBody(messageBody);
                lstASingleEmailMessage.add(mail);
               	System.debug('The message Body is: ' + messageBody);
                break;
                
                
            }else{
                String messageBody1 = accountIdEmailmessageMap.get(cl.AccountId);        
                
                List<String> emailAdds = new List<String>();
                emailAdds.add(cl.Parent_Project_if_applicable__r.Resource_Coordinator_Email__c);
                emailAdds.add(cl.Parent_Project_if_applicable__r.Client_Advisor_Email__c); 
                
                Messaging.SingleEmailMessage amail = new Messaging.SingleEmailMessage();
                amail.SetSenderDisplayName('Eyefinity Salesforce Support');
                amail.setToAddresses(emailAdds);
                amail.Subject = 'Multiple cases created alert message';
                amail.setPlainTextBody(messageBody1);
                lstBSingleEmailMessage.add(amail);
                
                
            }  
    }
    
}
    Messaging.SendEmailResult[] r = Messaging.sendEmail(lstASingleEmailMessage);   
    Messaging.SendEmailResult[] rb = Messaging.sendEmail(lstBSingleEmailMessage);
}
}