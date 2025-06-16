-- CreateEnum
CREATE TYPE "Role" AS ENUM ('CUSTOMER', 'ADMIN', 'CASHIER');

-- CreateEnum
CREATE TYPE "Type" AS ENUM ('PLACE', 'PRODUCT');

-- CreateEnum
CREATE TYPE "BookingStatus" AS ENUM ('PENDING', 'CONFIRMED', 'CANCELLED', 'ACCEPTED');

-- CreateEnum
CREATE TYPE "BookingPriority" AS ENUM ('REGULAR', 'PRIORITIZE', 'VOID');

-- CreateEnum
CREATE TYPE "PaymentType" AS ENUM ('UPFRONT', 'FULL', 'CLOSING', 'VOID');

-- CreateEnum
CREATE TYPE "PaymentMethod" AS ENUM ('CASH', 'QRIS', 'CREDITCARD', 'DEBITCARD', 'EWALLET');

-- CreateEnum
CREATE TYPE "PaymentStatus" AS ENUM ('PENDING', 'PAID', 'FAILED', 'CANCELLED', 'REFUNDED', 'VOID');

-- CreateTable
CREATE TABLE "Users" (
    "id" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "firebase_id" TEXT NOT NULL,
    "role" "Role" NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Categories" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "type" "Type" NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Products" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "item_sub_id" TEXT NOT NULL,
    "sport_category_id" TEXT NOT NULL,
    "product_category_id" TEXT NOT NULL,
    "hourly_prices" DOUBLE PRECISION NOT NULL,
    "is_maintainance" BOOLEAN NOT NULL,
    "is_available" BOOLEAN NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_by_id" TEXT NOT NULL,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_by_id" TEXT NOT NULL,

    CONSTRAINT "Products_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Places" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "location" TEXT NOT NULL,
    "hourly_prices" DOUBLE PRECISION NOT NULL,
    "sport_category_id" TEXT NOT NULL,
    "operational_hours" JSONB NOT NULL,
    "is_maintainance" BOOLEAN NOT NULL,
    "is_available" BOOLEAN NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_by_id" TEXT NOT NULL,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_by_id" TEXT NOT NULL,

    CONSTRAINT "Places_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Packages" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "package_type" "Type" NOT NULL,
    "product_id" TEXT,
    "place_id" TEXT,
    "features" JSONB NOT NULL,

    CONSTRAINT "Packages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Bookings" (
    "id" TEXT NOT NULL,
    "customer_name" TEXT NOT NULL,
    "booking_for" "Type" NOT NULL,
    "product_id" TEXT,
    "place_id" TEXT,
    "staff_book_id" TEXT,
    "customer_book_id" TEXT,
    "booking_date" TIMESTAMP(3) NOT NULL,
    "booking_is_hourly" BOOLEAN NOT NULL,
    "package_id" TEXT,
    "booking_status" "BookingStatus" NOT NULL DEFAULT 'PENDING',
    "booking_priority" "BookingPriority" NOT NULL DEFAULT 'REGULAR',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_by_id" TEXT NOT NULL,

    CONSTRAINT "Bookings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Rents" (
    "id" TEXT NOT NULL,
    "booking_ref_id" TEXT,
    "end_time" TIMESTAMP(3) NOT NULL,
    "payment_status" "PaymentType",
    "is_extended" BOOLEAN NOT NULL,
    "total_extended" INTEGER NOT NULL,
    "total_prices" DOUBLE PRECISION NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_by_id" TEXT NOT NULL,

    CONSTRAINT "Rents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Payments" (
    "id" TEXT NOT NULL,
    "payment_type" "PaymentType" NOT NULL,
    "amount" DOUBLE PRECISION NOT NULL,
    "method" "PaymentMethod" NOT NULL,
    "status" "PaymentStatus" NOT NULL,
    "reference_code" TEXT NOT NULL,
    "notes" TEXT NOT NULL,
    "method_details" JSONB NOT NULL,
    "paid_at" TIMESTAMP(3) NOT NULL,
    "booking_id" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_by_id" TEXT NOT NULL,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_by_id" TEXT NOT NULL,

    CONSTRAINT "Payments_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Users_email_key" ON "Users"("email");

-- AddForeignKey
ALTER TABLE "Products" ADD CONSTRAINT "Products_sport_category_id_fkey" FOREIGN KEY ("sport_category_id") REFERENCES "Categories"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Products" ADD CONSTRAINT "Products_product_category_id_fkey" FOREIGN KEY ("product_category_id") REFERENCES "Categories"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Products" ADD CONSTRAINT "Products_created_by_id_fkey" FOREIGN KEY ("created_by_id") REFERENCES "Users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Products" ADD CONSTRAINT "Products_updated_by_id_fkey" FOREIGN KEY ("updated_by_id") REFERENCES "Users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Places" ADD CONSTRAINT "Places_sport_category_id_fkey" FOREIGN KEY ("sport_category_id") REFERENCES "Categories"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Places" ADD CONSTRAINT "Places_created_by_id_fkey" FOREIGN KEY ("created_by_id") REFERENCES "Users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Places" ADD CONSTRAINT "Places_updated_by_id_fkey" FOREIGN KEY ("updated_by_id") REFERENCES "Users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Packages" ADD CONSTRAINT "Packages_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "Products"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Packages" ADD CONSTRAINT "Packages_place_id_fkey" FOREIGN KEY ("place_id") REFERENCES "Places"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Bookings" ADD CONSTRAINT "Bookings_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "Products"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Bookings" ADD CONSTRAINT "Bookings_place_id_fkey" FOREIGN KEY ("place_id") REFERENCES "Places"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Bookings" ADD CONSTRAINT "Bookings_staff_book_id_fkey" FOREIGN KEY ("staff_book_id") REFERENCES "Users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Bookings" ADD CONSTRAINT "Bookings_customer_book_id_fkey" FOREIGN KEY ("customer_book_id") REFERENCES "Users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Bookings" ADD CONSTRAINT "Bookings_package_id_fkey" FOREIGN KEY ("package_id") REFERENCES "Packages"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Bookings" ADD CONSTRAINT "Bookings_updated_by_id_fkey" FOREIGN KEY ("updated_by_id") REFERENCES "Users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Rents" ADD CONSTRAINT "Rents_booking_ref_id_fkey" FOREIGN KEY ("booking_ref_id") REFERENCES "Bookings"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Rents" ADD CONSTRAINT "Rents_updated_by_id_fkey" FOREIGN KEY ("updated_by_id") REFERENCES "Users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Payments" ADD CONSTRAINT "Payments_booking_id_fkey" FOREIGN KEY ("booking_id") REFERENCES "Bookings"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Payments" ADD CONSTRAINT "Payments_created_by_id_fkey" FOREIGN KEY ("created_by_id") REFERENCES "Users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Payments" ADD CONSTRAINT "Payments_updated_by_id_fkey" FOREIGN KEY ("updated_by_id") REFERENCES "Users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
