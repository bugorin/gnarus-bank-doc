CREATE TABLE business_unit (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  code VARCHAR(100),
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE TABLE sales_context (
  id INTEGER PRIMARY KEY,
  business_unit_id INTEGER NOT NULL,
  name VARCHAR(255) NOT NULL,
  currency VARCHAR(20),
  channel VARCHAR(100),
  status VARCHAR(50),
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  CONSTRAINT fk_sales_context_business_unit
    FOREIGN KEY (business_unit_id) REFERENCES business_unit(id)
);

CREATE TABLE product_segment (
  id INTEGER PRIMARY KEY,
  context_id INTEGER NOT NULL,
  name VARCHAR(255) NOT NULL,
  code VARCHAR(100) NOT NULL,
  description VARCHAR(255),
  configs JSON,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  CONSTRAINT fk_product_segment_context
    FOREIGN KEY (context_id) REFERENCES sales_context(id)
);

CREATE TABLE product (
  id INTEGER PRIMARY KEY,
  product_segment_id INTEGER NOT NULL,
  name VARCHAR(255) NOT NULL,
  sku VARCHAR(100),
  price DECIMAL(12, 2) NOT NULL,
  is_recurring BOOLEAN NOT NULL DEFAULT FALSE,
  recurrence_type VARCHAR(50),
  recurrence_interval INTEGER,
  auto_renew_default BOOLEAN NOT NULL DEFAULT FALSE,
  status VARCHAR(50),
  configs JSON,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  CONSTRAINT fk_product_product_segment
    FOREIGN KEY (product_segment_id) REFERENCES product_segment(id)
);

CREATE TABLE bundle (
  id INTEGER PRIMARY KEY,
  product_segment_id INTEGER NOT NULL,
  name VARCHAR(255) NOT NULL,
  pricing_type VARCHAR(50) NOT NULL,
  price DECIMAL(12, 2),
  is_recurring BOOLEAN NOT NULL DEFAULT FALSE,
  recurrence_type VARCHAR(50),
  recurrence_interval INTEGER,
  auto_renew_default BOOLEAN NOT NULL DEFAULT FALSE,
  status VARCHAR(50),
  configs JSON,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  CONSTRAINT fk_bundle_product_segment
    FOREIGN KEY (product_segment_id) REFERENCES product_segment(id)
);

CREATE TABLE bundle_item (
  id INTEGER PRIMARY KEY,
  bundle_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 1,
  created_at TIMESTAMP,
  CONSTRAINT fk_bundle_item_bundle
    FOREIGN KEY (bundle_id) REFERENCES bundle(id),
  CONSTRAINT fk_bundle_item_product
    FOREIGN KEY (product_id) REFERENCES product(id)
);

CREATE TABLE offer_optional_product (
  id INTEGER PRIMARY KEY,
  target_type ENUM('PRODUCT', 'BUNDLE') NOT NULL,
  target_external_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 1,
  optional_type ENUM('OPTIONAL', 'UPSELL') NOT NULL,
  extra_price DECIMAL(12,2),
  created_at TIMESTAMP,
  CONSTRAINT fk_offer_optional_product_product
    FOREIGN KEY (product_id) REFERENCES product(id)
);

CREATE TABLE coupon (
  id INTEGER PRIMARY KEY,
  context_id INTEGER NOT NULL,
  code VARCHAR(100) NOT NULL UNIQUE,
  discount_type VARCHAR(50) NOT NULL,
  discount_value DECIMAL(12, 2) NOT NULL,
  scope VARCHAR(50) NOT NULL,
  stackable BOOLEAN NOT NULL DEFAULT FALSE,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  valid_from TIMESTAMP,
  valid_until TIMESTAMP,
  min_subtotal DECIMAL(12, 2),
  max_discount DECIMAL(12, 2),
  usage_limit INTEGER,
  per_customer_limit INTEGER,
  configs JSON,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  CONSTRAINT fk_coupon_context
    FOREIGN KEY (context_id) REFERENCES sales_context(id)
);

CREATE TABLE coupon_group (
  id INTEGER PRIMARY KEY,
  context_id INTEGER NOT NULL,
  name VARCHAR(255) NOT NULL,
  code VARCHAR(100) NOT NULL,
  description VARCHAR(255),
  max_coupons_per_cart INTEGER NOT NULL DEFAULT 1,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  CONSTRAINT fk_coupon_group_context
    FOREIGN KEY (context_id) REFERENCES sales_context(id)
);

CREATE TABLE coupon_group_member (
  id INTEGER PRIMARY KEY,
  coupon_id INTEGER NOT NULL,
  coupon_group_id INTEGER NOT NULL,
  created_at TIMESTAMP,
  CONSTRAINT fk_coupon_group_member_coupon
    FOREIGN KEY (coupon_id) REFERENCES coupon(id),
  CONSTRAINT fk_coupon_group_member_group
    FOREIGN KEY (coupon_group_id) REFERENCES coupon_group(id)
);

CREATE TABLE coupon_product_target (
  id INTEGER PRIMARY KEY,
  coupon_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  CONSTRAINT fk_coupon_product_target_coupon
    FOREIGN KEY (coupon_id) REFERENCES coupon(id),
  CONSTRAINT fk_coupon_product_target_product
    FOREIGN KEY (product_id) REFERENCES product(id)
);

CREATE TABLE coupon_bundle_target (
  id INTEGER PRIMARY KEY,
  coupon_id INTEGER NOT NULL,
  bundle_id INTEGER NOT NULL,
  CONSTRAINT fk_coupon_bundle_target_coupon
    FOREIGN KEY (coupon_id) REFERENCES coupon(id),
  CONSTRAINT fk_coupon_bundle_target_bundle
    FOREIGN KEY (bundle_id) REFERENCES bundle(id)
);

CREATE TABLE campaign (
  id INTEGER PRIMARY KEY,
  context_id INTEGER NOT NULL,
  name VARCHAR(255) NOT NULL,
  reference_url VARCHAR(255),
  type VARCHAR(50) NOT NULL,
  stackable BOOLEAN NOT NULL DEFAULT TRUE,
  priority INTEGER NOT NULL DEFAULT 0,
  coupon_policy VARCHAR(50) NOT NULL,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  valid_from TIMESTAMP,
  valid_until TIMESTAMP,
  min_subtotal DECIMAL(12, 2),
  configs JSON,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  CONSTRAINT fk_campaign_context
    FOREIGN KEY (context_id) REFERENCES sales_context(id)
);

CREATE TABLE campaign_rule (
  id INTEGER PRIMARY KEY,
  campaign_id INTEGER NOT NULL,
  target_type VARCHAR(50) NOT NULL,
  target_external_id VARCHAR(255) NOT NULL,
  discount_type VARCHAR(50) NOT NULL,
  discount_value DECIMAL(12, 2) NOT NULL,
  priority INTEGER NOT NULL DEFAULT 0,
  configs JSON,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  CONSTRAINT fk_campaign_rule_campaign
    FOREIGN KEY (campaign_id) REFERENCES campaign(id)
);

CREATE TABLE campaign_coupon_group_rule (
  id INTEGER PRIMARY KEY,
  campaign_id INTEGER NOT NULL,
  coupon_group_id INTEGER NOT NULL,
  rule_type VARCHAR(50) NOT NULL,
  created_at TIMESTAMP,
  CONSTRAINT fk_campaign_coupon_group_rule_campaign
    FOREIGN KEY (campaign_id) REFERENCES campaign(id),
  CONSTRAINT fk_campaign_coupon_group_rule_group
    FOREIGN KEY (coupon_group_id) REFERENCES coupon_group(id)
);

CREATE TABLE payment_option (
  id INTEGER PRIMARY KEY,
  context_id INTEGER NOT NULL,
  name VARCHAR(255) NOT NULL,
  payment_type VARCHAR(50) NOT NULL,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  configs JSON,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  CONSTRAINT fk_payment_option_context
    FOREIGN KEY (context_id) REFERENCES sales_context(id)
);

CREATE TABLE offer_payment_option (
  id INTEGER PRIMARY KEY,
  target_type VARCHAR(50) NOT NULL,
  target_external_id INTEGER NOT NULL,
  payment_option_id INTEGER NOT NULL,
  max_installments INTEGER,
  discount_type VARCHAR(50),
  discount_value DECIMAL(12, 2),
  active BOOLEAN NOT NULL DEFAULT TRUE,
  configs JSON,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  CONSTRAINT fk_offer_payment_option_payment_option
    FOREIGN KEY (payment_option_id) REFERENCES payment_option(id)
);

CREATE TABLE customer (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  type ENUM('PF', 'PJ') NOT NULL,
  document VARCHAR(100),
  info JSON,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE TABLE customer_business_unit (
  id INTEGER PRIMARY KEY,
  customer_id INTEGER NOT NULL,
  business_unit_id INTEGER NOT NULL,
  configs JSON,
  created_at TIMESTAMP,
  CONSTRAINT fk_customer_business_unit_customer
    FOREIGN KEY (customer_id) REFERENCES customer(id),
  CONSTRAINT fk_customer_business_unit_business_unit
    FOREIGN KEY (business_unit_id) REFERENCES business_unit(id)
);

CREATE TABLE customer_payment_method (
  id INTEGER PRIMARY KEY,
  customer_id INTEGER NOT NULL,
  context_id INTEGER NOT NULL,
  payment_option_id INTEGER NOT NULL,
  provider VARCHAR(100) NOT NULL,
  token VARCHAR(255) NOT NULL,
  brand VARCHAR(100),
  last4 VARCHAR(4),
  holder_name VARCHAR(255),
  exp_month INTEGER,
  exp_year INTEGER,
  is_default BOOLEAN NOT NULL DEFAULT FALSE,
  reusable BOOLEAN NOT NULL DEFAULT TRUE,
  status VARCHAR(50) NOT NULL,
  consented_at TIMESTAMP,
  revoked_at TIMESTAMP,
  info JSON,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  CONSTRAINT fk_customer_payment_method_customer
    FOREIGN KEY (customer_id) REFERENCES customer(id),
  CONSTRAINT fk_customer_payment_method_context
    FOREIGN KEY (context_id) REFERENCES sales_context(id),
  CONSTRAINT fk_customer_payment_method_payment_option
    FOREIGN KEY (payment_option_id) REFERENCES payment_option(id)
);

CREATE TABLE customer_product_preference (
  id INTEGER PRIMARY KEY,
  customer_id INTEGER NOT NULL,
  target_type VARCHAR(50) NOT NULL,
  target_external_id VARCHAR(255) NOT NULL,
  preference_type VARCHAR(50) NOT NULL,
  status VARCHAR(50) NOT NULL,
  source VARCHAR(100),
  effective_at TIMESTAMP,
  expires_at TIMESTAMP,
  info JSON,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  CONSTRAINT fk_customer_product_preference_customer
    FOREIGN KEY (customer_id) REFERENCES customer(id)
);

CREATE TABLE partner (
  id INTEGER PRIMARY KEY,
  context_id INTEGER NOT NULL,
  name VARCHAR(255) NOT NULL,
  code VARCHAR(100) NOT NULL,
  type VARCHAR(50) NOT NULL,
  status VARCHAR(50) NOT NULL,
  info JSON,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  CONSTRAINT fk_partner_context
    FOREIGN KEY (context_id) REFERENCES sales_context(id)
);

CREATE TABLE partner_link (
  id INTEGER PRIMARY KEY,
  partner_id INTEGER NOT NULL,
  code VARCHAR(100) NOT NULL,
  url VARCHAR(255),
  utm_source VARCHAR(100),
  utm_medium VARCHAR(100),
  utm_campaign VARCHAR(100),
  active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  CONSTRAINT fk_partner_link_partner
    FOREIGN KEY (partner_id) REFERENCES partner(id)
);

CREATE TABLE partner_billing_link (
  id INTEGER PRIMARY KEY,
  partner_id INTEGER NOT NULL,
  context_id INTEGER NOT NULL,
  name VARCHAR(255) NOT NULL,
  code VARCHAR(100) NOT NULL,
  url VARCHAR(255),
  active BOOLEAN NOT NULL DEFAULT TRUE,
  expires_at TIMESTAMP,
  product_id INTEGER,
  bundle_id INTEGER,
  campaign_id INTEGER,
  coupon_id INTEGER,
  payment_option_id INTEGER,
  configs JSON,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  CONSTRAINT fk_partner_billing_link_partner
    FOREIGN KEY (partner_id) REFERENCES partner(id),
  CONSTRAINT fk_partner_billing_link_context
    FOREIGN KEY (context_id) REFERENCES sales_context(id),
  CONSTRAINT fk_partner_billing_link_product
    FOREIGN KEY (product_id) REFERENCES product(id),
  CONSTRAINT fk_partner_billing_link_bundle
    FOREIGN KEY (bundle_id) REFERENCES bundle(id),
  CONSTRAINT fk_partner_billing_link_campaign
    FOREIGN KEY (campaign_id) REFERENCES campaign(id),
  CONSTRAINT fk_partner_billing_link_coupon
    FOREIGN KEY (coupon_id) REFERENCES coupon(id),
  CONSTRAINT fk_partner_billing_link_payment_option
    FOREIGN KEY (payment_option_id) REFERENCES payment_option(id)
);

CREATE TABLE cart (
  id INTEGER PRIMARY KEY,
  customer_id INTEGER NOT NULL,
  context_id INTEGER NOT NULL,
  status VARCHAR(50) NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  CONSTRAINT fk_cart_customer
    FOREIGN KEY (customer_id) REFERENCES customer(id),
  CONSTRAINT fk_cart_context
    FOREIGN KEY (context_id) REFERENCES sales_context(id)
);

CREATE TABLE cart_item (
  id INTEGER PRIMARY KEY,
  cart_id INTEGER NOT NULL,
  product_id INTEGER,
  bundle_id INTEGER,
  quantity INTEGER NOT NULL DEFAULT 1,
  unit_price DECIMAL(12, 2),
  list_price DECIMAL(12, 2),
  final_price DECIMAL(12, 2),
  metadata JSON,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  CONSTRAINT fk_cart_item_cart
    FOREIGN KEY (cart_id) REFERENCES cart(id),
  CONSTRAINT fk_cart_item_product
    FOREIGN KEY (product_id) REFERENCES product(id),
  CONSTRAINT fk_cart_item_bundle
    FOREIGN KEY (bundle_id) REFERENCES bundle(id)
);

CREATE TABLE cart_coupon (
  id INTEGER PRIMARY KEY,
  cart_id INTEGER NOT NULL,
  coupon_id INTEGER NOT NULL,
  code VARCHAR(100),
  status VARCHAR(50) NOT NULL,
  created_at TIMESTAMP,
  CONSTRAINT fk_cart_coupon_cart
    FOREIGN KEY (cart_id) REFERENCES cart(id),
  CONSTRAINT fk_cart_coupon_coupon
    FOREIGN KEY (coupon_id) REFERENCES coupon(id)
);

CREATE TABLE cart_adjustment (
  id INTEGER PRIMARY KEY,
  cart_id INTEGER NOT NULL,
  cart_item_id INTEGER,
  adjustment_type VARCHAR(50) NOT NULL,
  reference_id INTEGER,
  description VARCHAR(255),
  amount DECIMAL(12, 2) NOT NULL,
  created_at TIMESTAMP,
  CONSTRAINT fk_cart_adjustment_cart
    FOREIGN KEY (cart_id) REFERENCES cart(id),
  CONSTRAINT fk_cart_adjustment_cart_item
    FOREIGN KEY (cart_item_id) REFERENCES cart_item(id)
);

CREATE TABLE cart_payment (
  id INTEGER PRIMARY KEY,
  cart_id INTEGER NOT NULL,
  payment_option_id INTEGER NOT NULL,
  customer_payment_method_id INTEGER,
  amount DECIMAL(12, 2) NOT NULL,
  status VARCHAR(50) NOT NULL,
  provider_transaction_id VARCHAR(255),
  info JSON,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  CONSTRAINT fk_cart_payment_cart
    FOREIGN KEY (cart_id) REFERENCES cart(id),
  CONSTRAINT fk_cart_payment_payment_option
    FOREIGN KEY (payment_option_id) REFERENCES payment_option(id),
  CONSTRAINT fk_cart_payment_customer_payment_method
    FOREIGN KEY (customer_payment_method_id) REFERENCES customer_payment_method(id)
);

CREATE TABLE attribution (
  id INTEGER PRIMARY KEY,
  cart_id INTEGER,
  order_ref VARCHAR(255),
  partner_id INTEGER NOT NULL,
  partner_link_id INTEGER,
  coupon_id INTEGER,
  attribution_type VARCHAR(50) NOT NULL,
  info JSON,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  CONSTRAINT fk_attribution_cart
    FOREIGN KEY (cart_id) REFERENCES cart(id),
  CONSTRAINT fk_attribution_partner
    FOREIGN KEY (partner_id) REFERENCES partner(id),
  CONSTRAINT fk_attribution_partner_link
    FOREIGN KEY (partner_link_id) REFERENCES partner_link(id),
  CONSTRAINT fk_attribution_coupon
    FOREIGN KEY (coupon_id) REFERENCES coupon(id)
);

CREATE TABLE commission (
  id INTEGER PRIMARY KEY,
  partner_id INTEGER NOT NULL,
  attribution_id INTEGER NOT NULL,
  commission_type VARCHAR(50) NOT NULL,
  commission_value DECIMAL(12, 2) NOT NULL,
  base_amount DECIMAL(12, 2) NOT NULL,
  commission_amount DECIMAL(12, 2) NOT NULL,
  status VARCHAR(50) NOT NULL,
  info JSON,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  CONSTRAINT fk_commission_partner
    FOREIGN KEY (partner_id) REFERENCES partner(id),
  CONSTRAINT fk_commission_attribution
    FOREIGN KEY (attribution_id) REFERENCES attribution(id)
);

CREATE TABLE payout (
  id INTEGER PRIMARY KEY,
  partner_id INTEGER NOT NULL,
  amount DECIMAL(12, 2) NOT NULL,
  status VARCHAR(50) NOT NULL,
  reference VARCHAR(255),
  info JSON,
  created_at TIMESTAMP,
  paid_at TIMESTAMP,
  CONSTRAINT fk_payout_partner
    FOREIGN KEY (partner_id) REFERENCES partner(id)
);
