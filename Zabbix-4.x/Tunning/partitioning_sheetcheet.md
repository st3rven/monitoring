# Partitioning Cheet Sheet
This cheet sheet is for partitioning postgresql tables.

**Note**: Please first [read the full documentation of the process](#Partitioning_Postgresql_11.md).

**Requirement:**
- `PG_PARTMAN` extension

### partition the tables `history_*` y `trends_*`


    -- history
    CREATE TABLE public.history
    (
        itemid bigint NOT NULL,
        clock integer NOT NULL DEFAULT 0,
        value numeric(16,4) NOT NULL DEFAULT 0.0000,
        ns integer NOT NULL DEFAULT 0
    ) PARTITION BY RANGE (clock);
    
    CREATE INDEX history_1 ON public.history USING btree (itemid, clock);
    
    -- history_log
    CREATE TABLE public.history_log
    (
        itemid bigint NOT NULL,
        clock integer NOT NULL DEFAULT 0,
        "timestamp" integer NOT NULL DEFAULT 0,
        source character varying(64) COLLATE pg_catalog."default" NOT NULL DEFAULT ''::character varying,
        severity integer NOT NULL DEFAULT 0,
        value text COLLATE pg_catalog."default" NOT NULL DEFAULT ''::text,
        logeventid integer NOT NULL DEFAULT 0,
        ns integer NOT NULL DEFAULT 0
    ) PARTITION BY RANGE (clock);
    
    CREATE INDEX history_log_1 ON public.history_log USING btree (itemid, clock);
    
    -- history_str
    CREATE TABLE public.history_str
    (
        itemid bigint NOT NULL,
        clock integer NOT NULL DEFAULT 0,
        value character varying(255) COLLATE pg_catalog."default" NOT NULL DEFAULT ''::character varying,
        ns integer NOT NULL DEFAULT 0
    ) PARTITION BY RANGE (clock);
    
    CREATE INDEX history_str_1 ON public.history_str USING btree (itemid, clock);
    
    -- history_text
    CREATE TABLE public.history_text
    (
        itemid bigint NOT NULL,
        clock integer NOT NULL DEFAULT 0,
        value text COLLATE pg_catalog."default" NOT NULL DEFAULT ''::text,
        ns integer NOT NULL DEFAULT 0
    ) PARTITION BY RANGE (clock);
    
    CREATE INDEX history_text_1 ON public.history_text USING btree (itemid, clock);
    
    -- history_uint
    CREATE TABLE public.history_uint
    (
        itemid bigint NOT NULL,
        clock integer NOT NULL DEFAULT 0,
        value numeric(20,0) NOT NULL DEFAULT (0)::numeric,
        ns integer NOT NULL DEFAULT 0
    ) PARTITION BY RANGE (clock);
    
    CREATE INDEX history_uint_1 ON public.history_uint USING btree (itemid, clock);
    
    -- trends
    CREATE TABLE public.trends
    (
        itemid bigint NOT NULL,
        clock integer NOT NULL DEFAULT 0,
        num integer NOT NULL DEFAULT 0,
        value_min numeric(16,4) NOT NULL DEFAULT 0.0000,
        value_avg numeric(16,4) NOT NULL DEFAULT 0.0000,
        value_max numeric(16,4) NOT NULL DEFAULT 0.0000,
        CONSTRAINT trends_pkey PRIMARY KEY (itemid, clock)
    ) PARTITION BY RANGE (clock);
    
    -- trends_uint
    CREATE TABLE public.trends_uint
    (
        itemid bigint NOT NULL,
        clock integer NOT NULL DEFAULT 0,
        num integer NOT NULL DEFAULT 0,
        value_min numeric(20,0) NOT NULL DEFAULT (0)::numeric,
        value_avg numeric(20,0) NOT NULL DEFAULT (0)::numeric,
        value_max numeric(20,0) NOT NULL DEFAULT (0)::numeric,
        CONSTRAINT trends_uint_pkey PRIMARY KEY (itemid, clock)
    ) PARTITION BY RANGE (clock);

### Partitioning Schema

    CREATE SCHEMA partman;
    CREATE EXTENSION pg_partman schema partman;

### Creation of partitioning tables

    SELECT partman.create_parent('public.history', 'clock', 'native', 'daily', null, 7, 'on', null, true, 'seconds');
    SELECT partman.create_parent('public.history_uint', 'clock', 'native', 'daily', null, 7, 'on', null, true, 'seconds');
    SELECT partman.create_parent('public.history_str', 'clock', 'native', 'daily', null, 7, 'on', null, true, 'seconds');
    SELECT partman.create_parent('public.history_text', 'clock', 'native', 'daily', null, 7, 'on', null, true, 'seconds');
    SELECT partman.create_parent('public.history_log', 'clock', 'native', 'daily', null, 7, 'on', null, true, 'seconds');
    SELECT partman.create_parent('public.trends', 'clock', 'native', 'monthly', null, 12, 'on', null, true, 'seconds');
    SELECT partman.create_parent('public.trends_uint', 'clock', 'native', 'monthly', null, 12, 'on', null, true, 'seconds');

### Table partitioning configuration

    UPDATE partman.part_config SET retention_keep_table = false, retention = '15 day'
    WHERE parent_table = 'public.history';
    UPDATE partman.part_config SET retention_keep_table = false, retention = '15 day'
    WHERE parent_table = 'public.history_uint';
    UPDATE partman.part_config SET retention_keep_table = false, retention = '15 day'
    WHERE parent_table = 'public.history_str';
    UPDATE partman.part_config SET retention_keep_table = false, retention = '15 day'
    WHERE parent_table = 'public.history_text';
    UPDATE partman.part_config SET retention_keep_table = false, retention = '15 day'
    WHERE parent_table = 'public.history_log';
    UPDATE partman.part_config SET retention_keep_table = false, retention = '12 month'
    WHERE parent_table = 'public.trends';
    UPDATE partman.part_config SET retention_keep_table = false, retention = '12 month'
    WHERE parent_table = 'public.trends_uint';

### Defined partitioning rule execution.

    SELECT partman.run_maintenance('public.history');
    SELECT partman.run_maintenance('public.history_uint');
    SELECT partman.run_maintenance('public.history_str');
    SELECT partman.run_maintenance('public.history_text');
    SELECT partman.run_maintenance('public.history_log');
    SELECT partman.run_maintenance('public.trends');
    SELECT partman.run_maintenance('public.trends_uint');
