const mongoose = require('mongoose');

const orderItemSchema = new mongoose.Schema({
    foodId: { type: mongoose.Schema.Types.ObjectId, ref: "Food" },
    quantity: { type: Number, required: true },
    price: { type: Number, required: true },
    unitPrice:{type:Number, default: 0},
    additives: { type: Array },
    instructions: {type: String, default: ''},
});

const orderSchema = new mongoose.Schema({
    userId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
    orderItems: [orderItemSchema],
    orderTotal: { type: Number, required: true },
    deliveryFee: { type: Number, required: true },
    grandTotal: { type: Number, required: true },
    deliveryAddress: { 
        type: mongoose.Schema.Types.ObjectId, 
        ref: "Address", 
        required: true 
    },
    restaurantAddress: {type: String, required: true},
    paymentMethod: { type: String },
    paymentStatus: { type: String, default: "Pending", enum: ["Pending", "Completed", "Failed"] },
    orderStatus: { type: String, default: "Placed", enum: ["Placed", "Preparing", "Manual" ,"Out_for_Delivery", "Ready","Cancelled", "Delivered"] },
    orderDate: { type: Date, default: Date.now },
    restaurantId: { type: mongoose.Schema.Types.ObjectId, ref: "Restaurant"},
    restaurantCoords: [Number],
    recipientCoords: [Number],
    driverId: { type: mongoose.Schema.Types.ObjectId, ref: "Driver" },
    rating: { type: Number, min: 1, max: 5 },
    feedback: String,
    promoCode: String,
    discountAmount: Number,
    notes: String,
    confirmation: { type: Boolean, default: false },
    
    revenueCalculated: { type: Boolean, default: false }, 
    //this is calculated during payout
    paidOut:{type:Boolean, default: false}
}, {timestamps: true});

module.exports = mongoose.model('Order', orderSchema);