drop database if exists graph;
create database graph;
use graph;

create table node (
 node_id int primary key,
 type varchar(20)
 );
 
 create table edge (
 edge_id int primary key,
  in_node int,
  out_node int,
  type varchar(20)
  );
  
create table node_props (
  node_id int,
  propkey varchar(20),
  string_value varchar(100),
  num_value double
  );
  
 
 insert into node values 
 (1,'Person'),
 (2,'Person'),
 (3,'Person'),
 (4,'Person'),
 (5,'Person'),
 (6,'Book'),
 (7,'Book'),
 (8,'Book'),
 (9,'Book');
 
 insert into node_props values
 (1, 'name', 'Emily', null),
 (2, 'name', 'Spencer', null),
 (3, 'name', 'Brendan', null),
 (4, 'name', 'Trevor', null),
 (5, 'name', 'Paxton', null),
 (6, 'title', 'Cosmos', null),
 (6, 'price', null, 17.00),
 (7, 'title', 'Database Design', null),
 (7, 'price', null, 195.00),
 (8, 'title', 'The Life of Cronkite', null),
 (8, 'price', null, 29.95),
 (9, 'title', 'DNA and you', null),
 (9, 'price', null, 11.50);
 
 insert into edge values
 (1, 1, 7, 'bought'),
 (2, 2, 6, 'bought'),
 (3, 2, 7, 'bought'),
 (4, 3, 7, 'bought'),
 (5, 3, 9, 'bought'),
 (6, 4, 6, 'bought'),
 (7, 4, 7, 'bought'), 
 (8, 5, 7, 'bought'),
 (9, 5, 8, 'bought'),
 (10, 1,2,'knows'),
 (11, 2, 1, 'knows'),
 (12, 2, 3, 'knows');
 
 select * from edge;
 select * from node;
 select * from node_props;
 
 
-- a. what is the sum of all book prices?
select sum(num_value)
from node_props;

-- Output:
-- 253.45



-- b. Who does spencer know? Give just their names.
select distinct p.string_value
from node_props p
left join edge e on e.out_node = p.node_id
where e.in_node = (select node_id from node_props where string_value = 'Spencer') and e.type = 'knows';

-- Output:
-- Emily
-- Brendan



-- c. What books did Spencer buy? Give title and price.
select distinct p.string_value
from node_props p
left join edge e on e.out_node = p.node_id
where e.in_node = (select node_id from node_props where string_value = 'Spencer') and e.type = 'bought' and p.propkey = 'title';

-- Output
-- Emily
-- Brendan



-- d. Who knows each other? Give just a pair of names.
select p1.string_value as person, p2.string_value as knows
from node_props p1
join edge e on e.in_node = p1.node_id
join node_props p2 on e.out_node = p2.node_id
where e.type = 'knows';

-- Output
-- Spencer	Emily
-- Emily	Spencer
-- Spencer	Brendan



-- e. Demonstrate a simple recommendation engine by answering the following
-- question with a SQL query:
-- What books were purchased by people who Spencer knows? 
-- Exclude books that Spencer already owns. Warning: The algorithm we
-- are using to make recommendations is conceptually simple, but you may find
-- that your SQL query is rather complicated. This is why we need graph databases!
select p.string_value
from node_props p
join edge e on (e.out_node = p.node_id)
where e.type = 'bought' and p.propkey = 'title' and e.in_node in
	(select distinct p.node_id
	from node_props p
	left join edge e on e.out_node = p.node_id
	where e.in_node = (select node_id from node_props where string_value = 'Spencer') and e.type = 'knows')
    
	and p.node_id not in
    (select distinct p.node_id
	from node_props p
	left join edge e on e.out_node = p.node_id
	where e.in_node = (select node_id from node_props where string_value = 'Spencer') and e.type = 'bought' and p.propkey = 'title');

-- Output:
-- DNA and you

