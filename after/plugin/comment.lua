vim.cmd([[ 
  augroup set-commentstring-ag
  autocmd!
  autocmd BufEnter *.jsx,*.tsx :lua vim.api.nvim_buf_set_option(0, "commentstring", "{/* %s */}")
  " when you've changed the name of a file opened in a buffer, the file type may have changed

  augroup END
]])

require('nvim_comment').setup({
  comment_empty = false,
  comment_empty_trim_whitespace = false,
  -- line_mapping = "<leader>cl", operator_mapping = "<leader>c", comment_chunk_text_object = "oc",
  hook = function()
    if vim.api.nvim_buf_get_option(0, "filetype") == "jsx" then
      require("ts_context_commentstring.internal").update_commentstring()
    end
  end
})
