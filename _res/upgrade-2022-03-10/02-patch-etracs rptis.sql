/* 255-03012 */

/*=====================================
* LEDGER TAG
=====================================*/
CREATE TABLE rptledger_tag (
  objid varchar(50) NOT NULL,
  parent_objid varchar(50) NOT NULL,
  tag varchar(255) NOT NULL,
  PRIMARY KEY (objid)
)
go 

create UNIQUE index ux_rptledger_tag on rptledger_tag(parent_objid,tag)
go 

create index FK_rptledgertag_rptledger on rptledger_tag(parent_objid)
go 
  
alter table rptledger_tag 
    add CONSTRAINT FK_rptledgertag_rptledger 
    FOREIGN KEY (parent_objid) REFERENCES rptledger (objid)
go     

/* 255-03013 */
alter table resection_item add newfaas_claimno varchar(25)
go
alter table resection_item add faas_claimno varchar(25)
go 

/* 255-03015 */

create table rptcertification_online (
  objid varchar(50) not null,
  state varchar(25) not null,
  reftype varchar(25) not null,
  refid varchar(50) not null,
  refno varchar(50) not null,
  refdate date not null,
  orno varchar(25) default null,
  ordate date default null,
  oramount decimal(16,2) default null,
  primary key (objid)
)
go 

alter table rptcertification_online 
	add constraint fk_rptcertification_online_rptcertification foreign key (objid) references rptcertification (objid)
go 
 
create index ix_state on rptcertification_online(state)
go 
 
create index ix_refid on rptcertification_online(refid)
go 
 
create index ix_refno on rptcertification_online(refno)
go 
 
create index ix_orno on rptcertification_online(orno)
go 
  



