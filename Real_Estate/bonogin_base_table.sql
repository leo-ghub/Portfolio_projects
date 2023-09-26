WITH
  base_table AS (
  SELECT
    address,
    CASE
      WHEN address LIKE "%TALLAI%" THEN "Tallai"
      WHEN address LIKE "%SPRINGBROOK%" THEN "Springbrook"
      WHEN address LIKE "%WORONGARY%" THEN "Worongary"
      WHEN address LIKE "%BONOGIN%" THEN "Bonogin"
      WHEN address LIKE "%MUDGEERABA%" THEN "Mudgeeraba"
      WHEN address LIKE "%WAYMUDGEERABA%" THEN "Waymudgeeraba"
    ELSE
    NULL
  END
    AS Suburb,
    Property_type,
    Sold_by,
    CAST(Bed AS int64) AS Bedrooms,
    CAST(Bath AS INT64) AS Bathrooms,
    CAST(Car AS INT64) AS Garage_spaces,
    Sale_price,
    Sale_date
  FROM
   (SELECT
  *
FROM
  `my-project-12345-329512.real_estate.bonogin`
WHERE
  Bed NOT IN ("N/A")
  AND Bath NOT IN ("N/A")
  AND Car NOT IN ("N/A")))

SELECT
  *
FROM
  base_table
WHERE
  Bedrooms IS NOT NULL
  AND Bathrooms IS NOT NULL
