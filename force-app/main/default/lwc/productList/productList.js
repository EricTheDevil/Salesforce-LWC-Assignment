import { LightningElement, api } from "lwc";

/**
 * The ProductList component displays a list of products.
 * It also listens for addtocartitem events fired by its child components (ProductItem).
 */
export default class ProductList extends LightningElement {
    @api products = [];

    /**
     * Handles addtocartitem event to add a product to the cart and sends to parent. 
     * @param {CustomEvent} addtocart - selected product as a detail payload.
     */     
    handleAddToCartItem(event) {
        this.dispatchEvent(
            new CustomEvent("addtocart", { detail: event.detail })
        );
    }
}
