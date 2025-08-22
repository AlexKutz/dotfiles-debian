require("config.lazy")

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- helper: save last chosen colorscheme
local function save_colorscheme(name)
  local f = io.open(vim.fn.stdpath("config") .. "/last_colorscheme.txt", "w")
  if f then
    f:write(name)
    f:close()
  end
end

-- helper: load last colorscheme on startup
local function load_colorscheme()
  local f = io.open(vim.fn.stdpath("config") .. "/last_colorscheme.txt", "r")
  if f then
    local scheme = f:read("*l")
    f:close()
    if scheme and #scheme > 0 then
      pcall(vim.cmd.colorscheme, scheme) -- pcall чтобы не упало если тема удалена
    end
  end
end

-- load saved colorscheme when starting nvim
load_colorscheme()

-- map <C-j> to open fzf-lua colorscheme picker and save selection
vim.keymap.set("n", "<C-j>", function()
  require("fzf-lua").colorschemes({
    actions = {
      ["default"] = function(selected)
        local scheme = selected[1]
        if scheme then
          vim.cmd.colorscheme(scheme)
          save_colorscheme(scheme)
        end
      end,
    },
  })
end, { silent = true, noremap = true })
