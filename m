Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435AbaLIBbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 20:31:36 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:19675 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261AbaLIBbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 20:31:33 -0500
X-AuditID: cbfee68e-f79b46d000002b74-da-548650f3d94e
Message-id: <548650F2.9090404@samsung.com>
Date: Tue, 09 Dec 2014 10:31:30 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, mark.rutland@arm.com, marc.zyngier@arm.com,
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
 <54858D81.1080003@samsung.com>
In-reply-to: <54858D81.1080003@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsWyRsSkUPdzQFuIQd9fXovHaxYzWfyddIzd
	4v2yHkaLy/u1LeYfOcdq8WdCK5vFpPsTWCxu/GpjtehdcJXN4mzTG3aLTY+vsVpc3jWHzWLG
	+X1ArXf+sVksvX6RyeLU9c9sFou2fmG3OPymndVixuSXbBardv1htHj58QSLg6jHmnlrGD1+
	/5rE6LFz1l12j81L6j2unGhi9ejbsorR4/MmuQD2KC6blNSczLLUIn27BK6MOVta2Qqu61Sc
	+HCRqYFxikoXIyeHhICJxJMJ/UwQtpjEhXvr2boYuTiEBJYySpy6cIINpmj67gmMEIlFjBJH
	vi2Hcl4zSlx8u5q1i5GDg1dAS+L46jKQBhYBVYkft2YwgthsQOH9L26ADRIVCJNYOf0KC4jN
	KyAo8WPyPTBbREBbovPyPVaQmcwCf5glTh/eC9YsLBAicXjaXCaIZQsYJW6sPQp2KydQx/JV
	v5hBFjML6Encv6gFEmYWkJfYvOYtM0i9hMAJDolZ294yQlwkIPFt8iEWkHoJAVmJTQeYIT6T
	lDi44gbLBEaxWUhumoUwdRaSqQsYmVcxiqYWJBcUJ6UXGekVJ+YWl+al6yXn525iBKaE0/+e
	9e1gvHnA+hCjAAejEg+vpmVbiBBrYllxZe4hRlOgIyYyS4km5wMTT15JvKGxmZGFqYmpsZG5
	pZmSOG+C1M9gIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYwWiwK4g3sM785jS9Fm+89cGXSm
	3uXxjITVGXW+UXfmJJV5397yg/nt4TtFNw9auevZtDw/YfX70O38g8/PVmtKFaQaqn2IPnKf
	y7REbKppcZd9K+vthQJeOoyb2/70as/SSJohfEtcwXxvuNvb050HNzZG/f3tamM1Ye57tXfB
	SrEL0pV6KpRYijMSDbWYi4oTAdJLHToEAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNKsWRmVeSWpSXmKPExsVy+t9jAd3PAW0hBjPvMls8XrOYyeLvpGPs
	Fu+X9TBaXN6vbTH/yDlWiz8TWtksJt2fwGJx41cbq0XvgqtsFmeb3rBbbHp8jdXi8q45bBYz
	zu8Dar3zj81i6fWLTBanrn9ms1i09Qu7xeE37awWMya/ZLNYtesPo8XLjydYHEQ91sxbw+jx
	+9ckRo+ds+6ye2xeUu9x5UQTq0ffllWMHp83yQWwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfH
	O8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAfaWkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC
	1zckCK7HyAANJKxhzJizpZWt4LpOxYkPF5kaGKeodDFyckgImEhM3z2BEcIWk7hwbz1bFyMX
	h5DAIkaJI9+WM0I4rxklLr5dzdrFyMHBK6AlcXx1GUgDi4CqxI9bM8Ca2YDC+1/cYAOxRQXC
	JFZOv8ICYvMKCEr8mHwPzBYR0JbovHyPFWQms8AfZonTh/eCNQsLhEgcnjaXCWLZAkaJG2uP
	MoEkOIE6lq/6xQyymFlAT+L+RS2QMLOAvMTmNW+ZJzAKzEKyYxZC1SwkVQsYmVcxiqYWJBcU
	J6XnGukVJ+YWl+al6yXn525iBCecZ9I7GFc1WBxiFOBgVOLh1bBsCxFiTSwrrsw9xCjBwawk
	wrt8Z2uIEG9KYmVValF+fFFpTmrxIUZTYAhMZJYSTc4HJsO8knhDYxMzI0sjc0MLI2NzJXFe
	JXugOQLpiSWp2ampBalFMH1MHJxSDYwNF5x1ih/P+FT61Jkju/D338uHrG/ufGL2fPsr++zn
	CY52WUqpepOco6Y+n82tfGzbLI69L+yyPX3yrsxY2bXswuO6L5bq994crOLYeSiA5yeTyceX
	lk+vK1e+/7ms9e3Ne4vP2tQu1ft3hevfb0mjOdt2JsypnH9RapbDv6h//c9eLT7OlvJgrhJL
	cUaioRZzUXEiAPAGML1OAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

