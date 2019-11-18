trigger CaseHandlerCountAlert on Case (after insert, after update) {
    if(TrggrUtility.RunOnce){
       	//Case trigger that will send email alert when 8 cases are created within 7 days.
        Set <String> ListOfMessages = new Set <String>();
        Set <Id> AcctIds = new Set <Id>();
        List < AggregateResult > AggregateResultList = [SELECT AccountId, Account.Name name, COUNT(Id) co
                                                        FROM Case
                                                        WHERE CreatedDate = LAST_N_DAYS:7
                                                        GROUP BY Account.Name, AccountId
                                                        HAVING COUNT(Id) >= 8
                                                        ];
        Map < Id, String > accountIdEmailmessageMap = new Map < Id, String > ();
        
  			 for (AggregateResult aggr: AggregateResultList){
                    String messageToSend =+ 'Account name: ' + aggr.get('name') +
                        ' has ' + aggr.get('co') +
                        ' cases opened in the last 8 days.';
                    Id accId = (Id) aggr.get('AccountId');
                    accountIdEmailmessageMap.put(accId, messageToSend);
                    AcctIds.add(accId);
                
             }

        List < Case > caseList = [SELECT Id, AccountId, Account.Name, Account.Eyefinity_EHR_Status__c,
                                  Account.Eyefinity_PM_Status__c, Account.OfficeMate_Status__c,
                                  Account.Project_Imp_Status__c                
                                  FROM Case
                                  WHERE AccountId IN: AcctIds];
        
          
        List<Messaging.SingleEmailMessage> lstASingleEmailMessage = new List<Messaging.SingleEmailMessage>();
        List<Messaging.SingleEmailMessage> lstBSingleEmailMessage = new List<Messaging.SingleEmailMessage>();
        
        for (Integer i=0; i<AggregateResultList.size(); i++){
        for (Case cl: caseList) {
            
            if (cl.Account.Eyefinity_EHR_Status__c == 'Active' ||
                cl.Account.Eyefinity_PM_Status__c == 'Active' ||
                cl.Account.Project_Imp_Status__c == 'Active'  ||
                cl.Account.OfficeMate_Status__c == 'Active') {
                    
                    String messageBody = accountIdEmailmessageMap.get(cl.AccountId);
                    
                    List<String> emailaddr = new List<String>();
                    emailaddr.add('test@test.com');  
                    
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setSenderDisplayName('Support');
                    mail.setToAddresses(emailaddr);   
                    mail.Subject = 'Multiple cases created alert message';
                    mail.setPlainTextBody(messageBody);
                    lstASingleEmailMessage.add(mail);
                    break;
                    
                
                }else if (cl.Account.Eyefinity_EHR_Status__c == 'Implementation' ||
                cl.Account.Eyefinity_PM_Status__c == 'Implementation' ||
                cl.Account.Project_Imp_Status__c == 'Implementation' ||
                cl.Account.OfficeMate_Status__c == 'Implementation'){
                    String messageBody1 = accountIdEmailmessageMap.get(cl.AccountId);        
                    
                    List<String> emailAdds = new List<String>();
                    emailAdds.add(cl.Parent_Project_if_applicable__r.Resource_Coordinator_Email__c);
                    emailAdds.add(cl.Parent_Project_if_applicable__r.Client_Advisor_Email__c); 
                    System.debug(emailAdds);
                    Messaging.SingleEmailMessage amail = new Messaging.SingleEmailMessage();
                    amail.SetSenderDisplayName('Support');
                    amail.setToAddresses(emailAdds);
                    amail.Subject = 'Multiple cases created alert message';
                    amail.setPlainTextBody(messageBody1);
                    lstBSingleEmailMessage.add(amail);   
                }  
                else{
                    //Notify admin
                    
                }
        }
        
    }
        Messaging.SendEmailResult[] r = Messaging.sendEmail(lstASingleEmailMessage);   
        Messaging.SendEmailResult[] rb = Messaging.sendEmail(lstBSingleEmailMessage);
        TrggrUtility.RunOnce = false;
    
    }
}