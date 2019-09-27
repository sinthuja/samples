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
                PET_STORE_CELL_URL: {value: ""},
                PORTAL_PORT: { value: 80 },
                BASE_PATH: { value: "." }
            },
            dependencies: {
                composites: {
                     petStoreBackend: <cellery:ImageName>{ org: "wso2cellery", name: "pet-be-comp", ver: "latest" }
                }
            }
    };

     cellery:Reference petStoreBackend = cellery:getReference(portalComponent, "petStoreBackend");
     portalComponent.envVars.PET_STORE_CELL_URL.value =
     "http://" +<string>petStoreBackend.controller_host + ":" + <string>petStoreBackend.controller_port+"/controller";

    // Composite Initialization
    cellery:Composite petFE = {
        components: {
            portal: portalComponent
        }
    };
    return cellery:createImage(petFE, untaint iName);
}

public function run(cellery:ImageName iName, map<cellery:ImageName> instances) returns error? {
    cellery:Composite petFE = check cellery:constructImage(untaint iName);
    return cellery:createInstance(petFE, iName, instances);
}