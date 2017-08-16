package Group27;

public class Customer {

	public final static int ID_LENGTH = 9;
	public final static int ID_LOWER_BOUNDS = 100000000;
	public final static int ID_UPPER_BOUNDS = 999999999;
	public final static int NAME_LENGTH_LIMIT = 50;
	public final static int EMAIL_LENGTH_LIMIT = 50;
	public final static int ADDRESS_LENGTH_LIMIT = 10000;
	public final static int PHONE_NUMBER_LENGTH_LIMIT = 12;

	private final static int ID_UPPER_GENERATED_BOUNDS = 900000000;

	private int customerID = 0;
	private String name = null;
	private String emailAddress = null;
	private String address = null;
	private String phoneNumber = null;

	public Customer(int customerID) {
		setCustomerID(customerID);
	}
	
	public Customer(int customerID, String name, String emailAddress, String address, String phoneNumber)
		throws IllegalArgumentException {

		this(name, emailAddress, address, phoneNumber);
		setCustomerID(customerID);
	}

	public Customer(String name, String emailAddress, String address, String phoneNumber)
			throws IllegalArgumentException {

		setName(name);
		setEmailAddress(emailAddress);
		setAddress(address);
		setPhoneNumber(phoneNumber);
	}
	

	public int getCustomerID() {
		return customerID;
	}

	public String getName() {
		return name;
	}

	public String getEmailAddress() {
		return emailAddress;
	}

	public String getAddress() {
		return address;
	}

	public String getPhoneNumber() {
		return phoneNumber;
	}

	public void setCustomerID(int customerID)
			throws IllegalArgumentException {

		if (!isValidCustomerID(customerID)) throw new IllegalArgumentException("Invalid Customer ID");
		this.customerID = customerID;
	}

	public void setName(String name)
			throws IllegalArgumentException {

		if (!isValidName(name)) throw new IllegalArgumentException("Invalid name");
		this.name = name;
	}

	public void setEmailAddress(String emailAddress)
			throws IllegalArgumentException {

		if (!isValidEmailAddress(emailAddress)) throw new IllegalArgumentException("Invalid email address");
		this.emailAddress = emailAddress;
	}

	public void setAddress(String address)
			throws IllegalArgumentException {

		if (!isValidAddress(address)) throw new IllegalArgumentException("Invalid address");
		this.address = address;
	}

	public void setPhoneNumber(String phoneNumber)
			throws IllegalArgumentException {

		if (!isValidPhoneNumber(phoneNumber)) throw new IllegalArgumentException("Invalid phone number");
		String sanitizedPhoneNumber = phoneNumber.replaceAll("[^0-9]","");
		this.phoneNumber = sanitizedPhoneNumber;
	}

	public boolean isAllDataValid() {
		if (isValidCustomerID(customerID) &&
			isValidName(name) &&
			isValidEmailAddress(emailAddress) &&
			isValidAddress(address) &&
			isValidPhoneNumber(phoneNumber)) return true;
		return false;
	}

	public static boolean isValidCustomerID(int customerID) {
		return (customerID > ID_LOWER_BOUNDS && customerID < ID_UPPER_BOUNDS);
	}

	public static boolean isValidName(String name) {
		return (name != null && !name.isEmpty() && name.length() < NAME_LENGTH_LIMIT);
	}

	public static boolean isValidEmailAddress(String emailAddress) {
		return (emailAddress != null && !emailAddress.isEmpty() && emailAddress.length() < EMAIL_LENGTH_LIMIT);
	}

	public static boolean isValidAddress(String address) {
		return (address != null && !address.isEmpty() && address.length() < ADDRESS_LENGTH_LIMIT);
	}

	public static boolean isValidPhoneNumber(String phoneNumber) {
		if (phoneNumber == null || phoneNumber.isEmpty()) return false;
		String sanitizedPhoneNumber = phoneNumber.replaceAll("[^0-9]","");
		if (sanitizedPhoneNumber.length() > PHONE_NUMBER_LENGTH_LIMIT) return false;
		return true;
	}

	public static int generateRandomCID() {
		return (int)Math.floor(ID_LOWER_BOUNDS + Math.random() * ID_UPPER_GENERATED_BOUNDS);
	}
}