-- Keren Cohen 206645939

--question 1
SELECT *
FROM
    CUSTOMER c
WHERE
    c.id >
    (
        SELECT id
        FROM customer
        WHERE state ="TX"
    );
/*
id          fname       lname       address         city        state       zip         phone       company_name
----------  ----------  ----------  --------------  ----------  ----------  ----------  ----------  ------------
333         Harry       Jones       25 Software Rd  San Jose    CA          94020       4085556689  Bits & Bytes
440         Marie       Curie       210 Helping Ha  LeCroix     MA          02140       6175558875  Wind & Rain
441         Elizibeth   Bordon      87 Grinding St  New Bedfor  MA          01801       5085558879  Blades & thi
444         Len         Manager     23 Network Way  Dallas      TX          76552       2145552685  Let's get Co
550         Tony        Antolini    6678 Sliver Ro  Fargo       ND          60500       7015553259  Flat Landers
551         Tom         Cruz        789 Far Away L  Eugene      OR          98524       5035557462  Raceway Engi
552         Janice      O'Toole     654 West Hill   Nashville   TN          37320       6155553689  Greensleeves
553         Stevie      Nickolas    77 Recordings   Tacoma      WA          96521       5095551695  It's a Hit!
555         Philipe     Fernandez   99 Main Street  Los Angele  CA          90205       2135554457  Quaker Fashi
661         Jennifer    Stutzman    3 Back Pages L  Missola     IL          60505       7085556857  Stutzman Adv
665         William     Thompson    91 Washington   Manchester  NY          11700       5165552549  The Apple Fa    The Apple Farm
*/

-- question 2
SELECT fname, lname
FROM customer c
WHERE c.address like '%x%';
/*
fname       lname
----------  ---------------
Moe         Bilhome
Sheng       Chen
Lewis N.    Clark
Jack        Johnson
*/

--question 3
SELECT DISTINCT c.id, fname, lname
FROM customer c join sales_order s on (c.id = s.cust_id)
WHERE c.id not in (
    SELECT DISTINCT cust_id
    FROM sales_order
    WHERE order_date not like '1994%'
);
/*
id          fname            lname
----------  ---------------  --------------------
186         Thao             Tenorio
*/

---question 4 
 SELECT DISTINCT p.name, p.description
 FROM customer c JOIN sales_order s on c.id =s.cust_id
 LEFT JOIN sales_order_items st on s.id = st.id 
 LEFT JOIN product p on p.id = st.prod_id
 WHERE fname LIKE 'K%'
 ORDER BY p.name asc;
 /*
 name        description
----------  ---------------
Baseball C  Cotton Cap
Baseball C  Wool cap
Shorts      Cotton Shorts
Sweatshirt  Hooded Sweatshi
Sweatshirt  Zipped Sweatshi
Tee Shirt   Crew Neck
Tee Shirt   Tank Top
Tee Shirt   V-neck
Visor       Cloth Visor
Visor       Plastic Visor
 */  

---question 5 
SELECT c.id, c.fname, c.lname
FROM customer c LEFT JOIN sales_order s on c.id = s.cust_id
WHERE s.cust_id is NULL;
/*
id          fname            lname
----------  ---------------  --------------------
220         Lewis N.         Clark
221         Jack             Johnson
222         Jane             Doe
330         John             Glenn
331         Dominic          Johansen
332         Stanley          Jue
333         Harry            Jones
440         Marie            Curie
441         Elizibeth        Bordon
444         Len              Manager
550         Tony             Antolini
551         Tom              Cruz
552         Janice           O'Toole
553         Stevie           Nickolas
555         Philipe          Fernandez
661         Jennifer         Stutzman
665         William          Thompson
*/

--question 6 
SELECT c.id, c.fname, c.lname
FROM customer c
WHERE c.id NOT IN (
    SELECT DISTINCT s.cust_id
    FROM sales_order s join sales_order_items ON (s.id = sales_order_items.id) 
    join product p ON (sales_order_items.prod_id = p.id)
    WHERE UPPER(p.name) LIKE '%SHIRT%'
)
AND c.id IN (
    SELECT DISTINCT s.cust_id
    FROM sales_order s
);
/*
id          fname            lname
----------  ---------------  --------------------
141         Peter            Pyper
152         Davey            Jones
154         Marvin           Smythe
160         Clara            Nette
194         Jen-Chang        Chin
*/

