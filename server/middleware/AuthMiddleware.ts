import {Request, Response, NextFunction, request} from 'express';
import dotenv from 'dotenv';
import jwt from 'jsonwebtoken'
dotenv.config(); // config env

const AuthMiddleware = (req: Request, res: Response, next: NextFunction) => {
    let token = req.headers.authorization?.split(' ')[1];

    if (token) {
        jwt.verify(token, 'SECRET_007***', (error, decoded) => {
            if (error) {
                return res.status(404).json({
                    message: error.message,
                })
            } else {
                res.locals.jwt = decoded;
                next()
            }
        })
    }else{
        return res.status(401).json({
            message: 'Unauthorized'
        })
    }
}

export default AuthMiddleware;