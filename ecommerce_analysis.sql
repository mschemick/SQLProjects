use EcommerceAnalytics


/*Demographic behavior:
	- 4178 customers are at the age of 38 
	- Females accounted for 25,096 (50.2%) while males accounted for 23928 (47.9%)
	- USA accounted for the most customers 17369 (34.7%)
	*/

/* Age */
select
	Age,
	count(*) as Customer_Count
from ecommerce_customer_final
group by Age
order by Age

/* Gender */
select
	Gender,
	count(*) as Customer_Count
from ecommerce_customer_final
group by Gender
order by Customer_Count desc

/* Country */
select
	Country,
	count(*) as Customer_Count
from ecommerce_customer_final
group by Country
order by Customer_Count desc


/* Purchasing Behavior
	- Males ($13.13) had a slightly higher average purchase than females ($13.11)
	- Canada had the highest average purchase of $13.04
	- India was the highest top spending country at $1458.21
	*/

/* Average purchases per Gender */
select
	Gender,
	round(avg(Total_purchases),2) as Avg_Purchases 
from ecommerce_customer_final
group by Gender
order by Avg_Purchases desc

/* Average purchases per Country */
select
	Country,
	round(avg(Total_purchases),2) as Avg_Purchases
from ecommerce_customer_final
group by Country
order by Avg_Purchases

/* Top Spending Countries */
select
	Country,
	round(avg(Lifetime_Value),2) as Avg_Purchases
from ecommerce_customer_final
group by Country
order by Avg_Purchases desc


/* Engagement Analysis:
	- Email: 
		>10 = 11958 customers average purchase $8.95
		>30 = 25727 customers average purchase $12.41
		30+ = 12275 customers average purchase $18.69
	- Social Media:
		>20 = 15975 customers average purchase $9.41
		>50 = 26582 customers average purchase $13.54
		50+ = 7403 customers average purchase $19.62
	- Mobile
		>10 = 7211 customers average purchase $7.82
		>25 = 30750 customers average purchase $12.01
		25+ = 11999 customers average purchase $19.14
	*/

/*Email Engagement */
select
	case
		when Email_Open_Rate < 10 then 'low'
		when Email_Open_Rate < 30 then 'medium'
		else 'high'
	end as Email_Engagement,
	count(*) as customers,
	avg(Total_Purchases) as Avg_Purchases
from ecommerce_customer_final
group by
	case
		when Email_Open_Rate < 10 then 'low'
		when Email_Open_Rate < 30 then 'medium'
		else 'high'
	end
order by Avg_Purchases

/* Social Media Engagement */
select
	case
		when Social_Media_Engagement_Score < 20 then 'low'
		when Social_Media_Engagement_Score < 50 then 'medium'
		else 'high'
	end as Social_Engagement,
	count(*) as customers,
	avg(Total_Purchases) as Avg_Purchases
from ecommerce_customer_final
group by
	case
		when Social_Media_Engagement_Score < 20 then 'low'
		when Social_Media_Engagement_Score < 50 then 'medium'
		else 'high'
	end
order by Avg_Purchases

/* Mobile App Usage */
select
	case
		when Mobile_App_Usage < 10 then 'low'
		when Mobile_App_Usage < 25 then 'medium'
		else 'high'
	end as Mobile_Engagement,
	count(*) as customers,
	avg(Total_Purchases) as Avg_Purchases
from ecommerce_customer_final
group by
	case
		when Mobile_App_Usage < 10 then 'low'
		when Mobile_App_Usage < 25 then 'medium'
		else 'high'
	end
order by Avg_Purchases


/* Churn Analysis:
	- 14443 customers (29%) were churned
	- churned vs unchurned
		Churned average purchase = $11.36 with average lifetime value = $1425.20
		Unchurned average purchase = $13.85 with average lifetime value = $1446.60
	- churned vs unchurned engagement
		churned = 16.17 email rate and 23.71 average social media engagement score
		unchurned = 22.79 email rate and 31.37 average social media engagement score
	*/

/* Churn Rate */
select
	Churned,
	count(*) as Customers
from ecommerce_customer_final
group by Churned

/* Churn vs Purchases */
select
	Churned,
	round(avg(Total_Purchases),2) as Avg_Purchases,
	round(avg(Lifetime_Value),2) as Avg_Lifetime_Value
from ecommerce_customer_final
group by Churned

