Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbaLHLhe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 06:37:34 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:16621 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949AbaLHLhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 06:37:31 -0500
X-AuditID: cbfee68d-f79296d000004278-77-54858d79eaf2
Message-id: <54858D81.1080003@samsung.com>
Date: Mon, 08 Dec 2014 17:07:37 +0530
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, mark.rutland@arm.com, marc.zyngier@arm.com,
        arnd@arndb.de, olof@lixom.net, catalin.marinas@arm.com,
        will.deacon@arm.com, s.nawrocki@samsung.com, tomasz.figa@gmail.com,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        chanho61.park@samsung.com, geunsik.lim@samsung.com,
        sw0312.kim@samsung.com, jh80.chung@samsung.com, a.kesavan@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 06/19] clk: samsung: exynos5433: Add clocks for CMU_MIF
 domain
References: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
 <1417510196-6714-7-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1417510196-6714-7-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsWyRsSkTreytzXE4O8NS4vHaxYzWfyddIzd
	4v2yHkaLy/u1La5/ec5qMf/IOVaLPxNa2Swm3Z/AYnHjVxurRe+Cq2wWZ5vesFtsenyN1eLy
	rjlsFjPO7wPqv/OPzWLp9YtMFqeuf2azOPymndVixuSXbBardv1htHj58QSLg6jHmnlrGD1+
	/5rE6LFz1l12j81L6j2unGhi9ejbsorR4/MmuQD2KC6blNSczLLUIn27BK6MGc+mMRbs1ah4
	enI+YwPjaqUuRg4OCQETiTd/bboYOYFMMYkL99azdTFycQgJLGWUeHZhIRNEwkRixvJPTBCJ
	RYwSu49+ZIVwWpkknn75zAgyiVdAS+L323qQBhYBVYlz++4ygthsAroST97PZQaxRQUiJK6s
	mQMW5xUQlPgx+R4LiC0ikC3x9M1hsM3MAjuZJc53TwFLCAuESByeNhfsCiGBeolTK/rYQWxO
	AVeJ1VNOsoHYzAK2Egver2OBsOUlNq95ywwySELgBIfEv39rGSEuEpD4NvkQC8TLshKbDjBD
	fCYpcXDFDZYJjGKzkNw0C8nYWUjGLmBkXsUomlqQXFCclF5kqFecmFtcmpeul5yfu4kRmBJO
	/3vWu4Px9gHrQ4wCHIxKPLwLHrSECLEmlhVX5h5iNAW6YiKzlGhyPjDx5JXEGxqbGVmYmpga
	G5lbmimJ8ypK/QwWEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwBiez/l/Z8rnsKszteYfuaAe
	ISF9s/tvtMw+m69zbbvZ89ef/6FfEK+SvsLoDhPbhTDzg+W7nq2rXjbJf5ZAO79Dc56gJ/eW
	/OzvVzRtorP7U5aKhrz7dl/EW0CbT8qNaVnizCTVx+WPJKQYbaIvdKyxyA788vkqv+GPhJbZ
	NpsvvbBh3/OaWYmlOCPRUIu5qDgRACvo4RUEAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDKsWRmVeSWpSXmKPExsVy+t9jAd3K3tYQgx2PdS0er1nMZPF30jF2
	i/fLehgtLu/Xtrj+5Tmrxfwj51gt/kxoZbOYdH8Ci8WNX22sFr0LrrJZnG16w26x6fE1VovL
	u+awWcw4vw+o/84/Noul1y8yWZy6/pnN4vCbdlaLGZNfslms2vWH0eLlxxMsDqIea+atYfT4
	/WsSo8fOWXfZPTYvqfe4cqKJ1aNvyypGj8+b5ALYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPj
	neNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAvlJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih
	6xsSBNdjZIAGEtYwZsx4No2xYK9GxdOT8xkbGFcrdTFyckgImEjMWP6JCcIWk7hwbz1bFyMX
	h5DAIkaJ3Uc/skI4rUwST798Zuxi5ODgFdCS+P22HqSBRUBV4ty+u4wgNpuArsST93OZQWxR
	gQiJK2vmgMV5BQQlfky+xwJiiwhkSzx9cxhsAbPATmaJ891TwBLCAiESh6fNBbtCSKBe4tSK
	PnYQm1PAVWL1lJNsIDazgK3EgvfrWCBseYnNa94yT2AUmIVkxywkZbOQlC1gZF7FKJpakFxQ
	nJSea6RXnJhbXJqXrpecn7uJEZxynknvYFzVYHGIUYCDUYmHd+GDlhAh1sSy4srcQ4wSHMxK
	IryJca0hQrwpiZVVqUX58UWlOanFhxhNgUEwkVlKNDkfmA7zSuINjU3MTY1NLU0sTMwslcR5
	b9zMDRESSE8sSc1OTS1ILYLpY+LglGpgjOOIacry+H2nWfZ/eWERS+6MmVvf125u2PD68RlX
	E+X+322+M04GvXHjeNqxM63wAdv2OzUcR9Umiuw5v1X4FPOXDWZTwpQ63S/y7zwcbtwUcNZv
	60XjEh9uhke6MwrjnXaGOl3aeyLun+p6LqUrjwV+nllWzd0bUvDfYMGn1Y/3Hn0s6ntKRoml
	OCPRUIu5qDgRAOmywtxPAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On Tuesday 02 December 2014 02:19 PM, Chanwoo Choi wrote:
