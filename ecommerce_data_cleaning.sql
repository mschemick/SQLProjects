use EcommerceAnalytics

			/* Total_Purchase import issue

Imported 50,000 ecommerce customer records into SQL Server and addressed import conversion issues 
in the Total_Purchases field resulting in 40 values being dropped into Null.  Being that it was only 0.08%
of the 50,000 records, I decided to exclude them from analysis.
*/

select count(*)
from ecommerce_customer
where Total_Purchases is null

select *
from ecommerce_customer
where Total_Purchases is null

select *
into ecommerce_customer_clean
from ecommerce_customer
where Total_Purchases is not Null

			/* Missing Values */

select
	count(*) - count(Age) as Missing_Age,
	count(*) - count(Gender) as Missing_Gender,
	count(*) - count(Country) as Missing_Country,
	count(*) - count(City) as Missing_City,
	count(*) - count(Membership_Years) as Missing_Membership,
	count(*) - count(Login_Frequency) as Missing_Login,
	count(*) - count(Session_Duration_Avg) as Missing_Sessions,
	count(*) - count(Pages_Per_Session) as Missing_Pages,
	count(*) - count(Cart_Abandonment_Rate) as Missing_Cart,
	count(*) - count(Wishlist_Items) as Missing_Wishlist,
	count(*) - count(Total_Purchases) as Missing_Total_Purchases,
	count(*) - count(Average_Order_Value) as Missing_Average_Order,
	count(*) - count(Days_Since_Last_Purchase) as Missing_Days,
	count(*) - count(Discount_Usage_Rate) as Missing_Discount,
	count(*) - count(Returns_Rate) as Missing_Returns,
	count(*) - count(Email_Open_Rate) as Missing_Email,
	count(*) - count(Customer_Service_Calls) as Missing_Customer_Service,
	count(*) - count(Product_Reviews_Written) as Missing_Product_review,
	count(*) - count(Social_Media_Engagement_Score) as Missing_Social_Media,
	count(*) - count(Mobile_App_Usage) as Missing_Mobile,
	count(*) - count(Payment_Method_Diversity) as Missing_Payment_method,
	count(*) - count(Lifetime_Value) as Missing_Lifetime,
	count(*) - count(Credit_Balance) as Missing_Credit_balance,
	count(*) - count(Churned) as Missing_chruned,
	count(*) - count(Signup_Quarter) as Missing_signup
from ecommerce_customer_clean

	/* finding the median< min, max, and average for imputation */

/* median = 38, min - 0, max = 200, avg = 37  (Note the min and max ages to investigate) */
select distinct
	percentile_cont(0.5) within group (order by age)
	over () as Median_age,
	min(age) over () as min_age,
	max(age) over () as max_age,
	avg(age) over () as avg_age
from ecommerce_customer_clean
where age is not null

/* Median = 26.7, min = 1, max = 75.59, avg = 27.66 */
select distinct
	percentile_cont(0.5) within group (order by Session_Duration_Avg)
	over () as Median_session,
	min(Session_Duration_Avg) over () as min_session,
	max(Session_Duration_Avg) over () as max_session,
	avg(Session_Duration_Avg) over () as avg_session
from ecommerce_customer_clean
where Session_Duration_Avg is not null

/* Median = 8.4, min = 1, max = 24.1, avg = 8.7 */
select distinct
	percentile_cont(0.5) within group (order by Pages_Per_Session)
	over () as Median_pages,
	min(Pages_Per_Session) over () as min_pages,
	max(Pages_Per_Session) over () as max_pages,
	avg(Pages_Per_Session) over () as avg_pages
from ecommerce_customer_clean
where Pages_Per_Session is not null

/* Median = 4, min = 0, max = 28, avg = 4 */
select distinct
	percentile_cont(0.5) within group (order by Wishlist_Items)
	over () as Median_Wishlist,
	min(Wishlist_Items) over () as min_wishlist,
	max(Wishlist_Items) over () as max_wishlist,
	avg(Wishlist_Items) over () as avg_wishlist
from ecommerce_customer_clean
where Wishlist_Items is not null

/* Median = 21, min = 0, max = 287, avg = 29 */
select distinct
	percentile_cont(0.5) within group (order by Days_Since_Last_Purchase)
	over () as Median_Days,
	min(Days_Since_Last_Purchase) over () as min_days,
	max(Days_Since_Last_Purchase) over () as max_days,
	avg(Days_Since_Last_Purchase) over () as avg_days
from ecommerce_customer_clean
where Days_Since_Last_Purchase is not null

/* median = 5.4, min = 0, max = 99.6, avg = 6.7 */
select distinct
	percentile_cont(0.5) within group (order by Returns_Rate)
	over () as Median_return,
	min(Returns_Rate) over () as min_returns,
	max(Returns_Rate) over () as max_returns,
	avg(Returns_Rate) over () as avg_returns
from ecommerce_customer_clean
where Returns_Rate is not null

/* median = 19.8, min = 0, max = 91.7, avg = 20.9 */
select distinct
	percentile_cont(0.5) within group (order by Email_Open_Rate)
	over () as Median_Email,
	min(Email_Open_Rate) over () as min_email,
	max(Email_Open_Rate) over () as max_email,
	avg(Email_Open_Rate) over () as avg_email
from ecommerce_customer_clean
where Email_Open_Rate is not null

