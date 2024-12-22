#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <random>
#include <string>
#include <ctime>

const std::vector<std::string> tables = {
    "tb1", "tb2", "tb3", "tb4", "tb5", "tb6", "tb7", "tb8", "tb9", "tb10",
    "tb11", "tb12", "tb13", "tb14", "tb15", "tb16", "tb17", "tb18", "tb19", "tb20",
    "tb21", "tb22", "tb23", "tb24", "tb25", "tb26", "tb27", "tb28", "tb29", "tb30",
    "tb31", "tb32", "tb33", "tb34", "tb35", "tb36", "tb37", "tb38", "tb39", "tb40",
    "tb41", "tb42", "tb43", "tb44", "tb45", "tb46", "tb47", "tb48", "tb49", "tb50"
};

// SQL 查询模板，仅包含 SELECT 查询
const std::vector<std::string> select_templates = {
    "SELECT * FROM {table} WHERE {column} = {value};",
    "SELECT COUNT(*) FROM {table} WHERE {column} = {value};",
    "SELECT {column1}, {column2} FROM {table} WHERE {column1} > {value} AND {column2} < {value};",
    "SELECT AVG({column}) FROM {table} WHERE {column} > {value};",
    "SELECT {column1}, {column2} FROM {table} GROUP BY {column1} ORDER BY {column2} DESC;",
    "SELECT {column1}, COUNT(*) FROM {table} GROUP BY {column1} HAVING COUNT(*) > {value};",
    "SELECT {column1}, MAX({column2}) FROM {table} GROUP BY {column1};",
    "SELECT {column1}, SUM({column2}) FROM {table} GROUP BY {column1} ORDER BY SUM({column2}) DESC;"
};

const std::vector<std::string> columns = {"name", "age", "country", "latitude", "longitude"};
const int min_value = 1;
const int max_value = 1000;
std::random_device rd;
std::mt19937 gen(rd());
std::uniform_int_distribution<> dist(0, 49);  // 用于选择表（0到49，对应tb1到tb50）
std::uniform_int_distribution<> col_dist(0, 4);  // 用于选择列（0到4）
std::uniform_int_distribution<> value_dist(min_value, max_value);  // 用于生成随机数

// 生成随机 SELECT 查询
std::string generate_query() {
    // 随机选择查询模板
    std::string query = select_templates[dist(gen) % select_templates.size()];
    // 随机选择表
    std::string table = tables[dist(gen)];
    // 随机选择列和数值
    std::string column = columns[col_dist(gen)];
    std::string column1 = columns[col_dist(gen)];
    std::string column2 = columns[col_dist(gen)];
    int value = value_dist(gen);
    // 替换模板中的占位符
    size_t pos = query.find("{table}");
    if (pos != std::string::npos) query.replace(pos, 7, table);
    pos = query.find("{column}");
    if (pos != std::string::npos) query.replace(pos, 8, column);
    pos = query.find("{column1}");
    if (pos != std::string::npos) query.replace(pos, 9, column1);
    pos = query.find("{column2}");
    if (pos != std::string::npos) query.replace(pos, 9, column2);
    pos = query.find("{value}");
    if (pos != std::string::npos) query.replace(pos, 7, std::to_string(value));
    
    return query;
}

int main() {
    std::ofstream csvfile("queries.csv");

    if (!csvfile.is_open()) {
        std::cerr << "Error opening file!" << std::endl;
        return 1;
    }

    // 写入标题行
    csvfile << "query_1,query_2,query_3,query_4,query_5,query_6,query_7,query_8,query_9,query_10\n";

    // 生成并写入 1000 行 SQL 查询
    for (int i = 0; i < 1000; ++i) {
        std::stringstream row;
        for (int j = 0; j < 10; ++j) {
            std::string query = generate_query();
            row << "\"" << query << "\"";
            if (j < 9) row << ",";
        }
        csvfile << row.str() << "\n";
    }

    csvfile.close();
    std::cout << "CSV file 'queries.csv' generated successfully." << std::endl;

    return 0;
}
