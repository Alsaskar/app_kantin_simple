import {Request, Response} from 'express';
import * as KantinModel from '../models/KantinModel';
import {Kantin} from '../interface/Kantin';
import {db} from '../config/database';
import dotenv from 'dotenv';

export async function getAll(req: Request, res: Response){
    KantinModel.findAll((err: Error, canteens: Kantin[]) => {
        if (err) {
            return res.status(500).json({errorMessage: err.message})
        }

        res.status(200).json({data: canteens})
    })
}