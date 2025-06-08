-- CreateEnum
CREATE TYPE "Role" AS ENUM ('CUSTOMER', 'ADMIN', 'CASHIER');

-- CreateTable
CREATE TABLE "User" (
    "id" SERIAL NOT NULL,
    "firestore_id" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "role" "Role" NOT NULL DEFAULT 'CUSTOMER',

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_firestore_id_key" ON "User"("firestore_id");

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");
