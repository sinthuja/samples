//   Copyright (c) 2019, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

// Cell file for Pet Store Sample Backend.
// This Cell encompasses the components which deals with the business logic of the Pet Store

import celleryio/cellery;

public function build(cellery:ImageName iName) returns error? {

    // Orders Component
    // This component deals with all the orders related functionality.
    int ordersPort = 80;
    cellery:Component ordersComponent = {
        name: "orders",
        source: {
            image: "wso2cellery/samples-pet-store-orders"
        },
        ingresses: {
            orders:  <cellery:HttpPortIngress>{
                port: ordersPort
            }
        }
    };

    // Customers Component
    // This component deals with all the customers related functionality.
    int customerPort = 80;
    cellery:Component customersComponent = {
        name: "customers",
        source: {
            image: "wso2cellery/samples-pet-store-customers"
        },
        ingresses: {
            customers: <cellery:HttpPortIngress>{
                port: customerPort
            }
        }
    };

    // Catalog Component
    // This component deals with all the catalog related functionality.
    int catalogPort = 80;
    cellery:Component catalogComponent = {
        name: "catalog",
        source: {
            image: "wso2cellery/samples-pet-store-catalog"
        },
        ingresses: {
            catalog: <cellery:HttpPortIngress>{
                port: catalogPort
            }
        }
    };

    // Controller Component
    // This component deals depends on Orders, Customers and Catalog components.
    // This exposes useful functionality from the Cell by using the other three components.
    int controllerPort = 80;
    cellery:Component controllerComponent = {
        name: "controller",
        source: {
            image: "wso2cellery/samples-pet-store-controller"
        },
        ingresses: {
            ingress: <cellery:HttpPortIngress>{
                port: controllerPort
            }
        },
        envVars: {
            CATALOG_HOST: { value: cellery:getHost(catalogComponent) },
            CATALOG_PORT: { value: catalogPort },
            ORDER_HOST: { value: cellery:getHost(ordersComponent) },
            ORDER_PORT: { value: ordersPort },
            CUSTOMER_HOST: { value: cellery:getHost(customersComponent) },
            CUSTOMER_PORT: { value: customerPort }
        },
        dependencies: {
            components: [catalogComponent, ordersComponent, customersComponent]
        }
    };

    cellery:Component portalComponent = {
            name: "portal",
            source: {
                image: "wso2cellery/samples-pet-store-portal"
            },
            ingresses: {
                portal: <cellery:HttpPortIngress>{
                    port: 80
              }
            },
            envVars: {
                PET_STORE_CELL_URL: { value: "http://"+cellery:getHost(controllerComponent)+":"+controllerPort},
                PORTAL_PORT: { value: 80 },
                BASE_PATH: { value: "." }
            },
            dependencies: {
                components: [controllerComponent]
            }
        };

    // Composite Initialization
    cellery:Composite petstore = {
        components: {
            catalog: catalogComponent,
            customer: customersComponent,
            orders: ordersComponent,
            controller: controllerComponent,
            portal: portalComponent
        }
    };
    return cellery:createImage(petstore, untaint iName);
}

public function run(cellery:ImageName iName, map<cellery:ImageName> instances) returns error? {
    cellery:Composite petStore = check cellery:constructImage(untaint iName);
    return cellery:createInstance(petStore, iName, instances);
}