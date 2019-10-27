public class CaseHandlerCountAlert{
public static void CaseCounter(){

    List<AggregateResult> AggregateResultList = [SELECT AccountId, Account.Name name, COUNT(Id) co, 
                                FROM Case
                                WHERE CreatedDate = LAST_N_DAYS:5
                                GROUP BY AccountId, Account.Name
                                HAVING COUNT(Id)  >= 8];
                                //In Trigger.New
                    /* I will need to query a sibling object
                        Case. (___).  This is currently not possible
                        to my knowledge.  I will query both children 
                        from the account object as a solution
                    */

    Set<Id> idAccountSet = new Set<Id>();
for(Case case : AggregateResultList){
idAccountSet.add(case.AccountId);   
}

List<Account> accountList = [SELECT Id, (SELECT Id FROM ChildObjs) FROM Account WHERE Id = :idAccountSet];
for(Account account : accountList)
{
    if(account.ChildObjs != null) {
        
        for(ChildObj childObjRec : account.ChildObjs)
        {
                //Code here for collectiong email
        }
    {
}



} 

/*

            for(AggregateResult aggr:AggregateResultList){ 

                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                        if((aggr.get('status1') == "Transition"){    // If Status = Transition
                            // Set Outgoing Email to Implementation Coordinator "Implementation.Consultalt "
                            message.toAddresses = new String[] { Milestone1_Project__c.Client_Advisor_Email__c };
                        }
                        else if ((aggr.get('status1') == "Live"){  // If Status equals "Live" - Out Of Transition
                            // Private method retrieves email address from Customer Success Managers
                            message.toAddresses = new String[] { getAddresses() };
                        } 
                            // Set Email Template Id
                    //EmailTemplate templateId = [Select id from EmailTemplate where name = 'Template Name'];  
                    //mail.setTemplateID(templateId.Id);
                    message.setSubject = 'Subject Test Message';
                    message.setPlainTextBody = 'Account name: ' + aggr.get('name') + ' has ' + (Integer)aggr.get('co') + ' cases opened in the last 8 days.';
                    Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                System.debug('Account Name: ' + aggr.get('name'));           
            }
            } 

            private List<String> getAddresses(){
            List<User> UserList =
                    [SELECT id, name, email, isactive, profile.name, userrole.name, usertype
                    FROM User 
                    WHERE id 
                    IN (SELECT userorgroupid 
                    FROM groupmember
                    WHERE group.name = 'Customer Success Managers')];

            Set<String> emailString = new Set<String>();

            for(User u: UserList){
                emailstring.add(u.email);
                // System.debug(u.email);
            }   
            //System.debug('The list ' + emailstring);
            return (emailString);
            }    
            }

*/