On 12/08/2014 08:37 PM, Pankaj Dubey wrote:
> Hi Chanwoo,
> 
> On Tuesday 02 December 2014 02:19 PM, Chanwoo Choi wrote:
>> This patch adds the mux/divider/gate clock fo CMU_MIF domain which includes
> 
> nit: %s/fo/of

I'll fix it.

> 
>> the clocks for DMC(DRAM memory controller) and CCI(Cache Coherent Interconnect).
>> The CMU_MIF domain provides the source clocks for CMU_DISP/CMU_BUS2.
>>
>> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Cc: Tomasz Figa <tomasz.figa@gmail.com>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Inki Dae <inki.dae@samsung.com>
>> Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
>> ---
>>   drivers/clk/samsung/clk-exynos5433.c   | 590 +++++++++++++++++++++++++++++++++
>>   include/dt-bindings/clock/exynos5433.h | 190 ++++++++++-
>>   2 files changed, 779 insertions(+), 1 deletion(-)
>>
> 
> [snip]
> 
>>
>>   static struct samsung_pll_clock mif_pll_clks[] __initdata = {
>> @@ -768,9 +888,479 @@ static struct samsung_pll_clock mif_pll_clks[] __initdata = {
>>           MFC_PLL_LOCK, MFC_PLL_CON0, exynos5443_pll_rates),
>>   };
>>
>> +/* list of all parent clock list */
>> +PNAME(mout_mfc_pll_div2_p)    = { "mout_mfc_pll", "dout_mfc_pll", };
>> +PNAME(mout_bus_pll_div2_p)    = { "mout_bus_pll", "dout_bus_pll", };
>> +PNAME(mout_mem1_pll_div2_p)    = { "mout_mem1_pll", "dout_mem1_pll", };
>> +PNAME(mout_mem0_pll_div2_p)    = { "mout_mem0_pll", "dout_mem0_pll", };
>> +PNAME(mout_mfc_pll_p)        = { "fin_pll", "fout_mfc_pll", };
>> +PNAME(mout_bus_pll_p)        = { "fin_pll", "fout_bus_pll", };
>> +PNAME(mout_mem1_pll_p)        = { "fin_pll", "fout_mem1_pll", };
>> +PNAME(mout_mem0_pll_p)        = { "fin_pll", "fout_mem0_pll", };
>> +
>> +PNAME(mout_clk2x_phy_c_p)    = { "mout_mem0_pll_div2", "mout_clkm_phy_b", };
>> +PNAME(mout_clk2x_phy_b_p)    = { "mout_bus_pll_div2", "mout_clkm_phy_a", };
>> +PNAME(mout_clk2x_phy_a_p)    = { "mout_bus_pll_div2", "mout_mfc_pll_div2", };
>> +PNAME(mout_clkm_phy_c_p)    = { "mout_mem0_pll_div2", "mout_clkm_phy_b", };
> 
> As mout_clk2x_phy_c_p and mout_clkm_phy_c_p both has same parent list one of them can be dropped.

OK, I'll use common parent to remove duplicat code.

> 
>> +PNAME(mout_clkm_phy_b_p)    = { "mout_mem1_pll_div2", "mout_clkm_phy_a", };
>> +PNAME(mout_clkm_phy_a_p)    = { "mout_bus_pll_div2", "mout_mfc_pll_div2", };
> 
> As mout_clk2x_phy_a_p and mout_clkm_phy_a_p both has same parent list one of them can be dropped.

OK.

