trigger CaseHandlerCountAlert on Case (after insert) {
    List<AggregateResult> AggregateResultList = [SELECT AccountId, Account.Name name, COUNT(Id) co,  Project__r.id,
                                    Project__r.Implementation_status__c, Project__r.Client_Advisor_Email__c
                                    FROM Case
                                    WHERE CreatedDate = LAST_N_DAYS:5 AND Id IN :Trigger.New
                                    GROUP BY AccountId, Account.Name
                                    HAVING COUNT(Id)  >= 8
                                    ];
                                    

                for(AggregateResult aggr:AggregateResultList){ 
                        system.debug(aggr);

                        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                        
                            if(Milestone1_Project__c.Implementation_status__c == 'LIVE - TRANSITION'){    
                                // Set Outgoing Email to Implementation Coordinator
                                //message.toAddresses = new String[] { 'test@test.com' }; 
                            }
                            else if (Milestone1_Project__c.Implementation_status__c == 'Live'){  
                                // Private method *** getAddresses() *** retrieves email address from Customer_Success_Managers Public Group
                                
                                //message.toAddresses = new String[] { 'test@test.com' };
                            } 
                        message.Subject = 'Subject Test Message';
                        message.PlainTextBody = 'Account name: ' + aggr.get('name') + ' has ' + (Integer)aggr.get('co') + ' cases opened in the last 8 days.';
                        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                    System.debug('Account Name: ' + aggr.get('name'));   
                }            
                  
 

private List<String> getAddresses(){
    List<User> UserList =
            [SELECT id, name, email
            FROM User 
            WHERE id 
            IN (SELECT userorgroupid 
                FROM groupmember
                WHERE group.name = 'Customer Success Managers')];

    List<String> emailString = new List<String>();

    for(User u: UserList){
        emailstring.add(u.email);
    }   
    return (emailString);
    }    
}