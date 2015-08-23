(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var buildQueryString, cleanObject, createErrorResponse, createSuccessResponse, get, isNonSerializable, post, request, wrapData;

get = function(opts) {
  opts.method = 'GET';
  return request(opts);
};

post = function(opts) {
  opts.method = 'POST';
  return request(opts);
};

request = function(arg) {
  var binary, data, headers, method, onProgress, responseType, type, url;
  url = arg.url, method = arg.method, data = arg.data, headers = arg.headers, responseType = arg.responseType, binary = arg.binary, onProgress = arg.onProgress;
  if (method == null) {
    method = 'GET';
  }
  type = url.split('.').pop();
  return new Promise((function(_this) {
    return function(resolve, reject) {
      var key, value, xhr;
      xhr = new XMLHttpRequest();
      if (method === 'GET' && (data != null)) {
        url += buildQueryString(data);
        data = void 0;
      }
      xhr.crossDomain = true;
      xhr.open(method, url);
      if (headers != null) {
        for (key in headers) {
          value = headers[key];
          xhr.setRequestHeader(key, value);
        }
      }
      if (binary) {
        xhr.responseType = 'arraybuffer';
        xhr.setRequestHeader('Accept', typeof mimeType !== "undefined" && mimeType !== null ? mimeType : 'application/octet-stream');
      } else {
        xhr.setRequestHeader('Accept', typeof mimeType !== "undefined" && mimeType !== null ? mimeType : 'application/json');
      }
      xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
      xhr.onload = function(event) {
        var e;
        try {
          return resolve(createSuccessResponse(xhr));
        } catch (_error) {
          e = _error;
          return reject(createErrorResponse(xhr));
        }
      };
      xhr.onerror = function(event) {
        return reject(createErrorResponse(xhr));
      };
      xhr.onprogress = function(event) {
        var progress;
        progress = event.total > 0 ? event.loaded / event.total : 1;
        if (typeof onProgress === "function") {
          onProgress(progress);
        }
        return console.log("Progress " + progress);
      };
      return xhr.send(wrapData(data));
    };
  })(this));
};

createSuccessResponse = function(xhr, opts) {

  /*
  	Creates a success response for a request.
   */
  var contentType, data, e, isArray, isJSON, isObject;
  if (xhr.status >= 400) {
    e = new Error("Error in response from server");
    e.status = xhr.status;
    e.data = xhr.response;
    throw e;
  }
  contentType = xhr.getResponseHeader('Content-Type');
  isJSON = contentType === 'application/json';
  isObject = function(r) {
    return r.charAt(0) === '{';
  };
  isArray = function(r) {
    return r.charAt(0) === '[';
  };
  if (_.isString(xhr.response) && (isJSON || isObject(xhr.response) || isArray(xhr.response))) {
    try {
      data = JSON.parse(xhr.response);
    } catch (_error) {
      e = _error;
      throw new Error("Response is not valid JSON");
    }
  } else {
    data = xhr.response;
  }
  return data;
};

createErrorResponse = function(xhr) {

  /*
  	Creates an error response for a request.
   */
  var data, e, error, ref;
  try {
    data = JSON.parse(xhr.response);
  } catch (_error) {
    e = _error;
    data = xhr.response;
  }
  error = new Error((ref = data != null ? data.message : void 0) != null ? ref : "Server error");
  error.status = xhr.status;
  error.data = data;
  return error;
};

wrapData = function(data) {

  /*
  	If the data is a key/value dictionary and one of the values is not serializable
  	(File, ArrayBuffer, etc), we need to wrap it in a FormData object.
  	If it's a single value object, nothing is changed.
  	If it's a key-value object but with no non-serializable values, it's cleaned
  	and JSON-encoded.
   */
  var cleanBundle, cleaned, formData, hasNonSerializableValue, id, key, numValues, object, value, values;
  if ((data == null) || _.isString(data)) {
    return data;
  }
  if (_.keys(data).length === 0) {
    return void 0;
  }
  values = _.values(data);
  numValues = values.length;
  hasNonSerializableValue = values.map(isNonSerializable).reduce(function(a, b) {
    return a || b;
  });
  if (numValues > 0) {
    formData = new FormData();
    for (key in data) {
      value = data[key];
      if ((value != null ? value.name : void 0) != null) {
        formData.append(key, value, value.name);
      } else if (isNonSerializable(value) || !_.isObject(value)) {
        formData.append(key, value);
      } else {
        formData.append(key, JSON.stringify(value));
      }
    }
    return formData;
  }
  if (_.isObject(data)) {
    cleanBundle = {};
    for (id in data) {
      object = data[id];
      if (_.isObject(object) && !_.isArray(object)) {
        cleaned = cleanObject(object);
      } else {
        cleaned = object;
      }
      cleanBundle[id] = cleaned;
    }
    return JSON.stringify(cleanBundle);
  } else {
    throw new Error("Illegal request data type: " + data);
  }
};

buildQueryString = function(data) {

  /*
  	Takes a javascript object and turns it to a query string usable with
  	GET request. The first level of keys will be the query string keys,
  	lower level objects will be converted to JSON strings.
   */
  var key, tokens, value;
  if ((data == null) || _.isEmpty(data)) {
    return "";
  }
  tokens = [];
  for (key in data) {
    value = data[key];
    if (_.isObject(value)) {
      value = JSON.stringify(value);
    }
    if (value !== void 0) {
      tokens.push(key + "=" + (encodeURIComponent(value)));
    }
  }
  return '?' + tokens.join('&');
};

isNonSerializable = function(object) {
  return object instanceof File || object instanceof Blob || object instanceof Document || object instanceof ArrayBuffer || object instanceof FormData;
};

cleanObject = function(object) {
  var cleaned, key, val;
  cleaned = {};
  for (key in object) {
    val = object[key];
    if (key.indexOf('$$') === 0 || key.indexOf('_') === 0) {
      continue;
    } else if (val instanceof Array) {
      cleaned[key] = val;
    } else if (val instanceof Object) {
      cleaned[key] = cleanObject(val);
    } else {
      cleaned[key] = val;
    }
  }
  return cleaned;
};

module.exports = {
  get: get,
  post: post
};


},{}],2:[function(require,module,exports){
var $, API_URL, Ajax, _el, generateName, refresh;

Ajax = require('./Ajax.coffee');

API_URL = 'http://localhost:9000';

document.addEventListener('DOMContentLoaded', function() {
  document.getElementById('refresh').addEventListener('click', refresh);
  return refresh();
});

$ = function(sel) {
  return document.querySelector(sel);
};

_el = function(id) {
  return document.getElementById(id);
};

refresh = function() {
  _el('ui').classList.add('loading');
  return generateName().then(function(name) {
    _el('ui').classList.remove('loading');
    _el('generated-name').innerHTML = name;
    return _el('get-domain').value = "Register " + name + " on Gandi.net";
  });
};

generateName = function() {
  var names;
  names = ['machinedot.com', 'mostformal.com', 'gladplant.com'];
  return Promise.resolve(_.sample(names));
};


},{"./Ajax.coffee":1}]},{},[2]);
