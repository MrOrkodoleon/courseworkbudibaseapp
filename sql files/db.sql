BEGIN;


CREATE TABLE IF NOT EXISTS public.faults
(
    fault_code text COLLATE pg_catalog."default" NOT NULL,
    title text COLLATE pg_catalog."default",
    price_to_fix numeric(10, 2),
    CONSTRAINT faults_pkey PRIMARY KEY (fault_code)
);

CREATE TABLE IF NOT EXISTS public.parts
(
    fault_code text COLLATE pg_catalog."default",
    title text COLLATE pg_catalog."default",
    price numeric(10, 2),
    amount integer,
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    vehicle_ids integer[],
    CONSTRAINT parts_pkey PRIMARY KEY (id),
    CONSTRAINT parts_fault_code_key UNIQUE (fault_code)
);

CREATE TABLE IF NOT EXISTS public.staff
(
    ssn character(11) COLLATE pg_catalog."default" NOT NULL,
    last_name text COLLATE pg_catalog."C" NOT NULL DEFAULT 'Doe'::text,
    first_name text COLLATE pg_catalog."default" NOT NULL DEFAULT 'John'::text,
    middle_name text COLLATE pg_catalog."default",
    team_id integer,
    workshop_id integer,
    CONSTRAINT staff_pkey PRIMARY KEY (ssn)
);

CREATE TABLE IF NOT EXISTS public.vehicle_repair
(
    vehicle_id integer NOT NULL,
    fault_code text COLLATE pg_catalog."default" NOT NULL,
    admission_date date NOT NULL,
    end_of_repair_date date,
    team_id integer NOT NULL,
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    CONSTRAINT vehicle_repair_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.vehicles
(
    vehicle_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    vin character(17) COLLATE pg_catalog."default" NOT NULL,
    engine_number text COLLATE pg_catalog."default",
    owner_lastname text COLLATE pg_catalog."C" NOT NULL DEFAULT 'Doe'::text,
    owner_firstname text COLLATE pg_catalog."default" NOT NULL DEFAULT 'John'::text,
    owner_middlename text COLLATE pg_catalog."default",
    CONSTRAINT vehicles_pkey PRIMARY KEY (vehicle_id),
    CONSTRAINT "vehicles_VIN_key" UNIQUE (vin)
);

CREATE TABLE IF NOT EXISTS public.workshop_teams
(
    team_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    title text COLLATE pg_catalog."default",
    workshop_id integer,
    CONSTRAINT workshop_teams_pkey PRIMARY KEY (team_id)
);

CREATE TABLE IF NOT EXISTS public.workshops
(
    workshop_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    title text COLLATE pg_catalog."default",
    CONSTRAINT workshops_pkey PRIMARY KEY (workshop_id)
);

ALTER TABLE IF EXISTS public.parts
    ADD CONSTRAINT parts_fault_code_fkey FOREIGN KEY (fault_code)
    REFERENCES public.faults (fault_code) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE RESTRICT
    NOT VALID;
CREATE INDEX IF NOT EXISTS parts_fault_code_key
    ON public.parts(fault_code);


ALTER TABLE IF EXISTS public.staff
    ADD CONSTRAINT staff_team_id_fkey FOREIGN KEY (team_id)
    REFERENCES public.workshop_teams (team_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE SET NULL
    NOT VALID;


ALTER TABLE IF EXISTS public.staff
    ADD CONSTRAINT staff_workshop_id_fkey FOREIGN KEY (workshop_id)
    REFERENCES public.workshops (workshop_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.vehicle_repair
    ADD CONSTRAINT "vehicle repair_fault_code_fkey" FOREIGN KEY (fault_code)
    REFERENCES public.faults (fault_code) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE RESTRICT
    NOT VALID;


ALTER TABLE IF EXISTS public.vehicle_repair
    ADD CONSTRAINT "vehicle repair_team_id_fkey" FOREIGN KEY (team_id)
    REFERENCES public.workshop_teams (team_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE SET NULL
    NOT VALID;


ALTER TABLE IF EXISTS public.vehicle_repair
    ADD CONSTRAINT "vehicle repair_vehicle_id_fkey" FOREIGN KEY (vehicle_id)
    REFERENCES public.vehicles (vehicle_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE RESTRICT
    NOT VALID;


ALTER TABLE IF EXISTS public.workshop_teams
    ADD CONSTRAINT workshop_teams_workshop_id_fkey FOREIGN KEY (workshop_id)
    REFERENCES public.workshops (workshop_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

END;