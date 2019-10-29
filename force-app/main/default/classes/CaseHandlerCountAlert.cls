public class CaseHandlerCountAlert{
public static void CaseCounter(){

    List<AggregateResult> AggregateResultList = [SELECT AccountId, Account.Name name, COUNT(Id) co,  Milestone1_Project__c.id mid,
                                Milestone1_Project__c.Implementation_status__c mis, Milestone1_Project__c.Client_Advisor_Email__c
                                FROM Case
                                WHERE CreatedDate = LAST_N_DAYS:5
                                GROUP BY AccountId, Account.Name
                                HAVING COUNT(Id)  >= 8
                                WHERE Id IN :Trigger.new];
                                

            for(AggregateResult aggr:AggregateResultList){ 
system.debug(aggr);

/*
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                       
                        if((aggr.get("mis") == "Transition"){    // If Status = Transition
                            // Set Outgoing Email to Implementation Coordinator "Implementation.Consultant "
                            //message.toAddresses = new String[] { smith.timothyh@gmail.com };
                        }
                        else if ((aggr.get("mis") == "Live"){  // If Status equals "Live" - Out Of Transition
                            // Private method retrieves email address from Customer Success Managers
                            //message.toAddresses = new String[] { "smith.timothyh@gmail.com" };
                        } 
                            // Set Email Template Id
                    //EmailTemplate templateId = [Select id from EmailTemplate where name = 'Template Name'];  
                    //mail.setTemplateID(templateId.Id);
                    message.setSubject = 'Subject Test Message';
                    message.setPlainTextBody = 'Account name: ' + aggr.get('name') + ' has ' + (Integer)aggr.get('co') + ' cases opened in the last 8 days.';
                    Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                System.debug('Account Name: ' + aggr.get('name'));           
*/            
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







