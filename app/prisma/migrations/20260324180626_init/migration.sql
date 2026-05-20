-- CreateEnum
CREATE TYPE "public"."task_status" AS ENUM ('pending', 'done');

-- CreateTable
CREATE TABLE "public"."Task" (
    "id" SERIAL NOT NULL,
    "title" VARCHAR(32) NOT NULL,
    "status" "public"."task_status" NOT NULL DEFAULT 'pending',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Task_pkey" PRIMARY KEY ("id")
);
