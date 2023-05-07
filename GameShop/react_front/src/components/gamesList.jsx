import useShopItems from '../hooks/useShopItems';
import {useState}  from 'react';
import {postOrder} from '../shopApi'

export default function GamesList() {
    const shopItemsHook = useShopItems()
    const items = shopItemsHook.shopItems
    const message = shopItemsHook.message
    const [basket, setBasket] = useState([]);
    let basketSum = basket.reduce((total, current) => {return total + current.minPrice}, 0.0)
    
    const [orderStatus, setOrderStatus] = useState("");

    const addToBasket = (item) => {        
        if(basket.some(i => item.id == i.id)) return
        const newBasket = basket.concat(item)
        setBasket(newBasket)
    }
    const removeFromBasket = (item) => {        
        if(!basket.some(i => item.id == i.id)) return
        const newBasket = basket.filter(it => it.id !== item.id)
        setBasket(newBasket)
    }
    const orderBasket = () => {
        const errorMessage = "Error ordering items - please try again later."
        if(basket.length === 0) return
        postOrder(basket).then(res => {
            if(res.status == 200) {
                setBasket([])
                setOrderStatus("You items have been ordered.\nYou will recieve activation codes on email.")
            } else {
                setOrderStatus(errorMessage)
            }
        }).catch((exc)=>{
            console.log(exc)
            setOrderStatus(errorMessage)})
    }

    return (
    <div>
        <h3>Indie games shop</h3>
        {message}
        <table className="games-list-table" border="1">
        <tbody>
            <tr>
            <th>Game name</th>
            <th>Developement status</th>
            <th>price</th>
            </tr>
            {items.map((item) => (
                <tr key={item.id}>
                <td>{item.name}</td>
                <td>{item.status}</td>
                <td>{item.minPrice}</td>
                <td> <button type="button" onClick={()=>addToBasket(item)}>
                        Add to basket
                     </button> </td>
                </tr>
            ))}
        </tbody>
        </table>
        <br></br>
        
        Basket: 
        <table className="games-list-table" border="1">
        <tbody>
            <tr>
            <th>Game name</th>
            <th>Price</th>
            </tr>
            {basket.map((item) => (
                <tr key={item.id}>
                <td>{item.name}</td>
                <td>{item.minPrice}</td>
                <td> <button type="button" onClick={()=>removeFromBasket(item)}>
                        Remove
                     </button> </td>
                </tr>
            ))}
                
                <tr key='summary'>
                    <td>Sum</td>
                    <td>{basketSum}</td>
                    <td> <button className='basketOrder' type="button" 
                                 onClick={()=>orderBasket()}>
                        Order</button>
                     </td>
                </tr>
        </tbody>
        </table>
            {orderStatus}
    </div>
    )
}