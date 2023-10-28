require('fine-cmdline').setup({
    cmdline = {
        enable_keymaps = true,
        smart_history = true,
        prompt = ' Cmd: '
    },
    popup = {
        position = {
            row = '30%',
            col = '50%',
        },
        size = {
            width = '60%',
        },
        border = {
            style = 'rounded',
        },
        win_options = {
            winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
        },
    },
    hooks = {
        before_mount = function(input)
            -- code
        end,
        after_mount = function(input)
            -- code
        end,
    }
})
