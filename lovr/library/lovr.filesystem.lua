---@meta lovr.filesystem

--- The `lovr.filesystem` module provides access to the filesystem.
--- All files written will go in a special folder called the "save directory".  The location of the save directory is platform-specific:
--- <table>
---   <tr>
---     <td>Windows</td>
---     <td><code>C:\Users\&lt;user&gt;\AppData\Roaming\LOVR\&lt;identity&gt;</code></td>
---   </tr>
---   <tr>
---     <td>macOS</td>
---     <td><code>/Users/&lt;user&gt;/Library/Application Support/LOVR/&lt;identity&gt;</code></td>
---   </tr>
---   <tr>
---     <td>Linux</td>
---     <td><code>/home/&lt;user&gt;/.local/share/LOVR/&lt;identity&gt;</code></td>
---   </tr>
---   <tr>
---     <td>Android</td>
---     <td><code>/sdcard/Android/data/&lt;identity&gt;/files</code></td>
---   </tr> </table>
--- `<identity>` is a unique identifier for the project, and can be set in `lovr.conf`.  On Android, the identity can not be changed and will always be the package id (e.g. `org.lovr.app`).
--- When files are read, they will be searched for in multiple places.  By default, the save directory is checked first, then the project source (folder or zip).  That way, when data is written to a file, any future reads will see the new data.  The `t.saveprecedence` conf setting can be used to change this precedence.
--- Conceptually, `lovr.filesystem` uses a "virtual filesystem", which is an ordered list of folders and zip files that are merged into a single filesystem hierarchy.  Folders and archives in the list can be added and removed with `lovr.filesystem.mount` and `lovr.filesystem.unmount`.
--- LÖVR extends Lua's `require` function to look for modules in the virtual filesystem.  The search patterns can be changed with `lovr.filesystem.setRequirePath`, similar to `package.path`.
---
--- [Open in browser](https://lovr.org/docs/lovr.filesystem)
---@class lovr.filesystem
lovr.filesystem = {}

--- The different actions that can be taken on files, reported by `lovr.filechanged` when filesystem watching is active.
---@alias FileAction
---| '"create"' # The file was created.
---| '"delete"' # The file was deleted.
---| '"modify"' # The file's contents were modified.
---| '"rename"' # The file was renamed.

--- Different ways to open a `File` with `lovr.filesystem.newFile`.
---@alias OpenMode
---| '"r"' # Open the file for reading.
---| '"w"' # Open the file for writing (overwrites existing data).
---| '"a"' # Open the file for appending.

--- A File is an object that provides read or write access to a file on the filesystem.
---
--- [Open in browser](https://lovr.org/docs/File)
---@class File
local File = {}

--- Returns the mode the file was opened in.
---
--- [Open in browser](https://lovr.org/docs/File:getMode)
---@see File.getPath
---@return OpenMode # The mode the file was opened in (`r`, `w`, or `a`).
function File:getMode() end

--- Returns the file's path.
---
--- [Open in browser](https://lovr.org/docs/File:getPath)
---@return string # The file path.
function File:getPath() end

--- Returns the size of the file, in bytes.
---
--- [Open in browser](https://lovr.org/docs/File:getSize)
---@see lovr.filesystem.getSize
---@return number # The size of the file, in bytes, or nil if an error occurred.
---@return string # The error message, if an error occurred.
function File:getSize() end

--- Returns whether the end of file has been reached.  When true, `File:read` will no longer return data.
---
--- [Open in browser](https://lovr.org/docs/File:isEOF)
---@see File.seek
---@see File.tell
---@see File.getSize
---@return boolean # Whether the end of the file has been reached.
function File:isEOF() end

--- Reads data from the file.
---
--- [Open in browser](https://lovr.org/docs/File:read)
---@see File.write
---@see lovr.filesystem.read
---@see lovr.filesystem.newBlob
---@param bytes number # The number of bytes to read from the file, or `nil` to read the rest of the file.
---@return string # The data that was read, or nil if an error occurred.
---@return number # The number of bytes that were read, or the error message if an error occurred.
function File:read(bytes) end

--- Seeks to a new position in the file.  `File:read` and `File:write` will read/write relative to this position.
---
--- [Open in browser](https://lovr.org/docs/File:seek)
---@see File.tell
---@see File.getSize
---@param offset number # The new file offset, in bytes.
function File:seek(offset) end

--- Returns the seek position of the file, which is where `File:read` and `File:write will read/write from.
---
--- [Open in browser](https://lovr.org/docs/File:tell)
---@see File.seek
---@return number # The file offset, in bytes.
function File:tell() end

--- Writes data to the file.
---
--- [Open in browser](https://lovr.org/docs/File:write)
---@see File.read
---@see lovr.filesystem.write
---@see lovr.filesystem.append
---@param string string # A string to write to the file.
---@param size number? # The number of bytes to write, or nil to write all of the data from the string/Blob. (default: nil)
---@return boolean # Whether the data was successfully written.
---@return string # The error message.
---@overload fun(self: File, blob: Blob, size?: number): boolean, string
function File:write(string, size) end

--- Appends content to the end of a file.
---
--- [Open in browser](https://lovr.org/docs/lovr.filesystem.append)
---@param filename string # The file to append to.
---@param content string | Blob # A string or Blob to append to the file.
---@return boolean # Whether the operation was successful.
---@return string | nil # The error message, or `nil` if there was no error.
function lovr.filesystem.append(filename, content) end

--- Creates a directory in the save directory.  Also creates any intermediate directories that don't exist.
---
--- [Open in browser](https://lovr.org/docs/lovr.filesystem.createDirectory)
---@param path string # The directory to create, recursively.
---@return boolean # Whether the directory was created.
---@return string | nil # The error message.
function lovr.filesystem.createDirectory(path) end

--- Returns the application data directory.  This will be something like:
--- - `C:\Users\user\AppData\Roaming` on Windows.
--- - `/home/user/.config` on Linux.
--- - `/Users/user/Library/Application Support` on macOS.
---
--- [Open in browser](https://lovr.org/docs/lovr.filesystem.getAppdataDirectory)
---@return string | nil # The absolute path to the appdata directory.
function lovr.filesystem.getAppdataDirectory() end

--- Returns a sorted table containing all files and folders in a single directory.
---
--- [Open in browser](https://lovr.org/docs/lovr.filesystem.getDirectoryItems)
---@param path string # The directory.
---@return string[] # A table with a string for each file and subfolder in the directory.
function lovr.filesystem.getDirectoryItems(path) end

--- Returns the absolute path of the LÖVR executable.
---
--- [Open in browser](https://lovr.org/docs/lovr.filesystem.getExecutablePath)
---@return string | nil # The absolute path of the LÖVR executable, or `nil` if it is unknown.
function lovr.filesystem.getExecutablePath() end

--- Returns the identity of the game, which is used as the name of the save directory.  The default is `default`.  It can be changed using `t.identity` in `lovr.conf`.
---
--- [Open in browser](https://lovr.org/docs/lovr.filesystem.getIdentity)
---@return string | nil # The name of the save directory, or `nil` if it isn't set.
function lovr.filesystem.getIdentity() end

--- Returns when a file was last modified, since some arbitrary time in the past.
---
--- [Open in browser](https://lovr.org/docs/lovr.filesystem.getLastModified)
---@param path string # The file to check.
---@return number | nil # The modification time of the file, in seconds, or `nil` if there was an error.
---@return string | nil # The error message, if there was an error.
function lovr.filesystem.getLastModified(path) end

--- Get the absolute path of the mounted archive containing a path in the virtual filesystem.  This can be used to determine if a file is in the game's source directory or the save directory.
---
--- [Open in browser](https://lovr.org/docs/lovr.filesystem.getRealDirectory)
---@param path string # The path to check.
---@return string | nil # The absolute path of the mounted archive containing `path`, or `nil` if the file is not in the virtual filesystem.
function lovr.filesystem.getRealDirectory(path) end

--- Returns the require path.  The require path is a semicolon-separated list of patterns that LÖVR will use to search for files when they are `require`d.  Any question marks in the pattern will be replaced with the module that is being required.  It is similar to Lua\'s `package.path` variable, but the main difference is that the patterns are relative to the virtual filesystem.
---
--- [Open in browser](https://lovr.org/docs/lovr.filesystem.getRequirePath)
---@return string # The semicolon separated list of search patterns.
function lovr.filesystem.getRequirePath() end

--- Returns the absolute path to the save directory.
---
--- [Open in browser](https://lovr.org/docs/lovr.filesystem.getSaveDirectory)
---@see lovr.filesystem.getIdentity
---@see lovr.filesystem.getAppdataDirectory
---@return string # The absolute path to the save directory.
function lovr.filesystem.getSaveDirectory() end

--- Returns the size of a file, in bytes.
---
--- [Open in browser](https://lovr.org/docs/lovr.filesystem.getSize)
---@see File.getSize
---@param file string # The file.
---@return number | nil # The size of the file, in bytes, or `nil` if there was an error.
---@return string | nil # The error message, if the operation was not successful.
function lovr.filesystem.getSize(file) end

--- Get the absolute path of the project's source directory or archive.
---
--- [Open in browser](https://lovr.org/docs/lovr.filesystem.getSource)
---@return string | nil # The absolute path of the project's source, or `nil` if it's unknown.
function lovr.filesystem.getSource() end

--- Returns the absolute path of the user's home directory.
---
--- [Open in browser](https://lovr.org/docs/lovr.filesystem.getUserDirectory)
---@return string | nil # The absolute path of the user's home directory.
function lovr.filesystem.getUserDirectory() end

--- Returns the absolute path of the working directory.  Usually this is where the executable was started from.
---
--- [Open in browser](https://lovr.org/docs/lovr.filesystem.getWorkingDirectory)
---@return string | nil # The current working directory, or `nil` if it's unknown.
function lovr.filesystem.getWorkingDirectory() end

--- Check if a path exists and is a directory.
---
--- [Open in browser](https://lovr.org/docs/lovr.filesystem.isDirectory)
---@see lovr.filesystem.isFile
---@param path string # The path to check.
---@return boolean # Whether or not the path is a directory.
function lovr.filesystem.isDirectory(path) end

--- Check if a path exists and is a file.
---
--- [Open in browser](https://lovr.org/docs/lovr.filesystem.isFile)
---@see lovr.filesystem.isDirectory
---@param path string # The path to check.
---@return boolean # Whether or not the path is a file.
function lovr.filesystem.isFile(path) end

--- Returns whether the current project source is fused to the executable.
---
--- [Open in browser](https://lovr.org/docs/lovr.filesystem.isFused)
---@return boolean # Whether or not the project is fused.
function lovr.filesystem.isFused() end

--- Load a file containing Lua code, returning a Lua chunk that can be run.
---
--- [Open in browser](https://lovr.org/docs/lovr.filesystem.load)
---@param filename string # The file to load.
---@param mode string? # The type of code that can be loaded.  `t` allows text, `b` allows binary, and `bt` allows both. (default: 'bt')
---@return function # The runnable chunk.
function lovr.filesystem.load(filename, mode) end

--- Mounts a directory or `.zip` archive, adding it to the virtual filesystem.  This allows you to read files from it.
---
--- [Open in browser](https://lovr.org/docs/lovr.filesystem.mount)
---@see lovr.filesystem.unmount
---@param path string # The path to mount.
---@param mountpoint string? # The path in the virtual filesystem to mount to. (default: '/')
---@param append boolean? # Whether the archive will be added to the end or the beginning of the search path. (default: false)
---@param root string? # A subdirectory inside the archive to use as the root.  If `nil`, the actual root of the archive is used. (default: nil)
---@return boolean # Whether the archive was successfully mounted.
---@return string | nil # The error message, if the archive failed to mount.
function lovr.filesystem.mount(path, mountpoint, append, root) end

--- Creates a new Blob that contains the contents of a file.
---
--- [Open in browser](https://lovr.org/docs/lovr.filesystem.newBlob)
---@see lovr.data.newBlob
---@see Blob
---@param filename string # The file to load.
---@return Blob # The new Blob.
function lovr.filesystem.newBlob(filename) end

--- Opens a file, returning a `File` object that can be used to read/write the file contents.
--- Normally you can just use `lovr.filesystem.read`, `lovr.filesystem.write`, etc.  However, those methods open and close the file each time they are called.  So, when performing multiple operations on a file, creating a File object and keeping it open will have less overhead.
---
--- [Open in browser](https://lovr.org/docs/lovr.filesystem.newFile)
---@see lovr.filesystem.read
---@see lovr.filesystem.write
---@see lovr.filesystem.append
---@param path string # The path of the file to open.
---@param mode OpenMode # The mode to open the file in (`r`, `w`, or `a`).
---@return File # A new file object, or nil if an error occurred.
---@return string # The error message, if an error occurred.
function lovr.filesystem.newFile(path, mode) end

--- Read the contents of a file.
---
--- [Open in browser](https://lovr.org/docs/lovr.filesystem.read)
---@param filename string # The name of the file to read.
---@return string | nil # The contents of the file, or nil if the file could not be read.
---@return string | nil # The error message, if any.
function lovr.filesystem.read(filename) end

--- Remove a file or directory in the save directory.
---
--- [Open in browser](https://lovr.org/docs/lovr.filesystem.remove)
---@param path string # The file or directory to remove.
---@return boolean # Whether the path was removed.
---@return string | nil # The error message, if any.
function lovr.filesystem.remove(path) end

--- Set the name of the save directory.  This function can only be called once and is called automatically at startup, so this function normally isn't called manually.  However, the identity can be changed by setting the `t.identity` option in `lovr.conf`.
---
--- [Open in browser](https://lovr.org/docs/lovr.filesystem.setIdentity)
---@see lovr.conf
---@see lovr.filesystem.getSaveDirectory
---@param identity string # The name of the save directory.
function lovr.filesystem.setIdentity(identity) end

--- Sets the require path.  The require path is a semicolon-separated list of patterns that LÖVR will use to search for files when they are `require`d.  Any question marks in the pattern will be replaced with the module that is being required.  It is similar to Lua\'s `package.path` variable, except the patterns will be checked using `lovr.filesystem` APIs. This allows `require` to work even when the project is packaged into a zip archive, or when the project is launched from a different directory.
---
--- [Open in browser](https://lovr.org/docs/lovr.filesystem.setRequirePath)
---@param path string? # An optional semicolon separated list of search patterns. (default: nil)
function lovr.filesystem.setRequirePath(path) end

--- Unmounts a directory or archive previously mounted with `lovr.filesystem.mount`.
---
--- [Open in browser](https://lovr.org/docs/lovr.filesystem.unmount)
---@see lovr.filesystem.mount
---@param path string # The path to unmount.
---@return boolean # Whether the archive was unmounted.
function lovr.filesystem.unmount(path) end

--- Stops watching files.
---
--- [Open in browser](https://lovr.org/docs/lovr.filesystem.unwatch)
---@see lovr.filesystem.watch
---@see lovr.filechanged
function lovr.filesystem.unwatch() end

--- Starts watching the filesystem for changes.  File events will be reported by the `lovr.filechanged` callback.
--- Currently, on PC, only files in the source directory will be watched.  On Android, files in the save directory will be watched instead, so that pushing new files with `adb` can be detected.
---
--- [Open in browser](https://lovr.org/docs/lovr.filesystem.watch)
---@see lovr.filesystem.unwatch
---@see lovr.filechanged
function lovr.filesystem.watch() end

--- Write to a file in the save directory.
---
--- [Open in browser](https://lovr.org/docs/lovr.filesystem.write)
---@see lovr.filesystem.append
---@see lovr.filesystem.getSaveDirectory
---@see lovr.filesystem.read
---@param filename string # The file to write to.
---@param content string | Blob # A string or Blob to write to the file.
---@return boolean # Whether the write was successful.
---@return string # The error message, if there was an error.
function lovr.filesystem.write(filename, content) end

return lovr.filesystem