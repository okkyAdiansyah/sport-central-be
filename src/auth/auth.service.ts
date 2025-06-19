import { BadRequestException, Injectable } from '@nestjs/common';
import { Request, Response } from 'express';
import { FirebaseService } from 'src/firebase/firebase.service';
import { PrismaService } from 'src/prisma/prisma.service';
import { CreateUserDTO } from './dto/create-user.dto';
import { Users } from '@prisma/client';
import { UserDTO } from './dto/user.dto';

@Injectable()
export class AuthService {
  constructor(
    private readonly firebase: FirebaseService,
    private readonly prisma: PrismaService,
  ) {}

  async registerNewUser(newUser: CreateUserDTO): Promise<Users> {
    const { username, email, firebase_id, role } = newUser;
    try {
      const userId = await this.firebase.validateToken(firebase_id);

      const user = await this.prisma.users.create({
        data: {
          username: username,
          email: email,
          firebase_id: userId.uid,
          role: role,
        },
      });

      return user;
    } catch (error: unknown) {
      const message =
        error instanceof Error ? error.message : 'Unknown error message';
      throw new BadRequestException({
        source: 'AuthService',
        message: 'Failed to register new user',
        reason: message,
      });
    }
  }

  async userLogin(token: string): Promise<UserDTO | null> {
    try {
      const userID = await this.firebase.validateToken(token);
      const user = await this.prisma.users.findUnique({
        where: {
          firebase_id: userID.uid,
        },
      });

      return user;
    } catch (error: unknown) {
      const message =
        error instanceof Error ? error.message : 'Unknown error message';
      throw new BadRequestException({
        source: 'AuthService',
        message: 'Failed to login',
        reason: message,
      });
    }
  }
}
