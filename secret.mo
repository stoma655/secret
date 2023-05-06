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

    public type Conversation = {
      user: Nat;
      messages: [Message];
  };

    var profiles = HashMap.HashMap<Principal, Profile>(10, func (x, y) { x == y }, Principal.hash);
    var messages = HashMap.HashMap<Nat, [Message]>(10, func (x, y) { x == y }, Hash.hash);
    var userMessages = HashMap.HashMap<Nat, [Message]>(10, func (x, y) { x == y }, Hash.hash);



public func sendMessage(sender: Nat, receiver: Nat, content: Text) : async () {
    let timestamp = messages.size();
    let message = {sender; receiver; content; timestamp};
    let key = if (sender < receiver) sender * 1000000 + receiver else receiver * 1000000 + sender;
    let currentMessages = switch (messages.get(key)) {
        case null { [] };
        case (?m) { m };
    };
    messages.put(key, Array.append<Secret.Message>(currentMessages, [message]));

    let senderMessages = switch (userMessages.get(sender)) {
        case null { [] };
        case (?m) { m };
    };
    userMessages.put(sender, Array.append<Secret.Message>(senderMessages, [message]));

    let receiverMessages = switch (userMessages.get(receiver)) {
        case null { [] };
        case (?m) { m };
    };
    userMessages.put(receiver, Array.append<Secret.Message>(receiverMessages, [message]));
};

public query func getAllMessages(user: Nat) : async [Message] {
    return switch (userMessages.get(user)) {
        case null { [] };
        case (?m) { m };
    };
};

public shared(msg) func createProfile(nickname: Text, color: Text, picture: Text) : async Bool {
    let principal = msg.caller;
    var existingProfile = false;
    for ((k,v) in profiles.entries()) {
        if (v.nickname == nickname) {
            existingProfile := true;
        };
    };
    if (existingProfile) {
        return false;
    } else {
        let profile = {nickname; color; picture; principal};
        profiles.put(principal, profile);
        return true;
    };
};

public query func getProfile(id: Principal) : async ?Profile {
        return profiles.get(id);
};

public query func getMessages(user1: Nat, user2: Nat) : async [Message] {
        let key = if (user1 < user2) user1 * 1000000 + user2 else user2 * 1000000 + user1;
        return switch (messages.get(key)) {
            case null { [] };
            case (?m) { m };
        };
};

public query func getUniqueConversations(user: Nat): async [Nat]{
  var uniqueUsers : [Nat] = [];
  for ((k,v) in messages.entries()) {
      if(k / 1000000 == user or k % 1000000 == user){
          if(k / 1000000 == user){
              uniqueUsers := Array.append<Nat>(uniqueUsers,[k % 1000000]);
          }else{
              uniqueUsers := Array.append<Nat>(uniqueUsers,[k / 1000000]);
          }
      }
  }
  return uniqueUsers;
}
}