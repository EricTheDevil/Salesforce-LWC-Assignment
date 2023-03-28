import { LightningElement, api } from "lwc";
import style from "./productItem.css";

/**
 * The ProductItem component represents a single product in a list of products. 
 * It displays information about the product (such as its name, image, and price)
 */
export default class ProductItem extends LightningElement {
    @api product;

    /**
     * Handles the user's request to add a product to the cart. 
     * @param {CustomEvent} addtocartitem - selected product as a detail payload.
     */                     
    handleAddToCart() {
        this.dispatchEvent(
            new CustomEvent("addtocartitem", { detail: this.product })
        );
    }
}
