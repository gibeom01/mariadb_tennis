const fs = require('fs');
const mariadb = require('./database/connect/mariadb');

const main_view = fs.readFileSync('/root/mariadb/main.html', 'utf-8');
const orderlist_view = fs.readFileSync('/root/mariadb/orderlist.html', 'utf-8');

function main(response) {
    response.writeHead(200, { 'Content-Type': 'text/html' });
    response.write(main_view);
    response.end();
}

function orderList(response) {
    response.writeHead(200, { 'Content-Type': 'text/html' });

    mariadb.query('SELECT * FROM orderlist', (err, rows) => {
        if (err) {
            console.error('Database query error:', err);
            response.write("<h2>Error retrieving order list</h2>");
            response.end();
            return;
        }

        response.write(orderlist_view);
        response.write("<table border='1'><tr><th>Product ID</th><th>Order Date</th></tr>");
        rows.forEach(element => {
            response.write("<tr><td>" + element.product_id + "</td><td>" + element.order_date + "</td></tr>");
        });
        response.write("</table>");
        response.end();
    });
}

exports.handle = {
    '/': main,
    '/orderlist': orderList
};
