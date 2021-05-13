import {db} from '../config/database';
import {Menu} from '../interface/Menu';
import {OkPacket, RowDataPacket} from 'mysql2';

export const getOne = (idKantin: number, callback: Function) => {
    const query = 'SELECT * FROM menu WHERE id_kantin = ? ORDER BY id DESC';

    db.query(query, [idKantin], (err, result) => {
        if(err) {callback(err)}

        const rows = <RowDataPacket[]> result;
        const menus: Menu[] = [];

        rows.forEach(row => {
            const menu: Menu = {
                id: row.id,
                id_kantin: row.id_kantin,
                nama_menu: row.nama_menu,
                foto: row.foto,
                harga: row.harga,
                stock: row.stock
            }

            menus.push(menu)
        })

        callback(null, menus)
    })
}