CREATE TABLE assessmentnotice_online (
  objid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
  reftype varchar(25) NOT NULL,
  refid varchar(50) NOT NULL,
  refno varchar(50) NOT NULL,
  refdate date NOT NULL,
  orno varchar(25) DEFAULT NULL,
  ordate date DEFAULT NULL,
  oramount decimal(16,2) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go 

create index ix_state on assessmentnotice_online (state)
go 
create index ix_refid on assessmentnotice_online (refid)
go 
create index ix_refno on assessmentnotice_online (refno)
go 
create index ix_orno on assessmentnotice_online (orno)
go 
  
alter table assessmentnotice_online 
  add CONSTRAINT fk_assessmentnotice_online_assessmentnotice 
  FOREIGN KEY (objid) REFERENCES assessmentnotice (objid)
go   



/*===============================================================
**
** FAAS ANNOTATION
**
===============================================================*/
CREATE TABLE faasannotation_faas (
  objid varchar(50) NOT NULL,
  parent_objid varchar(50) NOT NULL,
  faas_objid varchar(50) NOT NULL,
  PRIMARY KEY (objid)
) 
go 


alter table faasannotation_faas 
add constraint fk_faasannotationfaas_faasannotation foreign key(parent_objid)
references faasannotation (objid)
go

alter table faasannotation_faas 
add constraint fk_faasannotationfaas_faas foreign key(faas_objid)
references faas (objid)
go

create index ix_parent_objid on faasannotation_faas(parent_objid)
go

create index ix_faas_objid on faasannotation_faas(faas_objid)
go


create unique index ux_parent_faas on faasannotation_faas(parent_objid, faas_objid)
go

alter table faasannotation alter column faasid varchar(50) null
go



-- insert annotated faas
insert into faasannotation_faas(
  objid, 
  parent_objid,
  faas_objid 
)
select 
  objid, 
  objid as parent_objid,
  faasid as faas_objid 
from faasannotation
go
  


/*============================================
*
*  LEDGER FAAS FACTS
*
=============================================*/
INSERT INTO sys_var ([name], [value], [description], [datatype], [category]) 
VALUES ('rptledger_rule_include_ledger_faases', '0', 'Include Ledger FAASes as rule facts', 'checkbox', 'LANDTAX')
go

INSERT INTO sys_var ([name], [value], [description], [datatype], [category]) 
VALUES ('rptledger_post_ledgerfaas_by_actualuse', '0', 'Post by Ledger FAAS by actual use', 'checkbox', 'LANDTAX')
go 


/* 255-03016 */

/*================================================================
*
* RPTLEDGER REDFLAG
*
================================================================*/

CREATE TABLE rptledger_redflag (
  objid varchar(50) NOT NULL,
  parent_objid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
  caseno varchar(25) NULL,
  dtfiled datetime NULL,
  type varchar(25) NOT NULL,
  finding text,
  remarks text,
  blockaction varchar(25) DEFAULT NULL,
  filedby_objid varchar(50) DEFAULT NULL,
  filedby_name varchar(255) DEFAULT NULL,
  filedby_title varchar(50) DEFAULT NULL,
  resolvedby_objid varchar(50) DEFAULT NULL,
  resolvedby_name varchar(255) DEFAULT NULL,
  resolvedby_title varchar(50) DEFAULT NULL,
  dtresolved datetime NULL,
  PRIMARY KEY (objid)
) 
go

create index ix_parent_objid on rptledger_redflag(parent_objid)
go
create index ix_state on rptledger_redflag(state)
go
create unique index ux_caseno on rptledger_redflag(caseno)
go
create index ix_type on rptledger_redflag(type)
go
create index ix_filedby_objid on rptledger_redflag(filedby_objid)
go
create index ix_resolvedby_objid on rptledger_redflag(resolvedby_objid)
go

alter table rptledger_redflag 
add constraint fk_rptledger_redflag_rptledger foreign key (parent_objid)
references rptledger(objid)
go

alter table rptledger_redflag 
add constraint fk_rptledger_redflag_filedby foreign key (filedby_objid)
references sys_user(objid)
go

alter table rptledger_redflag 
add constraint fk_rptledger_redflag_resolvedby foreign key (resolvedby_objid)
references sys_user(objid)
go




/*==================================================
* RETURNED TASK 
==================================================*/
alter table faas_task add returnedby varchar(100)
go 
alter table subdivision_task add returnedby varchar(100)
go 
alter table consolidation_task add returnedby varchar(100)
go 
alter table cancelledfaas_task add returnedby varchar(100)
go 
alter table resection_task add returnedby varchar(100)
go 



/* 255-03016 */

/*================================================================
*
* LANDTAX SHARE POSTING
*
================================================================*/
alter table rptpayment_share add iscommon int
go 

alter table rptpayment_share add year int
go 

update rptpayment_share set iscommon = 0 where iscommon is null 
go 




CREATE TABLE cashreceipt_rpt_share_forposting (
  objid varchar(50) NOT NULL,
  receiptid varchar(50) NOT NULL,
  rptledgerid varchar(50) NOT NULL,
  txndate datetime,
  error int NOT NULL,
  msg text,
  PRIMARY KEY (objid)
) 
go 


create UNIQUE index ux_receiptid_rptledgerid on cashreceipt_rpt_share_forposting (receiptid,rptledgerid)
go 
create index fk_cashreceipt_rpt_share_forposing_rptledger on cashreceipt_rpt_share_forposting (rptledgerid)
go 
create index fk_cashreceipt_rpt_share_forposing_cashreceipt on cashreceipt_rpt_share_forposting (receiptid)
go 

alter table cashreceipt_rpt_share_forposting add CONSTRAINT fk_cashreceipt_rpt_share_forposing_rptledger 
FOREIGN KEY (rptledgerid) REFERENCES rptledger (objid)
go 
alter table cashreceipt_rpt_share_forposting add CONSTRAINT fk_cashreceipt_rpt_share_forposing_cashreceipt 
FOREIGN KEY (receiptid) REFERENCES cashreceipt (objid)
go 




/*==================================================
**
** BLDG DATE CONSTRUCTED SUPPORT 
**
===================================================*/

alter table bldgrpu add dtconstructed date
go 

/* 255-03018 */

/*==================================================
**
** ONLINE BATCH GR 
**
===================================================*/
select * into zz_tmp_batchgr  from batchgr
go

select * into zz_tmp_batchgr_item  from batchgr_item
go


if exists(select * from sysobjects where id = object_id('vw_batchgr')) 
begin 
	drop view vw_batchgr
end 
go 


if exists(select * from sysobjects where id = object_id('batchgr_log')) 
begin 
	drop table batchgr_log
end 
go 

if exists(select * from sysobjects where id = object_id('batchgr_error')) 
begin 
	drop table batchgr_error
end 
go 

if exists(select * from sysobjects where id = object_id('batchgr_forprocess')) 
begin 
	drop table batchgr_forprocess
end 
go 

if exists(select * from sysobjects where id = object_id('batchgr_task')) 
begin 
	drop table batchgr_task
end 
go 


if exists(select * from sysobjects where id = object_id('batchgr_item')) 
begin 
	drop table batchgr_item
end 
go 


if exists(select * from sysobjects where id = object_id('batchgr')) 
begin 
	drop table batchgr
end 
go 



create table batchgr (
  objid varchar(50) not null,
  state varchar(50) not null,
  ry int not null,
  txntype_objid varchar(5) not null,
  txnno varchar(25) not null,
  txndate datetime not null,
  effectivityyear int not null,
  effectivityqtr int not null,
  memoranda varchar(255) not null,
  originlguid varchar(50) not null,
  lguid varchar(50) not null,
  barangayid varchar(50) not null,
  rputype varchar(15) default null,
  classificationid varchar(50) default null,
  section varchar(10) default null,
  primary key (objid)
)
go 

create index ix_state on batchgr(state)
go
create index ix_ry on batchgr(ry)
go
create index ix_txnno on batchgr(txnno)
go
create index ix_lguid on batchgr(lguid)
go
create index ix_barangayid on batchgr(barangayid)
go
create index ix_classificationid on batchgr(classificationid)
go
create index ix_section on batchgr(section)
go

alter table batchgr 
add constraint fk_batchgr_lguid foreign key(lguid) 
references sys_org(objid)
go

alter table batchgr 
add constraint fk_batchgr_barangayid foreign key(barangayid) 
references sys_org(objid)
go

alter table batchgr 
add constraint fk_batchgr_classificationid foreign key(classificationid) 
references propertyclassification(objid)
go


create table batchgr_item (
  objid varchar(50) not null,
  parent_objid varchar(50) not null,
  state varchar(50) not null,
  rputype varchar(15) not null,
  tdno varchar(50) not null,
  fullpin varchar(50) not null,
  pin varchar(50) not null,
  suffix int not null,
  subsuffix int null,
  newfaasid varchar(50) default null,
  error text,
  primary key (objid)
) 
go

create index ix_parent_objid on batchgr_item(parent_objid)
go
create index ix_tdno on batchgr_item(tdno)
go
create index ix_pin on batchgr_item(pin)
go
create index ix_newfaasid on batchgr_item(newfaasid)
go

alter table batchgr_item 
add constraint fk_batchgr_item_batchgr foreign key(parent_objid) 
references batchgr(objid)
go

alter table batchgr_item 
add constraint fk_batchgr_item_faas foreign key(newfaasid) 
references faas(objid)
go

create table batchgr_task (
  objid varchar(50) not null,
  refid varchar(50) default null,
  parentprocessid varchar(50) default null,
  state varchar(50) default null,
  startdate datetime default null,
  enddate datetime default null,
  assignee_objid varchar(50) default null,
  assignee_name varchar(100) default null,
  assignee_title varchar(80) default null,
  actor_objid varchar(50) default null,
  actor_name varchar(100) default null,
  actor_title varchar(80) default null,
  message varchar(255) default null,
  signature text,
  returnedby varchar(100) default null,
  primary key (objid)
)
go 

create index ix_assignee_objid on batchgr_task(assignee_objid)
go
create index ix_refid on batchgr_task(refid)
go

alter table batchgr_task 
add constraint fk_batchgr_task_batchgr foreign key(refid) 
references batchgr(objid)
go


create view vw_batchgr 
as 
select 
  bg.*,
  l.name as lgu_name,
  b.name as barangay_name,
  pc.name as classification_name,
  t.objid AS taskid,
  t.state AS taskstate,
  t.assignee_objid 
from batchgr bg
inner join sys_org l on bg.lguid = l.objid 
left join sys_org b on bg.barangayid = b.objid
left join propertyclassification pc on bg.classificationid = pc.objid 
left join batchgr_task t on bg.objid = t.refid  and t.enddate is null 
go






/*===========================================
*
*  ENTITY MAPPING (PROVINCE)
*
============================================*/
if exists(select * from sysobjects where id = object_id('entity_mapping')) 
begin 
  drop table entity_mapping
end 
go 

CREATE TABLE entity_mapping (
  objid varchar(50) NOT NULL,
  parent_objid varchar(50) NOT NULL,
  org_objid varchar(50) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go

if exists(select * from sysobjects where id = object_id('vw_entity_mapping')) 
begin 
  drop view vw_entity_mapping
end 
go 

create view vw_entity_mapping
as 
select 
  r.*,
  e.entityno,
  e.name, 
  e.address_text as address_text,
  a.province as address_province,
  a.municipality as address_municipality
from entity_mapping r 
inner join entity e on r.objid = e.objid 
left join entity_address a on e.address_objid = a.objid
left join sys_org b on a.barangay_objid = b.objid 
left join sys_org m on b.parent_objid = m.objid 
go



/*===========================================
*
*  CERTIFICATION UPDATES
*
============================================*/
if exists(select * from sysobjects where id = object_id('vw_rptcertification_item')) 
begin 
  drop view vw_rptcertification_item
end 
go 

create view vw_rptcertification_item
as 
SELECT 
  rci.rptcertificationid,
  f.objid as faasid,
  f.fullpin, 
  f.tdno,
  e.objid as taxpayerid,
  e.name as taxpayer_name, 
  f.owner_name, 
  f.administrator_name,
  f.titleno,  
  f.rpuid, 
  pc.code AS classcode, 
  pc.name AS classname,
  so.name AS lguname,
  b.name AS barangay, 
  r.rputype, 
  r.suffix,
  r.totalareaha AS totalareaha,
  r.totalareasqm AS totalareasqm,
  r.totalav,
  r.totalmv, 
  rp.street,
  rp.blockno,
  rp.cadastrallotno,
  rp.surveyno,
  r.taxable,
  f.effectivityyear,
  f.effectivityqtr
FROM rptcertificationitem rci 
  INNER JOIN faas f ON rci.refid = f.objid 
  INNER JOIN rpu r ON f.rpuid = r.objid 
  INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
  INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
  INNER JOIN barangay b ON rp.barangayid = b.objid 
  INNER JOIN sys_org so on f.lguid = so.objid 
  INNER JOIN entity e on f.taxpayer_objid = e.objid 
go




/*===========================================
*
*  SUBDIVISION ASSISTANCE
*
============================================*/
if exists(select * from sysobjects where id = object_id('subdivision_assist_item')) 
begin 
  drop view subdivision_assist_item
end 
go 

if exists(select * from sysobjects where id = object_id('subdivision_assist')) 
begin 
  drop view subdivision_assist
end 
go 




CREATE TABLE subdivision_assist (
  objid varchar(50) NOT NULL,
  parent_objid varchar(50) NOT NULL,
  taskstate varchar(50) NOT NULL,
  assignee_objid varchar(50) NOT NULL,
  PRIMARY KEY (objid)
)
go

alter table subdivision_assist 
add constraint fk_subdivision_assist_subdivision foreign key(parent_objid)
references subdivision(objid)
go

alter table subdivision_assist 
add constraint fk_subdivision_assist_user foreign key(assignee_objid)
references sys_user(objid)
go

create index ix_parent_objid on subdivision_assist(parent_objid)
go

create index ix_assignee_objid on subdivision_assist(assignee_objid)
go

create unique index ux_parent_assignee on subdivision_assist(parent_objid, taskstate, assignee_objid)
go


CREATE TABLE subdivision_assist_item (
  objid varchar(50) NOT NULL,
  subdivision_objid varchar(50) NOT NULL,
  parent_objid varchar(50) NOT NULL,
  pintype varchar(10) NOT NULL,
  section varchar(5) NOT NULL,
  startparcel int NOT NULL,
  endparcel int NOT NULL,
  parcelcount int NOT NULL,
  parcelcreated int NULL,
  PRIMARY KEY (objid)
)
go

alter table subdivision_assist_item 
add constraint fk_subdivision_assist_item_subdivision foreign key(subdivision_objid)
references subdivision(objid)
go

alter table subdivision_assist_item 
add constraint fk_subdivision_assist_item_subdivision_assist foreign key(parent_objid)
references subdivision_assist(objid)
go

create index ix_subdivision_objid on subdivision_assist_item(subdivision_objid)
go

create index ix_parent_objid on subdivision_assist_item(parent_objid)
go







/*==================================================
**
** REALTY TAX CREDIT
**
===================================================*/

if exists(select * from sysobjects where id = object_id('rpttaxcredit')) 
begin 
  drop view rpttaxcredit
end 
go 


CREATE TABLE rpttaxcredit (
  objid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
  type varchar(25) NOT NULL,
  txnno varchar(25) DEFAULT NULL,
  txndate datetime DEFAULT NULL,
  reftype varchar(25) DEFAULT NULL,
  refid varchar(50) DEFAULT NULL,
  refno varchar(25) NOT NULL,
  refdate date NOT NULL,
  amount decimal(16,2) NOT NULL,
  amtapplied decimal(16,2) NOT NULL,
  rptledger_objid varchar(50) NOT NULL,
  srcledger_objid varchar(50) DEFAULT NULL,
  remarks varchar(255) DEFAULT NULL,
  approvedby_objid varchar(50) DEFAULT NULL,
  approvedby_name varchar(150) DEFAULT NULL,
  approvedby_title varchar(75) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go


create index ix_state on rpttaxcredit(state)
go

create index ix_type on rpttaxcredit(type)
go

create unique index ux_txnno on rpttaxcredit(txnno)
go

create index ix_reftype on rpttaxcredit(reftype)
go

create index ix_refid on rpttaxcredit(refid)
go

create index ix_refno on rpttaxcredit(refno)
go

create index ix_rptledger_objid on rpttaxcredit(rptledger_objid)
go

create index ix_srcledger_objid on rpttaxcredit(srcledger_objid)
go

alter table rpttaxcredit
add constraint fk_rpttaxcredit_rptledger foreign key (rptledger_objid)
references rptledger (objid)
go

alter table rpttaxcredit
add constraint fk_rpttaxcredit_srcledger foreign key (srcledger_objid)
references rptledger (objid)
go

alter table rpttaxcredit
add constraint fk_rpttaxcredit_sys_user foreign key (approvedby_objid)
references sys_user(objid)
go







/*==================================================
**
** MACHINE SMV
**
===================================================*/

CREATE TABLE machine_smv (
  objid varchar(50) NOT NULL,
  parent_objid varchar(50) NOT NULL,
  machine_objid varchar(50) NOT NULL,
  expr varchar(255) NOT NULL,
  previd varchar(50) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go

create index ix_parent_objid on machine_smv(parent_objid)
go
create index ix_machine_objid on machine_smv(machine_objid)
go
create index ix_previd on machine_smv(previd)
go
create unique index ux_parent_machine on machine_smv(parent_objid, machine_objid)
go



alter table machine_smv
add constraint fk_machinesmv_machrysetting foreign key (parent_objid)
references machrysetting (objid)
go

alter table machine_smv
add constraint fk_machinesmv_machine foreign key (machine_objid)
references machine(objid)
go


alter table machine_smv
add constraint fk_machinesmv_machinesmv foreign key (previd)
references machine_smv(objid)
go


create view vw_machine_smv 
as 
select 
  ms.*, 
  m.code,
  m.name
from machine_smv ms 
inner join machine m on ms.machine_objid = m.objid 
go


alter table machdetail add smvid varchar(50)
go 
alter table machdetail add params text
go

update machdetail set params = '[]' where params is null
go

create index ix_smvid on machdetail(smvid)
go


alter table machdetail 
add constraint fk_machdetail_machine_smv foreign key(smvid)
references machine_smv(objid)
go 





/*==================================================
**
** SUBDIVISION AFFECTED RPUS TXNTYPE (DP)
**
===================================================*/

INSERT INTO sys_var (name, value, description, datatype, category) 
VALUES ('faas_affected_rpu_txntype_dp', '0', 'Set affected improvements FAAS txntype to DP e.g. SD and CS', 'checkbox', 'ASSESSOR')
go

delete from sys_wf_transition where processname = 'batchgr'
go
delete from sys_wf_node where processname = 'batchgr'
go

INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('start', 'batchgr', 'Start', 'start', '1', NULL, 'RPT', 'START', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-receiver', 'batchgr', 'For Review and Verification', 'state', '2', NULL, 'RPT', 'RECEIVER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('receiver', 'batchgr', 'Review and Verification', 'state', '5', NULL, 'RPT', 'RECEIVER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-examiner', 'batchgr', 'For Examination', 'state', '10', NULL, 'RPT', 'EXAMINER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('examiner', 'batchgr', 'Examination', 'state', '15', NULL, 'RPT', 'EXAMINER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-taxmapper', 'batchgr', 'For Taxmapping', 'state', '20', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-provtaxmapper', 'batchgr', 'For Taxmapping', 'state', '20', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('taxmapper', 'batchgr', 'Taxmapping', 'state', '25', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('provtaxmapper', 'batchgr', 'Taxmapping', 'state', '25', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-taxmapping-approval', 'batchgr', 'For Taxmapping Approval', 'state', '30', NULL, 'RPT', 'TAXMAPPER_CHIEF', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('taxmapper_chief', 'batchgr', 'Taxmapping Approval', 'state', '35', NULL, 'RPT', 'TAXMAPPER_CHIEF', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-appraiser', 'batchgr', 'For Appraisal', 'state', '40', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-provappraiser', 'batchgr', 'For Appraisal', 'state', '40', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('appraiser', 'batchgr', 'Appraisal', 'state', '45', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('provappraiser', 'batchgr', 'Appraisal', 'state', '45', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-appraisal-chief', 'batchgr', 'For Appraisal Approval', 'state', '50', NULL, 'RPT', 'APPRAISAL_CHIEF', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('appraiser_chief', 'batchgr', 'Appraisal Approval', 'state', '55', NULL, 'RPT', 'APPRAISAL_CHIEF', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-recommender', 'batchgr', 'For Recommending Approval', 'state', '70', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('recommender', 'batchgr', 'Recommending Approval', 'state', '75', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('forprovsubmission', 'batchgr', 'For Province Submission', 'state', '80', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('forprovapproval', 'batchgr', 'For Province Approval', 'state', '81', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('forapproval', 'batchgr', 'Provincial Assessor Approval', 'state', '85', NULL, 'RPT', 'APPROVER,ASSESSOR', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-approver', 'batchgr', 'For Provincial Assessor Approval', 'state', '90', NULL, 'RPT', 'APPROVER,ASSESSOR', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('approver', 'batchgr', 'Provincial Assessor Approval', 'state', '95', NULL, 'RPT', 'APPROVER,ASSESSOR', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('provapprover', 'batchgr', 'Approved By Province', 'state', '96', NULL, 'RPT', 'APPROVER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('end', 'batchgr', 'End', 'end', '1000', NULL, 'RPT', NULL, NULL, NULL, NULL)
go 

INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('start', 'batchgr', '', 'assign-receiver', '1', NULL, NULL, NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('assign-receiver', 'batchgr', '', 'receiver', '2', NULL, '[caption:''Assign To Me'', confirm:''Assign task to you?'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('receiver', 'batchgr', 'submit', 'assign-provtaxmapper', '5', NULL, '[caption:''Submit For Taxmapping'', confirm:''Submit?'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('assign-examiner', 'batchgr', '', 'examiner', '10', NULL, '[caption:''Assign To Me'', confirm:''Assign task to you?'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('examiner', 'batchgr', 'returnreceiver', 'receiver', '15', NULL, '[caption:''Return to Receiver'', confirm:''Return to receiver?'', messagehandler:''default'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('examiner', 'batchgr', 'submit', 'assign-provtaxmapper', '16', NULL, '[caption:''Submit for Approval'', confirm:''Submit?'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('assign-provtaxmapper', 'batchgr', '', 'provtaxmapper', '20', NULL, '[caption:''Assign To Me'', confirm:''Assign task to you?'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('provtaxmapper', 'batchgr', 'returnexaminer', 'examiner', '25', NULL, '[caption:''Return to Examiner'', confirm:''Return to examiner?'', messagehandler:''default'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('provtaxmapper', 'batchgr', 'submit', 'assign-provappraiser', '26', NULL, '[caption:''Submit for Approval'', confirm:''Submit?'', messagehandler:''rptmessage:sign'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('assign-provappraiser', 'batchgr', '', 'provappraiser', '40', NULL, '[caption:''Assign To Me'', confirm:''Assign task to you?'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('provappraiser', 'batchgr', 'returntaxmapper', 'provtaxmapper', '45', NULL, '[caption:''Return to Taxmapper'', confirm:''Return to taxmapper?'', messagehandler:''default'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('provappraiser', 'batchgr', 'returnexaminer', 'examiner', '46', NULL, '[caption:''Return to Examiner'', confirm:''Return to examiner?'', messagehandler:''default'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('provappraiser', 'batchgr', 'submit', 'assign-approver', '47', NULL, '[caption:''Submit for Approval'', confirm:''Submit?'', messagehandler:''rptmessage:sign'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('assign-approver', 'batchgr', '', 'approver', '70', NULL, '[caption:''Assign To Me'', confirm:''Assign task to you?'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('approver', 'batchgr', 'approve', 'provapprover', '90', NULL, '[caption:''Approve'', confirm:''Approve record?'', messagehandler:''rptmessage:sign'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('provapprover', 'batchgr', 'backforprovapproval', 'approver', '95', NULL, '[caption:''Cancel Posting'', confirm:''Cancel posting record?'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('provapprover', 'batchgr', 'completed', 'end', '100', NULL, '[caption:''Approved'', visible:false]', NULL, NULL, NULL)
go

if exists(select * from sysobjects where id = OBJECT_ID('vw_real_property_payment'))
begin
	drop view vw_real_property_payment
end 
go 

create view vw_real_property_payment as 
select 
	cv.controldate as cv_controldate,
	rem.controldate as rem_controldate,
	rl.owner_name,
	rl.tdno,
	pc.name as classification, 
	case 
		when rl.rputype = 'land' then 'LAND' 
		when rl.rputype = 'bldg' then 'BUILDING' 
		when rl.rputype = 'mach' then 'MACHINERY' 
		when rl.rputype = 'planttree' then 'PLANT/TREE' 
		else 'MISCELLANEOUS'
	end as rputype,
	b.name as barangay,
	rpi.year, 
	rpi.qtr,
	rpi.amount + rpi.interest - rpi.discount as amount,
	case when v.objid is null then 0 else 1 end as voided
from collectionvoucher cv 
	inner join remittance rem on cv.objid = rem.collectionvoucherid
	inner join cashreceipt cr on rem.objid = cr.remittanceid
	inner join rptpayment rp on cr.objid = rp.receiptid 
	inner join rptpayment_item rpi on rp.objid = rpi.parentid 
	inner join rptledger rl on rp.refid = rl.objid 
	inner join barangay b on rl.barangayid = b.objid 
	inner join propertyclassification pc on rl.classification_objid = pc.objid 
	left join cashreceipt_void v on cr.objid = v.receiptid 
go


if exists(select * from sysobjects where id = OBJECT_ID('vw_newly_assessed_property'))
begin
	drop view vw_newly_assessed_property
end 
go 

create view vw_newly_assessed_property
as 
select
	f.objid,
	f.owner_name,
	f.tdno,
	b.name as barangay,
	case 
		when f.rputype = 'land' then 'LAND' 
		when f.rputype = 'bldg' then 'BUILDING' 
		when f.rputype = 'mach' then 'MACHINERY' 
		when f.rputype = 'planttree' then 'PLANT/TREE' 
		else 'MISCELLANEOUS'
	end as rputype,
	f.totalav,
	f.effectivityyear
from faas_list f 
	inner join barangay b on f.barangayid = b.objid 
where f.state in ('CURRENT', 'CANCELLED') 
and f.txntype_objid = 'ND' 
go


if exists(select * from sysobjects where id = OBJECT_ID('vw_report_orc'))
begin
	drop view vw_report_orc
end 
go 


create view vw_report_orc as 
select 
	f.objid,
	f.state,
	e.objid as taxpayerid,
	e.name as taxpayer_name,
	e.address_text as taxpayer_address,
  	o.name as lgu_name,
	o.code as lgu_indexno,
	f.dtapproved,
	r.rputype,
	pc.code as classcode,
	pc.name as classification,
	f.fullpin as pin,
	f.titleno,
	rp.cadastrallotno,
	f.tdno,
	'' as arpno,
	f.prevowner,
	b.name as location,
	r.totalareaha,
	r.totalareasqm,
	r.totalmv, 
	r.totalav,
	case when f.state = 'CURRENT' then '' else 'CANCELLED' end as remarks
from faas f
inner join rpu r on f.rpuid = r.objid 
inner join realproperty rp on f.realpropertyid = rp.objid 
inner join propertyclassification pc on r.classification_objid = pc.objid 
inner join entity e on f.taxpayer_objid = e.objid 
inner join sys_org o on rp.lguid = o.objid 
inner join barangay b on rp.barangayid = b.objid 
where f.state in ('CURRENT', 'CANCELLED')
go 




create index ix_year on rptpayment_item (year)
go
create index ix_revperiod on rptpayment_item (revperiod)
go
create index ix_revtype on rptpayment_item (revtype)
go 



create index ix_year on rptpayment_share (year)
go
create index ix_revperiod on rptpayment_share (revperiod)
go
create index ix_revtype on rptpayment_share (revtype)
go


CREATE TABLE cashreceipt_rpt_share_forposting_repost (
	objid varchar(50) NOT NULL,
  rptpaymentid varchar(50) NOT NULL,
  receiptid varchar(50) NOT NULL,
  receiptdate date NOT NULL,
  rptledgerid varchar(50) NOT NULL,
	primary key (objid)
)
go

create unique index ux_receiptid_rptledgerid on cashreceipt_rpt_share_forposting_repost (receiptid,rptledgerid)
go 

create index fk_rptshare_repost_rptledgerid on cashreceipt_rpt_share_forposting_repost (rptledgerid)
go

create index fk_rptshare_repost_cashreceiptid on cashreceipt_rpt_share_forposting_repost (receiptid)
go

alter table cashreceipt_rpt_share_forposting_repost 
	add CONSTRAINT fk_rptshare_repost_cashreceipt FOREIGN KEY (receiptid) REFERENCES cashreceipt (objid)
go 

alter table cashreceipt_rpt_share_forposting_repost 
	add CONSTRAINT fk_rptshare_repost_rptledger FOREIGN KEY (rptledgerid) REFERENCES rptledger (objid)
go 

alter table bldgrpu add occpermitno varchar(25)
go 

alter table rpu add isonline int
go 

update rpu set isonline = 0 where isonline is null 
go

if exists(select * from sysobjects where id = OBJECT_ID('sync_data_forprocess'))
begin 
  drop table sync_data_forprocess
end 
go 

if exists(select * from sysobjects where id = OBJECT_ID('sync_data_pending'))
begin 
  drop table sync_data_pending
end 
go 


if exists(select * from sysobjects where id = OBJECT_ID('sync_data'))
begin 
  drop table sync_data
end 
go 



if exists(select * from sysobjects where id = OBJECT_ID('syncdata_pending'))
begin 
  drop table syncdata_pending
end 
go 

if exists(select * from sysobjects where id = OBJECT_ID('syncdata_forprocess'))
begin 
  drop table syncdata_forprocess
end 
go 

if exists(select * from sysobjects where id = OBJECT_ID('syncdata_item'))
begin 
  drop table syncdata_item
end 
go 

if exists(select * from sysobjects where id = OBJECT_ID('syncdata'))
begin 
  drop table syncdata
end 
go 

if exists(select * from sysobjects where id = OBJECT_ID('syncdata_forsync'))
begin 
  drop table syncdata_forsync
end 
go 



CREATE TABLE syncdata_forsync (
  objid varchar(50) NOT NULL,
  reftype varchar(100) NOT NULL,
  refno varchar(50) NOT NULL,
  action varchar(100) NOT NULL,
  orgid varchar(25) NOT NULL,
  dtfiled datetime NOT NULL,
  createdby_objid varchar(50) DEFAULT NULL,
  createdby_name varchar(255) DEFAULT NULL,
  createdby_title varchar(100) DEFAULT NULL,
  info text,
  PRIMARY KEY (objid)
) 
go

CREATE INDEX ix_dtfiled ON syncdata_forsync (dtfiled)
go
CREATE INDEX ix_createdbyid ON syncdata_forsync (createdby_objid)
go
CREATE INDEX ix_reftype ON syncdata_forsync (reftype) 
go
CREATE INDEX ix_refno ON syncdata_forsync (refno)
go


CREATE TABLE syncdata (
  objid varchar(50) NOT NULL,
  state varchar(50) NOT NULL,
  refid varchar(50) NOT NULL,
  reftype varchar(50) NOT NULL,
  refno varchar(50) DEFAULT NULL,
  action varchar(50) NOT NULL,
  dtfiled datetime NOT NULL,
  orgid varchar(50) DEFAULT NULL,
  remote_orgid varchar(50) DEFAULT NULL,
  remote_orgcode varchar(20) DEFAULT NULL,
  remote_orgclass varchar(20) DEFAULT NULL,
  sender_objid varchar(50) DEFAULT NULL,
  sender_name varchar(150) DEFAULT NULL,
  fileid varchar(255) DEFAULT NULL,
  PRIMARY KEY (objid)
)
go

CREATE INDEX ix_reftype on syncdata (reftype)
go
CREATE INDEX ix_refno on syncdata (refno)
go
CREATE INDEX ix_orgid on syncdata (orgid)
go
CREATE INDEX ix_dtfiled on syncdata (dtfiled)
go
CREATE INDEX ix_fileid on syncdata (fileid)
go
CREATE INDEX ix_refid on syncdata (refid)
go


CREATE TABLE syncdata_item (
  objid varchar(50) NOT NULL,
  parentid varchar(50) NOT NULL,
  state varchar(50) NOT NULL,
  refid varchar(50) NOT NULL,
  reftype varchar(255) NOT NULL,
  refno varchar(50) DEFAULT NULL,
  action varchar(100) NOT NULL,
  error text,
  idx int NOT NULL,
  info text,
  PRIMARY KEY (objid)
)
go

CREATE INDEX ix_parentid ON syncdata_item(parentid)
go
CREATE INDEX ix_refid ON syncdata_item(refid)
go
CREATE INDEX ix_refno ON syncdata_item(refno)
go


ALTER TABLE syncdata_item 
ADD CONSTRAINT fk_syncdataitem_syncdata 
FOREIGN KEY (parentid) REFERENCES syncdata (objid)
GO 



CREATE TABLE syncdata_forprocess (
  objid varchar(50) NOT NULL,
  parentid varchar(50) NOT NULL,
  PRIMARY KEY (objid)
) 
go

CREATE INDEX ix_parentid ON syncdata_forprocess (parentid)
go 

ALTER TABLE syncdata_forprocess 
ADD CONSTRAINT fk_syncdata_forprocess_syncdata_item 
FOREIGN KEY (objid) REFERENCES syncdata_item (objid)
go


CREATE TABLE syncdata_pending (
  objid varchar(50) NOT NULL,
  error text,
  expirydate datetime DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go

CREATE INDEX ix_expirydate ON syncdata_pending(expirydate)
go 

ALTER TABLE syncdata_pending 
ADD CONSTRAINT fk_syncdata_pending_syncdata 
FOREIGN KEY (objid) REFERENCES syncdata (objid)
go



/* PREVTAXABILITY */
alter table faas_previous add prevtaxability varchar(10)
go


update pf set 
  pf.prevtaxability = case when r.taxable = 1 then 'TAXABLE' else 'EXEMPT' end 
from faas_previous pf, faas f, rpu r
where pf.prevfaasid = f.objid
and f.rpuid = r.objid 
and pf.prevtaxability is null 
go 






CREATE TABLE syncdata_org (
  orgid varchar(50) NOT NULL,
  state varchar(50) NOT NULL,
  errorcount int,
  PRIMARY KEY (orgid)
) 
go

create index ix_state on syncdata_org(state)
;

insert into syncdata_org (
  orgid, 
  state, 
  errorcount
)
select 
  objid,
  'ACTIVE',
  0
from sys_org
where orgclass = 'province'
;


drop table syncdata_forprocess
go 

CREATE TABLE syncdata_forprocess (
  objid varchar(50) NOT NULL,
  PRIMARY KEY (objid)
) 
go







alter table rptledger_item add fromqtr int
go 
alter table rptledger_item add toqtr int 
go 


CREATE TABLE batch_rpttaxcredit (
  objid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
  txndate date NOT NULL,
  txnno varchar(25) NOT NULL,
  rate decimal(10,2) NOT NULL,
  paymentfrom date DEFAULT NULL,
  paymentto varchar(255) DEFAULT NULL,
  creditedyear int NOT NULL,
  reason varchar(255) NOT NULL,
  validity date NULL,
  PRIMARY KEY (objid)
) 
go

create index ix_state on batch_rpttaxcredit(state)
go
create index ix_txnno on batch_rpttaxcredit(txnno)
go

CREATE TABLE batch_rpttaxcredit_ledger (
  objid varchar(50) NOT NULL,
  parentid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
  error varchar(255) NULL,
	barangayid varchar(50) not null, 
  PRIMARY KEY (objid)
) 
go


create index ix_parentid on batch_rpttaxcredit_ledger (parentid)
go
create index ix_state on batch_rpttaxcredit_ledger (state)
go
create index ix_barangayid on batch_rpttaxcredit_ledger (barangayid)
go

alter table batch_rpttaxcredit_ledger 
add constraint fk_rpttaxcredit_rptledger_parent foreign key(parentid) references batch_rpttaxcredit(objid)
go

alter table batch_rpttaxcredit_ledger 
add constraint fk_rpttaxcredit_rptledger_rptledger foreign key(objid) references rptledger(objid)
go




CREATE TABLE batch_rpttaxcredit_ledger_posted (
  objid varchar(50) NOT NULL,
  parentid varchar(50) NOT NULL,
  barangayid varchar(50) NOT NULL,
  PRIMARY KEY (objid)
)
go

create index ix_parentid on batch_rpttaxcredit_ledger_posted(parentid)
go
create index ix_barangayid on batch_rpttaxcredit_ledger_posted(barangayid)
go

alter table batch_rpttaxcredit_ledger_posted 
add constraint fk_rpttaxcredit_rptledger_posted_parent foreign key(parentid) references batch_rpttaxcredit(objid)
go

alter table batch_rpttaxcredit_ledger_posted 
add constraint fk_rpttaxcredit_rptledger_posted_rptledger foreign key(objid) references rptledger(objid)
go

create view vw_batch_rpttaxcredit_error
as 
select br.*, rl.tdno
from batch_rpttaxcredit_ledger br 
inner join rptledger rl on br.objid = rl.objid 
where br.state = 'ERROR'
go

alter table rpttaxcredit add info text
go


alter table rpttaxcredit add discapplied decimal(16,2) not null
go

update rpttaxcredit set discapplied = 0 where discapplied is null 
go


CREATE TABLE rpt_syncdata_forsync (
  [objid] varchar(50) NOT NULL,
  [reftype] varchar(50) NOT NULL,
  [refno] varchar(50) NOT NULL,
  [action] varchar(50) NOT NULL,
  [orgid] varchar(50) NOT NULL,
  [dtfiled] datetime NOT NULL,
  [createdby_objid] varchar(50) DEFAULT NULL,
  [createdby_name] varchar(255) DEFAULT NULL,
  [createdby_title] varchar(50) DEFAULT NULL,
  PRIMARY KEY (objid)
)
go 
create index ix_refno on rpt_syncdata_forsync (refno)
go
create index ix_orgid on rpt_syncdata_forsync (orgid)
go

CREATE TABLE rpt_syncdata (
  [objid] varchar(50) NOT NULL,
  [state] varchar(25) NOT NULL,
  [refid] varchar(50) NOT NULL,
  [reftype] varchar(50) NOT NULL,
  [refno] varchar(50) NOT NULL,
  [action] varchar(50) NOT NULL,
  [dtfiled] datetime NOT NULL,
  [orgid] varchar(50) NOT NULL,
  [remote_orgid] varchar(50) DEFAULT NULL,
  [remote_orgcode] varchar(5) DEFAULT NULL,
  [remote_orgclass] varchar(25) DEFAULT NULL,
  [sender_objid] varchar(50) DEFAULT NULL,
  [sender_name] varchar(255) DEFAULT NULL,
  [sender_title] varchar(80) DEFAULT NULL,
  PRIMARY KEY (objid)
)
go

create index ix_state on rpt_syncdata (state)
go
create index ix_refid on rpt_syncdata (refid)
go
create index ix_refno on rpt_syncdata (refno)
go
create index ix_orgid on rpt_syncdata (orgid)
go

CREATE TABLE rpt_syncdata_item (
  objid varchar(50) NOT NULL,
  parentid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
  refid varchar(50) NOT NULL,
  reftype varchar(50) NOT NULL,
  refno varchar(50) NOT NULL,
  action varchar(50) NOT NULL,
  idx int NOT NULL,
  info text,
  PRIMARY KEY (objid)
)
go 

create index ix_parentid on rpt_syncdata_item (parentid)
go
create index ix_state on rpt_syncdata_item (state)
go
create index ix_refid on rpt_syncdata_item (refid)
go
create index ix_refno on rpt_syncdata_item (refno)
go


alter table rpt_syncdata_item
  add CONSTRAINT FK_parentid_rpt_syncdata 
  FOREIGN KEY (parentid) REFERENCES rpt_syncdata (objid)
go 

CREATE TABLE rpt_syncdata_error (
  [objid] varchar(50) NOT NULL,
  [filekey] varchar(1000) NOT NULL,
  [error] text,
  [refid] varchar(50) NOT NULL,
  [reftype] varchar(50) NOT NULL,
  [refno] varchar(50) NOT NULL,
  [action] varchar(50) NOT NULL,
  [idx] int NOT NULL,
  [info] text,
  [parent] text,
  [remote_orgid] varchar(50) DEFAULT NULL,
  [remote_orgcode] varchar(5) DEFAULT NULL,
  [remote_orgclass] varchar(50) DEFAULT NULL,
  PRIMARY KEY (objid)
)
go 

create index ix_refid on rpt_syncdata_error (refid)
go
create index ix_refno on rpt_syncdata_error (refno)
go


create index ix_filekey on rpt_syncdata_error (filekey)
go
create index ix_remote_orgid on rpt_syncdata_error (remote_orgid)
go
create index ix_remote_orgcode on rpt_syncdata_error (remote_orgcode)
go

INSERT INTO sys_var ([name], [value], [description], [datatype], [category]) 
VALUES ('assesser_new_sync_lgus', NULL, 'List of LGUs using new sync facility', NULL, 'ASSESSOR')
go 





ALTER TABLE rpt_syncdata_forsync ADD remote_orgid VARCHAR(15)
go 

INSERT INTO sys_var ([name], [value], [description], [datatype], [category]) 
VALUES ('fileserver_upload_task_active', '0', 'Activate / Deactivate upload task', 'boolean', 'SYSTEM')
go 



INSERT INTO sys_var ([name], [value], [description], [datatype], [category]) 
VALUES ('fileserver_download_task_active', '0', 'Activate / Deactivate download task', 'boolean', 'SYSTEM')
go



CREATE TABLE rpt_syncdata_completed (
  [objid] varchar(255) NOT NULL,
  [idx] int DEFAULT NULL,
  [action] varchar(100) DEFAULT NULL,
  [refno] varchar(50) DEFAULT NULL,
  [refid] varchar(50) DEFAULT NULL,
  [reftype] varchar(50) DEFAULT NULL,
  [parent_orgid] varchar(50) DEFAULT NULL,
  [sender_name] varchar(255) DEFAULT NULL,
  [sender_title] varchar(255) DEFAULT NULL,
  [dtcreated] datetime DEFAULT NULL,
  PRIMARY KEY (objid)
)
go 

CREATE INDEX ix_refno ON rpt_syncdata_completed (refno)
go
CREATE INDEX ix_refid ON rpt_syncdata_completed (refid)
go
CREATE INDEX ix_parent_orgid ON rpt_syncdata_completed (parent_orgid)
go


if exists(select * from sysobjects where id = object_id('vw_landtax_lgu_account_mapping'))
begin 
	drop view vw_landtax_lgu_account_mapping
end 
go

CREATE VIEW vw_landtax_lgu_account_mapping 
AS 
select 
    ia.org_objid AS org_objid,
    ia.org_name AS org_name,
    o.orgclass AS org_class,
    p.objid AS parent_objid,
    p.code AS parent_code,
    p.title AS parent_title,
    ia.objid AS item_objid,
    ia.code AS item_code,
    ia.title AS item_title,
    ia.fund_objid AS item_fund_objid,
    ia.fund_code AS item_fund_code,
    ia.fund_title AS item_fund_title,
    ia.type AS item_type,
    pt.tag AS item_tag 
from itemaccount ia 
    inner join itemaccount p on ia.parentid = p.objid 
    inner join itemaccount_tag pt on p.objid = pt.acctid 
    inner join sys_org o on ia.org_objid = o.objid 
where p.state = 'ACTIVE' 
  and ia.state = 'ACTIVE'
go




if exists(select * from sysobjects where id = OBJECT_ID('batchgr_task'))
begin
  drop table batchgr_task
end 
go 
if exists(select * from sysobjects where id = OBJECT_ID('batchgr_item'))
begin
  drop table batchgr_item
end 
go 
if exists(select * from sysobjects where id = OBJECT_ID('batchgr'))
begin
  drop table batchgr
end 
go 

CREATE TABLE batchgr (
  objid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
  ry int NOT NULL,
  lgu_objid varchar(50) NOT NULL,
  barangay_objid varchar(50) NOT NULL,
  rputype varchar(15) DEFAULT NULL,
  classification_objid varchar(50) DEFAULT NULL,
  section varchar(10) DEFAULT NULL,
  memoranda varchar(100) DEFAULT NULL,
  txntype_objid varchar(50) DEFAULT NULL,
  txnno varchar(25) DEFAULT NULL,
  txndate datetime DEFAULT NULL,
  effectivityyear int DEFAULT NULL,
  effectivityqtr int DEFAULT NULL,
  originlgu_objid varchar(50) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go 

create index ix_barangay_objid on batchgr (barangay_objid)
go 
create index ix_state on batchgr (state)
go 
create index fk_lgu_objid on batchgr (lgu_objid)
go 
create index ix_ry on batchgr (ry)
go 
create index ix_txnno on batchgr (txnno)
go 
create index ix_classificationid on batchgr (classification_objid)
go 
create index ix_section on batchgr (section)
go 
  
alter table batchgr add CONSTRAINT batchgr_ibfk_1 FOREIGN KEY (barangay_objid) REFERENCES sys_org (objid)
go 
alter table batchgr add CONSTRAINT batchgr_ibfk_2 FOREIGN KEY (classification_objid) REFERENCES propertyclassification (objid)
go 
alter table batchgr add CONSTRAINT batchgr_ibfk_3 FOREIGN KEY (lgu_objid) REFERENCES sys_org (objid)
go 
alter table batchgr add CONSTRAINT fk_batchgr_barangayid FOREIGN KEY (barangay_objid) REFERENCES sys_org (objid)
go 
alter table batchgr add CONSTRAINT fk_batchgr_classificationid FOREIGN KEY (classification_objid) REFERENCES propertyclassification (objid)
go 
alter table batchgr add CONSTRAINT fk_batchgr_lguid FOREIGN KEY (lgu_objid) REFERENCES sys_org (objid)
go 


CREATE TABLE batchgr_task (
  objid varchar(50) NOT NULL,
  refid varchar(50) DEFAULT NULL,
  parentprocessid varchar(50) DEFAULT NULL,
  state varchar(50) DEFAULT NULL,
  startdate datetime DEFAULT NULL,
  enddate datetime DEFAULT NULL,
  assignee_objid varchar(50) DEFAULT NULL,
  assignee_name varchar(100) DEFAULT NULL,
  assignee_title varchar(80) DEFAULT NULL,
  actor_objid varchar(50) DEFAULT NULL,
  actor_name varchar(100) DEFAULT NULL,
  actor_title varchar(80) DEFAULT NULL,
  message varchar(255) DEFAULT NULL,
  signature text,
  returnedby varchar(100) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go 

create index ix_assignee_objid on batchgr_task (assignee_objid)
go 
create index ix_refid on batchgr_task (refid)
go 
alter table batchgr_task add CONSTRAINT fk_batchgr_task_batchgr FOREIGN KEY (refid) REFERENCES batchgr (objid)
go 

CREATE TABLE batchgr_item (
  objid varchar(50) NOT NULL,
  parent_objid varchar(50) NOT NULL,
  state varchar(50) NOT NULL,
  rputype varchar(15) NOT NULL,
  tdno varchar(50) NOT NULL,
  fullpin varchar(50) NOT NULL,
  pin varchar(50) NOT NULL,
  suffix int NOT NULL,
  newfaasid varchar(50) DEFAULT NULL,
  error text,
  subsuffix int DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go 

create index fk_batchgr_item_batchgr on batchgr_item (parent_objid) 
go 
create index fk_batchgr_item_newfaasid on batchgr_item (newfaasid) 
go 
create index fk_batchgr_item_tdno on batchgr_item (tdno) 
go 
create index fk_batchgr_item_pin on batchgr_item (pin) 
go 
  
alter table batchgr_item add CONSTRAINT batchgr_item_ibfk_1 FOREIGN KEY (parent_objid) REFERENCES batchgr (objid)
go 
alter table batchgr_item add CONSTRAINT batchgr_item_ibfk_2 FOREIGN KEY (objid) REFERENCES faas (objid)
go 
alter table batchgr_item add CONSTRAINT batchgr_item_ibfk_3 FOREIGN KEY (newfaasid) REFERENCES faas (objid)
go 
alter table batchgr_item add CONSTRAINT batchgr_item_ibfk_4 FOREIGN KEY (objid) REFERENCES faas (objid)
go 
alter table batchgr_item add CONSTRAINT fk_batchgr_item_faas FOREIGN KEY (objid) REFERENCES faas (objid)
go 



if exists(select * from sysobjects where id = object_id('vw_batchgr'))
begin 
	drop view vw_batchgr
end 
go


create view vw_batchgr 
as 
select 
    bg.objid AS objid,
    bg.state AS state,
    bg.ry AS ry,
    bg.lgu_objid AS lgu_objid,
    bg.barangay_objid AS barangay_objid,
    bg.rputype AS rputype,
    bg.classification_objid AS classification_objid,
    bg.section AS section,
    bg.memoranda AS memoranda,
    bg.txntype_objid AS txntype_objid,
    bg.txnno AS txnno,
    bg.txndate AS txndate,
    bg.effectivityyear AS effectivityyear,
    bg.effectivityqtr AS effectivityqtr,
    bg.originlgu_objid AS originlgu_objid,
    l.name AS lgu_name,
    b.name AS barangay_name,
    b.pin AS barangay_pin,
    pc.name AS classification_name,
    t.objid AS taskid,
    t.state AS taskstate,
    t.assignee_objid AS assignee_objid 
from batchgr bg join sys_org l on bg.lgu_objid = l.objid 
    left join barangay b on bg.barangay_objid = b.objid 
    left join propertyclassification pc on bg.classification_objid = pc.objid 
    left join batchgr_task t on bg.objid = t.refid and t.enddate is null 
go




if exists(select * from sysobjects where id = object_id('cashreceipt_rpt_share_forposting_repost'))
begin 
	drop table cashreceipt_rpt_share_forposting_repost
end 
go


CREATE TABLE cashreceipt_rpt_share_forposting_repost (
  objid varchar(50) NOT NULL,
  rptpaymentid varchar(50) NOT NULL,
  receiptid varchar(50) NOT NULL,
  receiptdate date NOT NULL,
  rptledgerid varchar(50) NOT NULL,
  PRIMARY KEY (objid)
) 
go 

create UNIQUE index  ux_receiptid_rptledgerid on cashreceipt_rpt_share_forposting_repost(receiptid,rptledgerid)
go 
create index fk_rptshare_repost_rptledgerid on cashreceipt_rpt_share_forposting_repost (rptledgerid)
go 
create index fk_rptshare_repost_cashreceiptid on cashreceipt_rpt_share_forposting_repost (receiptid)
go 
alter table cashreceipt_rpt_share_forposting_repost add CONSTRAINT fk_rptshare_repost_cashreceipt FOREIGN KEY (receiptid) REFERENCES cashreceipt (objid)
go 
alter table cashreceipt_rpt_share_forposting_repost add CONSTRAINT fk_rptshare_repost_rptledger FOREIGN KEY (rptledgerid) REFERENCES rptledger (objid)
go 






/*===================================================== 
	IMPORTANT: BEFORE EXECUTING !!!!

	CHANGE "eor" database name to match the LGUs 
	eor production database name

=======================================================*/

create view vw_landtax_eor 
as 
select * from eor..eor
go


create view vw_landtax_eor_remittance 
as 
select * from eor..eor_remittance
go



CREATE TABLE rpt_syncdata_fordownload (
  objid varchar(255) NOT NULL,
  etag varchar(64) NOT NULL,
  error int NOT NULL,
  PRIMARY KEY (objid)
)
go

create index ix_error on rpt_syncdata_fordownload (error)
go 


create view vw_landtax_abstract_of_collection_detail
as 
select
	liq.objid as liquidationid,
	liq.controldate as liquidationdate,
	rem.objid as remittanceid,
	rem.dtposted as remittancedate,
	cr.objid as receiptid, 
	cr.receiptdate as ordate, 
	cr.receiptno as orno, 
	cr.collector_objid as collectorid,
	rl.objid as rptledgerid,
	rl.fullpin,
	rl.titleno, 
	rl.cadastrallotno, 
	rl.rputype, 
	rl.totalmv, 
	b.name as barangay, 
	rp.fromqtr,
  rp.toqtr,
  rpi.year,
	rpi.qtr,
	rpi.revtype,
	case when cv.objid is null then rl.owner_name else '*** voided ***' end as taxpayername, 
	case when cv.objid is null then rl.tdno else '' end as tdno, 
	case when m.name is null then c.name else m.name end as municityname, 
	case when cv.objid is null  then rl.classcode else '' end as classification, 
	case when cv.objid is null then rl.totalav else 0.0 end as assessvalue,
	case when cv.objid is null then rl.totalav else 0.0 end as assessedvalue,
	case when cv.objid is null  and rpi.revtype = 'basic' and rpi.revperiod in ('current','advance') then rpi.amount else 0.0 end as basiccurrentyear,
	case when cv.objid is null  and rpi.revtype = 'basic' and rpi.revperiod in ('previous','prior') then rpi.amount else 0.0 end as basicpreviousyear,
	case when cv.objid is null  and rpi.revtype = 'basic' then rpi.discount else 0.0 end as basicdiscount,
	case when cv.objid is null  and rpi.revtype = 'basic' and rpi.revperiod in ('current','advance') then rpi.interest else 0.0 end as basicpenaltycurrent,
	case when cv.objid is null  and rpi.revtype = 'basic' and rpi.revperiod in ('previous','prior') then rpi.interest else 0.0 end as basicpenaltyprevious,

	case when cv.objid is null  and rpi.revtype = 'sef' and rpi.revperiod in ('current','advance') then rpi.amount else 0.0 end as sefcurrentyear,
	case when cv.objid is null  and rpi.revtype = 'sef' and rpi.revperiod in ('previous','prior') then rpi.amount else 0.0 end as sefpreviousyear,
	case when cv.objid is null  and rpi.revtype = 'sef' then rpi.discount else 0.0 end as sefdiscount,
	case when cv.objid is null  and rpi.revtype = 'sef' and rpi.revperiod in ('current','advance') then rpi.interest else 0.0 end as sefpenaltycurrent,
	case when cv.objid is null  and rpi.revtype = 'sef' and rpi.revperiod in ('previous','prior') then rpi.interest else 0.0 end as sefpenaltyprevious,

	case when cv.objid is null  and rpi.revtype = 'basicidle' and rpi.revperiod in ('current','advance') then rpi.amount else 0.0 end as basicidlecurrent,
	case when cv.objid is null  and rpi.revtype = 'basicidle' and rpi.revperiod in ('previous','prior') then rpi.amount else 0.0 end as basicidleprevious,
	case when cv.objid is null  and rpi.revtype = 'basicidle' then rpi.amount else 0.0 end as basicidlediscount,
	case when cv.objid is null  and rpi.revtype = 'basicidle' and rpi.revperiod in ('current','advance') then rpi.interest else 0.0 end as basicidlecurrentpenalty,
	case when cv.objid is null  and rpi.revtype = 'basicidle' and rpi.revperiod in ('previous','prior') then rpi.interest else 0.0 end as basicidlepreviouspenalty,

	
	case when cv.objid is null  and rpi.revtype = 'sh' and rpi.revperiod in ('current','advance') then rpi.amount else 0.0 end as shcurrent,
	case when cv.objid is null  and rpi.revtype = 'sh' and rpi.revperiod in ('previous','prior') then rpi.amount else 0.0 end as shprevious,
	case when cv.objid is null  and rpi.revtype = 'sh' then rpi.discount else 0.0 end as shdiscount,
	case when cv.objid is null  and rpi.revtype = 'sh' and rpi.revperiod in ('current','advance') then rpi.interest else 0.0 end as shcurrentpenalty,
	case when cv.objid is null  and rpi.revtype = 'sh' and rpi.revperiod in ('previous','prior') then rpi.interest else 0.0 end as shpreviouspenalty,

	case when cv.objid is null and rpi.revtype = 'firecode' then rpi.amount else 0.0 end as firecode,
	
	case 
			when cv.objid is null 
			then rpi.amount - rpi.discount + rpi.interest 
			else 0.0 
	end as total,
	case when cv.objid is null then rpi.partialled else 0 end as partialled
from collectionvoucher liq
	inner join remittance rem on rem.collectionvoucherid = liq.objid 
	inner join cashreceipt cr on rem.objid = cr.remittanceid
	left join cashreceipt_void cv on cr.objid = cv.receiptid 
	inner join rptpayment rp on rp.receiptid= cr.objid 
	inner join rptpayment_item rpi on rpi.parentid = rp.objid
	inner join rptledger rl on rl.objid = rp.refid
	inner join barangay b on b.objid  = rl.barangayid
	left join district d on b.parentid = d.objid 
	left join city c on d.parentid = c.objid 
	left join municipality m on b.parentid = m.objid 
go


create view vw_landtax_abstract_of_collection_detail_eor
as 
select
	rem.objid as liquidationid,
	rem.controldate as liquidationdate,
	rem.objid as remittanceid,
	rem.controldate as remittancedate,
	eor.objid as receiptid, 
	eor.receiptdate as ordate, 
	eor.receiptno as orno, 
	rem.createdby_objid as collectorid,
	rl.objid as rptledgerid,
	rl.fullpin,
	rl.titleno, 
	rl.cadastrallotno, 
	rl.rputype, 
	rl.totalmv, 
	b.name as barangay, 
	rp.fromqtr,
  rp.toqtr,
  rpi.year,
	rpi.qtr,
	rpi.revtype,
	case when cv.objid is null then rl.owner_name else '*** voided ***' end as taxpayername, 
	case when cv.objid is null then rl.tdno else '' end as tdno, 
	case when m.name is null then c.name else m.name end as municityname, 
	case when cv.objid is null  then rl.classcode else '' end as classification, 
	case when cv.objid is null then rl.totalav else 0.0 end as assessvalue,
	case when cv.objid is null then rl.totalav else 0.0 end as assessedvalue,
	case when cv.objid is null  and rpi.revtype = 'basic' and rpi.revperiod in ('current','advance') then rpi.amount else 0.0 end as basiccurrentyear,
	case when cv.objid is null  and rpi.revtype = 'basic' and rpi.revperiod in ('previous','prior') then rpi.amount else 0.0 end as basicpreviousyear,
	case when cv.objid is null  and rpi.revtype = 'basic' then rpi.discount else 0.0 end as basicdiscount,
	case when cv.objid is null  and rpi.revtype = 'basic' and rpi.revperiod in ('current','advance') then rpi.interest else 0.0 end as basicpenaltycurrent,
	case when cv.objid is null  and rpi.revtype = 'basic' and rpi.revperiod in ('previous','prior') then rpi.interest else 0.0 end as basicpenaltyprevious,

	case when cv.objid is null  and rpi.revtype = 'sef' and rpi.revperiod in ('current','advance') then rpi.amount else 0.0 end as sefcurrentyear,
	case when cv.objid is null  and rpi.revtype = 'sef' and rpi.revperiod in ('previous','prior') then rpi.amount else 0.0 end as sefpreviousyear,
	case when cv.objid is null  and rpi.revtype = 'sef' then rpi.discount else 0.0 end as sefdiscount,
	case when cv.objid is null  and rpi.revtype = 'sef' and rpi.revperiod in ('current','advance') then rpi.interest else 0.0 end as sefpenaltycurrent,
	case when cv.objid is null  and rpi.revtype = 'sef' and rpi.revperiod in ('previous','prior') then rpi.interest else 0.0 end as sefpenaltyprevious,

	case when cv.objid is null  and rpi.revtype = 'basicidle' and rpi.revperiod in ('current','advance') then rpi.amount else 0.0 end as basicidlecurrent,
	case when cv.objid is null  and rpi.revtype = 'basicidle' and rpi.revperiod in ('previous','prior') then rpi.amount else 0.0 end as basicidleprevious,
	case when cv.objid is null  and rpi.revtype = 'basicidle' then rpi.amount else 0.0 end as basicidlediscount,
	case when cv.objid is null  and rpi.revtype = 'basicidle' and rpi.revperiod in ('current','advance') then rpi.interest else 0.0 end as basicidlecurrentpenalty,
	case when cv.objid is null  and rpi.revtype = 'basicidle' and rpi.revperiod in ('previous','prior') then rpi.interest else 0.0 end as basicidlepreviouspenalty,

	
	case when cv.objid is null  and rpi.revtype = 'sh' and rpi.revperiod in ('current','advance') then rpi.amount else 0.0 end as shcurrent,
	case when cv.objid is null  and rpi.revtype = 'sh' and rpi.revperiod in ('previous','prior') then rpi.amount else 0.0 end as shprevious,
	case when cv.objid is null  and rpi.revtype = 'sh' then rpi.discount else 0.0 end as shdiscount,
	case when cv.objid is null  and rpi.revtype = 'sh' and rpi.revperiod in ('current','advance') then rpi.interest else 0.0 end as shcurrentpenalty,
	case when cv.objid is null  and rpi.revtype = 'sh' and rpi.revperiod in ('previous','prior') then rpi.interest else 0.0 end as shpreviouspenalty,

	case when cv.objid is null and rpi.revtype = 'firecode' then rpi.amount else 0.0 end as firecode,
	
	case 
			when cv.objid is null 
			then rpi.amount - rpi.discount + rpi.interest 
			else 0.0 
	end as total,
	case when cv.objid is null then rpi.partialled else 0 end as partialled
from vw_landtax_eor_remittance rem
	inner join vw_landtax_eor eor on rem.objid = eor.remittanceid 
	left join cashreceipt_void cv on eor.objid = cv.receiptid 
	inner join rptpayment rp on eor.objid = rp.receiptid 
	inner join rptpayment_item rpi on rpi.parentid = rp.objid
	inner join rptledger rl on rl.objid = rp.refid
	inner join barangay b on b.objid  = rl.barangayid
	left join district d on b.parentid = d.objid 
	left join city c on d.parentid = c.objid 
	left join municipality m on b.parentid = m.objid 
go



create view vw_landtax_collection_detail
as 
select 
	cv.objid as liquidationid,
	cv.controldate as liquidationdate,
	rem.objid as remittanceid,
	rem.controldate as remittancedate,
	cr.receiptdate,
	o.objid as lguid,
	o.name as lgu,
	b.objid as barangayid,
	b.indexno as brgyindex,
	b.name as barangay,
	ri.revperiod,
	ri.revtype,
	ri.year,
	ri.qtr,
	ri.amount,
	ri.interest,
	ri.discount,
  pc.name as classname, 
	pc.orderno, 
	pc.special,  
  case when ri.revperiod='current' and ri.revtype = 'basic' then ri.amount else 0.0 end  as basiccurrent,
  case when ri.revtype = 'basic' then ri.discount else 0.0 end  as basicdisc,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'basic'  then ri.amount else 0.0 end  as basicprev,
  case when ri.revperiod='current' and ri.revtype = 'basic'  then ri.interest else 0.0 end  as basiccurrentint,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'basic'  then ri.interest else 0.0 end  as basicprevint,
  case when ri.revtype = 'basic' then ri.amount - ri.discount+ ri.interest else 0 end as basicnet, 

  case when ri.revperiod='current' and ri.revtype = 'sef' then ri.amount else 0.0 end  as sefcurrent,
  case when ri.revtype = 'sef' then ri.discount else 0.0 end  as sefdisc,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'sef'  then ri.amount else 0.0 end  as sefprev,
  case when ri.revperiod='current' and ri.revtype = 'sef'  then ri.interest else 0.0 end  as sefcurrentint,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'sef'  then ri.interest else 0.0 end  as sefprevint,
  case when ri.revtype = 'sef' then ri.amount - ri.discount+ ri.interest else 0 end as sefnet, 

  case when ri.revperiod='current' and ri.revtype = 'basicidle' then ri.amount else 0.0 end  as idlecurrent,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'basicidle'  then ri.amount else 0.0 end  as idleprev,
  case when ri.revtype = 'basicidle' then ri.discount else 0.0 end  as idledisc,
  case when ri.revtype = 'basicidle' then ri.interest else 0 end   as idleint, 
  case when ri.revtype = 'basicidle'then ri.amount - ri.discount + ri.interest else 0 end as idlenet, 

  case when ri.revperiod='current' and ri.revtype = 'sh' then ri.amount else 0.0 end  as shcurrent,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'sh' then ri.amount else 0.0 end  as shprev,
  case when ri.revtype = 'sh' then ri.discount else 0.0 end  as shdisc,
  case when ri.revtype = 'sh' then ri.interest else 0 end  as shint, 
  case when ri.revtype = 'sh' then ri.amount - ri.discount + ri.interest else 0 end as shnet, 

  case when ri.revtype = 'firecode' then ri.amount - ri.discount + ri.interest else 0 end  as firecode,

  0.0 as levynet 
from remittance rem 
  inner join collectionvoucher cv on cv.objid = rem.collectionvoucherid 
  inner join cashreceipt cr on cr.remittanceid = rem.objid 
  left join cashreceipt_void crv on cr.objid = crv.receiptid
  inner join rptpayment rp on cr.objid = rp.receiptid 
  inner join rptpayment_item ri on rp.objid = ri.parentid
  left join rptledger rl ON rp.refid = rl.objid  
	left join barangay b on rl.barangayid = b.objid 
	left join sys_org o on rl.lguid = o.objid  
  left join propertyclassification pc ON rl.classification_objid = pc.objid 
where crv.objid is null 
go


create view vw_landtax_collection_disposition_detail
as 
select   
	cv.objid as liquidationid,
	cv.controldate as liquidationdate,
	rem.objid as remittanceid,
	rem.controldate as remittancedate,
	cr.receiptdate,
	ri.revperiod,
    case when ri.revtype in ('basic', 'basicint', 'basicidle', 'basicidleint') and ri.sharetype in ('province', 'city') then ri.amount else 0.0 end as provcitybasicshare,
    case when ri.revtype in ('basic', 'basicint', 'basicidle', 'basicidleint') and ri.sharetype in ('municipality') then ri.amount else 0.0 end as munibasicshare,
    case when ri.revtype in ('basic', 'basicint') and ri.sharetype in ('barangay') then ri.amount else 0.0 end as brgybasicshare,
    case when ri.revtype in ('sef', 'sefint') and ri.sharetype in ('province', 'city') then ri.amount else 0.0 end as provcitysefshare,
    case when ri.revtype in ('sef', 'sefint') and ri.sharetype in ('municipality') then ri.amount else 0.0 end as munisefshare,
    0.0 as brgysefshare 
  from remittance rem 
    inner join collectionvoucher cv on cv.objid = rem.collectionvoucherid 
    inner join cashreceipt cr on cr.remittanceid = rem.objid 
		left join cashreceipt_void crv on cr.objid = crv.receiptid 
    inner join rptpayment rp on cr.objid = rp.receiptid 
    inner join rptpayment_share ri on rp.objid = ri.parentid
  where crv.objid is null 
go




    


create view vw_landtax_collection_detail_eor
as 
select 
	rem.objid as liquidationid,
	rem.controldate as liquidationdate,
	rem.objid as remittanceid,
	rem.controldate as remittancedate,
	eor.receiptdate,
	o.objid as lguid,
	o.name as lgu,
	b.objid as barangayid,
	b.indexno as brgyindex,
	b.name as barangay,
	ri.revperiod,
	ri.revtype,
	ri.year,
	ri.qtr,
	ri.amount,
	ri.interest,
	ri.discount,
  pc.name as classname, 
	pc.orderno, 
	pc.special,  
  case when ri.revperiod='current' and ri.revtype = 'basic' then ri.amount else 0.0 end  as basiccurrent,
  case when ri.revtype = 'basic' then ri.discount else 0.0 end  as basicdisc,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'basic'  then ri.amount else 0.0 end  as basicprev,
  case when ri.revperiod='current' and ri.revtype = 'basic'  then ri.interest else 0.0 end  as basiccurrentint,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'basic'  then ri.interest else 0.0 end  as basicprevint,
  case when ri.revtype = 'basic' then ri.amount - ri.discount+ ri.interest else 0 end as basicnet, 

  case when ri.revperiod='current' and ri.revtype = 'sef' then ri.amount else 0.0 end  as sefcurrent,
  case when ri.revtype = 'sef' then ri.discount else 0.0 end  as sefdisc,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'sef'  then ri.amount else 0.0 end  as sefprev,
  case when ri.revperiod='current' and ri.revtype = 'sef'  then ri.interest else 0.0 end  as sefcurrentint,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'sef'  then ri.interest else 0.0 end  as sefprevint,
  case when ri.revtype = 'sef' then ri.amount - ri.discount+ ri.interest else 0 end as sefnet, 

  case when ri.revperiod='current' and ri.revtype = 'basicidle' then ri.amount else 0.0 end  as idlecurrent,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'basicidle'  then ri.amount else 0.0 end  as idleprev,
  case when ri.revtype = 'basicidle' then ri.discount else 0.0 end  as idledisc,
  case when ri.revtype = 'basicidle' then ri.interest else 0 end   as idleint, 
  case when ri.revtype = 'basicidle'then ri.amount - ri.discount + ri.interest else 0 end as idlenet, 

  case when ri.revperiod='current' and ri.revtype = 'sh' then ri.amount else 0.0 end  as shcurrent,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'sh' then ri.amount else 0.0 end  as shprev,
  case when ri.revtype = 'sh' then ri.discount else 0.0 end  as shdisc,
  case when ri.revtype = 'sh' then ri.interest else 0 end  as shint, 
  case when ri.revtype = 'sh' then ri.amount - ri.discount + ri.interest else 0 end as shnet, 

  case when ri.revtype = 'firecode' then ri.amount - ri.discount + ri.interest else 0 end  as firecode,

  0.0 as levynet 
from vw_landtax_eor_remittance rem 
  inner join vw_landtax_eor eor on rem.objid = eor.remittanceid
  inner join rptpayment rp on eor.objid = rp.receiptid 
  inner join rptpayment_item ri on rp.objid = ri.parentid
  left join rptledger rl ON rp.refid = rl.objid  
	left join barangay b on rl.barangayid = b.objid 
	left join sys_org o on rl.lguid = o.objid  
  left join propertyclassification pc ON rl.classification_objid = pc.objid 
go


create view vw_landtax_collection_disposition_detail_eor
as 
select   
	rem.objid as liquidationid,
	rem.controldate as liquidationdate,
	rem.objid as remittanceid,
	rem.controldate as remittancedate,
	eor.receiptdate,
	ri.revperiod,
    case when ri.revtype in ('basic', 'basicint', 'basicidle', 'basicidleint') and ri.sharetype in ('province', 'city') then ri.amount else 0.0 end as provcitybasicshare,
    case when ri.revtype in ('basic', 'basicint', 'basicidle', 'basicidleint') and ri.sharetype in ('municipality') then ri.amount else 0.0 end as munibasicshare,
    case when ri.revtype in ('basic', 'basicint') and ri.sharetype in ('barangay') then ri.amount else 0.0 end as brgybasicshare,
    case when ri.revtype in ('sef', 'sefint') and ri.sharetype in ('province', 'city') then ri.amount else 0.0 end as provcitysefshare,
    case when ri.revtype in ('sef', 'sefint') and ri.sharetype in ('municipality') then ri.amount else 0.0 end as munisefshare,
    0.0 as brgysefshare 
  from vw_landtax_eor_remittance rem 
    inner join vw_landtax_eor eor on rem.objid = eor.remittanceid
		inner join rptpayment rp on eor.objid = rp.receiptid 
    inner join rptpayment_share ri on rp.objid = ri.parentid
  
go

if exists(select * from sysobjects where id = OBJECT_ID('vw_newly_assessed_property'))
begin
  drop view vw_newly_assessed_property
end 
go 



create view vw_newly_assessed_property as 
select
	f.objid,
	f.owner_name,
	f.tdno,
	b.name as barangay,
	case 
		when f.rputype = 'land' then 'LAND' 
		when f.rputype = 'bldg' then 'BUILDING' 
		when f.rputype = 'mach' then 'MACHINERY' 
		when f.rputype = 'planttree' then 'PLANT/TREE' 
		else 'MISCELLANEOUS'
	end as rputype,
	f.totalav,
	f.effectivityyear
from faas_list f 
	inner join barangay b on f.barangayid = b.objid 
where f.state in ('CURRENT', 'CANCELLED') 
and f.txntype_objid = 'ND'
go 



if exists(select * from sysobjects where id = OBJECT_ID('vw_real_property_payment'))
begin
  drop view vw_real_property_payment
end 
go 


create view vw_real_property_payment as 
select 
	cv.controldate as cv_controldate,
	rem.controldate as rem_controldate,
	rl.owner_name,
	rl.tdno,
	pc.name as classification, 
	case 
		when rl.rputype = 'land' then 'LAND' 
		when rl.rputype = 'bldg' then 'BUILDING' 
		when rl.rputype = 'mach' then 'MACHINERY' 
		when rl.rputype = 'planttree' then 'PLANT/TREE' 
		else 'MISCELLANEOUS'
	end as rputype,
	b.name as barangay,
	rpi.year, 
	rpi.qtr,
	rpi.amount + rpi.interest - rpi.discount as amount,
	case when v.objid is null then 0 else 1 end as voided
from collectionvoucher cv 
	inner join remittance rem on cv.objid = rem.collectionvoucherid
	inner join cashreceipt cr on rem.objid = cr.remittanceid
	inner join rptpayment rp on cr.objid = rp.receiptid 
	inner join rptpayment_item rpi on rp.objid = rpi.parentid 
	inner join rptledger rl on rp.refid = rl.objid 
	inner join barangay b on rl.barangayid = b.objid 
	inner join propertyclassification pc on rl.classification_objid = pc.objid 
	left join cashreceipt_void v on cr.objid = v.receiptid
go 





if exists(select * from sysobjects where id = OBJECT_ID('vw_rptledger_cancelled_faas'))
begin
  drop view vw_rptledger_cancelled_faas
end 
go 

create view vw_rptledger_cancelled_faas 
as 
select 
	rl.objid,
	rl.state,
	rl.faasid,
	rl.lastyearpaid,
	rl.lastqtrpaid,
	rl.barangayid,
	rl.taxpayer_objid,
	rl.fullpin,
	rl.tdno,
	rl.cadastrallotno,
	rl.rputype,
	rl.txntype_objid,
	rl.classification_objid,
	rl.classcode,
	rl.totalav,
	rl.totalmv,
	rl.totalareaha,
	rl.taxable,
	rl.owner_name,
	rl.prevtdno,
	rl.titleno,
	rl.administrator_name,
	rl.blockno,
	rl.lguid,
	rl.beneficiary_objid,
	pc.name as classification,
	b.name as barangay,
	o.name as lgu
from rptledger rl 
	inner join faas f on rl.faasid = f.objid 
	left join barangay b on rl.barangayid = b.objid 
	left join sys_org o on rl.lguid = o.objid 
	left join propertyclassification pc on rl.classification_objid = pc.objid 
	inner join entity e on rl.taxpayer_objid = e.objid 
where rl.state = 'APPROVED' 
and f.state = 'CANCELLED' 
go





if exists(select * from sysobjects where id = OBJECT_ID('vw_certification_landdetail'))
begin
  drop view vw_certification_landdetail
end 
go 

create view vw_certification_landdetail 
as 
select 
	f.objid as faasid,
	ld.areaha,
	ld.areasqm,
	ld.assessedvalue,
	ld.marketvalue,
	ld.basemarketvalue,
	ld.unitvalue,
	lspc.name as specificclass_name
from faas f 
	inner join landdetail ld on f.rpuid = ld.landrpuid
	inner join landspecificclass lspc on ld.landspecificclass_objid = lspc.objid 
go



if exists(select * from sysobjects where id = OBJECT_ID('vw_certification_land_improvement'))
begin
  drop view vw_certification_land_improvement
end 
go 

create view vw_certification_land_improvement
as 
select 
	f.objid as faasid,
	pt.name as improvement,
	ptd.areacovered,
	ptd.productive,
	ptd.nonproductive,
	ptd.basemarketvalue,
	ptd.marketvalue,
	ptd.unitvalue,
	ptd.assessedvalue
from faas f 
	inner join planttreedetail ptd on f.rpuid = ptd.landrpuid
	inner join planttree pt on ptd.planttree_objid = pt.objid
go




INSERT INTO sys_usergroup ([objid], title, domain, userclass, orgclass, [role]) VALUES ('RPT.CERTIFICATION_APPROVER', 'CERTIFICATION_APPROVER', 'RPT', NULL, NULL, 'CERTIFICATION_APPROVER')
GO 
INSERT INTO sys_usergroup ([objid], title, domain, userclass, orgclass, [role]) VALUES ('RPT.CERTIFICATION_VERIFIER', 'RPT CERTIFICATION_VERIFIER', 'RPT', NULL, NULL, 'CERTIFICATION_VERIFIER')
GO 



delete from sys_wf_transition where processname = 'rptcertification'
go

delete from sys_wf_node where processname = 'rptcertification'
go


INSERT INTO sys_wf_node ([name], processname, title, nodetype, idx, salience, [domain], [role], properties, ui, tracktime) VALUES ('start', 'rptcertification', 'Start', 'start', '1', NULL, NULL, NULL, '[:]', '[fillColor:''#00ff00'',size:[32,32],pos:[102,127],type:''start'']', NULL)
go
INSERT INTO sys_wf_node ([name], processname, title, nodetype, idx, salience, [domain], [role], properties, ui, tracktime) VALUES ('receiver', 'rptcertification', 'Receiver', 'state', '2', NULL, 'RPT', 'CERTIFICATION_ISSUER', '[:]', '[fillColor:''#c0c0c0'',size:[114,40],pos:[206,127],type:''state'']', '1')
go
INSERT INTO sys_wf_node ([name], processname, title, nodetype, idx, salience, [domain], [role], properties, ui, tracktime) VALUES ('verifier', 'rptcertification', 'Verifier', 'state', '3', NULL, 'RPT', 'CERTIFICATION_VERIFIER', '[:]', '[fillColor:''#c0c0c0'',size:[129,44],pos:[412,127],type:''state'']', '1')
go
INSERT INTO sys_wf_node ([name], processname, title, nodetype, idx, salience, [domain], [role], properties, ui, tracktime) VALUES ('approver', 'rptcertification', 'Approver', 'state', '4', NULL, 'RPT', 'CERTIFICATION_APPROVER', '[:]', '[fillColor:''#c0c0c0'',size:[118,42],pos:[604,141],type:''state'']', '1')
go
INSERT INTO sys_wf_node ([name], processname, title, nodetype, idx, salience, [domain], [role], properties, ui, tracktime) VALUES ('approved', 'rptcertification', 'Approved', 'end', '5', NULL, NULL, NULL, '[:]', '[fillColor:''#ff0000'',size:[32,32],pos:[797,148],type:''end'']', NULL)
go

INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, caption, ui) VALUES ('start', 'rptcertification', 'assign', 'receiver', '1', NULL, '[:]', NULL, 'Assign', '[size:[72,0],pos:[134,142],type:''arrow'',points:[134,142,206,142]]')
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, caption, ui) VALUES ('receiver', 'rptcertification', 'cancelissuance', 'end', '5', NULL, '[caption:''Cancel Issuance'', confirm:''Cancel issuance?'',closeonend:true]', NULL, 'Cancel Issuance', '[size:[559,116],pos:[258,32],type:''arrow'',points:[262,127,258,32,817,40,813,148]]')
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, caption, ui) VALUES ('receiver', 'rptcertification', 'submit', 'verifier', '6', NULL, '[caption:''Submit to Verifier'', confirm:''Submit to verifier?'', messagehandler:''rptmessage:info'',targetrole:''RPT.CERTIFICATION_VERIFIER'']', NULL, 'Submit to Verifier', '[size:[92,0],pos:[320,146],type:''arrow'',points:[320,146,412,146]]')
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, caption, ui) VALUES ('verifier', 'rptcertification', 'return_receiver', 'receiver', '10', NULL, '[caption:''Return to Issuer'', confirm:''Return to issuer?'', messagehandler:''default'']', NULL, 'Return to Receiver', '[size:[160,63],pos:[292,64],type:''arrow'',points:[452,127,385,64,292,127]]')
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, caption, ui) VALUES ('verifier', 'rptcertification', 'submit', 'approver', '11', NULL, '[caption:''Submit for Approval'', confirm:''Submit for approval?'', messagehandler:''rptmessage:sign'',targetrole:''RPT.CERTIFICATION_APPROVER'']', NULL, 'Submit to Approver', '[size:[63,4],pos:[541,152],type:''arrow'',points:[541,152,604,156]]')
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, caption, ui) VALUES ('approver', 'rptcertification', 'return_receiver', 'receiver', '15', NULL, '[caption:''Return to Issuer'', confirm:''Return to issuer?'', messagehandler:''default'']', NULL, 'Return to Receiver', '[size:[333,113],pos:[285,167],type:''arrow'',points:[618,183,414,280,285,167]]')
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, caption, ui) VALUES ('approver', 'rptcertification', 'submit', 'approved', '16', NULL, '[caption:''Approve'', confirm:''Approve?'', messagehandler:''rptmessage:sign'']', NULL, 'Approve', '[size:[75,0],pos:[722,162],type:''arrow'',points:[722,162,797,162]]')
go



if exists(select * from sysobjects where id = object_id('rpt_syncdata_item_completed'))
begin 
  drop table rpt_syncdata_item_completed
end 
go 
if exists(select * from sysobjects where id = object_id('rpt_syncdata_completed'))
begin 
  drop table rpt_syncdata_completed
end 
go 
if exists(select * from sysobjects where id = object_id('rpt_syncdata_item'))
begin 
  drop table rpt_syncdata_item
end 
go 
if exists(select * from sysobjects where id = object_id('rpt_syncdata_forsync'))
begin 
  drop table rpt_syncdata_forsync
end 
go 
if exists(select * from sysobjects where id = object_id('rpt_syncdata_fordownload'))
begin 
  drop table rpt_syncdata_fordownload
end 
go 
if exists(select * from sysobjects where id = object_id('rpt_syncdata_error'))
begin 
  drop table rpt_syncdata_error
end 
go 
if exists(select * from sysobjects where id = object_id('rpt_syncdata'))
begin 
  drop table rpt_syncdata
end 
go 


CREATE TABLE rpt_syncdata (
  objid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
  refid varchar(50) NOT NULL,
  reftype varchar(50) NOT NULL,
  refno varchar(50) NOT NULL,
  action varchar(50) NOT NULL,
  dtfiled datetime NOT NULL,
  orgid varchar(50) NOT NULL,
  remote_orgid varchar(50) DEFAULT NULL,
  remote_orgcode varchar(5) DEFAULT NULL,
  remote_orgclass varchar(25) DEFAULT NULL,
  sender_objid varchar(50) DEFAULT NULL,
  sender_name varchar(255) DEFAULT NULL,
  sender_title varchar(80) DEFAULT NULL,
  info text,
  PRIMARY KEY (objid)
)
go 

create index ix_state on rpt_syncdata (state)
go 
create index ix_refid on rpt_syncdata (refid)
go 
create index ix_refno on rpt_syncdata (refno)
go 
create index ix_orgid on rpt_syncdata (orgid)
go 


CREATE TABLE rpt_syncdata_completed (
  objid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
  refid varchar(50) NOT NULL,
  reftype varchar(50) NOT NULL,
  refno varchar(50) NOT NULL,
  action varchar(50) NOT NULL,
  dtfiled datetime NOT NULL,
  orgid varchar(50) NOT NULL,
  remote_orgid varchar(50) DEFAULT NULL,
  remote_orgcode varchar(5) DEFAULT NULL,
  remote_orgclass varchar(25) DEFAULT NULL,
  sender_objid varchar(50) DEFAULT NULL,
  sender_name varchar(255) DEFAULT NULL,
  sender_title varchar(80) DEFAULT NULL,
  info text,
  PRIMARY KEY (objid)
) 
go 

create index ix_state on rpt_syncdata_completed (state)
go 
create index ix_refid on rpt_syncdata_completed (refid)
go 
create index ix_refno on rpt_syncdata_completed (refno)
go 
create index ix_orgid on rpt_syncdata_completed (orgid)
go 

CREATE TABLE rpt_syncdata_item (
  objid varchar(50) NOT NULL,
  parentid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
  refid varchar(50) NOT NULL,
  reftype varchar(50) NOT NULL,
  refno varchar(50) NOT NULL,
  action varchar(50) NOT NULL,
  idx int NOT NULL,
  info text,
  error text,
  filekey varchar(1200) DEFAULT NULL,
  etag varchar(255) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go 

create index ix_parentid on rpt_syncdata_item (parentid)
go 
create index ix_state on rpt_syncdata_item (state)
go 
create index ix_refid on rpt_syncdata_item (refid)
go 
create index ix_refno on rpt_syncdata_item (refno)
go 
alter table rpt_syncdata_item add CONSTRAINT FK_parentid_rpt_syncdata FOREIGN KEY (parentid) REFERENCES rpt_syncdata (objid)
go 

CREATE TABLE rpt_syncdata_item_completed (
  objid varchar(255) NOT NULL,
  parentid varchar(50) NOT NULL,
  state varchar(50) DEFAULT NULL,
  refid varchar(50) DEFAULT NULL,
  reftype varchar(50) DEFAULT NULL,
  refno varchar(50) DEFAULT NULL,
  action varchar(100) DEFAULT NULL,
  idx int DEFAULT NULL,
  info text,
  error text,
  PRIMARY KEY (objid)
) 
go 


create index ix_refno on rpt_syncdata_item_completed (refno)
go 
create index ix_refid on rpt_syncdata_item_completed (refid)
go 
create index ix_remote_orgid on rpt_syncdata_item_completed (parentid)
go 

CREATE TABLE rpt_syncdata_forsync (
  objid varchar(50) NOT NULL,
  reftype varchar(50) NOT NULL,
  refno varchar(50) NOT NULL,
  action varchar(50) NOT NULL,
  orgid varchar(50) NOT NULL,
  dtfiled datetime NOT NULL,
  createdby_objid varchar(50) DEFAULT NULL,
  createdby_name varchar(255) DEFAULT NULL,
  createdby_title varchar(50) DEFAULT NULL,
  remote_orgid varchar(15) DEFAULT NULL,
  state varchar(25) DEFAULT NULL,
  info text,
  PRIMARY KEY (objid)
  
)
go 

create index ix_refno on rpt_syncdata_forsync (refno)
go 
create index ix_orgid on rpt_syncdata_forsync (orgid)
go 
create index ix_state on rpt_syncdata_forsync (state)
go 

CREATE TABLE rpt_syncdata_fordownload (
  objid varchar(255) NOT NULL,
  etag varchar(64) NOT NULL,
  error int NOT NULL,
  state varchar(50) DEFAULT NULL,
  PRIMARY KEY (objid)
)
go 

create index ix_error on rpt_syncdata_fordownload (error)
go 

CREATE TABLE rpt_syncdata_error (
  objid varchar(50) NOT NULL,
  filekey varchar(1000) NOT NULL,
  error text,
  refid varchar(50) NOT NULL,
  reftype varchar(50) NOT NULL,
  refno varchar(50) NOT NULL,
  action varchar(50) NOT NULL,
  idx int NOT NULL,
  info text,
  parent text,
  remote_orgid varchar(50) DEFAULT NULL,
  remote_orgcode varchar(5) DEFAULT NULL,
  remote_orgclass varchar(50) DEFAULT NULL,
  state varchar(50) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go 

create index ix_refid on rpt_syncdata_error (refid)
go 
create index ix_refno on rpt_syncdata_error (refno)
go 
create index ix_filekey on rpt_syncdata_error (filekey)
go 
create index ix_remote_orgid on rpt_syncdata_error (remote_orgid)
go 
create index ix_remote_orgcode on rpt_syncdata_error (remote_orgcode)
go 
create index ix_state on rpt_syncdata_error (state)
go 





alter table rpu add stewardparentrpumasterid varchar(50)
go 

if exists(select * from sysobjects where id = object_id('vw_landtax_report_rptdelinquency_detail'))
begin 
  drop view vw_landtax_report_rptdelinquency_detail
end 
go 

if exists(select * from sysobjects where id = object_id('vw_landtax_report_rptdelinquency'))
begin 
  drop view vw_landtax_report_rptdelinquency
end 
go 


CREATE VIEW vw_landtax_report_rptdelinquency_detail AS select ri.objid AS objid,ri.rptledgerid AS rptledgerid,ri.barangayid AS barangayid,ri.year AS year,ri.qtr AS qtr,r.dtgenerated AS dtgenerated,r.dtcomputed AS dtcomputed,r.generatedby_name AS generatedby_name,r.generatedby_title AS generatedby_title,(case when (ri.revtype = 'basic') then ri.amount else 0 end) AS basic,(case when (ri.revtype = 'basic') then ri.interest else 0 end) AS basicint,(case when (ri.revtype = 'basic') then ri.discount else 0 end) AS basicdisc,(case when (ri.revtype = 'basic') then (ri.interest - ri.discount) else 0 end) AS basicdp,(case when (ri.revtype = 'basic') then ((ri.amount + ri.interest) - ri.discount) else 0 end) AS basicnet,(case when (ri.revtype = 'basicidle') then ri.amount else 0 end) AS basicidle,(case when (ri.revtype = 'basicidle') then ri.interest else 0 end) AS basicidleint,(case when (ri.revtype = 'basicidle') then ri.discount else 0 end) AS basicidledisc,(case when (ri.revtype = 'basicidle') then (ri.interest - ri.discount) else 0 end) AS basicidledp,(case when (ri.revtype = 'basicidle') then ((ri.amount + ri.interest) - ri.discount) else 0 end) AS basicidlenet,(case when (ri.revtype = 'sef') then ri.amount else 0 end) AS sef,(case when (ri.revtype = 'sef') then ri.interest else 0 end) AS sefint,(case when (ri.revtype = 'sef') then ri.discount else 0 end) AS sefdisc,(case when (ri.revtype = 'sef') then (ri.interest - ri.discount) else 0 end) AS sefdp,(case when (ri.revtype = 'sef') then ((ri.amount + ri.interest) - ri.discount) else 0 end) AS sefnet,(case when (ri.revtype = 'firecode') then ri.amount else 0 end) AS firecode,(case when (ri.revtype = 'firecode') then ri.interest else 0 end) AS firecodeint,(case when (ri.revtype = 'firecode') then ri.discount else 0 end) AS firecodedisc,(case when (ri.revtype = 'firecode') then (ri.interest - ri.discount) else 0 end) AS firecodedp,(case when (ri.revtype = 'firecode') then ((ri.amount + ri.interest) - ri.discount) else 0 end) AS firecodenet,(case when (ri.revtype = 'sh') then ri.amount else 0 end) AS sh,(case when (ri.revtype = 'sh') then ri.interest else 0 end) AS shint,(case when (ri.revtype = 'sh') then ri.discount else 0 end) AS shdisc,(case when (ri.revtype = 'sh') then (ri.interest - ri.discount) else 0 end) AS shdp,(case when (ri.revtype = 'sh') then ((ri.amount + ri.interest) - ri.discount) else 0 end) AS shnet,((ri.amount + ri.interest) - ri.discount) AS total from (report_rptdelinquency_item ri join report_rptdelinquency r on((ri.parentid = r.objid)))
go 

CREATE VIEW vw_landtax_report_rptdelinquency AS select ri.objid AS objid,ri.rptledgerid AS rptledgerid,ri.barangayid AS barangayid,ri.year AS year,ri.qtr AS qtr,r.dtgenerated AS dtgenerated,r.dtcomputed AS dtcomputed,r.generatedby_name AS generatedby_name,r.generatedby_title AS generatedby_title,(case when (ri.revtype = 'basic') then ri.amount else 0 end) AS basic,(case when (ri.revtype = 'basic') then ri.interest else 0 end) AS basicint,(case when (ri.revtype = 'basic') then ri.discount else 0 end) AS basicdisc,(case when (ri.revtype = 'basic') then (ri.interest - ri.discount) else 0 end) AS basicdp,(case when (ri.revtype = 'basic') then ((ri.amount + ri.interest) - ri.discount) else 0 end) AS basicnet,(case when (ri.revtype = 'basicidle') then ri.amount else 0 end) AS basicidle,(case when (ri.revtype = 'basicidle') then ri.interest else 0 end) AS basicidleint,(case when (ri.revtype = 'basicidle') then ri.discount else 0 end) AS basicidledisc,(case when (ri.revtype = 'basicidle') then (ri.interest - ri.discount) else 0 end) AS basicidledp,(case when (ri.revtype = 'basicidle') then ((ri.amount + ri.interest) - ri.discount) else 0 end) AS basicidlenet,(case when (ri.revtype = 'sef') then ri.amount else 0 end) AS sef,(case when (ri.revtype = 'sef') then ri.interest else 0 end) AS sefint,(case when (ri.revtype = 'sef') then ri.discount else 0 end) AS sefdisc,(case when (ri.revtype = 'sef') then (ri.interest - ri.discount) else 0 end) AS sefdp,(case when (ri.revtype = 'sef') then ((ri.amount + ri.interest) - ri.discount) else 0 end) AS sefnet,(case when (ri.revtype = 'firecode') then ri.amount else 0 end) AS firecode,(case when (ri.revtype = 'firecode') then ri.interest else 0 end) AS firecodeint,(case when (ri.revtype = 'firecode') then ri.discount else 0 end) AS firecodedisc,(case when (ri.revtype = 'firecode') then (ri.interest - ri.discount) else 0 end) AS firecodedp,(case when (ri.revtype = 'firecode') then ((ri.amount + ri.interest) - ri.discount) else 0 end) AS firecodenet,(case when (ri.revtype = 'sh') then ri.amount else 0 end) AS sh,(case when (ri.revtype = 'sh') then ri.interest else 0 end) AS shint,(case when (ri.revtype = 'sh') then ri.discount else 0 end) AS shdisc,(case when (ri.revtype = 'sh') then (ri.interest - ri.discount) else 0 end) AS shdp,(case when (ri.revtype = 'sh') then ((ri.amount + ri.interest) - ri.discount) else 0 end) AS shnet,((ri.amount + ri.interest) - ri.discount) AS total from (report_rptdelinquency_item ri join report_rptdelinquency r on((ri.parentid = r.objid)))
go 


if exists(select * from sysobjects where id = object_id('vw_rptpayment_item_detail'))
begin 
  drop view vw_rptpayment_item_detail
end 
go 

CREATE VIEW vw_rptpayment_item_detail AS select rpi.objid AS objid,rpi.parentid AS parentid,rpi.rptledgerfaasid AS rptledgerfaasid,rpi.year AS year,rpi.qtr AS qtr,rpi.revperiod AS revperiod,(case when (rpi.revtype = 'basic') then rpi.amount else 0 end) AS basic,(case when (rpi.revtype = 'basic') then rpi.interest else 0 end) AS basicint,(case when (rpi.revtype = 'basic') then rpi.discount else 0 end) AS basicdisc,(case when (rpi.revtype = 'basic') then (rpi.interest - rpi.discount) else 0 end) AS basicdp,(case when (rpi.revtype = 'basic') then ((rpi.amount + rpi.interest) - rpi.discount) else 0 end) AS basicnet,(case when (rpi.revtype = 'basicidle') then ((rpi.amount + rpi.interest) - rpi.discount) else 0 end) AS basicidle,(case when (rpi.revtype = 'basicidle') then rpi.interest else 0 end) AS basicidleint,(case when (rpi.revtype = 'basicidle') then rpi.discount else 0 end) AS basicidledisc,(case when (rpi.revtype = 'basicidle') then (rpi.interest - rpi.discount) else 0 end) AS basicidledp,(case when (rpi.revtype = 'sef') then rpi.amount else 0 end) AS sef,(case when (rpi.revtype = 'sef') then rpi.interest else 0 end) AS sefint,(case when (rpi.revtype = 'sef') then rpi.discount else 0 end) AS sefdisc,(case when (rpi.revtype = 'sef') then (rpi.interest - rpi.discount) else 0 end) AS sefdp,(case when (rpi.revtype = 'sef') then ((rpi.amount + rpi.interest) - rpi.discount) else 0 end) AS sefnet,(case when (rpi.revtype = 'firecode') then ((rpi.amount + rpi.interest) - rpi.discount) else 0 end) AS firecode,(case when (rpi.revtype = 'sh') then rpi.amount else 0 end) AS sh,(case when (rpi.revtype = 'sh') then rpi.interest else 0 end) AS shint,(case when (rpi.revtype = 'sh') then rpi.discount else 0 end) AS shdisc,(case when (rpi.revtype = 'sh') then (rpi.interest - rpi.discount) else 0 end) AS shdp,(case when (rpi.revtype = 'sh') then ((rpi.amount + rpi.interest) - rpi.discount) else 0 end) AS shnet,((rpi.amount + rpi.interest) - rpi.discount) AS amount,rpi.partialled AS partialled from rptpayment_item rpi
go 




if exists(select * from sysobjects where id = object_id('vw_rptpayment_item'))
begin 
  drop view vw_rptpayment_item
end 
go 

CREATE VIEW vw_rptpayment_item AS select x.parentid AS parentid,x.rptledgerfaasid AS rptledgerfaasid,x.year AS year,x.qtr AS qtr,x.revperiod AS revperiod,sum(x.basic) AS basic,sum(x.basicint) AS basicint,sum(x.basicdisc) AS basicdisc,sum(x.basicdp) AS basicdp,sum(x.basicnet) AS basicnet,sum(x.basicidle) AS basicidle,sum(x.basicidleint) AS basicidleint,sum(x.basicidledisc) AS basicidledisc,sum(x.basicidledp) AS basicidledp,sum(x.sef) AS sef,sum(x.sefint) AS sefint,sum(x.sefdisc) AS sefdisc,sum(x.sefdp) AS sefdp,sum(x.sefnet) AS sefnet,sum(x.firecode) AS firecode,sum(x.sh) AS sh,sum(x.shint) AS shint,sum(x.shdisc) AS shdisc,sum(x.shdp) AS shdp,sum(x.amount) AS amount,max(x.partialled) AS partialled from vw_rptpayment_item_detail x group by x.parentid,x.rptledgerfaasid,x.year,x.qtr,x.revperiod
go 




if exists(select * from sysobjects where id = object_id('vw_rpu_assessment'))
begin 
  drop view vw_rpu_assessment
end 
go 

CREATE VIEW vw_rpu_assessment AS select r.objid AS objid,r.rputype AS rputype,dpc.objid AS dominantclass_objid,dpc.code AS dominantclass_code,dpc.name AS dominantclass_name,dpc.orderno AS dominantclass_orderno,ra.areasqm AS areasqm,ra.areaha AS areaha,ra.marketvalue AS marketvalue,ra.assesslevel AS assesslevel,ra.assessedvalue AS assessedvalue,ra.taxable AS taxable,au.code AS actualuse_code,au.name AS actualuse_name,auc.objid AS actualuse_objid,auc.code AS actualuse_classcode,auc.name AS actualuse_classname,auc.orderno AS actualuse_orderno from ((((rpu r join propertyclassification dpc on((r.classification_objid = dpc.objid))) join rpu_assessment ra on((r.objid = ra.rpuid))) join landassesslevel au on((ra.actualuse_objid = au.objid))) left join propertyclassification auc on((au.classification_objid = auc.objid))) union select r.objid AS objid,r.rputype AS rputype,dpc.objid AS dominantclass_objid,dpc.code AS dominantclass_code,dpc.name AS dominantclass_name,dpc.orderno AS dominantclass_orderno,ra.areasqm AS areasqm,ra.areaha AS areaha,ra.marketvalue AS marketvalue,ra.assesslevel AS assesslevel,ra.assessedvalue AS assessedvalue,ra.taxable AS taxable,au.code AS actualuse_code,au.name AS actualuse_name,auc.objid AS actualuse_objid,auc.code AS actualuse_classcode,auc.name AS actualuse_classname,auc.orderno AS actualuse_orderno from ((((rpu r join propertyclassification dpc on((r.classification_objid = dpc.objid))) join rpu_assessment ra on((r.objid = ra.rpuid))) join bldgassesslevel au on((ra.actualuse_objid = au.objid))) left join propertyclassification auc on((au.classification_objid = auc.objid))) union select r.objid AS objid,r.rputype AS rputype,dpc.objid AS dominantclass_objid,dpc.code AS dominantclass_code,dpc.name AS dominantclass_name,dpc.orderno AS dominantclass_orderno,ra.areasqm AS areasqm,ra.areaha AS areaha,ra.marketvalue AS marketvalue,ra.assesslevel AS assesslevel,ra.assessedvalue AS assessedvalue,ra.taxable AS taxable,au.code AS actualuse_code,au.name AS actualuse_name,auc.objid AS actualuse_objid,auc.code AS actualuse_classcode,auc.name AS actualuse_classname,auc.orderno AS actualuse_orderno from ((((rpu r join propertyclassification dpc on((r.classification_objid = dpc.objid))) join rpu_assessment ra on((r.objid = ra.rpuid))) join machassesslevel au on((ra.actualuse_objid = au.objid))) left join propertyclassification auc on((au.classification_objid = auc.objid))) union select r.objid AS objid,r.rputype AS rputype,dpc.objid AS dominantclass_objid,dpc.code AS dominantclass_code,dpc.name AS dominantclass_name,dpc.orderno AS dominantclass_orderno,ra.areasqm AS areasqm,ra.areaha AS areaha,ra.marketvalue AS marketvalue,ra.assesslevel AS assesslevel,ra.assessedvalue AS assessedvalue,ra.taxable AS taxable,au.code AS actualuse_code,au.name AS actualuse_name,auc.objid AS actualuse_objid,auc.code AS actualuse_classcode,auc.name AS actualuse_classname,auc.orderno AS actualuse_orderno from ((((rpu r join propertyclassification dpc on((r.classification_objid = dpc.objid))) join rpu_assessment ra on((r.objid = ra.rpuid))) join planttreeassesslevel au on((ra.actualuse_objid = au.objid))) left join propertyclassification auc on((au.classification_objid = auc.objid))) union select r.objid AS objid,r.rputype AS rputype,dpc.objid AS dominantclass_objid,dpc.code AS dominantclass_code,dpc.name AS dominantclass_name,dpc.orderno AS dominantclass_orderno,ra.areasqm AS areasqm,ra.areaha AS areaha,ra.marketvalue AS marketvalue,ra.assesslevel AS assesslevel,ra.assessedvalue AS assessedvalue,ra.taxable AS taxable,au.code AS actualuse_code,au.name AS actualuse_name,auc.objid AS actualuse_objid,auc.code AS actualuse_classcode,auc.name AS actualuse_classname,auc.orderno AS actualuse_orderno from ((((rpu r join propertyclassification dpc on((r.classification_objid = dpc.objid))) join rpu_assessment ra on((r.objid = ra.rpuid))) join miscassesslevel au on((ra.actualuse_objid = au.objid))) left join propertyclassification auc on((au.classification_objid = auc.objid)))
go 


