trigger CaseHandlerCountAlert on Case (after insert) {
 		String messageToSend;
    List < String > ListOfMessages = new List < String > ();
    Set < Id > AcctIds = new Set < Id > ();
    List < String > clientEmail;
    String messageBody;
    String mailGroup;
    List < String > emailAdds;

    List < AggregateResult > AggregateResultList = [SELECT AccountId, Account.Name name, COUNT(Id) co
        FROM Case
        WHERE CreatedDate = LAST_N_DAYS: 1
        GROUP BY AccountId, Account.Name
        HAVING COUNT(Id) = 1
    ];

    Map < Id, String > accountIdEmailmessageMap = new Map < Id, String > ();

    for (AggregateResult aggr: AggregateResultList) {
        String messageToSend = 'Account name: ' + aggr.get('name') +
            ' has ' + (Integer) aggr.get('co') +
            ' cases opened in the last 8 days.';
        Id accId = (Id) aggr.get('AccountId');
        accountIdEmailmessageMap.put(accId, messageToSend);
        AcctIds.add(accId);
    }


    List < Case > caseList = [SELECT Id, AccountId, Account.Name, Parent_Project_if_applicable__r.Implementation_status__c,
        Parent_Project_if_applicable__r.PM_Implementation_Status__c,
        Parent_Project_if_applicable__r.RCM_Implementation_Status__c,
        Parent_Project_if_applicable__r.Resource_Coordinator_Email__c,
        Parent_Project_if_applicable__r.Client_Advisor_Email__c
                              
        FROM Case
        WHERE AccountId IN: AcctIds
    ];

    for (Case cl: caseList) {

        if (cl.Parent_Project_if_applicable__r.Implementation_status__c == 'Live - Closed Project' ||
            cl.Parent_Project_if_applicable__r.PM_Implementation_Status__c == 'Live - Closed Project' ||
            cl.Parent_Project_If_Applicable__r.RCM_Implementation_Status__c == 'Live - Closed Project') {


            
            
            String messageBody = accountIdEmailmessageMap.get(cl.AccountId);
			
			System.debug('If Fired, CSM' + emailAdds);
                System.debug('Resource Coord' + cl.Parent_Project_if_applicable__r.Resource_Coordinator_Email__c);
                System.debug('If Fired, CSM' + cl.Parent_Project_if_applicable__r.Client_Advisor_Email__c);
				
                List<String> email = new List<String>();
                email.add('smith.timothyh@gmail.com');
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSenderDisplayName('IT Support');
            mail.setToAddresses(email);   //mailto:CustomerSuccessManagers@eyefinity.com
            mail.Subject = 'Multiple cases created alert message';
            mail.setPlainTextBody(messageBody);

            if (messageToSend != null) {
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
                    mail
                });
            }
		
        } else {

			System.debug(cl.Parent_Project_if_applicable__r.Resource_Coordinator_Email__c);
            System.debug(cl.Parent_Project_if_applicable__r.Client_Advisor_Email__c);
            
			
            
            //Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            //mail.SetSenderDisplayName('IT Support');
            //mail.setToAddresses(emailAdds);
            //mail.Subject = 'Multiple cases created alert message';
            //mail.setPlainTextBody(messageToSend);

			/*
            if (messageToSend != null) {
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
                    mail
                });
            }
			*/
        }
    }


    
		
}