/* Churn vs Engagement */
select
	Churned,
	round(avg(Email_Open_Rate),2) as Avg_Email_Rate,
	round(avg(Social_Media_Engagement_Score),2) as Avg_Social_Media
from ecommerce_customer_final
group by Churned


/* Business insights */


/* Which customer segment generates the highest lifetime value? 

Summary:
High-value customers represent only 6.3% of customers but generate the highest 
lifetime value ($3,785) and purchase activity (22.1 purchases). This highlights 
the importance of retaining high-value customer segments.

*/

select
	case
		when Lifetime_Value < 1000 then 'low value'
		when Lifetime_Value < 3000 then 'medium value'
		else 'high value'
	end as Customer_Segment,
	count(*) as customers,
	avg(Lifetime_Value) as Avg_Lifetime_Value,
	avg(Total_Purchases) as Avg_Purchases
from ecommerce_customer_final
group by
	case
		when Lifetime_Value < 1000 then 'low value'
		when Lifetime_Value < 3000 then 'medium value'
		else 'high value'
	end


/* Which age groups spend the most? 

Summary:
Average purchases and lifetime value were highly consistent 
across all age groups, suggesting that age has minimal influence
on customer spending behavior within this dataset.

*/

select
	case
		when Age < 25 then '18-24'
		when Age < 35 then '25-34'
		when Age < 45 then '35-44'
		when Age < 55 then '45-54'
		else '55+'
	end as age_group,
	count(*) as customers,
	avg(Total_Purchases) as avg_purchases,
	avg(Lifetime_Value) as avg_lifetime_value
from ecommerce_customer_final
group by
	case
		when Age < 25 then '18-24'
		when Age < 35 then '25-34'
		when Age < 45 then '35-44'
		when Age < 55 then '45-54'
		else '55+'
	end

/*Which gender has the highest average order value?

Summary:
Male customers generated the highest average order value ($124.64), 
followed by female ($121.86) and other customers ($117.64). However, 
the differences were relatively small.

*/

select
	Gender,
	avg(Average_Order_Value) as average_order_value
from ecommerce_customer_final
group by
	Gender
order by
	average_order_value desc

/* Do customers with more payment methods make more purchases? 

Summary:
Customers using four payment methods generated the highest average purchases (13.3),
but purchase activity remained relatively consistent across all groups, indicating 
limited impact from payment method diversity.

*/

select
	Payment_Method_Diversity,
	count(*) as customers,
	avg(Total_Purchases) as avg_purchases
from ecommerce_customer_final
group by Payment_Method_Diversity
order by Payment_Method_Diversity

/*Which customers have the highest credit balances? 

Summary:
Customers with high credit balances averaged 18.2 purchases and $2,008 lifetime value,
significantly outperforming medium- and low-credit customers. Higher credit balances 
were associated with greater customer value and purchase activity.

*/

select
	case
		when Credit_Balance < 1000 then 'Low Credit'
		when Credit_Balance < 3000 then 'Medium Credit'
		else 'High Credit'
	end as credit_segment,
	count(*) as customers,
	avg(Credit_Balance) as avg_credit_balance,
	avg(Total_Purchases) as avg_purchases,
	avg(Lifetime_Value) as avg_lifetime_value
from ecommerce_customer_final
group by
	case
		when Credit_Balance < 1000 then 'Low Credit'
		when Credit_Balance < 3000 then 'Medium Credit'
		else 'High Credit'
	end
order by
	avg_credit_balance desc


/* What is the overall churn rate?

Summary:
Approximately 28.9% of customers churned, while 71.1% remained active, 
indicating a meaningful opportunity for customer retention initiatives.

*/

select
	Churned,
	count(*) as customers,
	round(count(*) * 100.0 / sum(count(*)) over (), 2) as customer_percentage
from ecommerce_customer_final
group by Churned


/*How do churned customers differ from retained customers?

Summary:
Retained customers made more purchases and generated slightly higher lifetime value
than churned customers, while churned customers exhibited higher average order values.

*/

select
	Churned,
	count(*) as customers,
	avg(Total_Purchases) as avg_purchase,
	avg(Lifetime_Value) as avg_lifetime_value,
	avg(average_order_value) as avg_order_value 
from ecommerce_customer_final
group by Churned

/* Does email engagement affect churn? 

Summary:
Customers with low email engagement experienced a churn rate of 46.3%, 
compared to 18.8% for highly engaged customers, suggesting a strong relationship
between email engagement and retention.

*/

