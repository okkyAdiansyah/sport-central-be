import { Injectable, UnauthorizedException } from '@nestjs/common';
import { Request, Response } from 'express';
import { FirebaseService } from 'src/firebase/firebase.service';
import { PrismaService } from 'src/prisma/prisma.service';
import { CreateUserDTO } from './dto/create-user.dto';
import { Users } from '@prisma/client';

@Injectable()
export class AuthService {
  constructor(
    private readonly firebase: FirebaseService,
    private readonly prisma: PrismaService,
  ) {}

  async registerNewUser(newUser: CreateUserDTO): Promise<Users> {
    const { username, email, firebase_id, role } = newUser;

    // Validate firebase token
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
  }

  async userLogin(token: string): Promise<Users | null> {
    if (!token || !token.startsWith('Bearer ')) {
      throw new UnauthorizedException('Missing User Token ID');
    }
    const userID = token.split(' ')[1];
    const decodedToken = await this.firebase.validateToken(userID);
    const user = await this.prisma.users.findUnique({
      where: {
        firebase_id: decodedToken.uid,
      },
    });

    return user;
  }
}
