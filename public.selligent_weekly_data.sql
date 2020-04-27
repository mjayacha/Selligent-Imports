create view public.selligent_weekly_data as
(with strategic_vw_func as(
select campaign,
sent_dt,
case when trim(campaign) LIKE '%Consumer_Reactivation_Journey_Active%' then 'Reactivation'
when trim(campaign) LIKE '%Consumer_Reactivation_Journey_NotActive%' then 'Reactivation'
when trim(campaign) LIKE '%Final_Cart_Abandon_Send%' then 'Abandon Cart'
when trim(campaign) LIKE '%New_Account_No_Purchase_Build_Welcome_C_S2%' then 'Welcome Email'
when trim(campaign) LIKE '%LDI_Welcome_Journey_S2%' then 'Welcome Email'
when trim(campaign) LIKE '%NicheWelcomeSeries2.0%' then 'Welcome Email'
when trim(campaign) LIKE '%Welcome%' then 'Welcome Email'
when trim(campaign) LIKE '%22~Created_Account_NoPurchase%' then 'Welcome Email'
when trim(campaign) LIKE '%QUOTE_JM_FINAL%' then 'Quotes'
when trim(campaign) LIKE '%BrowseAbandon_S2_Send%' then 'Browse Abandon'
when trim(campaign) LIKE '%ProjectTool_Journey%' then 'Post Purchase'
when trim(campaign) LIKE '%PostPurchase_Revamp_BuiltInGrill_Journey%' then 'Post Purchase'
when trim(campaign) LIKE '%em~eml~1%' then 'Promo'
when trim(campaign) LIKE '%em~eml~0%' then 'Promo'
when trim(campaign) LIKE '%SHOPNOW%' then 'Promo'
when trim(campaign) LIKE '%CLEARANCE10%' then 'Promo'
when trim(campaign) LIKE '%32~network-general~%' then 'Promo'
when trim(campaign) LIKE '%em~eml~6%' then 'Reviews'
when trim(campaign) LIKE '%review%' then 'Reviews'
when trim(campaign) LIKE '%em~eml~33%' then 'Rep Automated Emails'
when trim(campaign) LIKE '%em~eml~75%' then 'Browser Push Promos'
when trim(campaign) LIKE '%em~eml~76%' then 'Browser Push Triggered'
when trim(campaign) LIKE '%AppBadgeSig%' then 'Email Signature'
when trim(campaign) LIKE '%GetVerified_SusPro%' then 'Suspected Pro'
when trim(campaign) LIKE '%22~PP%' then 'Post Purchase'
when trim(campaign) LIKE '%ProVerification_SIGNUP%' then 'Welcome Email'
when trim(campaign) LIKE '%22~Checkout_Final%' then 'Post Purchase'
when trim(campaign) LIKE '%23~Network-General%' then 'Post Purchase'
when trim(campaign) LIKE '%SYSTEM.CAMPAIGNNAME%' then 'Post Purchase'
--- new classifcation October '19 forward ---
when trim(campaign) LIKE '%em~eml~78%' then 'Reactivation'
when trim(campaign) LIKE '%em~eml~79%' then 'Abandon Cart'
when trim(campaign) LIKE '%em~eml~77%' then 'Welcome Email'
when trim(campaign) LIKE '%em~eml~81%' then 'Quotes'
when trim(campaign) LIKE '%em~eml~80%' then 'Browse Abandon'
when trim(campaign) LIKE '%em~eml~82%' then 'Post Purchase'
when trim(campaign) LIKE '%em~eml~1%' then 'Promo'
when trim(campaign) LIKE '%em~eml~83%' then 'Reviews'
when trim(campaign) LIKE '%em~eml~84%' then 'Rep Automated Emails'
when trim(campaign) LIKE '%em~eml~75%' then 'Browser Push Promos'
when trim(campaign) LIKE '%em~eml~76%' then 'Browser Push Triggered'
when trim(campaign) LIKE '%em~eml~77%' then 'Email Signature'
when trim(campaign) LIKE '%em~eml~34%' then 'TRM Banners'
when trim(campaign) LIKE '%em~eml~85%' then 'Suspected PRO'
--- historical classification ---
when trim(campaign) LIKE 'Cart_Abandon' then 'Abandon Cart'
when trim(campaign) LIKE 'Browse_Abandon' then 'Browse Abandon'
when trim(campaign) LIKE 'FirstPurchase' then 'First Purchase'
when trim(campaign) LIKE 'eml~22~2018' then 'Promo'
when trim(campaign) LIKE 'CatalogDrop_ActiveCon' then 'Promo'
when trim(campaign) LIKE 'ProjectToolsUpdates' then 'Promo'
when trim(campaign) LIKE 'eml~22~2019' then 'Promo'
when trim(campaign) LIKE 'network-general' then 'Promo'
when trim(campaign) LIKE 'ProVerificationSeries' then 'Promo'
when trim(campaign) LIKE 'Unique_Coupon_Journey_Final' then 'Promo'
when trim(campaign) LIKE 'eml~32' then 'Promo'
when trim(campaign) LIKE 'Account_NoPurchase' then 'Welcome Email'
when trim(campaign) LIKE 'Guest_Checkout_Final' then 'Welcome Email'
when trim(campaign) LIKE 'Checkout_Final' then 'Welcome Email'
---Added on 4/23/2020 ----
when trim(campaign) LIKE '%ActiveCon' then 'Promo (1)'
when trim(campaign) LIKE '%ActivePro' then 'Promo (1)'
when trim(campaign) LIKE '%SuperActivePro' then 'Promo (1)'
else null
end as strategy_vw
from spectrum.selligent_daily_import)
select date_trunc('week',to_date(daily_import.sent_dt,'MM/DD/YYYY')) as week_start,
date_trunc('month',to_date(daily_import.sent_dt,'MM/DD/YYYY')) as month_start,
strategic_vw_func.strategy_vw as strategy_view,
sum(daily_import.sent) as target_count,
sum(daily_import.delivered) as delivered_count,
sum(daily_import.bouncecount) as bounce_count,
sum(daily_import.unique_opens) as unique_open_count,
sum(daily_import.unique_clicks) as unique_click_count,
max(daily_import.sent_dt) as reported_date
 from spectrum.selligent_daily_import daily_import left join strategic_vw_func
on daily_import.campaign=strategic_vw_func.campaign
and daily_import.sent_dt=strategic_vw_func.sent_dt
group by date_trunc('month',to_date(daily_import.sent_dt,'MM/DD/YYYY')),
date_trunc('week',to_date(daily_import.sent_dt,'MM/DD/YYYY')),
strategic_vw_func.strategy_vw
order by 1)
 WITH NO SCHEMA BINDING;

