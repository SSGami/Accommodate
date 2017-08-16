package Group27;

import java.util.Date;

public class Room implements Comparable<Room> {
	
	private int roomNumber;
	private int hotelID;
	private double price;
	private int capacity;
	private int floorNumber;
	private String description;
	private String type;
	private double discountPercentage;
	private Date discountStartsOn;
	private Date discountEndsOn;
	
	public Room(int roomNumber, int hotelID, double price, int capacity, int floorNumber, String description, String type, double discountPercentage,
			Date discountStartsOn, Date discountEndsOn) {
		this.roomNumber = roomNumber;
		this.hotelID = hotelID;
		this.price = price;
		this.capacity = capacity;
		this.floorNumber = floorNumber;
		this.description = description;
		this.type = type;
		this.discountPercentage = discountPercentage;
		this.discountStartsOn = discountStartsOn;
		this.discountEndsOn = discountEndsOn;
	}
	
	public int getRoomNumber() {
		return roomNumber;
	}
	
	public int getHotelID() {
		return hotelID;
	}
	
	public double getPrice() {
		return price;
	}
	
	public int getCapacity() {
		return capacity;
	}
	
	public int getFloorNumber() {
		return floorNumber;
	}
	
	public String getDescription() {
		return description;
	}
	
	public String getType() {
		return type;
	}
	
	public double getDiscountPercentage() {
		return discountPercentage;
	}
	
	public Date getDateDiscountStartsOn() {
		return discountStartsOn;
	}
	
	public Date getDateDiscountEndsOn() {
		return discountEndsOn;
	}
	
	public int compareTo(Room compareRoom) {

		return (this.roomNumber - compareRoom.roomNumber);

	}
	
}