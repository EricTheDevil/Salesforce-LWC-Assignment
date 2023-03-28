import { LightningElement, api } from "lwc";
import styles from "./shoppingCart.css";

export default class ShoppingCart extends LightningElement {
    @api items = [];

    get cartItemsWithTotal() {
        return this.items.map((item) => {
            return {
                ...item,
                itemTotal: item.product.Price__c * item.quantity,
            };
        });
    }

    get totalCost() {
        let cost = 0;
        this.items.forEach((item) => {
            cost += item.product.Price__c * item.quantity;
        });
        return cost;
    }

    /** Communication with the parent for placing the order */  
    handlePlaceOrder() {
        this.dispatchEvent(new CustomEvent("placeorder"));
    }

    /**
     * Increases the quantity. 
     * @param {CustomEvent} increasequantity - selected product as a detail payload.
     */      
    handleIncreaseQuantity(event) {
        const productId = event.target.dataset.id;
        this.dispatchEvent(
            new CustomEvent("increasequantity", { detail: { productId } })
        );
    }
    
    /**
     * Decreases the quantity. 
     * @param {CustomEvent} decreasequantity - selected product as a detail payload.
     */      
    handleDecreaseQuantity(event) {
        const productId = event.target.dataset.id;
        this.dispatchEvent(
            new CustomEvent("decreasequantity", { detail: { productId } })
        );
    }
}