select
	case
		when Email_Open_Rate < 10 then 'low email engagement'
		when Email_Open_Rate < 30 then 'medium email engagement'
		else 'high email engagement'
	end as email_engagement,
	count(*) as customers,
	round(avg(cast(Churned as float)) * 100, 2) as churned_rate
from ecommerce_customer_final
group by
	case
		when Email_Open_Rate < 10 then 'low email engagement'
		when Email_Open_Rate < 30 then 'medium email engagement'
		else 'high email engagement'
	end
order by
	churned_rate desc


/* Does mobile app usage affect churn? 

Summary:
Churn rates declined from 51.8% among low app users to 19.6% among high app users,
indicating that greater mobile app engagement is associated with stronger customer retention.

*/

select
	case
		when Mobile_App_Usage < 10 then 'low mobile engagement'
		when Mobile_App_Usage < 25 then 'medium mobile engagement'
		else 'high mobile engagement'
	end as email_engagement,
	count(*) as customers,
	round(avg(cast(Churned as float)) * 100, 2) as churned_rate
from ecommerce_customer_final
group by
	case
		when Mobile_App_Usage < 10 then 'low mobile engagement'
		when Mobile_App_Usage < 25 then 'medium mobile engagement'
		else 'high mobile engagement'
	end
order by
	churned_rate desc

/* Which countries have the highest churn rates? 

Summary:
Churn rates were relatively consistent across countries, ranging from 27.3% to 29.9%, 
suggesting that geography has limited influence on customer retention compared 
to behavioral factors.

*/

select
	Country,
	count(*) as customers,
	round(avg(cast(Churned as float)) * 100, 2) as churned_rate
from ecommerce_customer_final
group by Country
order by
	churned_rate desc

/* Do customers with higher email engagement make more purchases?

Summary:
Customers with higher email engagement generated significantly more purchases 
and greater lifetime value. Highly engaged customers averaged 16.5 purchases
and $1,809 lifetime value, compared to 9.0 purchases and $979 lifetime value 
among low-engagement customers.
*/

select
	case
		when Email_Open_Rate < 10 then 'low engagement rate'
		when Email_Open_Rate < 20 then 'medium engagement rate'
		else 'high engagement rate'
	end as engagement_rate,
	count(*) as customers,
	avg(Total_Purchases) as avg_purchases,
	avg(Lifetime_Value) as avg_lifetime_value
from ecommerce_customer_final
group by
	case
		when Email_Open_Rate < 10 then 'low engagement rate'
		when Email_Open_Rate < 20 then 'medium engagement rate'
		else 'high engagement rate'
	end
order by avg_lifetime_value desc

/*  Do customers with higher social media engagement 
generate higher lifetime value?

Summary:
Customers with higher social media engagement generated significantly 
more purchases and higher lifetime value. Highly engaged customers averaged
19.6 purchases and $2,150 lifetime value, compared to 9.4 purchases and $1,035 
lifetime value among low-engagement customers.

*/

select
    case
        when Social_Media_Engagement_Score < 20 Then 'low social engagement'
        when Social_Media_Engagement_Score < 50 Then 'medium social engagement'
        else 'high social engagement'
    end as Social_Engagement,
    Count(*) as Customers,
    Avg(Total_Purchases) as avg_purchases,
    Avg(Lifetime_Value) as avg_lifetime_value
from ecommerce_customer_final
group by
    case
        when Social_Media_Engagement_Score < 20 Then 'low social engagement'
        when Social_Media_Engagement_Score < 50 Then 'medium social engagement'
        else 'high social engagement'
    end
order by avg_lifetime_value desc;

/* Does mobile app usage increase customer value? 

Summary:
Customers with higher mobile app usage generated significantly more purchases 
and greater lifetime value. High app users averaged 19.1 purchases and $2,102 lifetime
value, compared to 7.8 purchases and $851 lifetime value among low app users.

*/

select
    case
        when Mobile_App_Usage < 10 Then 'low mobile engagement'
        when Mobile_App_Usage < 25 Then 'medium mobile engagement'
        else 'high mobile engagement'
    end as Social_Engagement,
    Count(*) as Customers,
    Avg(Total_Purchases) as avg_purchases,
    Avg(Lifetime_Value) as avg_lifetime_value
from ecommerce_customer_final
group by
    case
        when Mobile_App_Usage < 10 Then 'low mobile engagement'
        when Mobile_App_Usage < 25 Then 'medium mobile engagement'
        else 'high mobile engagement'
    end
