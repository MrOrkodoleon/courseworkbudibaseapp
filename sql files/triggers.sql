begin;

create or REPLACE function validate_date() 
RETURNS TRIGGER as '
BEGIN
	IF new.end_of_repair_date is not null and new.end_of_repair_date<new.admission_date THEN
		raise exception ''Repair end date should be after admission date %'', new.id;
	END IF;
	RETURN new;
END
'LANGUAGE plpgsql;

end;

begin;
create or replace TRIGGER trigger_validate_date
after insert or update on vehicle_repair
for each row EXECUTE function validate_date();
end;

--
begin;

CREATE OR REPLACE FUNCTION check_parts_amount() 
RETURNS TRIGGER AS '
BEGIN
    IF NEW.amount < 0 THEN
        RAISE EXCEPTION ''Amount cannot be negative'';
    END IF;
    RETURN NEW;
END
' LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_parts_amount
BEFORE INSERT OR UPDATE ON parts
FOR EACH ROW EXECUTE FUNCTION check_parts_amount();
end;

--
BEGIN;

CREATE or REPLACE FUNCTION cascade_delete_vehicle_repair()
RETURNS trigger as '
BEGIN
	delete from vehicle_repair where vehicle_id = old.vehicle_id;
	return old;
end
' LANGUAGE plpgsql;

create TRIGGER trigger_cascade_delete_vehicle_repair
after delete on vehicles for each row
execute function cascade_delete_vehicle_repair();

end;
--
begin;
CREATE OR REPLACE FUNCTION check_vehicle_id_exist()
RETURNS TRIGGER AS '
DECLARE
    id integer;
BEGIN
	foreach id IN ARRAY NEW.vehicle_ids
	loop
		IF NOT EXISTS (SELECT 1 FROM vehicles WHERE id = any(new.vehicle_ids)) THEN
    		RAISE EXCEPTION ''Vehicle ID % does not exist in vehicles table'', id;
		END IF;
	end loop;
    RETURN NEW;
END;
' LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_vehicle_id_exist
BEFORE INSERT OR UPDATE ON parts
FOR EACH ROW EXECUTE FUNCTION check_vehicle_id_exist();

update parts set vehicle_ids = array[7,42] where fault_code='B1231';
select * from parts where vehicle_ids is not null;
commit;
rollback;