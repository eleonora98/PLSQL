--TABLES
CREATE TABLE TRADERS   -- Traders table
(
    TRADER_ID VARCHAR2(10) NOT NULL,
    TRADER_TYPE VARCHAR2(20),
    AGENT_NAME VARCHAR2(30),
    AGENT_ID VARCHAR2(10) NULL,
    AGENT_TRADER VARCHAR2(50),
    status_trader varchar2(2), -- status trader
    SUSPICIOUS_PAST varchar(2) not null, -- traders with a suspicious past
    CONSTRAINT PK_TRADER PRIMARY KEY(TRADER_ID),
    constraint AGENT_FK foreign key (AGENT_ID)
    references AGENTS (AGENT_ID)
)

CREATE TABLE AGENTS  -- agents of the traders
(
    AGENT_ID VARCHAR2(10) NOT NULL,
    CONSTRAINT PK_AGENT PRIMARY KEY (AGENT_ID)
)

CREATE TABLE PARCELS  -- parcels table
(
    PARCEL_ID VARCHAR2(10) NOT NULL,
    TRADER_ID VARCHAR2(10) NOT NULL,
    INITIAL_BALANCE INT DEFAULT 0,
    DAY_START DATE,
    CONSTRAINT PK_PARCEL PRIMARY KEY (PARCEL_ID),
    constraint TRADER_FK foreign key (TRADER_ID)
    references TRADERS (TRADER_ID)
)

CREATE TABLE PRODUCTS  -- products of the traders
(
    PRODUCT_ID VARCHAR2(5) NOT NULL,
    TRADER_ID VARCHAR(10) NOT NULL,
    PRODUCT_NAME VARCHAR2(30),
    QUANTITY_ID varchar2(20) NOT NULL, 
    PRICE INT, 
    PRODUCT_QUANTITY INT,
    DAY_BOOK DATE,
    CONSTRAINT PK_PRODUCT PRIMARY KEY (PRODUCT_ID),
    CONSTRAINT TRADER_P_FK FOREIGN KEY (TRADER_ID)
    references TRADERS (TRADER_ID)
)

CREATE TABLE ORDER_ITEMS  --ordered products
(
   ORDER_ITEM_ID VARCHAR2(10) NOT NULL,
   PRODUCT_ID VARCHAR2(10) NOT NULL ,
   UNIT_PRICE numeric(8,2) NOT NULL,
   QUANTITY numeric(8)  NOT NULL,
   constraint PK_ORDER_ITEMS primary key (ORDER_ITEM_ID, PRODUCT_ID),
   constraint ORDER_ITEMS_PRODUCT_ID_FK foreign key (PRODUCT_ID)
   references PRODUCTS (PRODUCT_ID)
)
CREATE TABLE REGISTER -- register of the sales
(
    SALE_ID VARCHAR2(10) NOT NULL,
    TRADER_ID VARCHAR2(10) NOT NULL,
    PRODUCT_ID VARCHAR2(5),
    QUANTITY_ID VARCHAR2(20),
    CONSTRAINT PK_SALE_ID PRIMARY KEY (SALE_ID),
    constraint PRODUCT_FK foreign key (PRODUCT_ID)
    references PRODUCTS (PRODUCT_ID),
    CONSTRAINT TRADER_R_FK FOREIGN KEY (TRADER_ID)
    references TRADERS (TRADER_ID)
)

CREATE TABLE MALICIOUS_TRADERS   --register of traders, that are malicious
(
    MALICIOUS_TRADER_ID VARCHAR2(10) NOT NULL,
    TRADER_ID VARCHAR2(10) NOT NULL,
    CONSTRAINT PK_MAL_TR PRIMARY KEY (MALICIOUS_TRADER_ID),
    CONSTRAINT TRADER_MAL_FK FOREIGN KEY (TRADER_ID)
    references TRADERS (TRADER_ID)

)
CREATE TABLE VIOLATERS   -- table of traders that are violators

(   VIOLATER_ID VARCHAR2(10) NOT NULL,
    TRADER_ID VARCHAR2(10) NOT NULL,
    CONSTRAINT PK_VIOLATER PRIMARY KEY (VIOLATER_ID),
    CONSTRAINT TRADER_V_FK FOREIGN KEY (TRADER_ID)
    references TRADERS (TRADER_ID)
)
     
