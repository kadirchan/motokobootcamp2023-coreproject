import Text "mo:base/Text";
import Blob = "mo:base/Blob";
import Option "mo:base/Option";
import HashMap = "mo:base/HashMap";
import Principal "mo:base/Principal";

actor {

    private stable var webpageText = "Just Started";
    private stable var daoCanister = "dabh6-siaaa-aaaag-qbrzq-cai";

    public shared ({ caller }) func setNewText(newText : Text) : async () {
        if (not Principal.equal(caller, Principal.fromText("dabh6-siaaa-aaaag-qbrzq-cai"))) return;
        webpageText := newText
    };

    public type HttpRequest = {
        body : Blob;
        headers : [HeaderField];
        method : Text;
        url : Text
    };

    public type StreamingCallbackToken = {
        content_encoding : Text;
        index : Nat;
        key : Text;
        sha256 : ?Blob
    };
    public type StreamingCallbackHttpResponse = {
        body : Blob;
        token : ?StreamingCallbackToken
    };
    public type ChunkId = Nat;
    public type SetAssetContentArguments = {
        chunk_ids : [ChunkId];
        content_encoding : Text;
        key : Key;
        sha256 : ?Blob
    };
    public type Path = Text;
    public type Key = Text;

    public type HttpResponse = {
        body : Blob;
        headers : [HeaderField];
        status_code : Nat16;
        streaming_strategy : ?StreamingStrategy
    };

    public type StreamingStrategy = {
        #Callback : {
            callback : query (StreamingCallbackToken) -> async (StreamingCallbackHttpResponse);
            token : StreamingCallbackToken
        }
    };

    public type HeaderField = (Text, Text);

    private func removeQuery(str : Text) : Text {
        return Option.unwrap(Text.split(str, #char '?').next())
    };

    public query func http_request(req : HttpRequest) : async (HttpResponse) {
        let path = removeQuery(req.url);

        return {
            body = Text.encodeUtf8(webpageText);
            headers = [];
            status_code = 200;
            streaming_strategy = null
        }
    };

}
