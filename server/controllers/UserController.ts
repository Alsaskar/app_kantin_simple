import {Request, Response} from 'express';
import * as UserModel from '../models/UserModel';
import {User} from '../interface/User';
import dotenv from 'dotenv';
import {OkPacket, RowDataPacket} from 'mysql2';
import {db} from '../config/database';
const bcrypt = require('bcrypt')

const jwt = require('jsonwebtoken')
dotenv.config(); // config env

export async function register(req: Request, res: Response){
    const newUser: User = req.body;

    UserModel.create(newUser, (err: Error, userId: number) => {
        if(err){
            return res.status(500).json({'message': err.message, 'success': false})
        }

        res.status(200).json({
            'message': 'Berhasil mendaftar',
            'success': true,
            'userId': userId
        })
    })
}

export async function login(req: Request, res: Response){    
    const email = req.body.email
    const password = req.body.password

    const query = 'SELECT id, firstname, lastname, email, password, role FROM users WHERE email = ?';

    db.query(query, email, (err, result) => {
        if(err) {err}

        const row = (<RowDataPacket> result)[0];
        const count = (<RowDataPacket> result).length;

        if (count > 0) { // jika email benar

            bcrypt.compare(password, row.password, (error: Error, response: Response) => {
                if(error) {error}
                
                if(response){ // jika berhasil login
                    const payload = {
                        id: row.id,
                        firstname: row.firstname,
                        lastname: row.lastname,
                        email: row.email,
                        loggedIn: true
                    }
                    const token = jwt.sign(payload, process.env.SECRET_TOKEN, {expiresIn: '1day'});

                    const users = {
                        id: row.id,
                        firstname: row.firstname,
                        lastname: row.lastname,
                        email: row.email,
                        role: row.role,
                        token: token,
                    }
            
                    res.status(200).json({users: users, loggedIn: true})
                }else{ // jika gagal login
                    res.status(401).json({error: 'Password salah', loggedIn: false})
                }
            })
        } else { // jika email salah
            res.status(401).json({error: 'Email salah', loggedIn: false})
        }
    })

    // UserModel.login(email, password, (err: Error, user: User) => {
    //     if(err){
    //         return res.status(500).json({'message': err.message})
    //     }

    //     res.status(200).json({'data': user})
    // })
}