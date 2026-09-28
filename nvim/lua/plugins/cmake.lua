return {
  {
    "Civitasv/cmake-tools.nvim",
    opts = {
      cmake_build_directory = function()
        local custom = "build/linux_x86_64_Debug"
        if vim.uv.fs_stat(vim.uv.cwd() .. "/" .. custom) then
          return custom
        end
        return "cmake-build-${variant:buildType}"
      end,
    },
  },
}
