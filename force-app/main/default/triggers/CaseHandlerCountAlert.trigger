trigger CaseHandlerCountAlert on Case (after insert, after update) {
    if(TrggrUtility.RunOnce){
       	//Case trigger that will send email alert when 8 cases are created within 7 days.
       
        Set <Id> AcctIds = new Set <Id>();
    	List<String>emailAddresses = new List<String>();
    	String messageToSend;
        List < AggregateResult > AggregateResultList = [SELECT AccountId, Account.Name name, COUNT(Id) co
                                                        FROM Case
                                                        WHERE CreatedDate = LAST_N_DAYS:7 AND Id IN :Trigger.New
                                                        GROUP BY Account.Name, AccountId
                                                        HAVING COUNT(Id) >= 8
                                                        ];
        Map < Id, String > accountIdEmailmessageMap = new Map < Id, String > ();
        
  			 for (AggregateResult aggr: AggregateResultList){
                           messageToSend = 'You are receiving this email alert due to an account ';
                 		   messageToSend += 'activity rule has exceeded 8 cases created within 5 business days.<br><br>';
                           messageToSend += 'Please, follow up with the account and provide guidance and assistance.<br><br>';
                           messageToSend += '<b>Account Name:  </b>' + aggr.get('name') + '<br> <br>';
                           messageToSend +=  'Thank you, <br>';
                           messageToSend +=  'Salesforce Team';
                        
                        
                    Id accId = (Id) aggr.get('AccountId');
                    accountIdEmailmessageMap.put(accId, messageToSend);
                    AcctIds.add(accId);   
             }

    
        List < Case > caseList = [SELECT Id, AccountId, Account.Name, Account.Eyefinity_EHR_Status__c,
                                  Account.Eyefinity_PM_Status__c, Account.OfficeMate_Status__c,
                                  Account.Project_Imp_Status__c                
                                  FROM Case
                                  WHERE AccountId IN: AcctIds];

        List<Account> accList = [SELECT Id, Name 
                                 FROM Account
                                 WHERE Id IN :AcctIds];
        
        for(Account ac :accList){
            System.debug('The account name for this one ' + ac.name);
        }
    
    	List<Milestone1_Project__c> projectList = [SELECT Id, Client_Advisor_Email__c, Resource_Coordinator_Email__c
                                                   FROM Milestone1_Project__c
                                                   WHERE Customer_Account__c IN :accList];
    
    for(Milestone1_Project__c prj :projectList){  
        emailAddresses.add(prj.Client_Advisor_Email__c);
        emailAddresses.add(prj.Resource_Coordinator_Email__c);       
    }
          
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
                    emailaddr.add('tim.smith@vsp.com');  
                    
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setSenderDisplayName('Eyefinity Salesforce Support');
                    mail.setToAddresses(emailaddr);   
                    mail.Subject = 'Notification:  Account Case activity rule exceeded';
                    mail.setHtmlBody(messageToSend);
                    lstASingleEmailMessage.add(mail);
                    break;
                    
                
                }else if (cl.Account.Eyefinity_EHR_Status__c == 'Implementation' ||
                cl.Account.Eyefinity_PM_Status__c == 'Implementation' ||
                cl.Account.Project_Imp_Status__c == 'Implementation' ||
                cl.Account.OfficeMate_Status__c == 'Implementation'){
                    //String messageBody1 = accountIdEmailmessageMap.get(cl.AccountId);        
                    
                    //List<String> emailAdds = new List<String>();
                  //  emailAdds.add(cl.Parent_Project_if_applicable__r.Resource_Coordinator_Email__c);
                   // emailAdds.add(cl.Parent_Project_if_applicable__r.Client_Advisor_Email__c); 
                   
                    
                    Messaging.SingleEmailMessage amail = new Messaging.SingleEmailMessage();
                    amail.SetSenderDisplayName('Eyefinity Salesforce Support');
                    amail.setToAddresses(emailAddresses);
                    amail.Subject = 'Notification:  Account Case activity rule exceeded';
                    amail.setHtmlBody(messageToSend);
                    lstBSingleEmailMessage.add(amail);   
                }  
                else{
                    System.debug(AggregateResultList);
                    
                }
        }
        
    }
        Messaging.SendEmailResult[] r = Messaging.sendEmail(lstASingleEmailMessage);   
        Messaging.SendEmailResult[] rb = Messaging.sendEmail(lstBSingleEmailMessage);
        TrggrUtility.RunOnce = false;
    
    }
}