import { Role } from '@prisma/client';
import { IsEmail, IsEnum, IsString } from 'class-validator';

// export enum Role {
//   ADMIN = 'admin',
//   CASHIER = 'cashier',
//   CUSTOMER = 'customer',
// }

export class CreateUserDTO {
  @IsString()
  username: string;

  @IsEmail()
  email: string;

  @IsString()
  firebase_id: string;

  @IsEnum(Role)
  role: Role;
}
