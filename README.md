# lovr-sumneko
So, I had a terrible experience with the [Sumneko LSP](https://github.com/bjornbytes/lovr) [LÖVR](https://github.com/bjornbytes/lovr) annotations, they always worked super weird to me, and I decided to make new ones from the [official API definitions](https://github.com/bjornbytes/lovr-docs).

## How to use
1. Steal the little folder named "api" in this repository
2. Paste it into your project, anywhere
3. Let the LSP know you're using this instead of the original ones, use this example:
```json
{
  "runtime.version": "LuaJIT",
  "workspace.library": [
    "your/path/to/the/api/folder",
  ]
}
```

## How to generate
1. Get LuaJIT, and Make from your package manager of choice.
3. Run `make generate`

### How to update the API and possibly help me mantain this:
1. Get LuaJIT, and Make, as stated previously.
2. Get CURL and/or WGet
3. Run `make fetch-api`
4. Run `make generate`

> [!NOTE]
> This might break some things in regards to the generator script, should work fine unless the team decided to switch something in regards to how the API is expressed, though.

## How to contribute
Do the thing above, get the ball rolling and generate the API in case anything changes, if that doesn't work as it should, then try to fix the script.

**DO NOT USE GENERATIVE AI FOR CODE GENERATION**, I will not accept any usage of it in this project, thank you.

## Licensing
Mate, this thing was whipped out in like 30 minutes, I don't care what you do with it. Just please keep it mantained and loved, the only licensed component in here would be the API JSON file that we fetch, and RXI's Amazing [json.lua library](https://github.com/rxi/json.lua/)

The api definitions themselves are all automatically generated, so I can't even be (or should be) considered the owner of them, use them and modify them however you so please.
