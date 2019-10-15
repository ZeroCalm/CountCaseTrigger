public class caseHandlerCountAlert{
    public static void CaseCounter(){

        List<AggregateResult> AggregateResultList = [SELECT AccountId, Account.Name name, COUNT(Id) co
                            FROM Case
                            WHERE CreatedDate = LAST_N_DAYS:50
                            GROUP BY AccountId, Account.Name
                            HAVING COUNT(Id)  >= 20];

        for(AggregateResult aggr:AggregateResultList){ 

                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    if(true){
                        // Set Outgoing Email to Implementation Coordinator
                        message.toAddresses = new String[] { 'test@test.com' };
                    }
                    else if (false){
                        // Set Outgoing Email to Customer Success Managers
                        message.toAddresses = new String[] { 'test@test.com' };
                    }   
                    message.subject = 'Subject Test Message';
                    message.plainTextBody = 'Account name: ' + aggr.get('name') + ' has ' + (Integer)aggr.get('co') + ' cases opened in the last 8 days.';
                Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            System.debug('Account Name: ' + aggr.get('name'));           
        }
    } 
}
