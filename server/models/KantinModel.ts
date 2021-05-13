import {db} from '../config/database';
import {Kantin} from '../interface/Kantin';
import {OkPacket, RowDataPacket} from 'mysql2';

export const findAll = (callback: Function) => {
    const query = 'SELECT * FROM kantin';

    db.query(query, (err, result) => {
        if(err) {callback(err)}

        const rows = <RowDataPacket[]> result;
        const canteens: Kantin[] = [];

        rows.forEach(row => {
            const canteen: Kantin = {
                id: row.id,
                nama: row.nama,
                foto: row.foto,
                alamat: row.alamat
            }

            canteens.push(canteen)
        })

        callback(null, canteens)
    })
}