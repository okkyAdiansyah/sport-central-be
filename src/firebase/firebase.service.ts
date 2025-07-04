import { Inject, Injectable, UnauthorizedException } from '@nestjs/common';
import { app } from 'firebase-admin';
import type { DecodedIdToken } from 'firebase-admin/lib/auth/token-verifier';

@Injectable()
export class FirebaseService {
  constructor(
    @Inject('FIREBASE_APP')
    private readonly admin: app.App,
  ) {}

  async validateToken(tokenId: string): Promise<DecodedIdToken> {
    try {
      const decodedToken = await this.admin.auth().verifyIdToken(tokenId);
      return decodedToken;
    } catch (error: unknown) {
      const message =
        error instanceof Error ? error.message : 'Unknown error message';
      throw new UnauthorizedException({
        source: 'FirebaseService',
        message: 'Invalid Token',
        details: message,
      });
    }
  }
}
