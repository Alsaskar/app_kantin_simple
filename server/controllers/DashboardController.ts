import {Request, Response} from 'express';

export async function beranda(req: Request, res: Response){
    return res.json({
        email: res.locals.jwt.email,
        firstname: res.locals.jwt.firstname,
    })
}