> This patch adds the mux/divider/gate clock fo CMU_MIF domain which includes

nit: %s/fo/of

> the clocks for DMC(DRAM memory controller) and CCI(Cache Coherent Interconnect).
> The CMU_MIF domain provides the source clocks for CMU_DISP/CMU_BUS2.
>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Tomasz Figa <tomasz.figa@gmail.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Inki Dae <inki.dae@samsung.com>
> Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
> ---
>   drivers/clk/samsung/clk-exynos5433.c   | 590 +++++++++++++++++++++++++++++++++
>   include/dt-bindings/clock/exynos5433.h | 190 ++++++++++-
>   2 files changed, 779 insertions(+), 1 deletion(-)
>

[snip]

>
>   static struct samsung_pll_clock mif_pll_clks[] __initdata = {
> @@ -768,9 +888,479 @@ static struct samsung_pll_clock mif_pll_clks[] __initdata = {
>   		MFC_PLL_LOCK, MFC_PLL_CON0, exynos5443_pll_rates),
>   };
>
> +/* list of all parent clock list */
> +PNAME(mout_mfc_pll_div2_p)	= { "mout_mfc_pll", "dout_mfc_pll", };
> +PNAME(mout_bus_pll_div2_p)	= { "mout_bus_pll", "dout_bus_pll", };
> +PNAME(mout_mem1_pll_div2_p)	= { "mout_mem1_pll", "dout_mem1_pll", };
> +PNAME(mout_mem0_pll_div2_p)	= { "mout_mem0_pll", "dout_mem0_pll", };
> +PNAME(mout_mfc_pll_p)		= { "fin_pll", "fout_mfc_pll", };
> +PNAME(mout_bus_pll_p)		= { "fin_pll", "fout_bus_pll", };
> +PNAME(mout_mem1_pll_p)		= { "fin_pll", "fout_mem1_pll", };
> +PNAME(mout_mem0_pll_p)		= { "fin_pll", "fout_mem0_pll", };
> +
> +PNAME(mout_clk2x_phy_c_p)	= { "mout_mem0_pll_div2", "mout_clkm_phy_b", };
> +PNAME(mout_clk2x_phy_b_p)	= { "mout_bus_pll_div2", "mout_clkm_phy_a", };
> +PNAME(mout_clk2x_phy_a_p)	= { "mout_bus_pll_div2", "mout_mfc_pll_div2", };
> +PNAME(mout_clkm_phy_c_p)	= { "mout_mem0_pll_div2", "mout_clkm_phy_b", };

As mout_clk2x_phy_c_p and mout_clkm_phy_c_p both has same parent list 
one of them can be dropped.

> +PNAME(mout_clkm_phy_b_p)	= { "mout_mem1_pll_div2", "mout_clkm_phy_a", };
> +PNAME(mout_clkm_phy_a_p)	= { "mout_bus_pll_div2", "mout_mfc_pll_div2", };

As mout_clk2x_phy_a_p and mout_clkm_phy_a_p both has same parent list 
one of them can be dropped.

