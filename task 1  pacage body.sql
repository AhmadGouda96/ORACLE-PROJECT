CREATE OR REPLACE PACKAGE BODY update_package
IS
 FUNCTION calc_payment_number( v_start_date date, v_end_date date,v_type varchar2)
RETURN NUMBER
IS
  v_pay_num number(8);  
  v_num_of_months number(6);
begin
----------------------------------------------------------------------------------------      
 v_num_of_months:=months_between( v_end_date , v_start_date) ;
----------------------------------------------------------------------------------------
   if v_type='annual'
   then v_pay_num:=(v_num_of_months)/12 ;
   
   elsif  v_type='half_annual'
   then v_pay_num:=(v_num_of_months)/6 ;
   
    elsif  v_type='quarter'
   then v_pay_num:=(v_num_of_months)/3 ;
   
    else   v_pay_num:=(v_num_of_months) ;
    end if ;
    
RETURN v_pay_num;
end;

PROCEDURE UPDATE_PAYMENT_INSTALLMENTS_NO
                    (v_pay number , v_id number)
IS

BEGIN

        update contracts
         set PAYMENT_INSTALLMENTS_NO = v_pay
          where CONTRACT_ID = v_id;    
END;


end;