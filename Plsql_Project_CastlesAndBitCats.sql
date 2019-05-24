--Tables
CREATE TABLE USERS
(
    USER_ID VARCHAR2(100) PRIMARY KEY,
    USER_NAME VARCHAR2(30), 
    CASTLE VARCHAR2(10),
    CAT_TYPE VARCHAR2(15),
    CATS_NAME VARCHAR2(20), 
    CAT_NUMBER INT, --number of user's cats
    MONEY NUMERIC, --money of the user
    FOOD VARCHAR2(10) 
   
)

CREATE TABLE USERS_REG 
(
    USER_REG_ID VARCHAR2(100) PRIMARY KEY,
    EMAIL VARCHAR2(40),
    FNAME VARCHAR2(20),
    LNAME VARCHAR2(20),
    USER_NAME VARCHAR2(20),
    PASSWORD VARCHAR2(105),
    PASSWORD_CONFIRM VARCHAR2(105),
    USER_STATUS VARCHAR2(3)
)

CREATE TABLE USERS_log --table for each log
(
    log_id    VARCHAR2(105) PRIMARY KEY,
    USER_REG_ID VARCHAR2(100)
)
CREATE TABLE CATS
(
    CAT_ID VARCHAR2(10) PRIMARY KEY,
    CAT_TYPE VARCHAR2(30),
    PRICE NUMERIC,
    USER_NAME VARCHAR2(30)
)

CREATE TABLE CASTLES 
(
    CASTLE_ID VARCHAR2(100) PRIMARY KEY,
    ROOMS INT 

)
CREATE TABLE ROOMS
(
    ROOM_ID VARCHAR2(100) PRIMARY KEY,
    STARS	varchar(99),
    PRICE NUMERIC
)

CREATE TABLE ADOPTED_CATS
(
    ADOPTED_CAT_ID VARCHAR2(10) PRIMARY KEY,
    NAME VARCHAR2(20),
    FURR_COLOUR VARCHAR2(10),
    KG VARCHAR2(2),
    TYPE VARCHAR2(20),
    USER_ID VARCHAR2(10)
)

CREATE TABLE FOOD
(
    FOOD_ID VARCHAR2(10) PRIMARY KEY,
    FOOD_TYPE VARCHAR2(20),
    CAT_TYPE VARCHAR(30),
    QUANTITY INT
)

CREATE TABLE ERRORS
(
    ERROR_ID VARCHAR2(100) PRIMARY KEY,
    STATUS varchar(30)
)

BEGIN
INSERT INTO FOOD 
VALUES('1','BitScas','LittleCat',1);
INSERT INTO FOOD 
VALUES('2','PeddyBite','MediumCat',1);
INSERT INTO FOOD 
VALUES('3','PurrDigital','BigCat',1);
END;


--Creating sequences
CREATE SEQUENCE log_seq
  MINVALUE 1
  MAXVALUE 999999999
  START WITH 1
  INCREMENT BY 1
  CACHE 20

  
CREATE SEQUENCE user_reg_seq
  MINVALUE 1
  MAXVALUE 999999999
  START WITH 1
  INCREMENT BY 1
  CACHE 20

  --registration
DECLARE
l_users_reg users_reg%ROWTYPE;
l_count NUMBER := 0;
BEGIN

dbms_output.enable();
l_users_reg.email:= 'georgi@abv.bg';
l_users_reg.user_name := 'georgi';
l_users_reg.password := 'password';
l_users_reg.PASSWORD_CONFIRM := 'password';

select count(1)
into l_count
from users_reg
where user_name = l_users_reg.user_name;

if l_count > 0 --if there is more than user wih the same name (the name already exists)
then
dbms_output.put_line('Username exists');
return;
end if;

if l_users_reg.PASSWORD != l_users_reg.PASSWORD_CONFIRM --if the password is not the same as the confirmed password
then
dbms_output.put_line('Your passwords does not match.'); 
return;
end if;

l_users_reg.user_reg_id := 'US_'||user_reg_seq.nextval;
l_users_reg.FNAME :='georgi'; 
l_users_reg.LNAME := 'georgiev';
l_users_reg.user_status := 'U';

l_users_reg.password := 
dbms_crypto.hash(utl_i18n.string_to_raw(l_users_reg.password, 'AL32UTF8'), dbms_crypto.hash_sh1); --this way the password does not show
l_users_reg.PASSWORD_CONFIRM := 
dbms_crypto.hash(utl_i18n.string_to_raw(l_users_reg.password_CONFIRM, 'AL32UTF8'), dbms_crypto.hash_sh1);

insert into users_reg
values l_users_reg;

dbms_output.put_line('Successful user '|| l_users_reg.user_name || ' was created.');

END;

--trigger
CREATE OR REPLACE TRIGGER TR_USERS
AFTER INSERT
   ON users_reg
   FOR EACH ROW
DECLARE
l_users USERS%ROWTYPE;
BEGIN

