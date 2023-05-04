import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";
import Array "mo:base/Array";

actor Secret {
    public type Profile = {
        id: Nat;
        name: Text;
        age: Nat;
    };

    public type Message = {
        sender: Nat;
        receiver: Nat;
        content: Text;
        timestamp: Nat;
    };

    var profiles = HashMap.HashMap<Nat, Profile>(10, func (x, y) { x == y }, Hash.hash);
    var messages = HashMap.HashMap<Nat, [Message]>(10, func (x, y) { x == y }, Hash.hash);

    public func createProfile(id: Nat, name: Text, age: Nat) : async () {
        let profile = {id; name; age};
        profiles.put(id, profile);
    };

    public query func getProfile(id: Nat) : async ?Profile {
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