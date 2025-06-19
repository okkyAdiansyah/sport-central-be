import { Role } from '@prisma/client';
import { IsEmail, IsEnum, IsString } from 'class-validator';

export class UserDTO {
  @IsString()
  username: string;

  @IsEmail()
  email: string;

  @IsEnum(Role)
  role: Role;
}

export class LoginDTO {
  @IsString()
  token: string;
}