> 
>> +
>> +PNAME(mout_aclk_mifnm_200_p)    = { "mout_mem0_pll_div2", "div_mif_pre", };
>> +PNAME(mout_aclk_mifnm_400_p)    = { "mout_mem1_pll_div2", "mout_bus_pll_div2",};
>> +
>> +PNAME(mout_aclk_disp_333_b_p)    = { "mout_aclk_disp_333_a",
>> +                    "mout_bus_pll_div2", };
>> +PNAME(mout_aclk_disp_333_a_p)    = { "mout_mfc_pll_div2", "sclk_mphy_pll", };
>> +
>> +PNAME(mout_sclk_decon_vclk_c_p)    = { "mout_sclk_decon_vclk_b",
>> +                    "sclk_mphy_pll", };
>> +PNAME(mout_sclk_decon_vclk_b_p)    = { "mout_sclk_decon_vclk_a",
>> +                    "mout_mfc_pll_div2", };
>> +PNAME(mout_sclk_decon_vclk_a_p)    = { "fin_pll", "mout_bus_pll_div2", };
>> +PNAME(mout_sclk_decon_eclk_c_p)    = { "mout_sclk_decon_eclk_b",
>> +                    "sclk_mphy_pll", };
>> +PNAME(mout_sclk_decon_eclk_b_p)    = { "mout_sclk_decon_eclk_a",
>> +                    "mout_mfc_pll_div2", };
>> +PNAME(mout_sclk_decon_eclk_a_p)    = { "fin_pll", "mout_bus_pll_div2", };
>> +
>> +PNAME(mout_sclk_decon_tv_eclk_c_p) = { "mout_sclk_decon_tv_eclk_b",
>> +                       "sclk_mphy_pll", };
>> +PNAME(mout_sclk_decon_tv_eclk_b_p) = { "mout_sclk_decon_tv_eclk_a",
>> +                       "mout_mfc_pll_div2", };
>> +PNAME(mout_sclk_decon_tv_eclk_a_p) = { "fin_pll", "mout_bus_pll_div2", };
>> +PNAME(mout_sclk_dsd_c_p)    = { "mout_sclk_dsd_b", "mout_bus_pll_div2", };
>> +PNAME(mout_sclk_dsd_b_p)    = { "mout_sclk_dsd_a", "sclk_mphy_pll", };
>> +PNAME(mout_sclk_dsd_a_p)    = { "fin_pll", "mout_mfc_pll_div2", };
>> +
>> +PNAME(mout_sclk_dsim0_c_p)    = { "mout_sclk_dsim0_b", "sclk_mphy_pll", };
>> +PNAME(mout_sclk_dsim0_b_p)    = { "mout_sclk_dsim0_a", "mout_mfc_pll_div2" };
>> +PNAME(mout_sclk_dsim0_a_p)    = { "fin_pll", "mout_bus_pll_div2", };
>> +
>> +PNAME(mout_sclk_decon_tv_vclk_c_p) = { "mout_sclk_decon_tv_vclk_b",
>> +                       "sclk_mphy_pll", };
>> +PNAME(mout_sclk_decon_tv_vclk_b_p) = { "mout_sclk_decon_tv_vclk_a",
>> +                       "mout_mfc_pll_div2", };
>> +PNAME(mout_sclk_decon_tv_vclk_a_p) = { "fin_pll", "mout_bus_pll_div2", };
>> +PNAME(mout_sclk_dsim1_c_p)    = { "mout_sclk_dsim1_b", "sclk_mphy_pll", };
>> +PNAME(mout_sclk_dsim1_b_p)    = { "mout_sclk_dsim1_a", "mout_mfc_pll_div2",};
>> +PNAME(mout_sclk_dsim1_a_p)    = { "fin_pll", "mout_bus_pll_div2", };
>> +
> 
> Same way I can see {"fin_pll", "mout_bus_pll_div2", } this combination of parents is repeated six times above in different PNAME, which can be replaced by one PNAME list with some common name, thus saving of 5 lines.

OK.

> 
>> +static struct samsung_fixed_factor_clock mif_fixed_factor_clks[] __initdata = {
>> +    /* dout_{mfc|bus|mem1|mem0}_pll is half fixed rate from parent mux */
>> +    FFACTOR(CLK_DOUT_MFC_PLL, "dout_mfc_pll", "mout_mfc_pll", 1, 1, 0),
>> +    FFACTOR(CLK_DOUT_BUS_PLL, "dout_bus_pll", "mout_bus_pll", 1, 1, 0),
>> +    FFACTOR(CLK_DOUT_MEM1_PLL, "dout_mem1_pll", "mout_mem1_pll", 1, 1, 0),
>> +    FFACTOR(CLK_DOUT_MEM0_PLL, "dout_mem0_pll", "mout_mem0_pll", 1, 1, 0),
>> +};
>> +

Thanks for your review.

Best Regards,
Chanwoo Choi

