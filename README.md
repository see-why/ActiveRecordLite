# ActiveRecordLite

A lightweight implementation of ActiveRecord patterns in Ruby, providing a simplified ORM (Object-Relational Mapping) framework with query building capabilities.

---

## Quick Start

Here's a minimal example to get you up and running:

```ruby
require 'activerecord_lite'

# Setup in-memory database and create a table
ActiveRecordLite::DatabaseConnection.instance.execute(<<-SQL)
  CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    name TEXT,
    organization TEXT,
    active BOOLEAN,
    created_at DATETIME
  );
SQL

ActiveRecordLite::DatabaseConnection.instance.execute(
  "INSERT INTO users (name, organization, active, created_at) VALUES (?, ?, ?, ?)", ["Alice", "OrgA", 1, "2024-06-01"]
)

class User < ActiveRecordLite::Base
  def self.active
    where(active: 1)
  end
end

puts User.active.where(organization: "OrgA").to_a
```

---

## Running Tests

This project uses RSpec for testing. To run all specs (including integration):

```bash
bundle exec rspec
```

To run a specific spec file:

```bash
bundle exec rspec spec/integration_spec.rb
```

### Test Coverage
- **Unit specs**: All major classes/modules are covered (Base, Relation, DatabaseConnection, Delegation, ClassSpecificRelation, CurrentScope).
- **Integration specs**: End-to-end usage with real models, table creation, and query chaining.

---

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

### Integration Example

A real-world scenario using all the main features:

```ruby
require 'activerecord_lite'

db = ActiveRecordLite::DatabaseConnection.instance

db.execute('CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT, organization TEXT, active BOOLEAN, created_at DATETIME);')
db.execute("INSERT INTO users (name, organization, active, created_at) VALUES (?, ?, ?, ?)", ["Alice", "OrgA", 1, "2024-06-01"])
db.execute("INSERT INTO users (name, organization, active, created_at) VALUES (?, ?, ?, ?)", ["Bob", "OrgB", 0, "2024-06-02"])
db.execute("INSERT INTO users (name, organization, active, created_at) VALUES (?, ?, ?, ?)", ["Carol", "OrgA", 1, "2024-06-03"])

class User < ActiveRecordLite::Base
  def self.active
    where(active: 1)
  end
  def self.recent
    order(created_at: :desc)
  end
end

# Count active users in OrgA
puts User.where(organization: "OrgA").active.count # => 2

# Get recent active users in OrgA
puts User.where(organization: "OrgA").active.recent.to_a
# => [{"id"=>3, "name"=>"Carol", ...}, {"id"=>1, "name"=>"Alice", ...}]
```