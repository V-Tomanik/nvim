-- Funções e ferramentas adicionais

-- Create Scratch Buffer
local api = vim.api  -- Chama localmente a api do vim
local M ={}
function M.makeScratch()
		api.nvim_command('enew') -- Identico a :enew
		vim.bo[0].buftype=nofile
		vim.bo[0].bufhidden=hide
		vim.bo[0].swapfile=false
end

return M


