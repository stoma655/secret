import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export interface Message {
  'content' : string,
  'sender' : bigint,
  'timestamp' : bigint,
  'receiver' : bigint,
}
export interface Profile {
  'id' : bigint,
  'principal' : Principal,
  'nickname' : string,
  'color' : string,
  'picture' : string,
}
export interface _SERVICE {
  'createProfile' : ActorMethod<[bigint, string, string, string], boolean>,
  'getAllMessages' : ActorMethod<[bigint], Array<Message>>,
  'getMessages' : ActorMethod<[bigint, bigint], Array<Message>>,
  'getProfile' : ActorMethod<[Principal], [] | [Profile]>,
  'sendMessage' : ActorMethod<[bigint, bigint, string], undefined>,
}
