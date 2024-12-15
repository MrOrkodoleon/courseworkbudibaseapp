begin;
create or replace view parts_price as
select title, price from parts
order by title;
end;

select * from parts_price;

begin;
create view staff_working_places
as 
select s.first_name, s.middle_name, s.last_name, t.title as team_name, w.title as workshop_name
from workshops w join workshop_teams t on t.workshop_id = w.workshop_id join staff s on s.team_id = t.team_id
order by s.last_name;
select * from staff_working_places;
select s.first_name, s.middle_name, s.last_name, t.title as team_name, w.title as workshop_name
from workshops w join workshop_teams t on t.workshop_id = w.workshop_id join staff s on s.team_id = t.team_id
order by s.last_name;
update workshop_teams set workshop_id = 1 where team_id = 1;
end;

BEGIN;

create or REPLACE view repair_cost
as 
select v.vin, sum(faults.price_to_fix+parts.price) as repair_cost
from vehicles v join vehicle_repair ON vehicle_repair.vehicle_id = v.vehicle_id join faults ON faults.fault_code = vehicle_repair.fault_code join parts on parts.fault_code = faults.fault_code
group by v.vin
having sum (faults.price_to_fix+parts.price)>5000;

select * from repair_cost_above_5000;
alter view repair_cost RENAME to repair_cost_above_5000;
end;