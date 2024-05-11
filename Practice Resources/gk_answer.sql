-- 1
SELECT * FROM "Customer"
WHERE "Country" = 'USA';

-- 2
select distinct t.*
from "Track" t
join "InvoiceLine" il on t."TrackId" = il."TrackId"
join "Invoice" i on il."InvoiceId" = i."InvoiceId";

-- 3
select c.*
from "Customer" c
where c."CustomerId" not in (
    select distinct i."CustomerId"
    from "Invoice" i
    where extract(year from i."InvoiceDate") = 2012
);

-- 4
select distinct i.*
from "Invoice" i
join "InvoiceLine" il on i."InvoiceId" = il."InvoiceId"
join "Track" t on il."TrackId" = t."TrackId"
where t."Name" = 'Dazed and Confused'
   or t."Name" = 'You Shook Me(2)';

-- 5
select distinct i.*
from "Invoice" i
join "InvoiceLine" il on i."InvoiceId" = il."InvoiceId"
join "Track" t on il."TrackId" = t."TrackId"
where t."Name" = 'Dazed and Confused'
   and exists (
       select 1
       from "InvoiceLine" il2
       join "Track" t2 on il2."TrackId" = t2."TrackId"
       where il2."InvoiceId" = i."InvoiceId"
         and t2."Name" = 'You Shook Me(2)'
   );

-- 6
select "CustomerId", count(*) as "Number of Invoices"
from "Invoice"
group by "CustomerId";

-- 7
select "Name" as "Track Name", "Milliseconds"
from "Track"
order by "Milliseconds" desc;

-- 8
select avg("UnitPrice") as "AveragePrice"
from "Track"
where "AlbumId" = (
    select "AlbumId"
    from "Album"
    where "Title" = 'Supernatural'
);

-- 9
select avg("UnitPrice") as "AveragePrice", max("UnitPrice") as "MaxPrice", min("UnitPrice") as "MinPrice"
from "Track";

-- 10
select c."Country"
from "Customer" c
join "Invoice" i on c."CustomerId" = i."CustomerId"
group by c."Country"
having count(distinct i."InvoiceId") >= 2;


-- 11
select t.*, sum(il."UnitPrice" * il."Quantity") as "Revenue"
from "Track" t
join "InvoiceLine" il on t."TrackId" = il."TrackId"
join "Invoice" i on il."InvoiceId" = i."InvoiceId"
join "Customer" c on i."CustomerId" = c."CustomerId"
where c."Country" = 'USA'
group by t."TrackId"
order by "Revenue" desc;


-- 12
select t.*, sum(il."UnitPrice" * il."Quantity") as "Revenue"
from "Track" t
join "InvoiceLine" il on t."TrackId" = il."TrackId"
group by t."TrackId"
order by "Revenue" desc
limit 10;










