import {
  BadRequestException,
  Body,
  Controller,
  Headers,
  NotFoundException,
  Post,
} from '@nestjs/common';
import { CreateUserDTO } from './dto/create-user.dto';
import { AuthService } from './auth.service';
import { UserDTO } from './dto/user.dto';
import { FirebaseService } from 'src/firebase/firebase.service';

@Controller('auth')
export class AuthController {
  constructor(
    private authService: AuthService,
    private readonly firebaseService: FirebaseService,
  ) {}

  @Post('signup')
  async register(@Body() newUser: CreateUserDTO) {
    if (!newUser) {
      throw new BadRequestException('Missing correct request body');
    }

    try {
      const user = await this.authService.registerNewUser(newUser);
      return {
        username: user.username,
        email: user.email,
        role: user.role,
      };
    } catch {
      throw new BadRequestException('Failed to register new user');
    }
  }

  @Post('login')
  async login(
    @Headers('authorization') authorization: string,
  ): Promise<UserDTO> {
    const user = await this.authService.userLogin(authorization);
    if (!user) {
      throw new NotFoundException('No User Found');
    }
    return {
      username: user.username,
      email: user.email,
      role: user.role,
    };
  }
}
