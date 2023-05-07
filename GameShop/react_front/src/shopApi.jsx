import axios from "axios";

const BACKEND_URL = "http://localhost:3001"


async function getItems() {
    return axios.get(BACKEND_URL + '/items')
}

async function postOrder(orderItems) {
    return axios.post(BACKEND_URL + '/order',
        {"order": orderItems}
    )
}


export {
    getItems,
    postOrder
}