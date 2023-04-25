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
    var messages : [Message] = [];

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
        messages := Array.append<Secret.Message>(messages, [message]);
    };

    public query func getMessages(user1: Nat, user2: Nat) : async [Message] {
        return Array.filter<Message>(messages, func (msg: Message) : Bool {
            return (msg.sender == user1 and msg.receiver == user2) or (msg.sender == user2 and msg.receiver == user1);
        });
    };
}