l_users.user_id := 'us_'||user_reg_seq.nextval;
l_users.USER_NAME := 'GEORGI';
l_users.CASTLE := 'CASTLE1';
l_users.CAT_TYPE := 'LITTLE CAT';
l_users.CATS_NAME := 'KITTY';
l_users.CAT_NUMBER :=1;
l_users.MONEY := 100;
l_users.FOOD := 'BitScas';

INSERT INTO USERS
VALUES l_users;
INSERT INTO USERS_log
VALUES ('LOG_'||log_seq.nextval, l_users.user_id);

END;


select * from USERS
select * from users_reg





--

BEGIN
INSERT INTO ROOMS 
VALUES('Room 1', '10', 10);
INSERT INTO ROOMS 
VALUES('Room 2' ,'30', 30);
END;

INSERT INTO CASTLES 
VALUES('CASTLE1', 1)
INSERT INTO CASTLES 
VALUES('CASTLE2', 1)


--first way
alter table users
add rooms_number int

DECLARE
l_users USERS%ROWTYPE;
l_room_price int :=10;
BEGIN

l_users.user_id := 'us_'||user_reg_seq.nextval;
l_users.CASTLE := 'CASTLE1';
l_users.CAT_TYPE := 'LITTLE CAT';
l_users.CATS_NAME := 'sam';
l_users.CAT_NUMBER :=1;
l_users.rooms_number:=1;
l_users.MONEY := 100;
l_users.FOOD := 'BitScas';

if l_users.money > l_room_price
then l_users.rooms_number := l_users.rooms_number +1;
     l_users.money := l_users.MONEY - l_room_price;

INSERT INTO USERS
VALUES l_users;
end if;
end;

select * from users


--second way
DECLARE 
l_user_money int := 100;
l_room_price int := 10;
l_rooms int :=1;

BEGIN
IF l_user_money > l_room_price
then
l_rooms :=l_rooms+1;
dbms_output.enable();
dbms_output.put_line('You have ' || l_rooms || ' rooms');

END IF;
END;



--

DECLARE
l_users USERS%ROWTYPE;
l_cat_price int :=10;
BEGIN

l_users.user_id := 'us_'||user_reg_seq.nextval;
l_users.CASTLE := 'CASTLE2';
l_users.CAT_TYPE := 'LITTLE CAT';
l_users.CATS_NAME := 'tom';
l_users.CAT_NUMBER :=1;
l_users.rooms_number:=2;
l_users.MONEY := 600;
l_users.FOOD := 'BitScas';

if l_users.money = 0 --if the user does not have money
then 
dbms_output.enable();
dbms_output.put_line('You cant buy the cat because you dont have any money');

elsif l_users.money<l_cat_price --if the user has lower money than needed to buy the cat
then
dbms_output.enable();
dbms_output.put_line('You cant buy the cat because you dont have enough money');

elsif l_users.rooms_number<2 --if the user does not have enough rooms
then
dbms_output.enable();
dbms_output.put_line('You cant buy the cat because you dont have enough space');

elsif l_users.money > l_cat_price and l_users.rooms_number >1
then l_users.cat_number := l_users.cat_number +1; --cats become with 1 more
     l_users.MONEY :=l_users.money-l_cat_price; --money become lower, because the cat has been bought

INSERT INTO USERS
VALUES l_users;
end if;
end;

select * from users


--when the user doe not have any money
DECLARE
l_users USERS%ROWTYPE;
l_cat_price int :=10;
BEGIN

l_users.user_id := 'us_'||user_reg_seq.nextval;
l_users.CASTLE := 'CASTLE2';
l_users.CAT_TYPE := 'LITTLE CAT';
l_users.CATS_NAME := 'tom';
l_users.CAT_NUMBER :=1;
l_users.rooms_number:=2;
l_users.MONEY := 0;
l_users.FOOD := 'BitScas';

if l_users.money = 0
then 
dbms_output.enable();
dbms_output.put_line('You cant buy the cat because you dont have any money');

elsif l_users.money<l_cat_price
then
dbms_output.enable();
dbms_output.put_line('You cant buy the cat because you dont have enough money');

elsif l_users.rooms_number<2
then
dbms_output.enable();
dbms_output.put_line('You cant buy the cat because you dont have enough space');

elsif l_users.money > l_cat_price and l_users.rooms_number >1
then l_users.cat_number := l_users.cat_number +1; 
     l_users.MONEY :=l_users.money-l_cat_price;

INSERT INTO USERS
VALUES l_users;
end if;
end;


select * from users





--
alter table cats 
add food_type varchar2(30)

DECLARE
l_users users%rowtype;
l_cats cats%ROWTYPE;
l_food_price int :=10;
l_food_for_little_cat varchar(30) := 'BitScas';
l_food_for_medium_cat varchar(30) := 'PedyBite';
l_food_for_big_cat varchar(30) := 'PurrDigital';
BEGIN

