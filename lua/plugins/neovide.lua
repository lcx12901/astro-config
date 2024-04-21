if not vim.g.neovide then
  return {} -- do nothing if not in a Neovide session
end

return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    options = {
      g = {
        neovide_scale_factor = 1.0,
        neovide_transparency = 0.99,
        neovide_refresh_rate = 60,
        neovide_no_idle = true,
        neovide_cursor_animate_in_insert_mode = true,
        neovide_cursor_animate_command_line = true,
        neovide_cursor_vfx_mode = "sonicboom",
      },
    },
  },
}
