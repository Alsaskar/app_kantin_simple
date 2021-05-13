import {db} from '../config/database';
import {User} from '../interface/User';
import {OkPacket, RowDataPacket} from 'mysql2';
const bcrypt = require('bcrypt')
const jwt = require('jsonwebtoken')

export const create = (user: User, callback: Function) => {
    // create hash password
    const salt = bcrypt.genSaltSync(10);
    const hash = bcrypt.hashSync(user.password, salt)

    const query = 'INSERT INTO users(firstname, lastname, email, password, role) VALUES(?, ?, ?, ?, ?)';

    db.query(query, [user.firstname, user.lastname, user.email, hash, user.role], (err, result) => {
        if(err) throw err;

        const insertId = (<OkPacket> result).insertId;
        callback(null, insertId)
    })
}

export const login = (userEmail: string, userPass: string, callback: Function) => {
    const query = 'SELECT id, firstname, lastname, email, password, role FROM users WHERE email = ?';

    db.query(query, userEmail, (err, result) => {
        if(err) {callback(err)}

        const row = (<RowDataPacket> result)[0];
        const count = (<RowDataPacket> result).length;

        if (count > 0) { // jika email benar

            bcrypt.compare(userPass, row.password, (error: Error, response: Response) => {
                if(error) {callback(error)}
                
                if(response){ // jika berhasil login
                    const payload = {
                        id: row.id,
                        firstname: row.firstname,
                        lastname: row.lastname,
                        email: row.email,
                    }
                    const token = jwt.sign(payload, process.env.SECRET_TOKEN, {expiresIn: '1day'});

                    const users = {
                        firstname: row.firstname,
                        lastname: row.lastname,
                        email: row.email,
                        role: row.role,
                        token: token
                    }
            
                    callback(null, users)
                }else{ // jika gagal login
                    callback(null, 'Password salah')
                }
            })
        } else { // jika email salah
            callback(null, 'Email salah')
        }
    })
}

export const findAll = (callback: Function) => {
    const query = 'SELECT * FROM users';

    db.query(query, (err, result) => {
        if(err) {callback(err)}

        const rows = <RowDataPacket[]> result;
        const users: User[] = [];

        rows.forEach(row => {
            const user: User = {
                firstname: row.firstname,
                lastname: row.lastname,
                email: row.email,
                password: row.password,
                role: row.role
            }

            users.push(user)
        })

        callback(null, users)
    })
}

export const update = (user: User, callback: Function) => {
    const query = 'UPDATE users SET id = ?';

    db.query(query, [user.id], (err, result) => {
        if(err) {callback(err)}

        callback(null)
    })
}