import { Module, Global } from '@nestjs/common';
import { FirebaseService } from './firebase.service';
import * as admin from 'firebase-admin';
import { ConfigModule, ConfigService } from '@nestjs/config';
import type { ServiceAccount } from 'firebase-admin';

@Global()
@Module({
  imports: [ConfigModule],
  providers: [
    FirebaseService,
    {
      provide: 'FIREBASE_ADMIN',
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => {
        const serviceAccountJson = configService.get<string>(
          'FIREBASE_SERVICE_KEY',
        );
        if (!serviceAccountJson) {
          throw new Error('Firebase service key is not available');
        }
        const serviceAccount = JSON.parse(serviceAccountJson) as ServiceAccount;
        return admin.initializeApp({
          credential: admin.credential.cert(serviceAccount),
        });
      },
    },
  ],
  exports: ['FIREBASE_ADMIN', FirebaseService],
})
export class FirebaseModule {}