CREATE TABLE UNSUCCESSFUL_SALES -- register of unsuccessful sales
(
    UNSUCCESSFUL_SALE_ID VARCHAR2(10) NOT NULL,
    PARCEL_ID VARCHAR2(5),
    PRODUCT_NAME VARCHAR2(30),
    QUANTITY_ID varchar2(20), 
    PRICE INT, 
    PRODUCT_QUANTITY INT,
    DAY_BOOK DATE,
    CONSTRAINT PK_UNSUCCESS_SALE PRIMARY KEY (UNSUCCESSFUL_SALE_ID),
    constraint PARCEL_FK foreign key (PARCEL_ID)
    references PARCELS (PARCEL_ID)

)
   
CREATE TABLE ACCOUNTANCY    --accountancy table
(
    ACCOUNT_ID VARCHAR2(10) NOT NULL,
    TRADER_ID VARCHAR2(10) NOT NULL,
    DAY_ACCOUNT DATE,
    CONSTRAINT PK_ACC_ID PRIMARY KEY (ACCOUNT_ID),
    CONSTRAINT TRADER_ACC_FK FOREIGN KEY (TRADER_ID)
    references TRADERS (TRADER_ID)
) 
      
CREATE TABLE TAXES
(
    TAX_ID VARCHAR2(10) NOT NULL,
    TRADER_ID VARCHAR2(10) NOT NULL,
    TAX NUMERIC,
    CONSTRAINT PK_TAX_ID PRIMARY KEY (TAX_ID),
    CONSTRAINT TRADER_T_FK FOREIGN KEY (TRADER_ID)
    references TRADERS (TRADER_ID)
)
CREATE TABLE SALES   --sales for a month
(
    SALE_ID VARCHAR2(10) NOT  NULL,
    TRADER_ID VARCHAR2(10) NOT NULL,
    CONSTRAINT PK_SAL_ID PRIMARY KEY (SALE_ID),
    CONSTRAINT TRADER_S_FK FOREIGN KEY (TRADER_ID)
    references TRADERS (TRADER_ID)
)

-----------------------------------------------------------------------------------
   --inserts

BEGIN
insert into AGENTS
values ('1');
insert into AGENTS
values ('2');
END;

BEGIN 
INSERT INTO PRODUCTS
VALUES('1', '1', 'LAPTOP', '2', 1000, 2, TO_DATE('13/01/2017', 'DD/MM/YYYY'));
INSERT INTO PRODUCTS
VALUES('2', '3', 'LAPTOP1', '1', 1000, 1, TO_DATE('15/01/2017', 'DD/MM/YYYY'));
END;

BEGIN 
INSERT INTO ORDER_ITEMS
VALUES ('1', '1', 2000, 2);
END;

DECLARE 
l_trader_type1 varchar2(20):= 'Individual';
l_trader_type2 varchar2(30) := 'Juridical';
l_agent_trader1 TRADERS.AGENT_TRADER%TYPE;
l_agent_trader2 TRADERS.AGENT_TRADER%TYPE;
l_reg boolean := true;
l_status VARCHAR2(2);
BEGIN	
IF (l_trader_type1 = 'Individual') -- if the trader is indicidual
THEN 
l_agent_trader1 := 'The trader is the agent'; --then the trader and the agent are the same
elsif 
l_trader_type1 = 'Juridical'
then l_agent_trader1 := 'The trader is not the agent';
else
l_agent_trader1 := 'other';
END IF;
IF (l_trader_type2 = 'Juridical')
THEN 
l_agent_trader2 := 'The trader is not the agent';
elsif 
l_trader_type2 = 'Individual'
then l_agent_trader1 := 'The trader is the agent';
else
l_agent_trader2 := 'other';
END IF;

begin
insert into TRADERS
values ('1', l_trader_type1, 'ivan', '1', l_agent_trader1, l_status, 'N');
insert into TRADERS
values ('2', l_trader_type2, 'georgi', '2', l_agent_trader2, l_status, 'N');
insert into TRADERS
values ('3', l_trader_type1, 'gosho','',l_agent_trader1, l_status, 'N');
end;
END;

--second way
declare
l_traders traders%ROWTYPE;
begin

l_traders.trader_id := '5';
l_traders.trader_type:= 'Individual';
l_traders.agent_name := 'ivo';
l_traders.agent_trader := '';
l_traders.status_trader := '';
l_traders.suspicious_past := 'N';

