CREATE OR REPLACE PACKAGE update_package
IS
        -- HEADERS OF FUNCTIONS / PROCEDURES 
 FUNCTION calc_payment_number( v_start_date date, v_end_date date,v_type varchar2)
RETURN NUMBER;

 PROCEDURE UPDATE_PAYMENT_INSTALLMENTS_NO
                    (v_pay number , v_id number);
         
END;