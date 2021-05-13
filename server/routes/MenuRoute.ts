import {Router} from 'express';
import {getMenu} from '../controllers/MenuController';

const router = Router()

router.route('/:id').get(getMenu)

export default router;