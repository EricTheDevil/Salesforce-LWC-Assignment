import { LightningElement, track, wire } from "lwc";
import { loadStyle } from "lightning/platformResourceLoader";

import createOrder from "@salesforce/apex/OrderPlacementController.createOrder";
import getFilteredProducts from "@salesforce/apex/OrderPlacementController.getFilteredProducts";

import styles from "./mainApp.css";

/**
 * The MainApp component is the top-level component for the application. It is responsible
 * for managing the cart state and rendering the child components (productList, shoppingCart and productFilter) 
 */
export default class MainApp extends LightningElement {
    @track products;
    @track cartItems = [];
    selectedCategory = "all";

    /** Retrieve filtered products **/
    @wire(getFilteredProducts, { category: "$selectedCategory" })
    products;

    /** Add stylesheet **/
    renderedCallback() {
        const styleEl = document.createElement('style');
        styleEl.textContent = styles.default;
        this.template.appendChild(styleEl);
      }
      
    /** Update the selected category payload is the category  */      
    handleFilterChange(event) {
        this.selectedCategory = event.detail.category;
    }
    /** Handles and add a product to the cart payload is the selected item */      
    handleAddToCart(event) {
        const productToAdd = event.detail;
        const existingItemIndex = this.cartItems.findIndex(
            (item) => item.product.Id === productToAdd.Id
        );

        if (existingItemIndex >= 0) {
            this.cartItems[existingItemIndex].quantity += 1;
        } else {
            this.cartItems.push({
                product: productToAdd,
                quantity: 1,
                Price__c: productToAdd.Price__c,
            });
        }
    }

    /**
     *  This function handles adding a product to the cart and placing an order.
     *  It passes orderItems to both orderItems and orderChoices due to the way we destructurize them in the apex.
     */     
    async handlePlaceOrder(event) {
        if (this.cartItems.length === 0) {
            alert(
                "Your cart is empty. Add items to the cart before placing an order."
            );
            return;
        }
        const orderItems = this.cartItems.map((item) => {
            return {
                Product__c: item.product.Id,
                Quantity__c: item.quantity,
                Cost__c: item.Price__c,
            };
        });
        try {
            const orderId = await createOrder({
                orderItems: orderItems,
                orderChoices: orderItems,
                orderName: "Order",
            });
            alert(`Order placed successfully.`);
            this.cartItems = [];
        } catch (error) {
            alert(`Failed to place the order: ${error.body.message}`);
        }
    }

    /** Handles and increases the quantity of a cart item payload is the selected item */      
    handleIncreaseQuantity(event) {
        const productId = event.detail.productId;
        const index = this.cartItems.findIndex(
            (item) => item.product.Id === productId
        );

        if (index !== -1) {
            this.cartItems[index].quantity += 1;
        }
    }

    /** Handles and decreases the quantity of a cart item payload is the selected item */      
    handleDecreaseQuantity(event) {
        const productId = event.detail.productId;
        const index = this.cartItems.findIndex(
            (item) => item.product.Id === productId
        );

        if (index !== -1 && this.cartItems[index].quantity > 1) {
            this.cartItems[index].quantity -= 1;
        }
    }
}
