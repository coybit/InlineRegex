# InlineRegex
InlineRegex allows you to use regular expression to extract pieces of data from a string in consice way.

``` swift
struct Info {
    var action: String? = nil
    var phone: String? = nil
}

var info = Info()

InlineRegex.on("Call    me:  +123456",
               pattern: "^\("\\w+", \.action)\\s+\\w+:\\s+\\+\("\\d{6}", \.phone)",
               store: &info)

print(info.action) // "Call"
print(info.phone) // 123456
```
