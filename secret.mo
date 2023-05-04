import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";
import Array "mo:base/Array";
import Principal "mo:base/Principal";

actor Secret {
    public type Profile = {
        nickname: Text;
        color: Text;
        picture: Text;
        principal: Principal;
    };

    public type Message = {
        sender: Nat;
        receiver: Nat;
        content: Text;
        timestamp: Nat;
    };

    var profiles = HashMap.HashMap<Principal, Profile>(10, func (x, y) { x == y }, Principal.hash);
    var messages = HashMap.HashMap<Nat, [Message]>(10, func (x, y) { x == y }, Hash.hash);

    public shared(msg) func createProfile(nickname: Text, color: Text, picture: Text) : async () {
        let principal = msg.caller;
        let profile = {nickname; color; picture; principal};
        profiles.put(principal, profile);
    };

    public query func getProfile(id: Principal) : async ?Profile {
        return profiles.get(id);
    };

    public func sendMessage(sender: Nat, receiver: Nat, content: Text) : async () {
        let timestamp = messages.size();
        let message = {sender; receiver; content; timestamp};
        let key = if (sender < receiver) sender * 1000000 + receiver else receiver * 1000000 + sender;
        let currentMessages = switch (messages.get(key)) {
            case null { [] };
            case (?m) { m };
        };
        messages.put(key, Array.append<Secret.Message>(currentMessages, [message]));
    };

    public query func getMessages(user1: Nat, user2: Nat) : async [Message] {
        let key = if (user1 < user2) user1 * 1000000 + user2 else user2 * 1000000 + user1;
        return switch (messages.get(key)) {
            case null { [] };
            case (?m) { m };
        };
    };
}