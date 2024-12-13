return {
	"arminveres/md-pdf.nvim",
	config = function()
		local m_pdf = require("md-pdf")
		m_pdf.setup({
            output_path = './'
        })
		vim.keymap.set("n", "<leader>,", function()
			require("md-pdf").convert_md_to_pdf()
		end)
	end,
}