order by avg_lifetime_value desc

/* Do long-term members spend more money? 

Summary:
Long-term members generated the highest average lifetime value ($1,468), 
compared to $1,439 for short-term members and $1,435 for medium-term members.
However, average purchases and lifetime value were relatively similar across
all membership groups.

*/

select
	case
		when Membership_Years < 3 then 'short_term_members'
		when Membership_Years < 6 then 'medium_term_members'
		else 'long_term_members'
	end as membership_type,
	count(*) as customers,
	avg(Total_Purchases) as avg_purchases,
	avg(Lifetime_Value) as avg_lifetime_value
from ecommerce_customer_final
group by
	case
		when Membership_Years < 3 then 'short_term_members'
		when Membership_Years < 6 then 'medium_term_members'
		else 'long_term_members'
	end
order by
	avg_lifetime_value desc

/* Do customers with larger wishlist make more purchaes? 

Summary:
Customers with medium-sized wishlists averaged 21.3 purchases and 
$2,352 lifetime value, significantly outperforming customers with small wishlists,
who averaged 12.5 purchases and $1,375 lifetime value. Customers with large wishlists
also demonstrated high purchase activity, although the group contained only 6 customers.

** note - Large_wishlist group only contains 6 customers **
*/

select
	case
		when Wishlist_Items < 10 then 'small_wishlist'
		when Wishlist_Items < 20 then 'medium_wishlist'
		else 'large wishlist'
	end as wishlist_group,
	count(*) as customers,
	avg(Total_Purchases) as avg_purchases,
	avg(Lifetime_Value) as avg_lifetime_value
from ecommerce_customer_final
group by
	case
		when Wishlist_Items < 10 then 'small_wishlist'
		when Wishlist_Items < 20 then 'medium_wishlist'
		else 'large wishlist'
	end
order by
	avg_purchases

/* Does cart abandonment affect customer value?

Summary:
Customers with low cart abandonment generated the highest customer value, 
averaging 20.5 purchases and $2,256 lifetime value. Customer value declined
substantially as cart abandonment increased, with high-abandonment customers
averaging only 7.6 purchases and $820 lifetime value.

*/

select
	case
		when Cart_Abandonment_Rate < 40 then 'low cart abandoment'
		when Cart_Abandonment_Rate < 80 then 'medium cart abandonment'
		else 'large cart abandonment'
	end as cart_abandonment_group,
	avg(Total_Purchases) as avg_purchases,
	avg(Lifetime_Value) as avg_lifetime_value
from ecommerce_customer_final
group by
	case
		when Cart_Abandonment_Rate < 40 then 'low cart abandoment'
		when Cart_Abandonment_Rate < 80 then 'medium cart abandonment'
		else 'large cart abandonment'
	end
order by
	avg_lifetime_value desc

/* Do frequent Logins lead to more purchases 

Summary:
Customers with higher login frequency generated substantially more purchases
and greater lifetime value. High-frequency users averaged 24.9 purchases and $2,671
lifetime value, compared to 10.7 purchases and $1,172 lifetime value among low-frequency users.

*/

select
	case
		when Login_Frequency < 15 then 'low frequency'
		when Login_Frequency < 30 then 'medium frequency'
		else 'high frequency'
	end as frequency_group,
	count(*) as customers,
	avg(Total_Purchases) as avg_purchases,
	avg(Lifetime_Value) as avg_lifetime_value
from ecommerce_customer_final
group by
	case
		when Login_Frequency < 15 then 'low frequency'
		when Login_Frequency < 30 then 'medium frequency'
		else 'high frequency'
	end
order by
	avg_purchases

/* Do customers who contact customer service more often spend more or less? 

Summary:
Customers who made no customer service calls generated the highest customer value,
averaging 18.5 purchases and $1,997 lifetime value. Customer value steadily declined
as the number of service calls increased, with high-call customers averaging 11.1 purchases
and $1,218 lifetime value.

*/

select
	case
		when Customer_Service_Calls = 0 then 'no calls'
		when Customer_Service_Calls <= 5 then 'low calls'
		else 'high calls'
	end as service_group,
	avg(Total_Purchases) as avg_purchases,
	avg(Lifetime_Value) as avg_lifetime_value
from ecommerce_customer_final
group by
	case
		when Customer_Service_Calls = 0 then 'no calls'
		when Customer_Service_Calls <= 5 then 'low calls'
		else 'high calls'
	end
order by
	avg_lifetime_value desc