l_users.user_id := 'us_'||user_reg_seq.nextval;
l_users.CASTLE := 'CASTLE1';
l_users.user_name:= 'ivan';
l_users.CAT_TYPE := 'LITTLE CAT';
l_users.CATs_NAME := 'tom';
l_users.CAT_NUMBER :=1;
l_users.rooms_number:=2;
l_users.MONEY := 600;
l_users.FOOD := 'BitScas';


l_cats.cat_id:='2';
l_cats.user_name:='ivan';
l_cats.CAT_TYPE :='MediumCat';
l_cats.price := 10;

if l_users.money = 0
then 
dbms_output.enable();
dbms_output.put_line('You cant buy the food because you dont have any money');

elsif l_users.money<l_food_price
then
dbms_output.enable();
dbms_output.put_line('You cant buy the foof because you dont have enough money');


elsif l_users.money > l_food_price --if the user has the money
then                               --then we see the type of the cat and set the food 
    if l_cats.CAT_TYPE = 'LittleCat' 
    then l_cats.food_type := l_food_for_little_cat;
    elsif l_cats.CAT_TYPE = 'MediumCat'
    then l_cats.food_type := l_food_for_medium_cat;
    elsif l_cats.CAT_TYPE = 'BigCat'
    then l_cats.food_type := l_food_for_big_cat;
   
    end if;

l_users.MONEY :=l_users.money-l_food_price; --lower the money, because tha cat has been bought

INSERT INTO CATS
VALUES l_cats;

INSERT INTO USERS
VALUES l_users;
end if;
end;

select * from cats




--

alter table cats 
add cat_level int

alter table cats 
add room_id varchar2(30)

select * from rooms

DECLARE
l_users users%rowtype;
l_cats cats%ROWTYPE;
l_rooms rooms%ROWTYPE;
l_food_price int :=10;
l_food_for_little_cat varchar(30) := 'BitScas';
l_food_for_medium_cat varchar(30) := 'PedyBite';
l_food_for_big_cat varchar(30) := 'PurrDigital';
BEGIN

l_users.user_id := 'us_'||user_reg_seq.nextval;
l_users.CASTLE := 'CASTLE1';
l_users.CAT_TYPE := 'LITTLE CAT';
l_users.CATS_NAME := 'tom';
l_users.CAT_NUMBER :=1;
l_users.rooms_number:=2;
l_users.MONEY := 600;
l_users.FOOD := 'BitScas';


l_cats.cat_id:='4';
l_cats.CAT_TYPE :='BigCat';
l_cats.price := 20;
l_cats.room_id := 1;
l_cats.cat_level:=0;

if l_users.money = 0
then 
dbms_output.enable();
dbms_output.put_line('You cant buy the food because you dont have any money');

elsif l_users.money<l_food_price
then
dbms_output.enable();
dbms_output.put_line('You cant buy the food because you dont have enough money');


elsif l_users.money > l_food_price 
then
    if l_cats.CAT_TYPE = 'LittleCat'
    then l_cats.food_type := l_food_for_little_cat;
    elsif l_cats.CAT_TYPE = 'MediumCat'
    then l_cats.food_type := l_food_for_medium_cat;
    elsif l_cats.CAT_TYPE = 'BigCat'
    then l_cats.food_type := l_food_for_big_cat;
   
    end if;

l_users.MONEY :=l_users.money-l_food_price;
l_cats.cat_level := l_cats.cat_level+1;


INSERT INTO CATS
VALUES l_cats;

INSERT INTO USERS
VALUES l_users;
end if;
end;

update cats 
set cat_type = 'LittleCat'
where cat_level between 0 and 10 --the level

update cats 
set cat_type = 'MediumCat'
where cat_level between 10 and 25

update cats 
set cat_type = 'BigCat'
where cat_level >25

select * from cats




--
ALTER TABLE CATS
ADD USER_ID VARCHAR2(100)

--more inserts
INSERT INTO CATS
VALUES ('10', 'LittleCat', 10, 'stoqn', 'PeddyBite', 'Room 1', 40, '2')
UPDATE CATS
SET CAT_TYPE = 'BigCat'
WHERE cat_level>25
UPDATE CATS
SET FOOD_TYPE = 'PurrDigital'
WHERE cat_level>25

INSERT INTO USERS 
VALUES('2', 'STOQN', 'CASTLE1', 'LITTLECAT', 'Sam', '1', 100, 'PeddyBite', 1)


CREATE VIEW REPORT AS 
SELECT CATS.CAT_ID , USERS.USER_NAME
FROM CATS JOIN USERS
ON CATS.USER_ID = USERS.USER_ID

CREATE VIEW REPORT2 AS
SELECT CAT_ID, USER_NAME, FOOD_TYPE, CAT_LEVEL
FROM CATS

CREATE VIEW REPORT3 AS 
SELECT * FROM USERS
ORDER BY MONEY ASC --sorting by money, ascending

CREATE VIEW REPORT4 AS 
SELECT * FROM USERS
ORDER BY CAT_NUMBER DESC --sorting by number of cats, descending

