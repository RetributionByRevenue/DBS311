#include <iostream>
#include <string>
#include <occi.h>
#include <cctype>

using oracle::occi::Environment;
using oracle::occi::Connection;

using namespace oracle::occi;
using namespace std;

struct ShoppingCart {
	int product_id;
	double price;
	int quantity;
};


// mainMenu() --> Display main menu for the program
int mainMenu() {
	int option = 0;
	do {
		cout << "******************** Main Menu ********************\n"
			<< "1)\tLogin\n"
			<< "0)\tExit\n";

		if (option != 0 && option != 1) {
			cout << "You entered a wrong value. Enter an option (0-1): ";
		}
		else
			cout << "Enter an option (0-1): ";

		cin >> option;
	} while (option != 0 && option != 1);

	return option;
}

// findProduct() --> Receives a Connection object and a product_id, returns the price of the product or 0 if not exist.
double findProduct(Connection* conn, int product_id) {
	// Statement object to execute SQL scripts
	Statement *stmt = conn->createStatement();

	// Specify input parameters
	stmt->setSQL("BEGIN find_product(:1, :2); END;");
	double price;
	stmt->setInt(1, product_id);   // specify the first (IN) parameter of procedure

	// specify type and size of the second (OUT) parameter
	stmt->registerOutParam(2, Type::OCCIDOUBLE, sizeof(price));

	// Error handling here
	// Call procedure
	stmt->executeUpdate();

	// Store price
	price = stmt->getDouble(2);

	// Terminate statement
	conn->terminateStatement(stmt);

	return price > 0 ? price : 0;	// price = 0 if id is not valid
}

// displayProducts() --> Receives an array of items and number of items, displays every items in the array
void displayProducts(struct ShoppingCart cart[], int productCount) {
	if (productCount > 0) {
		double totalPrice = 0;
		cout << "------- Ordered Products ---------" << endl;
		for (int i = 0; i < productCount; ++i) {
			cout << "---Item " << i + 1 << endl;
			cout << "Product ID: " << cart[i].product_id << endl;
			cout << "Price: " << cart[i].price << endl;
			cout << "Quantity: " << cart[i].quantity << endl;
			totalPrice += cart[i].price * cart[i].quantity;
		}
		cout << "----------------------------------\nTotal: " << totalPrice << endl;
	}
}

// customerLogin() --> Receives a Connection object and customer id, returns 1 if customer exists, 0 if not
int customerLogin(Connection* conn, int customerId) {
	// Statement object to execute SQL scripts
	Statement *stmt = conn->createStatement();

	// Specify input parameters
	stmt->setSQL("BEGIN find_customer(:1, :2); END;");
	int found;
	stmt->setInt(1, customerId);   // specify the first (IN) parameter of procedure

	// specify type and size of the second (OUT) parameter
	stmt->registerOutParam(2, Type::OCCIINT, sizeof(found));

	// Error handling here
	// Call procedure
	stmt->executeUpdate();

	// Store price
	found = stmt->getInt(2);

	// Terminate statement
	conn->terminateStatement(stmt);

	return found;	// 1 if found - 0 if not
}

// addToCart() --> Receives a Connection object and an array of items, add items to the array and return number of items
int addToCart(Connection* conn, struct ShoppingCart cart[]) {
	cout << "-------------- Add Products to Cart --------------" << endl;
	for (int i = 0; i < 5; ++i) {
		int productId;
		int qty;
		ShoppingCart item;
		int choice;

		do {
			cout << "Enter the product ID: ";
			cin >> productId;
			cout << isdigit(productId);
			if (findProduct(conn, productId) == 0) {
				cout << "The product does not exist. Try again..." << endl;
			}
		} while (findProduct(conn, productId) == 0);

		cout << "Product Price: " << findProduct(conn, productId) << endl;
		cout << "Enter the product Quantity: ";
		cin >> qty;

		item.product_id = productId;
		item.price = findProduct(conn, productId);	// Error handling
		item.quantity = qty;
		cart[i] = item;

		if (i == 4)
			return i + 1;
		else {
			do {
				cout << "Enter 1 to add more products or 0 to check out: ";
				cin >> choice;
			} while (choice != 0 && choice != 1);
		}

		if (choice == 0)
			return i + 1;
	}
}


// checkout() --> Receives a Connection object, an array of items, customer id, number of items, add items to order_items table and return
int checkout(Connection *conn, struct ShoppingCart cart[], int customerId, int productCount) {
	char choice;
	do {
		cout << "Would you like to checkout ? (Y / y or N / n) ";
		cin >> choice;

		if (choice != 'Y' && choice != 'y' && choice != 'N' && choice != 'n')
			cout << "Wrong input. Try again..." << endl;
	} while (choice != 'Y' && choice != 'y' && choice != 'N' && choice != 'n');

	if (choice == 'N' || choice == 'n') {
		cout << "The order is cancelled." << endl;
		return 0;
	}
	else {
		// Statement object to execute SQL scripts
		Statement *stmt = conn->createStatement();

		// Specify input parameters
		stmt->setSQL("BEGIN add_order(:1, :2); END;");
		int next_order_id;
		stmt->setInt(1, customerId);   // specify the first (IN) parameter of procedure

		// specify type and size of the second (OUT) parameter
		stmt->registerOutParam(2, Type::OCCIINT, sizeof(next_order_id));

		// Error handling here
		// Call procedure
		stmt->executeUpdate();

		// Store price
		next_order_id = stmt->getInt(2);

		for (int i = 0; i < productCount; ++i) {
			// Reset Statement object
			stmt->setSQL("BEGIN add_order_item(:1, :2, :3, :4, :5); END;");

			// Set IN parameters
			stmt->setInt(1, next_order_id);
			stmt->setInt(2, i + 1);
			stmt->setInt(3, cart[i].product_id);
			stmt->setInt(4, cart[i].quantity);
			stmt->setDouble(5, cart[i].price);

			// Error handling
			// Call procedure
			stmt->executeUpdate();
		}

		cout << "The order is successfully completed." << endl;

		// Terminate statement
		conn->terminateStatement(stmt);

		return 1;
	}
}

int main() {
	Environment* env = nullptr;
	Connection* conn = nullptr;

	string user = "dbs311_202d20";
	string pass = "14596168";
	string constr = "myoracle12c.senecacollege.ca:1521/oracle12c";

	try {
		env = Environment::createEnvironment(Environment::DEFAULT);
		conn = env->createConnection(user, pass, constr);
		cout << "Connection is successful!" << endl;

		// mainMenu
		int choice;
		int customerId;
		do {
			choice = mainMenu();

			if (choice == 1) {
				cout << "Enter the customer ID: ";
				cin >> customerId;

				if (customerLogin(conn, customerId) == 0) {
					cout << "The customer does not exist." << endl;
				}
				else {
					ShoppingCart cart[5];
					int productCnt = addToCart(conn, cart);
					displayProducts(cart, productCnt);
					checkout(conn, cart, customerId, productCnt);
				}

			}

			
		} while (choice != 0);

		cout << "Good bye!..." << endl;

		env->terminateConnection(conn);
		Environment::terminateEnvironment(env);
	}
	catch (SQLException& sqlExcp) {
		cout << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage();
	}
	return 0;
}