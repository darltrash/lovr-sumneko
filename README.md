# lovr-sumneko
So, I had a terrible experience with the [Sumneko LSP](https://github.com/bjornbytes/lovr) [LÖVR](https://github.com/bjornbytes/lovr) annotations, they always worked super weird to me, and I decided to make new ones from the [official API definitions](https://github.com/bjornbytes/lovr-docs).

## How to use
1. Steal the `lovr` folder from this repository
2. Paste it into your project, anywhere
3. Let the LSP know you're using this instead of the original ones, use this example:
```json
{
  "workspace.library": [
    "your/lovr/folder",
  ]
}
```
You can also get the lovr folder, isolated, by [grabbing a release.](https://github.com/darltrash/lovr-sumneko/releases/)

## How to generate
1. Get LuaJIT, and Make from your package manager of choice.
2. Get this repository, WITH the submodule. (`git clone --recurse-submodules https://github.com/darltrash/lovr-sumneko`)
3. Run `make generate`

## On being merged:
There are plans that, hopefully, this will be [merged into the main documentation repo](https://github.com/bjornbytes/lovr-docs/pull/188) which will make the "default" annotations for LÖVR in LuaLS to be these ones right in front of you. No more having to download this weirdo little folder, you just select LÖVR in your IDE and that's about it! 

## Licensing
Mate, this thing was whipped out in like 30 minutes, I don't care what you do with it. Just please keep it mantained and loved.

The API definitions themselves are all automatically generated, so I can't even be (or should be) considered the owner of them, use them and modify them however you so please.