--question 7
SELECT DISTINCT c.id, c.fname, c.lname
FROM customer c
WHERE c.id IN (
    SELECT s.cust_id
    FROM sales_order s
    JOIN customer c ON c.id = s.cust_id
    JOIN employee em ON em.emp_id = s.sales_rep
    WHERE em.emp_id = 299 AND NOT EXISTS (
        SELECT 1
        FROM sales_order
        WHERE cust_id = c.id AND sales_rep != 299
    )
);
/*
id          fname       lname
----------  ----------  ----------
141         Peter       Pyper
*/

--question 8
SELECT d.dept_name, d.dept_id, AVG(em.salary) AS avg_salary, COUNT(em.emp_id) AS emp_count
FROM department d
JOIN employee em ON d.dept_id = em.dept_id
GROUP BY d.dept_id, d.dept_name;
/*
dept_name   dept_id     avg_salary        emp_count
----------  ----------  ----------------  ----------
R & D       100         58736.2813636364  22
Sales       200         48390.9473684211  19
Finance     300         59500.0           9
Marketing   400         43640.671875      16
Shipping    500         33752.2           9
*/

--question 9
SELECT e.emp_id, e.emp_fname, e.emp_lname, COUNT(s.id) AS order_count
FROM employee e
LEFT JOIN sales_order s ON e.emp_id = s.sales_rep
GROUP BY e.emp_id;
/*
emp_id      emp_fname   emp_lname   order_count
----------  ----------  ----------  -----------
102         Fran        Whitney     0
105         Matthew     Cobb        0
129         Philip      Chin        57
148         Julie       Jordan      0
160         Robert      Breault     0
184         Melissa     Espinoza    0
191         Jeannette   Bertrand    0
195         Marc        Dill        50
207         Jane        Francis     0
243         Natasha     Shishov     0
247         Kurt        Driscoll    0
249         Rodrigo     Guevara     0
266         Ram         Gowda       0
278         Terry       Melkisetia  0
299         Rollin      Overbey     115
316         Lynn        Pastor      0
318         John        Crow        0
390         Jo Ann      Davidson    0
409         Bruce       Weaver      0
445         Kim         Lull        0
453         Andrew      Rabkin      0
467         James       Klobucher   56
479         Linda       Siperstein  0
501         David       Scott       0
529         Dorothy     Sullivan    0
582         Peter       Samuels     0
586         James       Coleman     0
591         Irene       Barletta    0
604         Albert      Wang        0
641         Thomas      Powell      0
667         Mary        Garcia      53
690         Kathleen    Poitras     52
703         Jose        Martinez    0
750         Jane        Braun       0
757         Denis       Higgins     0
839         Dean        Marshall    0
856         Samuel      Singer      55
862         John        Sheffield   0
868         Felicia     Kuo         0
879         Kristen     Coe         0
888         Doug        Charlton    0
902         Moira       Kelly       47
913         Ken         Martel      0
921         Charles     Crowley     0
930         Ann         Taylor      0
949         Pamela      Savarino    53
958         Thomas      Sisson      0
992         Joyce       Butterfiel  0
1013        Joseph      Barker      0
1021        Paul        Sterling    0
1039        Shih Lin    Chao        0
1062        Barbara     Blaikie     0
1090        Susan       Smith       0
1101        Mark        Preston     0
1142        Alison      Clark       57
1157        Hing        Soo         0
1162        Kevin       Goggin      0
1191        Matthew     Bucceri     0
1250        Emilio      Diaz        0
1293        Mary Anne   Shea        0
1336        Janet       Bigelow     0
1390        Jennifer    Litton      0
1446        Caroline    Yeung       0
1483        John        Letiecq     0
1507        Ruth        Wetherby    0
1570        Anthony     Rebeiro     0
1576        Scott       Evans       0
1596        Catherine   Pickett     53
1607        Mark        Morris      0
1615        Sheila      Romero      0
1643        Elizabeth   Lambert     0
1658        Michael     Lynch       0
1684        Janet       Hildebrand  0
1740        Robert      Nielsen     0
1751        Alex        Ahmed       0
*/

--question 10
SELECT MAX(s.order_date)
FROM sales_order s;
/*
MAX(s.order_date)
-----------------
1994-07-23
*/

--question 11
SELECT c.state
FROM customer c 
GROUP BY c.state 
HAVING COUNT(c.id) = (
    SELECT MAX(customer_count)
    FROM (
        SELECT COUNT(id) AS customer_count
        FROM customer
        GROUP BY state
    )
);
/*
state
----------
NY
*/

