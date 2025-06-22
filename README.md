# ActiveRecordLite

A lightweight implementation of ActiveRecord patterns in Ruby, providing a simplified ORM (Object-Relational Mapping) framework with query building capabilities.

## Overview

ActiveRecordLite is a project that demonstrates the core concepts behind ActiveRecord, the popular ORM used in Ruby on Rails. It implements a minimal but functional ORM that supports:

- Query building with `where` and `order` clauses
- Lazy evaluation of queries
- Method delegation to relation objects
- SQL generation and execution
- In-memory SQLite database integration

## Features

### 🔍 Query Building
- **Where clauses**: Filter records based on conditions
- **Order clauses**: Sort results by specified columns
- **Lazy evaluation**: Queries are only executed when needed

### 🏗️ Architecture
- **Base class**: Provides the main interface for models
- **Relation objects**: Handle query building and SQL generation
- **Delegation system**: Automatically delegates methods to relation objects
- **Current scope management**: Maintains query state across method calls

### 🗄️ Database Integration
- **SQLite in-memory database**: Fast, lightweight database for development
- **SQL generation**: Automatically converts query objects to SQL
- **Result handling**: Returns results as hash objects

## Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd ActiveRecordLite
```

2. Install dependencies:
```bash
bundle install
```

## Usage

### Basic Model Definition

```ruby
require 'activerecord_lite'

class User < ActiveRecordLite::Base
end
```

### Query Examples

```ruby
# Find all users
users = User.to_a

# Find users with specific conditions
active_users = User.where(active: true).to_a

# Order results
sorted_users = User.order(name: 'ASC').to_a

# Chain queries
recent_active_users = User.where(active: true)
                         .order(created_at: 'DESC')
                         .to_a

# Count records
user_count = User.count
active_user_count = User.where(active: true).count
```

### SQL Generation

The library automatically generates SQL queries based on your method calls:

```ruby
# This generates: SELECT * FROM users WHERE active = 'true' ORDER BY name 'ASC'
User.where(active: true).order(name: 'ASC').to_a

# This generates: SELECT COUNT(*) FROM users WHERE active = 'true'
User.where(active: true).count
```

## Architecture

### Core Components

#### `ActiveRecordLite::Base`
The main base class that provides the ORM interface. It includes:
- Class-level query methods (`where`, `order`, `count`, `to_a`)
- Table name generation
- Current scope management
- Relation delegation setup

#### `Relation`
Handles query building and SQL generation:
- Stores `where_values` and `order_values`
- Generates SQL clauses from stored conditions
- Supports method chaining with `tap`

#### `DatabaseConnection`
Singleton class managing database operations:
- Uses SQLite in-memory database
- Executes SQL queries
- Returns results as hash objects

#### `Delegation`
Manages method delegation to relation objects:
- Defines which classes can be delegated to
- Currently supports `Relation` class delegation

#### `CurrentScope`
Simple struct for maintaining query state:
- Stores the current scope object
- Allows for query state persistence across method calls

#### `ClassSpecificRelation`
Provides dynamic method delegation:
- Uses `method_missing` to delegate unknown methods to the model
- Automatically defines methods for future calls
- Supports `respond_to_missing?` for proper method checking

### Query Flow

1. **Method Call**: User calls `User.where(active: true)`
2. **Delegation**: Method is delegated to a `Relation` object
3. **Query Building**: `Relation` stores the condition in `where_values`
4. **Lazy Evaluation**: Query is not executed until `to_a` or `count` is called
5. **SQL Generation**: `Relation.to_sql` converts stored conditions to SQL
6. **Execution**: `DatabaseConnection` executes the generated SQL
7. **Result**: Returns array of hash objects or count value

## Development

### Project Structure

```
ActiveRecordLite/
├── lib/
│   ├── activerecord_lite.rb          # Main entry point
│   └── activerecord_lite/
│       ├── base.rb                   # Base class implementation
│       ├── relation.rb               # Query building and SQL generation
│       ├── database_connection.rb    # Database interface
│       ├── delegation.rb             # Method delegation system
│       ├── current_scope.rb          # Query state management
│       └── class_specific_relation.rb # Dynamic method delegation
├── bin/
│   └── activerecord_lite.rb          # Executable (currently empty)
├── Gemfile                           # Dependencies
└── README.md                         # This file
```

### Dependencies

- **sqlite3**: SQLite database adapter for Ruby
- **singleton**: Ruby standard library for singleton pattern

## Limitations

This is an educational implementation with several limitations:

- **In-memory database only**: Data is lost when the process ends
- **Limited query support**: Only `where` and `order` clauses are implemented
- **No associations**: No support for relationships between models
- **No migrations**: No database schema management
- **Basic SQL generation**: Limited SQL escaping and complex query support
- **No validations**: No model validation system

## Contributing

This is primarily an educational project, but contributions are welcome:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is open source and available under the [MIT License](LICENSE).

## Learning Resources

This project demonstrates several important Ruby and ORM concepts:

- **Method delegation**: Using `method_missing` and `respond_to_missing?`
- **Singleton pattern**: Database connection management
- **Query building**: Lazy evaluation and method chaining
- **SQL generation**: Converting Ruby objects to SQL queries
- **Scope management**: Maintaining state across method calls

For more information about ActiveRecord patterns, see the [Rails ActiveRecord documentation](https://guides.rubyonrails.org/active_record_basics.html). 