> +
> +PNAME(mout_aclk_mifnm_200_p)	= { "mout_mem0_pll_div2", "div_mif_pre", };
> +PNAME(mout_aclk_mifnm_400_p)	= { "mout_mem1_pll_div2", "mout_bus_pll_div2",};
> +
> +PNAME(mout_aclk_disp_333_b_p)	= { "mout_aclk_disp_333_a",
> +				    "mout_bus_pll_div2", };
> +PNAME(mout_aclk_disp_333_a_p)	= { "mout_mfc_pll_div2", "sclk_mphy_pll", };
> +
> +PNAME(mout_sclk_decon_vclk_c_p)	= { "mout_sclk_decon_vclk_b",
> +				    "sclk_mphy_pll", };
> +PNAME(mout_sclk_decon_vclk_b_p)	= { "mout_sclk_decon_vclk_a",
> +				    "mout_mfc_pll_div2", };
> +PNAME(mout_sclk_decon_vclk_a_p)	= { "fin_pll", "mout_bus_pll_div2", };
> +PNAME(mout_sclk_decon_eclk_c_p)	= { "mout_sclk_decon_eclk_b",
> +				    "sclk_mphy_pll", };
> +PNAME(mout_sclk_decon_eclk_b_p)	= { "mout_sclk_decon_eclk_a",
> +				    "mout_mfc_pll_div2", };
> +PNAME(mout_sclk_decon_eclk_a_p)	= { "fin_pll", "mout_bus_pll_div2", };
> +
> +PNAME(mout_sclk_decon_tv_eclk_c_p) = { "mout_sclk_decon_tv_eclk_b",
> +				       "sclk_mphy_pll", };
> +PNAME(mout_sclk_decon_tv_eclk_b_p) = { "mout_sclk_decon_tv_eclk_a",
> +				       "mout_mfc_pll_div2", };
> +PNAME(mout_sclk_decon_tv_eclk_a_p) = { "fin_pll", "mout_bus_pll_div2", };
> +PNAME(mout_sclk_dsd_c_p)	= { "mout_sclk_dsd_b", "mout_bus_pll_div2", };
> +PNAME(mout_sclk_dsd_b_p)	= { "mout_sclk_dsd_a", "sclk_mphy_pll", };
> +PNAME(mout_sclk_dsd_a_p)	= { "fin_pll", "mout_mfc_pll_div2", };
> +
> +PNAME(mout_sclk_dsim0_c_p)	= { "mout_sclk_dsim0_b", "sclk_mphy_pll", };
> +PNAME(mout_sclk_dsim0_b_p)	= { "mout_sclk_dsim0_a", "mout_mfc_pll_div2" };
> +PNAME(mout_sclk_dsim0_a_p)	= { "fin_pll", "mout_bus_pll_div2", };
> +
> +PNAME(mout_sclk_decon_tv_vclk_c_p) = { "mout_sclk_decon_tv_vclk_b",
> +				       "sclk_mphy_pll", };
> +PNAME(mout_sclk_decon_tv_vclk_b_p) = { "mout_sclk_decon_tv_vclk_a",
> +				       "mout_mfc_pll_div2", };
> +PNAME(mout_sclk_decon_tv_vclk_a_p) = { "fin_pll", "mout_bus_pll_div2", };
> +PNAME(mout_sclk_dsim1_c_p)	= { "mout_sclk_dsim1_b", "sclk_mphy_pll", };
> +PNAME(mout_sclk_dsim1_b_p)	= { "mout_sclk_dsim1_a", "mout_mfc_pll_div2",};
> +PNAME(mout_sclk_dsim1_a_p)	= { "fin_pll", "mout_bus_pll_div2", };
> +

Same way I can see {"fin_pll", "mout_bus_pll_div2", } this combination 
of parents is repeated six times above in different PNAME, which can be 
replaced by one PNAME list with some common name, thus saving of 5 lines.

> +static struct samsung_fixed_factor_clock mif_fixed_factor_clks[] __initdata = {
> +	/* dout_{mfc|bus|mem1|mem0}_pll is half fixed rate from parent mux */
> +	FFACTOR(CLK_DOUT_MFC_PLL, "dout_mfc_pll", "mout_mfc_pll", 1, 1, 0),
> +	FFACTOR(CLK_DOUT_BUS_PLL, "dout_bus_pll", "mout_bus_pll", 1, 1, 0),
> +	FFACTOR(CLK_DOUT_MEM1_PLL, "dout_mem1_pll", "mout_mem1_pll", 1, 1, 0),
> +	FFACTOR(CLK_DOUT_MEM0_PLL, "dout_mem0_pll", "mout_mem0_pll", 1, 1, 0),
> +};
> +


Thanks,
Pankaj Dubey
