import {
  BadRequestException,
  Body,
  Controller,
  NotFoundException,
  Post,
} from '@nestjs/common';
import { CreateUserDTO } from './dto/create-user.dto';
import { AuthService } from './auth.service';
import { LoginDTO, UserDTO } from './dto/user.dto';
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
    const user = await this.authService.registerNewUser(newUser);
    return {
      username: user.username,
      email: user.email,
      role: user.role,
    };
  }

  @Post('login')
  async login(@Body() loginDTO: LoginDTO): Promise<UserDTO> {
    if (!loginDTO) {
      throw new BadRequestException('Missing login token');
    }

    const user = await this.authService.userLogin(loginDTO.token);
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
