var pairs =
{
"lifecycle":{"events":1}
,"events":{"lifecycle":1,"page":1,"configure":1,"enterprise":1}
,"page":{"create":1}
,"create":{"new":1,"lifecycle":1}
,"new":{"events":1}
,"configure":{"existing":1}
,"existing":{"events":1}
,"enterprise":{"trigger":1}
,"trigger":{"business":1}
,"business":{"process":1,"processes":1}
,"process":{"changes":1}
,"changes":{"detected":1}
,"detected":{"during":1}
,"during":{"identity":1}
,"identity":{"refresh":1}
,"refresh":{"identityiq":1}
,"identityiq":{"launch":1,"administrative":1,"administrator":1}
,"launch":{"event-based":1}
,"event-based":{"business":1}
,"note":{"identityiq":1}
,"administrative":{"capabilities":1}
,"capabilities":{"setup":1,"contact":1}
,"setup":{"function":1}
,"function":{"information":1}
,"information":{"setting":1}
,"setting":{"administrative":1}
,"contact":{"identityiq":1}
,"additional":{"information":1}
}
;Search.control.loadWordPairs(pairs);
