--set hive.execution.engine=spark;
--set hive.exec.parallel=true;
--set spark.network.timeout=1400s;

--案件实体 
 
-- 获取案件基础信息
--dwd_graphbase.CASE_ENTITY
--dwd_graphbase.ACCOUNT_ENTITY

--案件到账号的关系
--
--DROP TABLE  IF EXISTS DWD_GRAPHBASE.ACCOUNT_TO_CASE;
--INSERT OVERWRITE TABLE DWD_GRAPHBASE.ACCOUNT_TO_CASE 
DROP TABLE  IF EXISTS DWD_GRAPHBASE.ACCOUNT_TO_CASE_${DATE_CONF};
CREATE  TABLE DWD_GRAPHBASE.ACCOUNT_TO_CASE_${DATE_CONF} AS 
SELECT  DISTINCT
T1.ACCOUNTNOID  --  --帐号实体
,'' AS REGISTNO  --保安号码
,T1.SUMPAID  --赔付金额
,T1.ACCOUNTNO  --银行账号
,T1.PAYEEMOBILE  --  --收款人手机号
,T1.PAYEEBANKACCOUNTNAME  --收款方账户名称
,T1.PAYEEBANKNAME  --领赔款单位/代理人/索赔人
,T1.PAIDMETHODCODE  --赔款支付方式
,T1.PAYEETYPE  --赔款接收人类型
,T1.ETL_DATE  --增量时间
,'' AS KIND  --帐号种类
,T1.COMPANYCODE COMPANYCODE_ACCOUNT
,T1.COMPANY COMPANY_ACCOUNT
,T1.COMPANY_CODE_ORG COMPANY_CODE_ORG_ACCOUNT
,T1.ACCOUNT_LAST_MARKER
,T1.ACCOUNT_MARKED_STATUS
,T1.ACCOUNT_MARKED_TAG
,T1.ACCOUNT_LAST_MARKED_TIME
,T2.CASEID  --案件实体
,'' AS  REGISTNO_1  --报案号吗
,T2.INITDAMAGEDATE  --出险时间
,T2.REPORTDATE  --报案时间
,T2.OPENDATE  --立案时间
,T2.ENDCASEDATE  --结案时间
,T2.ACCEPTDATE  --承保日期
,T2.SUMPAID as SUMPAID_1 --赔付金额
,'' AS POLICYNO  --保单号
,T2.PHONENUMBER  --  --联系电话
,T2.REPORTORPHONENUMBER  --  --报案人联系电话
,T2.ETL_DATE as ETL_DATE_1  --增量时间
,T2.DAMAGEADDRESS  --出险地点
,T2.COMPANYCODE COMPANYCODE_CASE
,T2.COMPANY COMPANY_CASE
,T2.APPLINAME --投保人姓名
,T2.INSUREDNAME  --被保人姓名
,T2.SUMESTLOSS --估损金额
,T2.COMPANY_CODE_ORG  --机构编码
,T2.ALREADYPAIDIND --已决标志位
,T2.LAST_MARKER
,T2.MARKED_STATUS
,T2.MARKED_TAG
,T2.LAST_MARKED_TIME
--,T1.KIND AS RELATIONSHIP
,CASE WHEN T1.KIND='ACCOUNT_INSURED' THEN 'INSURED_ACCOUNTNO_CLAIMMAIN'
     WHEN T1.KIND='ACCOUNT_THIRD_PARTY' THEN 'THIRD_PARTY_ACCOUNTNO_CLAIMMAIN'
     ELSE NULL END RELATIONSHIP
,T1.ACCOUNTNOID AS SRCID
,T2.CASEID AS DESID
FROM 
dwd_graphbase.CASE_ENTITY_RESULT T2 
INNER JOIN 
dwd_graphbase.ACCOUNT_ENTITY_RESULT T1 
ON 
T1.REGISTNO=T2.REGISTNO
WHERE T1.KIND IN ('ACCOUNT_INSURED','ACCOUNT_THIRD_PARTY')
--AND T1.ACCOUNTNO IS NOT NULL 
--AND T2.REGISTNO IS NOT NULL 
;























