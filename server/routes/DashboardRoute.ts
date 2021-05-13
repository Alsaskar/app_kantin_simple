import {Router} from 'express';
import {beranda} from '../controllers/DashboardController';
import AuthMiddleware from '../middleware/AuthMiddleware';

const router = Router()

router.route('/').get(AuthMiddleware, beranda)

export default router;