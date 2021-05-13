import {Router} from 'express';
import {login, register} from '../controllers/UserController';

const router = Router()

router.route('/login').post(login)
router.route('/register').post(register)

// router.route('/:profilId')
//     .get(getProfil)
//     .delete(deleteProfil)
//     .put(updateProfil)

export default router;