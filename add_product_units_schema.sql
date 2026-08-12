-- ─────────────────────────────────────────────────────────────
-- نظام السوبر ماركت والمواد الغذائية: الوحدات ودعم الكميات الكسرية
-- وتطهير قاعدة البيانات من خصائص الملابس (ألوان ومواسم)
-- شغّل هذا الملف في Supabase SQL Editor
-- ─────────────────────────────────────────────────────────────

-- 1) إزالة أعمدة الملابس السابقة إن وجدت
alter table products drop column if exists season;
alter table products drop column if exists color;

-- 2) عمود الوحدة على المنتجات (الافتراضي: قطعة)
alter table products
  add column if not exists unit text not null default 'قطعة';

-- 3) السماح بكميات كسرية (وزن/حجم) في المخزون والفواتير
--    تحويل أعمدة الكمية من integer إلى numeric
alter table products
  alter column stock_quantity type numeric using stock_quantity::numeric;

alter table purchase_items
  alter column quantity type numeric using quantity::numeric;

alter table order_items
  alter column quantity type numeric using quantity::numeric,
  alter column returned_quantity type numeric using returned_quantity::numeric;

-- 4) إضافة تصنيفات السوبر ماركت الافتراضية
insert into categories (name)
select name from (values 
  ('ألبان ومجمدات'),
  ('بقالة جافة'),
  ('مشروبات وحلويات'),
  ('منظفات ورقيات'),
  ('خضار وفواكه'),
  ('لحوم وأسماك'),
  ('مخبوزات')
) as t(name)
where not exists (select 1 from categories where categories.name = t.name);

-- تم. الآن النظام مهيأ بالكامل للسوبر ماركت والمواد الغذائية والأوزان.
