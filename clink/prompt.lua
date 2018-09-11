---
 -- Dawid Ferenczy 2017 - 2018
 -- http://github.com/ferenczy/dotfiles

 -- Modified from Cmder's clink.lua script
 -- Original script: https://github.com/cmderdev/cmder/blob/development/vendor/clink.lua

 -- Script location: %UserProfile%\AppData\Local\clink\

 -- Setting the prompt in clink means that commands which rewrite the prompt do
 -- not destroy our own prompt. It also means that started cmds (or batch files
 -- which echo) don't get the ugly '{lamb}' shown.
---

local clink_completions_path = clink.get_env('CLINK_DIR') .. '/../clink-completions/'

function set_prompt_filter()
    -- orig: $E[1;32;40m$P$S{git}{hg}$S$_$E[1;30;40m{lamb}$S$E[0m
    -- color codes: "\x1b[1;37;40m"
    -- prompt = "\x1b[1;32;40m{cwd} {git}{hg} \n\x1b[1;30;40m{lamb} \x1b[0m"
    prompt = "{python_virtualenv}\x1b[0;36m[{datetime}] \x1b[1;36m{username}\x1b[0;35m@\x1b[0;32m{hostname} \x1b[1;33m{cwd}\x1b[0m{git}\n\x1b[0;30;42m$\x1b[0m "

    prompt = prompt:gsub("{cwd}", clink.get_cwd())
    prompt = prompt:gsub("{username}", clink.get_env("username"))
    prompt = prompt:gsub("{hostname}", string.lower(os.getenv("computername")))
    prompt = prompt:gsub("{datetime}", os.date("%Y-%m-%d %H:%M:%S"))
    prompt = prompt:gsub("{python_virtualenv}", get_python_virtualenv())

    -- prompt = string.gsub(prompt, "{errorlevel}", os.getenv("errorlevel"))
    prompt = prompt:gsub("{lamb}", "λ")
    clink.prompt.value = prompt
end

package.path = package.path .. ';' .. clink_completions_path .. 'modules/?.lua'
local clink_path_lua_file = clink_completions_path .. 'modules/path.lua'
path_module = dofile(clink_path_lua_file)

---
 -- Return currently active Python virtualenv or en empty string
 -- @return {string} Name of the currently active Python virtualenv
function get_python_virtualenv()
    python_virtualenv_path = clink.get_env("VIRTUAL_ENV")
    if (python_virtualenv_path) then
        -- python_virtualenv = '\x1b[1;35m(' .. python_virtualenv:match("\\([^\\]+)$") .. ')\x1b[0m '
        python_virtualenv = path_module.basename(python_virtualenv_path)
        python_virtualenv = '\x1b[1;35m(' .. python_virtualenv .. ')\x1b[0m '
    else
        python_virtualenv = ''
    end

    return python_virtualenv
end


---
 -- Resolves closest directory location for specified directory.
 -- Navigates subsequently up one level and tries to find specified directory
 -- @param  {string} path    Path to directory will be checked. If not provided
 --                          current directory will be used
 -- @param  {string} dirname Directory name to search for
 -- @return {string} Path to specified directory or nil if such dir not found
local function get_dir_contains(path, dirname)

    -- return parent path for specified entry (either file or directory)
    local function pathname(path)
        local prefix = ""
        local i = path:find("[\\/:][^\\/:]*$")
        if i then
            prefix = path:sub(1, i-1)
        end
        return prefix
    end

    -- Navigates up one level
    local function up_one_level(path)
        if path == nil then path = '.' end
        if path == '.' then path = clink.get_cwd() end
        return pathname(path)
    end

    -- Checks if provided directory contains git directory
    local function has_specified_dir(path, specified_dir)
        if path == nil then path = '.' end
        local found_dirs = clink.find_dirs(path..'/'..specified_dir)
        if #found_dirs > 0 then return true end
        return false
    end

    -- Set default path to current directory
    if path == nil then path = '.' end

    -- If we're already have .git directory here, then return current path
    if has_specified_dir(path, dirname) then
        return path..'/'..dirname
    else
        -- Otherwise go up one level and make a recursive call
        local parent_path = up_one_level(path)
        if parent_path == path then
            return nil
        else
            return get_dir_contains(parent_path, dirname)
        end
    end
end

-- adapted from from clink-completions' git.lua
local function get_git_dir(path)

    -- return parent path for specified entry (either file or directory)
    local function pathname(path)
        local prefix = ""
        local i = path:find("[\\/:][^\\/:]*$")
        if i then
            prefix = path:sub(1, i-1)
        end
        return prefix
    end

    -- Checks if provided directory contains git directory
    local function has_git_dir(dir)
        return #clink.find_dirs(dir..'/.git') > 0 and dir..'/.git'
    end

    local function has_git_file(dir)
        local gitfile = io.open(dir..'/.git')
        if not gitfile then return false end

        local git_dir = gitfile:read():match('gitdir: (.*)')
        gitfile:close()

        return git_dir and dir..'/'..git_dir
    end

    -- Set default path to current directory
    if not path or path == '.' then path = clink.get_cwd() end

    -- Calculate parent path now otherwise we won't be
    -- able to do that inside of logical operator
    local parent_path = pathname(path)

    return has_git_dir(path)
        or has_git_file(path)
        -- Otherwise go up one level and make a recursive call
        or (parent_path ~= path and get_git_dir(parent_path) or nil)
end

---
 -- Find out current branch
 -- @return {nil|git branch name}
---
function get_git_branch(git_dir)
    local git_dir = git_dir or get_git_dir()

    -- If git directory not found then we're probably outside of repo
    -- or something went wrong. The same is when head_file is nil
    local head_file = git_dir and io.open(git_dir..'/HEAD')
    if not head_file then return end

    local HEAD = head_file:read()
    head_file:close()

    -- if HEAD matches branch expression, then we're on named branch
    -- otherwise it is a detached commit
    local branch_name = HEAD:match('ref: refs/heads/(.+)')
    return branch_name or 'HEAD detached at '..HEAD:sub(1, 7)
end

---
 -- Get the status of working dir
 -- @return {bool}
---
function get_git_status()
    local file = io.popen("git status --no-lock-index --porcelain 2>nul")
    for line in file:lines() do
        file:close()
        return false
    end
    file:close()
    return true
end

function git_prompt_filter()

    -- Colors for git status
    local colors = {
        clean = "\x1b[0;35;40m",
        --clean = "\x1b[37;42m",
        dirty = "\x1b[1;35m",
        --dirty = "\x1b[30;43m",
    }

    local git_dir = get_git_dir()
    if git_dir then
        -- if we're inside of git repo then try to detect current branch
        local branch = get_git_branch(git_dir)
        if branch then
            -- Has branch => therefore it is a git folder, now figure out status
            if get_git_status() then
                color = colors.clean
                suffix = ''
            else
                color = colors.dirty
                suffix = '±'
            end

            clink.prompt.value = clink.prompt.value:gsub("{git}", " " .. color .. " " .. branch .. suffix)
            return false
        end
    end

    -- No git present or not in git file
    clink.prompt.value = clink.prompt.value:gsub("{git}", "")
    return false
end

-- insert the set_prompt at the very beginning so that it runs first
clink.prompt.register_filter(set_prompt_filter, 1)
clink.prompt.register_filter(git_prompt_filter, 50)


-- load Clink completion modules
for _,lua_module in ipairs(clink.find_files(clink_completions_path .. '*.lua')) do
    -- Skip files that starts with _. This could be useful if some files should be ignored
    if not string.match(lua_module, '^_.*') then
        local filename = clink_completions_path .. lua_module
        -- use dofile instead of require because require caches loaded modules
        -- so config reloading using Alt-Q won't reload updated modules.
        dofile(filename)
    end
end
