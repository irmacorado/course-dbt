What is our user repeat rate? (Repeat Rate = Users who purchased 2 or more times / users who purchased)
- 76%

What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?
- Re-purchase indicators:
    - Products: what products are they purchasing and are they satisfactory? Are the products single-use? 
    - Promos: what promotions are working and keeping people?
- 1-purchase indicators:
    - Products: what products are they purchasing and are they defective/unsatisfactory?
    - Events: how long are they browsing our website?

Explain the marts models you added. Why did you organize the models in the way you did?
- I began by making a dim_users model that included all user information, including address. Then in order to create fact_orders and fact_order_items I had to start by creating int_orders and int_order items to effectively be able to aggregate data by order and order/product keys respectively. I then wanted to make a fact_product and fact_product sessions_daily to look at inventory and order information at the product level, but I started by making the int_user_sessions and int_user_product_sessions to include views, add-to-carts, checkouts, and shipping information. I decided to put all our fact product tables under the product folder and intermediate session tables in the marketing folder while leaving everything else in the core folder.

What assumptions are you making about each model? (i.e. why are you adding each test?)
- Assuming that each model's key isn't null and is unique

Did you find any “bad” data as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?
- Not "Bad" data but I found some errors in the SQL code that made my tables blow up and gave me duplicate rows/keys. Had to go back and look at each table one by one until I figured out what I had done wrong.

Your stakeholders at Greenery want to understand the state of the data each day. Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.
- Set up a slack channel that alerts when a test if failed and when a dbt run is successful.

Which orders changed from week 1 to week 2? 
- 3 orders went from preparing to shipped and their shipping/tracking information was updated.
