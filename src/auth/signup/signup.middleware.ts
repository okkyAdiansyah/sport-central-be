import { Injectable, NestMiddleware } from '@nestjs/common';
import { NextFunction, Request, Response } from 'express';
import { FirebaseService } from 'src/firebase/firebase.service';

@Injectable()
export class SignupMiddleware implements NestMiddleware {
  constructor(private readonly firebaseService: FirebaseService) {}
  async use(req: Request, res: Response, next: NextFunction) {
    if (!req.body) {
      return res.status(400).json({ message: 'Missing request body' });
    }

    const body = req.body as { userId: string };
    const token = body.userId;

    const user = await this.firebaseService.validateToken(token);

    req['user'] = user;

    next();
  }
}
