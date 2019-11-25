trigger CaseCountAlertTrigger on Case (after insert, after update) {
if(HelperClass.firstRun){	
    List<String> emailAdds = new List<String>();  							// Holds '2' ToAddresses from Milestone1_project__c object
    Set <Id> AcctIds = new Set <Id>();										//Holds Account Ids from this Case Trigger	
    Id accId;
    
    
    Set<Id> workCasesIds = new Set<Id>();   //Account Ids for Cases in the Trigger
   
     // SYstem.debug('Account Ids to send email for: ' + workCasesIds);   ---This works
    List <AggregateResult> AggregateResultList = [SELECT AccountId, Account.Name name, COUNT(Id) co
                                                        FROM Case
                                                        WHERE CreatedDate = LAST_N_DAYS:7 AND Id in :Trigger.New
                                                        GROUP BY Account.Name, AccountId
                                                 		HAVING COUNT(Id) >= 8];
    
        Map < Id, String > accountIdEmailmessageMap = new Map < Id, String > (); // map of AccountId and Email body per Account/AccountId to be sent

     
    
    for (AggregateResult aggr: AggregateResultList){ 
          System.debug('First cycle: ' + aggr);
                      String  messageToSend = 'You are receiving this email alert due to an account ';
                 		   messageToSend += 'activity rule has exceeded 8 cases created within 5 business days.<br><br>';
                           messageToSend += 'Please, follow up with the account and provide guidance and assistance.<br><br>';
                           messageToSend += '<b>Account Name:  </b>' + aggr.get('name') + '<br> <br>';
                           messageToSend +=  'Thank you, <br>';
                           messageToSend +=  'Salesforce Team';
                        
                 //Crete Map of <AccountId, Message to serve as body in Email
                 //							for each accountId>       
                     accId = (Id) aggr.get('AccountId');
        			System.debug('THe accountID in the questionblock is: ' + accId);
                    accountIdEmailmessageMap.put(accId, messageToSend);
        
          		//Create List of AccountId's to cycle through and grab email addresses from
          		//child Object for 'Implementation' Status emails	
                    AcctIds.add(accId);  
       
    }  
	
    	// SOQL to grab the four status fields on Account to check status either 'Active' or 'Implementation'
    	// also grab two email addresses for use in ifElse block
        List<Account> accList = [SELECT Id, Name, Eyefinity_EHR_Status__c, Eyefinity_PM_Status__c,
                                 		Project_Imp_Status__c, OfficeMate_Status__c,
                                 			(select Client_Advisor_Email__c,
                                             Resource_Coordinator_Email__c
                                     		 from Projects__r) 
                                 FROM Account
                                 WHERE Id IN :AcctIds];
    
          
        List<Messaging.SingleEmailMessage> lstASingleEmailMessage = new List<Messaging.SingleEmailMessage>();
        List<Messaging.SingleEmailMessage> lstBSingleEmailMessage = new List<Messaging.SingleEmailMessage>();

      
       
    
        for (Account al: accList) {
            
            if (al.Eyefinity_EHR_Status__c == 'Active' ||
                al.Eyefinity_PM_Status__c == 'Active' ||
                al.Project_Imp_Status__c == 'Active'  ||
                al.OfficeMate_Status__c == 'Active') {
                    
                    //Grab the message to send from the Map to the AccountId 
					
                    String messageBody = accountIdEmailmessageMap.get(al.Id);
                    
                    //Send Email to Customer Service if "Active"
                    List<String> emailaddr = new List<String>();
                    emailaddr.add('CustomerSuccessManagers@eyefinity.com');  
                    
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setSenderDisplayName('Support');
                    mail.setToAddresses(emailaddr);   
                    mail.Subject = 'Notification:  Account Case activity rule exceeded';
                    mail.setHtmlBody(messageBody);
                    lstASingleEmailMessage.add(mail);
                    
                }
                    
                
                else if (al.Eyefinity_EHR_Status__c == 'Implementation' ||
                         al.Eyefinity_PM_Status__c == 'Implementation' ||
                         al.Project_Imp_Status__c == 'Implementation' ||
                         al.OfficeMate_Status__c == 'Implementation'){
                            
                             
                    
                      String messageBody = accountIdEmailmessageMap.get(al.Id);        
                    
                   //Send email to Coordinator and Advisor if in Implementation
					                    
                    for(Account a : accList)
                    {
                        for(Milestone1_Project__c p : a.Projects__r)
                        {
                            emailAdds.add(p.Client_Advisor_Email__c);
                            emailAdds.add(p.Resource_Coordinator_Email__c);
                            
                        }
                    }
                   
                    System.debug('Emails sent to: ' + emailAdds);
                    Messaging.SingleEmailMessage amail = new Messaging.SingleEmailMessage();
                        amail.SetSenderDisplayName('Support');
                        amail.setToAddresses(emailAdds);
                        amail.Subject = 'Notification:  Account Case activity rule exceeded';
                        amail.setHtmlBody(messageBody);
                    lstBSingleEmailMessage.add(amail); 
                    System.debug('SIngle email: ' + amail);
                }  
                else{
                    System.debug(AggregateResultList);
                    
                }
        }
        

        Messaging.SendEmailResult[] r = Messaging.sendEmail(lstASingleEmailMessage); 
        Messaging.SendEmailResult[] rb = Messaging.sendEmail(lstBSingleEmailMessage); 
             
   HelperClass.firstRun=false;     
}
}