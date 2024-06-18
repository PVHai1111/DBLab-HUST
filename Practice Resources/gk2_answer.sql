-- 1. Viết hàm nhận 1 tham số là id của 1 thể loại (Genre) và trả về số lượng bài hát thuộc thể loại đó
CREATE OR REPLACE FUNCTION GetTrackCountByGenre(genre_id INT)
RETURNS INT AS $$
DECLARE
    track_count INT;
BEGIN
    SELECT COUNT(*)
    INTO track_count
    FROM "Track"
    WHERE "GenreId" = genre_id;

    RETURN track_count;
END;
$$ LANGUAGE plpgsql;

-- 2. Viết hàm nhận 1 tham số tên công ty (company) và trả về danh sách khách hàng ở công ty đó
CREATE OR REPLACE FUNCTION GetCustomersByCompany(company_name VARCHAR)
RETURNS TABLE (
    "CustomerId" INT,
    "FirstName" VARCHAR,
    "LastName" VARCHAR,
    "Company" VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT "CustomerId", "FirstName", "LastName", "Company"
    FROM "Customer"
    WHERE "Company" = company_name;
END;
$$ LANGUAGE plpgsql;

-- 3. Viết hàm nhận đầu vào là 1 số nguyên N và trả về top N bài hát có doanh thu lớn nhất
CREATE OR REPLACE FUNCTION TopRevenueTracks(N INTEGER)
RETURNS TABLE (
    "TrackId" INT,
    "Name" VARCHAR(200),
    "Artist" VARCHAR(120),
    "Album" VARCHAR(160),
    "UnitPrice" NUMERIC(10,2),
    "TotalRevenue" NUMERIC(10,2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT "Track"."TrackId", "Track"."Name", "Artist"."Name" AS "Artist", "Album"."Title" AS "Album",
           "Track"."UnitPrice",
           SUM("InvoiceLine"."UnitPrice" * "InvoiceLine"."Quantity") AS "TotalRevenue"
    FROM "Track"
    INNER JOIN "InvoiceLine" ON "Track"."TrackId" = "InvoiceLine"."TrackId"
    INNER JOIN "Album" ON "Track"."AlbumId" = "Album"."AlbumId"
    INNER JOIN "Artist" ON "Album"."ArtistId" = "Artist"."ArtistId"
    GROUP BY "Track"."TrackId", "Track"."Name", "Artist"."Name", "Album"."Title", "Track"."UnitPrice"
    ORDER BY "TotalRevenue" DESC
    LIMIT N;
END;
$$ LANGUAGE plpgsql;

-- 4. Thêm cột “amount” vào bảng InvoiceLine để lưu trữ giá phải trả cho bài hát trong hoá đơn. Sau đó viết câu lệnh SQL để tính giá trị cho cột “amount” này (amount = UnitPrice*Quantity). Viết hàm trigger để tự động cập nhập cột amount khi dữ liệu được cập nhập hoặc thêm mới
ALTER TABLE "InvoiceLine"
ADD COLUMN "Amount" NUMERIC(10,2);

UPDATE "InvoiceLine"
SET "Amount" = "UnitPrice" * "Quantity";

CREATE OR REPLACE FUNCTION UpdateInvoiceLineAmount()
RETURNS TRIGGER AS $$
BEGIN
    NEW."Amount" := NEW."UnitPrice" * NEW."Quantity";
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER UpdateInvoiceLineAmountTrigger
BEFORE INSERT OR UPDATE ON "InvoiceLine"
FOR EACH ROW EXECUTE FUNCTION UpdateInvoiceLineAmount();

-- 5. Viết hàm trigger để đảm bảo rằng trên bảng Track không có bản ghi nào được thêm mới hay cập nhập mà trường Milliseconds < 0
CREATE OR REPLACE FUNCTION CheckTrackMilliseconds()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW."Milliseconds" < 0 THEN
        RAISE EXCEPTION 'Milliseconds < 0';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER CheckTrackMillisecondsTrigger
BEFORE INSERT OR UPDATE ON "Track"
FOR EACH ROW EXECUTE FUNCTION CheckTrackMilliseconds();

-- 6. Tạo index để tối ưu cho các truy vấn sử dụng trong câu truy vấn/hàm viết ở câu 1,2,3`
CREATE INDEX ON "Track"("GenreId");
CREATE INDEX ON "Customer"("Company");
CREATE INDEX ON "Invoice"("Total");


