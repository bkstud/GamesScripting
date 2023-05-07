import {useState, useEffect}  from 'react';
import { getItems } from '../shopApi';




export default function useShopItems() {
    const [items, setShopItems] = useState([]);
    const [message, setMessage] = useState(<p>Loading game list...</p>);

    useEffect(() => {
        let errorMessage = <p>Error loading game list. Try again later.</p>
        getItems().then(res => {
            if(res.status == 200) {
                setShopItems(res.data)
                setMessage("")
            } else {
                setMessage(errorMessage)
            } 
        }).catch((exc)=>{
            console.log(exc)
            setMessage(errorMessage)}
        );
    }, [])

    return {"shopItems": items, "message": message}
}