import express, {Application, Request, Response} from 'express';
import bodyParser from 'body-parser';
import morgan from 'morgan';
import cors from 'cors';
import dotenv from 'dotenv';
dotenv.config(); // config env

// Routes
import UserRoute from './routes/UserRoute'
import DashboardRoute from './routes/DashboardRoute'
import KantinRoute from './routes/KantinRoute'
import MenuRoute from './routes/MenuRoute'

class App{
    public app: Application;

    constructor(){
        this.app = express();
        this.plugins();
        this.routes();
    }

    protected plugins(): void{
        this.app.use(bodyParser.urlencoded({extended: true}))
        this.app.use(bodyParser.json())
        this.app.use(morgan('dev'))
        this.app.use(cors())
    }

    protected routes(): void{
        this.app.use('/user', UserRoute)
        this.app.use('/dashboard', DashboardRoute)
        this.app.use('/kantin', KantinRoute)
        this.app.use('/menu', MenuRoute)
    }
}

const app = new App().app;
app.listen(process.env.PORT)