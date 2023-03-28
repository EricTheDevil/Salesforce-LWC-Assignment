import { LightningElement, track } from "lwc";

/**
 * The ProductFilter component provides a dropdown menu for filtering products by category.
 * When the user selects a category, the component fires a filterchange event with the selected category as a detail payload.
 */
export default class ProductFilter extends LightningElement {
    @track selectedCategory = "";

    get categoryOptions() {
        return [
            { label: "All", value: "all" },
            { label: "Boot", value: "boot" },
            { label: "Shirt", value: "shirt" },
            { label: "Shoe", value: "shoe" },
        ];
    }

    /** Updates the category value  */
    handleCategoryChange(event) {
        this.selectedCategory = event.target.value;
    }

    /** This function handles the user's request to filter products by category. (Dispatches to parent) 
     * @param {CustomEvent} filterchange - selected category as a detail payload.
     */
    handleFilter() {
        this.dispatchEvent(
            new CustomEvent("filterchange", {
                detail: { category: this.selectedCategory },
            })
        );
    }
}
