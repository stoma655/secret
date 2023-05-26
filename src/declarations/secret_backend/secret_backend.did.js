export const idlFactory = ({ IDL }) => {
  const Message = IDL.Record({
    'content' : IDL.Text,
    'sender' : IDL.Nat,
    'timestamp' : IDL.Nat,
    'receiver' : IDL.Nat,
  });
  const Profile = IDL.Record({
    'id' : IDL.Nat,
    'principal' : IDL.Principal,
    'nickname' : IDL.Text,
    'color' : IDL.Text,
    'picture' : IDL.Text,
  });
  return IDL.Service({
    'createProfile' : IDL.Func(
        [IDL.Nat, IDL.Text, IDL.Text, IDL.Text],
        [IDL.Bool],
        [],
      ),
    'getAllMessages' : IDL.Func([IDL.Nat], [IDL.Vec(Message)], ['query']),
    'getMessages' : IDL.Func([IDL.Nat, IDL.Nat], [IDL.Vec(Message)], ['query']),
    'getProfile' : IDL.Func([IDL.Principal], [IDL.Opt(Profile)], ['query']),
    'sendMessage' : IDL.Func([IDL.Nat, IDL.Nat, IDL.Text], [], []),
  });
};
export const init = ({ IDL }) => { return []; };