/* median = 2, min = 0, max = 21, avg = 2 */
select distinct
	percentile_cont(0.5) within group (order by Product_Reviews_Written)
	over () as Median_Product,
	min(Product_Reviews_Written) over () as min_product,
	max(Product_Reviews_Written) over () as max_product,
	avg(Product_Reviews_Written) over () as avg_product
from ecommerce_customer_clean
where Product_Reviews_Written is not null

/* median = 27.6, min = 0, max = 100, avg = 29.4 */
select distinct
	percentile_cont(0.5) within group (order by Social_Media_Engagement_Score)
	over () as Median_Social,
	min(Social_Media_Engagement_Score) over () as min_social,
	max(Social_Media_Engagement_Score) over () as max_social,
	avg(Social_Media_Engagement_Score) over () as avg_social
from ecommerce_customer_clean
where Social_Media_Engagement_Score is not null

/* median = 18.6, min = 0, max = 61.9, avg = 19.4 */
select distinct
	percentile_cont(0.5) within group (order by Mobile_App_Usage)
	over () as Median_Mobile,
	min(Mobile_App_Usage) over () as min_mobile,
	max(Mobile_App_Usage) over () as max_mobile,
	avg(Mobile_App_Usage) over () as avg_mobile
from ecommerce_customer_clean
where Mobile_App_Usage is not null

/* median = 2, min = 1, max = 5, avg = 2 */
select distinct
	percentile_cont(0.5) within group (order by Payment_Method_Diversity)
	over () as Median_Payment,
	min(Payment_Method_Diversity) over () as min_payment,
	max(Payment_Method_Diversity) over () as max_payment,
	avg(Payment_Method_Diversity) over () as avg_payment
from ecommerce_customer_clean
where Payment_Method_Diversity is not null

/* median = 1896, min = 0, max = 7197, avg = 1966 */
select distinct
	percentile_cont(0.5) within group (order by Credit_Balance)
	over () as Median_Credit,
	min(Credit_Balance) over () as min_credit,
	max(Credit_Balance) over () as max_credit,
	avg(Credit_Balance) over () as avg_credit
from ecommerce_customer_clean
where Credit_Balance is not null

	/* Outlier check */

/* found 50 records that contained ages below 13 and above 100 years old. The records are
still good except for the ages, so I set them to null to be part of the age imputation process. */
select
	Age,
	count(*) as Customer_Count
from ecommerce_customer_clean
where age < 13 or age > 100
group by Age
order by Age

select count(*) as age_Outliers
from ecommerce_customer_clean
where age < 13 or age > 100

Update ecommerce_customer_clean
set Age = NULL
where Age < 13 or Age > 100

	/* Duplicate Check */

/* both results are 49960 rows which equals no duplicates */
select count(*) as Total_Rows
from ecommerce_customer_clean

select count(*) as Distinct_Rows
from (
	select distinct *
	from ecommerce_customer_clean
) x

	/* formatting check */

/* no spelling or formatting issues */
select distinct gender
from ecommerce_customer_clean
order by Gender

select distinct Country
from ecommerce_customer_clean
order by Country

select distinct City
from ecommerce_customer_clean
order by City

	/* Imputation and final data cleaning step */

/* imputation process plus flagging records that were imputated */
select
	isnull(Age, 38) as Age,
	case
		when Age is null then 1
		else 0
	end as Age_Imputed,
		isnull(Session_Duration_Avg, 26.7) as session_Duration_Avg,
	case
		when Session_Duration_Avg is null then 1
		else 0
	end as Session_Imputed,
		isnull(Pages_Per_Session, 8.4) as Pages_Per_Session,
	case
		when Pages_Per_Session is null then 1
		else 0
	end as Pages_Imputed,
		isnull(Wishlist_Items, 4) as Wishlist_Items,
	case
		when Wishlist_Items is null then 1
		else 0
	end as Wishlist_Imputed,
		isnull(Days_Since_Last_Purchase, 21) as Days_Since_Last_Purchase,
	case
		when Days_Since_Last_Purchase is null then 1
		else 0
	end as Days_Imputed,
		isnull(Returns_Rate, 5.4) as Returns_Rate,
	case
		when Returns_Rate is null then 1
		else 0
	end as Returns_Imputed,
		isnull(Email_Open_Rate, 19.8) as Email_Open_Rate,
	case
		when Email_Open_Rate is null then 1
		else 0
	end as Email_Imputed,
		isnull(Product_Reviews_Written, 0) as Product_Reviews_Written,
	case
		when Product_Reviews_Written is null then 1
		else 0
	end as Product_Reviews_Imputed,
		isnull(Social_Media_Engagement_Score, 27.6) as Social_Media_Engagement_Score,
	case
		when Social_Media_Engagement_Score is null then 1
		else 0
	end as Social_Imputed,
		isnull(Mobile_App_Usage, 18.6) as Mobile_App_Usage,
	case
		when Mobile_App_Usage is null then 1
		else 0
	end as Mobile_Imputed,
		isnull(Payment_Method_Diversity, 2) as Payment_Method_Diversity,
	case
		when Payment_Method_Diversity is null then 1
		else 0
	end as Payment_Imputed,
		isnull(Credit_Balance, 1896) as Credit_Balance,
	case
		when Credit_Balance is null then 1
		else 0
	end as Credit_Imputed,
	Gender,
	Country,
	City,
	Membership_Years,
	Login_Frequency,
	Cart_Abandonment_Rate,
	Total_Purchases,
	Average_Order_Value,
	Customer_Service_Calls,
	Lifetime_Value,
	Churned,
	Signup_Quarter
into ecommerce_customer_final
from ecommerce_customer_clean
