SET SERVEROUTPUT ON SIZE 1000000
DECLARE 
        cursor contracts_cursor is
                SELECT * FROM CONTRACTS;
                
        v_payments_no CONTRACTS.PAYMENT_INSTALLMENTS_NO %type;
        v_start_date DATE;
        v_end_date DATE;
        
BEGIN
        FOR contract_record in contracts_cursor LOOP
            SELECT CONTRACT_STARTDATE, CONTRACT_ENDDATE
            INTO v_start_date, v_end_date
            FROM CONTRACTS
            WHERE CONTRACT_ID = contract_record.CONTRACT_ID;
            
            v_payments_no :=  update_package.calc_payment_number(v_start_date, v_end_date,contract_record.CONTRACT_PAYMENT_TYPE );
            
              /*dbms_output.put_line('Contract ID :  '||contract_record.CONTRACT_ID||', Start Date:  '||v_start_date||', End Date:  '||v_end_date||', No Payments =  '||v_payments_no);*/
            
            update_package.UPDATE_PAYMENT_INSTALLMENTS_NO(v_payments_no,contract_record.CONTRACT_ID); 
                  
        END LOOP;
END;

