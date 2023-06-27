--
-- This script contains DDL statements to upgrade a database schema to
-- reflect changes to the model.  This file should only be used to
-- upgrade from the last formal release version to the current code base.
--

CONNECT TO iiq;

create unique index uk_c7ccr73vpnee48igqv6w9spmp on identityiq.spt_plugin (file_id);

-- Add Request.live column
alter table identityiq.spt_request add live smallint default 0;
update identityiq.spt_request set live = 0;

--
-- New Attachment Table
--
create table identityiq.spt_attachment (
   id varchar(32) not null,
    created bigint,
    modified bigint,
    assigned_scope_path varchar(450),
    name varchar(256),
    description varchar(256),
    content blob(2147483647),
    owner varchar(32),
    assigned_scope varchar(32),
    primary key (id)
) IN identityiq_ts;

create table identityiq.spt_identity_req_item_attach (
   identity_request_item_id varchar(32) not null,
    idx integer not null,
    attachment_id varchar(32) not null,
    primary key (identity_request_item_id, idx)
) IN identityiq_ts;

alter table identityiq.spt_attachment
   add constraint FKbyb94bn214vosuh3a9cr6ydi3
   foreign key (owner)
   references identityiq.spt_identity;

create index identityiq.FKbyb94bn214vosuh3a9cr6ydi3 on identityiq.spt_attachment (owner);

alter table identityiq.spt_attachment
   add constraint FKn1iv5d2bgun4hh7gmnyqyl0u7
   foreign key (assigned_scope)
   references identityiq.spt_scope;

create index identityiq.FKn1iv5d2bgun4hh7gmnyqyl0u7 on identityiq.spt_attachment (assigned_scope);

create index identityiq.SPT_IDXE758C3D7FFA1CC82 on identityiq.spt_attachment (assigned_scope_path);

alter table identityiq.spt_identity_req_item_attach
   add constraint FK9j07eg4emep4vaseaa779fatl
   foreign key (attachment_id)
   references identityiq.spt_attachment;

create index identityiq.FK9j07eg4emep4vaseaa779fatl on identityiq.spt_identity_req_item_attach (attachment_id);

alter table identityiq.spt_identity_req_item_attach
   add constraint FK32c6p6xsumvu31gciybgj93f8
   foreign key (identity_request_item_id)
   references identityiq.spt_identity_request_item;

create index identityiq.FK32c6p6xsumvu31gciybgj93f8 on identityiq.spt_identity_req_item_attach (identity_request_item_id);

--
-- Add client and server hosts to audit events
--

alter table identityiq.spt_audit_event add column client_host varchar(128);
alter table identityiq.spt_audit_event add column server_host varchar(128);

--
-- Add a description attribute to application schemas
--
alter table identityiq.spt_application_schema add column description_attribute varchar(255);

--
-- IdentityAI recommendation schema changes
--
create table identityiq.spt_recommender_definition (
  id varchar(32) not null,
  created bigint,
  modified bigint,
  name varchar(128) not null,
  attributes clob(100000000),
  name_ci generated always as (upper(name)),
  primary key (id)
) IN identityiq_ts;

alter table identityiq.spt_recommender_definition
add constraint uk_ekuvq6a1uhwkxb7fofir077xv unique (name);

create index identityiq.spt_recommender_definition_nam on identityiq.spt_recommender_definition (name_ci);
alter table identityiq.spt_certification_item add column recommend_value varchar(100);

create table identityiq.spt_module (
  id varchar(32) not null,
  created bigint,
  modified bigint,
  name varchar(128) not null,
  description varchar(512),
  attributes clob(100000000),
  name_ci generated always as (upper(name)),
  primary key (id)
) IN identityiq_ts;

alter table identityiq.spt_module
add constraint uk_bebq8nsflsucu90sph68pf43r unique (name);

create index identityiq.spt_module_name on identityiq.spt_module (name_ci);

--
-- Access Request notification needed column addition
--
alter table identityiq.spt_request add notification_needed smallint default 0;
update identityiq.spt_request set notification_needed = 0;
create index identityiq.spt_request_notif_needed on identityiq.spt_request (notification_needed);

--
-- Change some indexes to case insensitive indexes
--
set integrity for identityiq.spt_certification off;
alter table identityiq.spt_certification add column phase_ci generated always as (upper(phase));

alter table identityiq.spt_certification add column certification_definition_id_ci generated always as (upper(certification_definition_id));
alter table identityiq.spt_certification add column trigger_id_ci generated always as (upper(trigger_id));
alter table identityiq.spt_certification add column task_schedule_id_ci generated always as (upper(task_schedule_id));
alter table identityiq.spt_certification add column type_ci generated always as (upper(type));
alter table identityiq.spt_certification add column group_definition_name_ci generated always as (upper(group_definition_name));
alter table identityiq.spt_certification add column group_definition_id_ci generated always as (upper(group_definition_id));
alter table identityiq.spt_certification add column manager_ci generated always as (upper(manager));
alter table identityiq.spt_certification add column application_id_ci generated always as (upper(application_id));
alter table identityiq.spt_certification add column short_name_ci generated always as (upper(short_name));
alter table identityiq.spt_certification add column name_ci generated always as (upper(name));
set integrity for identityiq.spt_arch_cert_item_apps,identityiq.spt_archived_cert_entity,identityiq.spt_archived_cert_item,identityiq.spt_cert_item_applications,identityiq.spt_certification,identityiq.spt_certification_entity,identityiq.spt_certification_groups,identityiq.spt_certification_item,identityiq.spt_certification_tags,identityiq.spt_certifiers,identityiq.spt_entitlement_snapshot,identityiq.spt_identity_entitlement,identityiq.spt_remediation_item,identityiq.spt_sign_off_history,identityiq.spt_snapshot_permissions,identityiq.spt_work_item,identityiq.spt_work_item_comments immediate checked force generated;
        
drop index identityiq.spt_cert_group_id;
create index identityiq.spt_cert_group_id_ci on identityiq.spt_certification (group_definition_id_ci);
drop index identityiq.spt_cert_type;
create index identityiq.spt_cert_type_ci on identityiq.spt_certification (type_ci);
drop index identityiq.spt_certification_phase;
create index identityiq.spt_cert_phase_ci on identityiq.spt_certification (phase_ci);
drop index identityiq.spt_cert_group_name;
create index identityiq.spt_cert_group_name_ci on identityiq.spt_certification (group_definition_name_ci);
drop index identityiq.spt_certification_short_name;
create index identityiq.spt_cert_short_name_ci on identityiq.spt_certification (short_name_ci);
drop index identityiq.spt_cert_application;
create index identityiq.spt_cert_application_ci on identityiq.spt_certification (application_id_ci);
drop index identityiq.spt_cert_cert_def_id;
create index identityiq.spt_cert_cert_def_id_ci on identityiq.spt_certification (certification_definition_id_ci);
drop index identityiq.spt_certification_name;
create index identityiq.spt_certification_name_ci on identityiq.spt_certification (name_ci);
drop index identityiq.spt_cert_trigger_id;
create index identityiq.spt_cert_trigger_id_ci on identityiq.spt_certification (trigger_id_ci);
drop index identityiq.spt_cert_manager;
create index identityiq.spt_cert_manager_ci on identityiq.spt_certification (manager_ci);
drop index identityiq.spt_cert_task_sched_id;
create index identityiq.spt_cert_task_sched_id_ci on identityiq.spt_certification (task_schedule_id_ci);

--
-- This is necessary to maintain the schema version. DO NOT REMOVE.
--
update identityiq.spt_database_version set schema_version = '8.0-09' where name = 'main';
