import {Router} from 'express';
import {getAll} from '../controllers/KantinController';

const router = Router()

router.route('/get-all').get(getAll)

export default router;