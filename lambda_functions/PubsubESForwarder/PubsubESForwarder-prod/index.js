console.log('Loading function');
var AWS = require('aws-sdk');
var path = require('path');
var esDomain = {
    region: 'us-east-1',
    endpoint: '',
    index: 'request_logs',
    doctype: 'appengine'
};

var endpoint = new AWS.Endpoint(esDomain.endpoint);
var creds = new AWS.EnvironmentCredentials('AWS');
exports.handler = function(event, context) {
    //console.log('Received event:', JSON.stringify(event, null, 2));
    var message = event.Records[0].Sns.Message;
    postToES(message, context)
};

function postToES(doc, context) {
    var req = new AWS.HttpRequest(endpoint);

    req.method = 'POST';
    req.path = path.join('/', esDomain.index, esDomain.doctype);
    req.region = esDomain.region;
    req.headers['presigned-expires'] = false;
    req.headers['Host'] = endpoint.host;
    req.body = doc;

    var signer = new AWS.Signers.V4(req , 'es');  // es: service code
    signer.addAuthorization(creds, new Date());

    var send = new AWS.NodeHttpClient();
    send.handleRequest(req, null, function(httpResp) {
        var respBody = '';
        httpResp.on('data', function (chunk) {
            respBody += chunk;
        });
        httpResp.on('end', function (chunk) {
            console.log('Response: ' + respBody);
            context.succeed('Added document ');
           //context.done();
        });
    }, function(err) {
        console.log('Error: ' + err);
        context.succeed('Failed to add doc ' + err);
    });
}
