
import TestSearch from '../test/test_search.js';
import TestRaw from '../test/test_raw.js';
import TestLogistics from '../test/test_logistics.js';
import TestLogisticsRaw from '../test/test_logistics_raw.js';
import TestAnalysis from '../test/test_analysis.js';
import TestInsurance from '../test/test_insurance.js';
import Output from './output.js';

export default function file(module, contractName, input) {
    //support chrome IE10
    if (window.FileReader) {
        var file = input.files[0];
        var filename = file.name.split(".")[0];
        var reader = new FileReader();
        reader.readAsText(file);
        reader.onload = function() {
            let test;
            let elementId;
            //console.log(this.result);
            //alert(this.result);

            switch(module) {
                case 'Search': {
                    if('undefined' == typeof window.testSearchClass) {
                        test = new TestSearch();
                        window.testSearchClass = test;
                    } else {
                        test = window.testSearchClass;
                    }
                    break;
                }
                case 'Raw': {
                    if('undefined' == typeof window.testRawClass) {
                        test = new TestRaw();
                        window.testRawClass = test;
                    } else {
                        test = window.testRawClass;
                    }
                    break;
                }
                case 'Logistics': {
                    if('undefined' == typeof window.testLogisticsClass) {
                        test = new TestLogistics();
                        window.testLogisticsClass = test;
                    } else {
                        test = window.testLogisticsClass;
                    }
                    break;
                }
                case 'LogisticsRaw': {
                    if('undefined' == typeof window.testLogisticsRawClass) {
                        test = new TestLogisticsRaw();
                        window.testLogisticsRawClass = test;
                    } else {
                        test = window.testLogisticsRawClass;
                    }
                    if ('LogisticsDatabase' == contractName) {
                        elementId = window.outputDeployDatabaseElement;
                    } else if ('LogisticsCore' == contractName) {
                        elementId = window.outputDeployCoreElement;
                    } else if ('LogisticsAnalytics' == contractName) {
                        elementId = window.outputDeployAnalyticsElement;
                    } else if ('LogisticsAnalyticsMin' == contractName) {
                        elementId = window.outputDeployAnalyticsMinElement;
                    } else {
                        elementId = window.outputDeployElement;
                    }
                    break;
                }
                case 'Analysis': {
                    if('undefined' == typeof window.testAnalysisClass) {
                        test = new TestAnalysis();
                        window.testAnalysisClass = test;
                    } else {
                        test = window.testAnalysisClass;
                    }
                    break;
                }
                case 'Insurance': {
                    if('undefined' == typeof window.testInsuranceClass) {
                        test = new TestInsurance();
                        window.testInsuranceClass = test;
                    } else {
                        test = window.testInsuranceClass;
                    }
                    if ('InsuranceTemplate' == contractName) {
                        elementId = window.outputDeployTemplateElement;
                    } else if ('InsuranceUser' == contractName) {
                        elementId = window.outputDeployUserElement;
                    } else {
                        elementId = window.outputDeployElement;
                    }
                    break;
                }
                default:
                    let error = `Module:[${module}] Error!`;
                    alert(error);
                    break;
            }

            if('undefined' != typeof test) {
                test.setCompiledJson(this.result);
                Output(elementId, 'small', 'red', 'Upload successfully!');
            }
        }
    } 
    //support IE 7 8 9 10
    else if (typeof window.ActiveXObject != 'undefined'){
        var xmlDoc; 
        xmlDoc = new ActiveXObject("Microsoft.XMLDOM"); 
        xmlDoc.async = false; 
        xmlDoc.load(input.value); 
        alert(xmlDoc.xml); 
    } 
    //support FF
    else if (document.implementation && document.implementation.createDocument) { 
        var xmlDoc; 
        xmlDoc = document.implementation.createDocument("", "", null); 
        xmlDoc.async = false; 
        xmlDoc.load(input.value); 
        alert(xmlDoc.xml);
    } else { 
        alert('error'); 
    } 
}

// Node.js and other environments that support module.exports.
if (typeof module !== 'undefined' && typeof module.exports !== 'undefined') {
    module.exports = file();
} else {
    // AMD.
    if (typeof define === 'functon' && define.amd) {
        define([], function() {return file;});
    // Browser.
    } else {
        window.file = file;
    }
}