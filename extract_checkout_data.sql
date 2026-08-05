-- =====================================================================
-- Extraction Query: Checkout Revenue Data (Pre vs Post Launch)
-- =====================================================================
-- Purpose: Pull daily transaction-level data covering the 4 weeks before
-- and 2 weeks after the new checkout launch (2026-06-01), so it can be
-- analyzed for a revenue drop, segmented root cause, and A/B validation.
--
-- Assumes a transactions table structure like:
--   transactions (
--     transaction_id, txn_date, region, channel,
--     customer_segment, product_category,
--     order_completed, revenue
--   )
-- =====================================================================

SELECT
    transaction_id,
    txn_date AS date,
    CASE
        WHEN txn_date < '2026-06-01' THEN 'pre_launch'
        ELSE 'post_launch'
    END AS period,
    region,
    channel,
    customer_segment,
    product_category,
    order_completed,
    revenue
FROM
    transactions
WHERE
    txn_date BETWEEN '2026-05-04' AND '2026-06-14'   -- 4 weeks pre + 2 weeks post
ORDER BY
    txn_date ASC;


-- =====================================================================
-- Quick sanity check query: daily revenue trend
-- (This is what you'd run first to eyeball the drop before deep analysis)
-- =====================================================================

SELECT
    txn_date AS date,
    SUM(revenue) AS total_revenue,
    COUNT(*) AS total_transactions,
    SUM(order_completed) AS completed_orders,
    ROUND(SUM(order_completed) * 1.0 / COUNT(*), 3) AS completion_rate
FROM
    transactions
WHERE
    txn_date BETWEEN '2026-05-04' AND '2026-06-14'
GROUP BY
    txn_date
ORDER BY
    txn_date ASC;
