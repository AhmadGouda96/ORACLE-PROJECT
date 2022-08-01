DECLARE
     V_CONTRACT_ID NUMBER;
     V_INSTALLMENT_DATE DATE;
     V_ORIGINAL_AMOUNT NUMBER(10,2);
     V_P_INSTALLMENTS_NO NUMBER;
     V_C_PAYMENT_TYPE VARCHAR2(100);
     V_INSTALLMENT_AMOUNT NUMBER(10,2);
     V_PAID NUMBER;
       CURSOR CONTRACT_CRS
        IS
        SELECT * FROM CONTRACTS;
BEGIN
           FOR CONTRACT_REC IN CONTRACT_CRS LOOP
                     SELECT CONTRACT_REC.CONTRACT_ID
                    , CONTRACT_REC.CONTRACT_STARTDATE
                    , CONTRACT_REC.CONTRACT_TOTAL_FEES - COALESCE(CONTRACT_REC.CONTRACT_DEPOSIT_FEES,0)
                    , CONTRACT_REC.PAYMENT_INSTALLMENTS_NO 
                    ,  CONTRACT_REC.CONTRACT_PAYMENT_TYPE
                     INTO
                     V_CONTRACT_ID, V_INSTALLMENT_DATE,
                     V_ORIGINAL_AMOUNT, V_P_INSTALLMENTS_NO, V_C_PAYMENT_TYPE
                     FROM CONTRACTS
                     WHERE CONTRACT_ID = CONTRACT_REC.CONTRACT_ID;
                 
       --------------------------
                
        V_INSTALLMENT_AMOUNT := V_ORIGINAL_AMOUNT / V_P_INSTALLMENTS_NO;
       
       --------------------------
        FOR X IN 1..V_P_INSTALLMENTS_NO  LOOP
            IF X = 1 THEN
                 V_INSTALLMENT_DATE :=  CONTRACT_REC.CONTRACT_STARTDATE;
            ELSE
                IF CONTRACT_REC.CONTRACT_PAYMENT_TYPE = 'ANNUAL' THEN
                    V_INSTALLMENT_DATE := ADD_MONTHS(V_INSTALLMENT_DATE, 12);
                ELSIF CONTRACT_REC.CONTRACT_PAYMENT_TYPE = 'HALF_ANNUAL' THEN
                    V_INSTALLMENT_DATE := ADD_MONTHS(V_INSTALLMENT_DATE, 6);
                ELSIF CONTRACT_REC.CONTRACT_PAYMENT_TYPE = 'QUARTER' THEN
                    V_INSTALLMENT_DATE := ADD_MONTHS(V_INSTALLMENT_DATE, 3);
                ELSE
                    V_INSTALLMENT_DATE := ADD_MONTHS(V_INSTALLMENT_DATE, 1);
                END IF;
           END IF;
           
           -- Instert Installments to table
                     INSERT INTO INSTALLMENTS_PAID
                    VALUES( 
                                    INSTALLMENT_ID_SEQ.NEXTVAL,
                                    V_CONTRACT_ID,
                                    V_INSTALLMENT_DATE,
                                    V_INSTALLMENT_AMOUNT,
                                    V_PAID
                                 );                  
           
           END LOOP;
     END LOOP;
end;     