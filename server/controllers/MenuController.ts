import {Request, Response} from 'express';
import * as MenuModel from '../models/MenuModel';
import {Menu} from '../interface/Menu';
import {db} from '../config/database';
import dotenv from 'dotenv';

export async function getMenu(req: Request, res: Response){
    const idKantin: number = Number(req.params.id);
    MenuModel.getOne(idKantin, (err: Error, menus: Menu[]) => {
        if (err) {
            return res.status(500).json({errorMessage: err.message})
        }

        res.status(200).json({data: menus})
    })
}