
create database PracticeViewIndexStoreProcedure;

use practiceviewindexstoreprocedure;

create table Products
(
    Id                 int primary key,
    productCode        char(10),
    productName        nvarchar(50),
    productPrice       float,
    productAmount      int,
    productDescription text,
    productStatus      boolean
);

INSERT INTO practiceviewindexstoreprocedure.products (Id, productCode, productName, productPrice, productAmount, productDescription, productStatus) VALUES
(1, 'book1', 'Đắc nhân tâm', 300000, 5, 'Nghệ thuật thu phục lòng người và làm tất cả mọi người phải yêu mến mình.', null),
(2, 'book2', 'Nhà giả kim', 250000, 3, 'Nhà giả kim của Paulo Coelho là một cuốn sách dành cho những người đã đánh mất đi ước mơ hoặc chưa bao giờ có nó.', null),
(3, 'book3', 'Tuổi trẻ đáng giá bao nhiêu?', 280000, 9, 'Hãy làm những điều bạn thích. Hãy đi theo tiếng nói trái tim. Hãy sống theo cách bạn cho là mình nên sống.', null),
(4, 'book4', 'Dạy con làm giàu', 500000, 4, 'Cách suy nghĩ về đồng tiền sẽ quyết định tương lai và sự giàu có của bạn.', null),
(5, 'book5', 'Mỗi lần vấp ngã là một lần trưởng thành', 430000, 6, 'Những câu chuyện thực về đối nhân xử thế', null),
(6, 'book6', 'Đời thay đổi khi chúng ta thay đổi', 180000, 8, 'Đời thay đổi khi chúng ta thay đổi” đem lại cho độc giả những tình huống vô cùng thực tế', null);

-- Index
/*
Tạo Unique Index trên bảng Products (sử dụng cột productCode để tạo chỉ mục)
Tạo Composite Index trên bảng Products (sử dụng 2 cột productName và productPrice)
Sử dụng câu lệnh EXPLAIN để biết được câu lệnh SQL của bạn thực thi như nào
So sánh câu truy vấn trước và sau khi tạo index
 */
create index idx_productCode on products(productCode);

explain select productCode,productName from Products where productCode = 'book3';

create index idx_Name_Price on Products(productName,productPrice);

explain select productName,productPrice from Products where productName = 'Nhà giả kim' or productPrice = 280000;

-- View
/*
Tạo view lấy về các thông tin: productCode, productName, productPrice, productStatus từ bảng products.
Tiến hành sửa đổi view
Tiến hành xoá view
 */
create view Product_view as
    select productCode,
           productName,
           productPrice,
           productStatus
    from products;

select *from Product_view;

create or replace view Product_view as
    select productCode,
           productName,
           productPrice,
           productDescription
    from products
    where productCode = 'book3'or productPrice = 180000;

select *from Product_view;

drop view product_view;

-- Store Procedure
/*
Tạo store procedure lấy tất cả thông tin của tất cả các sản phẩm trong bảng product
Tạo store procedure thêm một sản phẩm mới
Tạo store procedure sửa thông tin sản phẩm theo id
Tạo store procedure xoá sản phẩm theo id
 */
delimiter //
drop procedure if exists sp_AllProduct;
create procedure sp_AllProduct()
begin
    select * from products;
end //
delimiter ;

call sp_AllProduct();

delimiter //
drop procedure if exists sp_InsertNewProduct;
create procedure sp_InsertNewProduct(in newId                 int ,
                                     in newProductCode        char(10),
                                     in newProductName        nvarchar(50),
                                     in newProductPrice       float,
                                     in newProductAmount      int,
                                     in newProductDescription text,
                                     in newProductStatus      boolean)
                                     begin
                                         insert into products values(
                                                                     newId,
                                                                     newProductCode,
                                                                     newProductName,
                                                                     newProductPrice,
                                                                     newProductAmount,
                                                                     newProductDescription,
                                                                     newProductStatus
                                                                     );
                                     end //
delimiter ;

call sp_InsertNewProduct(7, 'book7', 'Cho tôi xin 1 vé đi tuổi thơ', 190000, 8, 'Tác giả cũng muốn gửi gắm bạn vào quyển sách này những tình cảm, niềm nhung nhớ cho 1 thời tuổi thơ và những câu chuyện đầy sâu sắc, ý nghĩa trong cuộc sống gia đình và bạn bè.', null);

select * from products;

delimiter //
drop procedure if exists sp_UpdateProduct;
create procedure sp_UpdateProduct(in newId                 int ,
                                     in newProductCode        char(10),
                                     in newProductName        nvarchar(50),
                                     in newProductPrice       float,
                                     in newProductAmount      int,
                                     in newProductDescription text,
                                     in newProductStatus      boolean)
begin
    update products set productCode=newProductCode,
                        productName=newProductName,
                        productPrice=newProductPrice,
                        productAmount=newProductAmount,
                        productDescription=newProductDescription,
                        productStatus=newProductStatus
    where Id=newId;
end //
delimiter ;

call sp_UpdateProduct(7, 'book7', 'Cho tôi xin 1 vé đi tuổi thơ111', 190000, 8, 'Những tình cảm, niềm nhung nhớ cho 1 thời tuổi thơ và những câu chuyện đầy sâu sắc, ý nghĩa trong cuộc sống gia đình và bạn bè. ', null)

select *
from products;


delimiter //
drop procedure if exists sp_DeleteProduct;
create procedure sp_DeleteProduct(in newId int)
begin
    delete from products where Id=newId;
end //
delimiter ;

call sp_DeleteProduct(7);

select *
from products;