if l_traders.trader_type = 'Individual'
then
l_traders.agent_trader := 'The trader is the agent';
elsif l_traders.trader_type = 'Juridical'
then
l_traders.agent_trader := 'The trader is not the agent';
else 
l_traders.agent_trader := 'other';
end if;
insert into traders
values l_traders;

end;

--third way
SELECT trader_type,
CASE
  WHEN trader_type = 'Individual' THEN 'the trader is the agent '
  WHEN trader_type = 'Juridical'  THEN 'the trader is not the agent'
END AS agent_trader
FROM traders


--
alter table TRADERS
add manufacturer varchar2(40)

DECLARE 
l_trader_type1 varchar2(20):= 'Individual';
l_trader_type2 varchar2(30) := 'Juridical';
l_suspicious_past1 varchar2(2):= 'N';
l_suspicious_past2 varchar2(2):= 'Y';
l_agent_trader1 TRADERS.AGENT_TRADER%TYPE;
l_agent_trader2 TRADERS.AGENT_TRADER%TYPE;
l_manufacturer VARCHAR2(40) := 'zemedelski proizvoditel';
l_status VARCHAR2(2);
BEGIN	
IF (l_trader_type1 = 'Individual') 
THEN 
l_agent_trader1 := 'The trader is the agent'; 
      if l_manufacturer ='zemedelski proizvoditel'
      then l_status:='fl';
      end if;
elsif 
l_trader_type1 = 'Juridical'
then l_agent_trader1 := 'The trader is not the agent';
else
l_agent_trader1 := 'other';
END IF;
IF (l_trader_type2 = 'Juridical')
THEN 
l_agent_trader2 := 'The trader is not the agent';
elsif 
l_trader_type2 = 'Individual'
then l_agent_trader1 := 'The trader is the agent';
else
l_agent_trader2 := 'other';
END IF;
IF (l_suspicious_past1 = 'N') --if the trader does nkt a suspicious past
THEN
begin
insert into TRADERS
values ('4', l_trader_type1, 'ivan', '1', l_agent_trader1, l_status, l_suspicious_past1, l_manufacturer);
insert into TRADERS
values ('5', l_trader_type1, 'ivan', '1', l_agent_trader1, l_status, l_suspicious_past2, l_manufacturer);
end;
elsif l_suspicious_past2 = 'Y' --if the trader has a suspicious past
then 
begin
insert into MALICIOUS_TRADERS --then the trader has to be put in the table of the malicious traders
values ('1');
end;
end if;
delete from traders where SUSPICIOUS_PAST = 'Y'; -- and the trader gets deleted from the table of traders
END;


--Daily sales and taxes on the sales
alter table traders 
add tax_free varchar2(5)

declare
l_trader_type TRADERS.TRADER_TYPE%TYPE;
l_tax_free TRADERS.TAX_FREE%TYPE;
l_percentage NUMBER;
l_amount NUMBER := 5600;
begin

if (l_trader_type = 'Individual') -- if the trader is individual, then the amount have to be with 2500 less
then l_amount:=l_amount-2500;
elsif (l_trader_type = 'Jurirdical') and (l_tax_free = 'Y') --else if the trader is juridical and it does not have a tax, then the aount stays the same
then 
l_amount := l_amount;
end if;

--
case 
--when the amount is >500 and <7500, the tax is 5%
when l_amount between 5000 and 7500 
then
l_percentage := 5;
insert into TAXES
values ('1', '1', l_percentage/100*l_amount);

--when the amount is >7500 and <1000, the tax is 7%
when l_amount between 7500 and 10000
then
l_percentage := 7;
insert into TAXES
values ('2', '2', l_percentage/100*l_amount);

--when the amount is >1000, the tax is 10%
when l_amount > 10000
then
l_percentage := 10;
insert into TAXES
values ('3', '3', l_percentage/100*l_amount); 

end case;
end;

select * from TAXES


-- Creating view about reports

    INSERT INTO SALES
    VALUES ('1', '1')
    INSERT INTO SALES
    VALUES ('2', '3')
    INSERT INTO SALES
    VALUES ('3', '1') 

CREATE VIEW REPORTS AS
SELECT SUM(TAXES.TAX) AS TAXES, COUNT(SALES.SALE_ID) AS SALES
FROM TAXES JOIN SALES 
ON TAXES.TRADER_ID = SALES.TRADER_ID

SELECT * FROM REPORTS