--question 12
SELECT DISTINCT c.id, c.fname, c.lname, count(s.id) as amount
FROM customer c
JOIN sales_order s ON c.id = s.cust_id
JOIN employee em ON em.emp_id = s.sales_rep
WHERE em.emp_id = 129
GROUP BY c.id;
/*
id          fname       lname       order_amount
----------  ----------  ----------  ------------
101         Michaels    Devlin      1
103         Erin        Niedringha  1
104         Meghan      Mason       2
107         Kelly       Colburn     1
110         Michael     Agliori     1
111         Dylan       Ricci       1
116         Brian       Gugliuzza   1
117         Meredith    Morgan      1
119         Tomm        Smith       1
121         Pete        Elkins      2
122         Al          Dente       1
126         Sam         Ovar        1
127         Mary        Lamm        1
128         Hardy       Mums        1
131         Daljit      Sinnot      2
132         Marilyn     King        1
136         Tommie      Wooten      1
137         Polly       Morfek      1
138         Regus       Patoff      1
143         Peter       Piper       1
144         Fangmei     Wan         1
149         Hans        Uhnfitte    1
155         Milo        Phipps      1
157         William     Watcom      4
162         Melba       Toste       1
167         Nicklas     Cara        1
168         Almen       de Joie     2
170         Manh        Neubauer    2
173         Grover      Pendelton   1
178         Suresh      Naidu       1
179         Marsha      Nguyen      1
180         Edith       Peros       1
182         Leilani     Gardner     1
184         Anoush      Serafina    1
189         Herbert     Berejiklia  1
190         Randy       Arlington   1
191         Marta       Richards    1
194         Jen-Chang   Chin        1
197         Maio        Chermak     1
198         Sheng       Chen        1
199         Ella        Mentary     2
201         Amit        Singh       2
202         Bubba       Murphy      2
204         Robert      Spaid       2
205         Elmo        Smythe      1
*/

--question 13 
CREATE VIEW T AS
SELECT s.id, SUM(p.unit_price * st.quantity) AS sales_sum, s.cust_id
FROM sales_order s
LEFT JOIN sales_order_items st ON st.id = s.id
LEFT JOIN product p ON st.prod_id = p.id
GROUP BY s.id;

SELECT SUM(sales_sum)
FROM T
WHERE cust_id = 101;
/*
SUM(sales_sum)
--------------
5808
*/

--question 14
CREATE VIEW Employee_Age 
AS SELECT emp_id, emp_fname, emp_lname, birth_date, DATE('now') - birth_date AS age, dept_id
FROM employee;

SELECT avg(age) 
FROM Employee_Age
group by dept_id;
/*
avg(age)
----------------
67.2727272727273
65.2105263157895
68.5555555555556
68.25
61.6666666666667
*/
--question 15
CREATE TABLE manufacturer(id integer,
						  name_manufacturer char(100),
						  address char(100),
						  balance integer,
						  primary key(id));

--question 16
insert into manufacturer
values('0', 'DANIELA', 'ISRAEL HOLON', 14000);
insert into manufacturer
values('1', 'ALDO', 'NEW YORK CITY', 1000000);
insert into manufacturer
values('2', 'COOKIES', 'JAFFA', 30);

SELECT *
FROM manufacturer;
/*
id          name_manufacturer  address       balance
----------  -----------------  ------------  ----------
0           DANIELA            ISRAEL HOLON  14000
1           ALDO               NEW YORK CIT  1000000
2           COOKIES            JAFFA         30
*/

--question 17
SELECT 'Keren', 'Cohen', 206645939;
/*
'Keren'     'Cohen'     206645939
----------  ----------  ----------
Keren       Cohen       206645939
*/


const paymentMethodParameters = {
  paymentIntent: 'pi_123456789', // The ID of the PaymentIntent created on your backend
  description: 'Payment for XYZ', // A description for the payment
  capture_method: 'manual', // The capture method for the payment, set to 'manual' for delayed capture
  confirmation_method: 'manual', // The confirmation method for the payment, set to 'manual' for delayed confirmation
  setup_future_usage: 'on_session', // Indicates when this PaymentIntent can be confirmed, set to 'on_session' for immediate confirmation
  // Additional parameters as needed based on your integration
};

