Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbaJXOHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 10:07:45 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:25652 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090AbaJXOHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 10:07:43 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-8a-544a5d2dc4c9
Message-id: <544A5D2D.2040501@samsung.com>
Date: Fri, 24 Oct 2014 23:07:41 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: tomasz.figa@gmail.com, kgene.kim@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        geunsik.lim@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/2] clk: samsung: exynos4415: Add clocks using common
 clock framework
References: <1414148828-23719-1-git-send-email-cw00.choi@samsung.com>
 <1414148828-23719-2-git-send-email-cw00.choi@samsung.com>
 <544A402F.1010207@samsung.com>
In-reply-to: <544A402F.1010207@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsWyRsSkWFc31ivEYM9XeYs/E1rZLCbdn8Bi
	0bvgKpvF2aY37BaXd81hs5hxfh+TxeE37awWMya/ZLNYtesPowOnx85Zd9k9+rasYvT4vEku
	gDmKyyYlNSezLLVI3y6BK+PY9L3sBXeyK+7vnMLYwNgU0cXIySEhYCLxvvctE4QtJnHh3nq2
	LkYuDiGBpYwSnx+eZ4cp2n7tOCNEYjqjRNP6K6wQzmtGieYnLawgVbwCWhJ/pq8Gs1kEVCW+
	X9nEDGKzAcX3v7jBBmKLCoRJrJx+hQWiXlDix+R7YLaIgL7EklUXwVYzC1xnlPjzax5Ys7BA
	nMTbW+1Q2xYxSuyedRVsA6eAtsTf091AHRxAHXoS9y9qgYSZBeQlNq95ywxSLyFwjl1i8bNe
	FoiLBCS+TT7EAlIvISArsekAM8RrkhIHV9xgmcAoNgvJTbMQps5CMnUBI/MqRtHUguSC4qT0
	IhO94sTc4tK8dL3k/NxNjMDIO/3v2YQdjPcOWB9iFOBgVOLhNZjtGSLEmlhWXJl7iNEU6IiJ
	zFKiyfnA+M4riTc0NjOyMDUxNTYytzRTEud9LfUzWEggPbEkNTs1tSC1KL6oNCe1+BAjEwen
	VAPj5NuCb7aX6QTbuv81OOaZtqa7w9LZfamCndOLxnmiGlzHD69Ktiw+Z8O64pfQhwdHwr2a
	XFuO6MXtmei7nItZLIvPfV1IwBvD2mSW1hPcNpsXmu2a6y+5Z3Iy1+eiD5kfNe7qT9dVS4tU
	+uzyVfhU79ae3e7NbAHZe3QUviV73dVcK7PucKcSS3FGoqEWc1FxIgBmhFfBtwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t9jQV3dWK8QgxNbRC3+TGhls5h0fwKL
	Re+Cq2wWZ5vesFtc3jWHzWLG+X1MFofftLNazJj8ks1i1a4/jA6cHjtn3WX36NuyitHj8ya5
	AOaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKA7
	lBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZx6bvZS+4k11xf+cUxgbG
	poguRk4OCQETie3XjjNC2GISF+6tZ+ti5OIQEpjOKNG0/gorhPOaUaL5SQsrSBWvgJbEn+mr
	wWwWAVWJ71c2MYPYbEDx/S9usIHYogJhEiunX2GBqBeU+DH5HpgtIqAvsWTVRbANzALXGSX+
	/JoH1iwsECfx9lY71LZFjBK7Z10F28ApoC3x93Q3UAcHUIeexP2LWiBhZgF5ic1r3jJPYBSY
	hWTHLISqWUiqFjAyr2IUTS1ILihOSs810itOzC0uzUvXS87P3cQIjutn0jsYVzVYHGIU4GBU
	4uG9McMzRIg1say4MvcQowQHs5IIr7+/V4gQb0piZVVqUX58UWlOavEhRlNgCExklhJNzgem
	nLySeENjEzMjSyNzQwsjY3Mlcd6DrdaBQgLpiSWp2ampBalFMH1MHJxSDYzu5zv+v1MpNO1R
	ruWR37fy/fqy1Qctxdu2fluy5O6d5bFT7G3CuFVDV7jFrsnm11LuXqzFMtHXSO3X+/kfrCpf
	+VhJ/1yz9WzblBL11RbMG9i/atonrPN7Xn2Tt+Pcoyv1fNNTtW/+uL19yZyQL727XFZVzryu
	1T99pUaN9fKtH/jjps0vmy2ixFKckWioxVxUnAgA976hXwEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester,

On 10/24/2014 09:03 PM, Sylwester Nawrocki wrote:
> On 24/10/14 13:07, Chanwoo Choi wrote:
>> This patch adds the new clock driver of Exynos4415 SoC based on Cortex-A9
>> using common clock framework. The CMU (Clock Management Unit) of Exynos4415
>> controls PLLs(Phase Locked Loops) and generates system clocks for CPU, buses
>> and function clocks for individual IPs.
>>
>> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Cc: Tomasz Figa <tomasz.figa@gmail.com>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
>> Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> Thanks for the update, there are still couple issues pointed out
> by checkpatch.pl unfortunately, please see below.
> Please fix the errors, I added also some more comments inline below.
> In future please put DT binding documentation patch first in the
> series, before the actual driver patch.
> 
> WARNING: kfree(NULL) is safe this check is probably not required
> #252: FILE: drivers/clk/samsung/clk-exynos4415.c:252:
> +	if (clk_regs)
> +		kfree(clk_regs);
> 
> ERROR: space required after that ',' (ctx:VxV)
> #423: FILE: drivers/clk/samsung/clk-exynos4415.c:423:
> +		0,4),
>  		 ^
> 
> WARNING: line over 80 characters
> #726: FILE: drivers/clk/samsung/clk-exynos4415.c:726:
> +		"div_pxlasync_csis0_fimc", GATE_SCLK_CAM, 10, CLK_SET_RATE_PARENT, 0),
> 
> WARNING: line over 80 characters
> #817: FILE: drivers/clk/samsung/clk-exynos4415.c:817:
> +	GATE(CLK_SMMUFIMC_LITE2, "smmufimc_lite2", "div_aclk_160", GATE_IP_CAM, 22,
> 
> WARNING: line over 80 characters
> #875: FILE: drivers/clk/samsung/clk-exynos4415.c:875:
> +	GATE(CLK_USBDEVICE, "usbdevice", "div_aclk_200", GATE_IP_FSYS, 13, 0, 0),
> 
> ERROR: space prohibited after that open parenthesis '('
> #920: FILE: drivers/clk/samsung/clk-exynos4415.c:920:
> +	PLL_35XX_RATE( 960000000, 320, 4,  1),
> 
> ERROR: space prohibited after that open parenthesis '('
> #921: FILE: drivers/clk/samsung/clk-exynos4415.c:921:
> +	PLL_35XX_RATE( 900000000, 300, 4,  1),
> 
> ERROR: space prohibited after that open parenthesis '('
> #922: FILE: drivers/clk/samsung/clk-exynos4415.c:922:
> +	PLL_35XX_RATE( 850000000, 425, 6,  1),
> 
> ERROR: space prohibited after that open parenthesis '('
> #923: FILE: drivers/clk/samsung/clk-exynos4415.c:923:
> +	PLL_35XX_RATE( 800000000, 200, 3,  1),
> 
> ERROR: space prohibited after that open parenthesis '('
> #924: FILE: drivers/clk/samsung/clk-exynos4415.c:924:
> +	PLL_35XX_RATE( 700000000, 175, 3,  1),
> 
> ERROR: space prohibited after that open parenthesis '('
> #925: FILE: drivers/clk/samsung/clk-exynos4415.c:925:
> +	PLL_35XX_RATE( 667000000, 667, 12, 1),
> 
> ERROR: space prohibited after that open parenthesis '('
> #926: FILE: drivers/clk/samsung/clk-exynos4415.c:926:
> +	PLL_35XX_RATE( 600000000, 400, 4,  2),
> 
> ERROR: space prohibited after that open parenthesis '('
> #927: FILE: drivers/clk/samsung/clk-exynos4415.c:927:
> +	PLL_35XX_RATE( 550000000, 275, 3,  2),
> 
> ERROR: space prohibited after that open parenthesis '('
> #928: FILE: drivers/clk/samsung/clk-exynos4415.c:928:
> +	PLL_35XX_RATE( 533000000, 533, 6,  2),
> 
> ERROR: space prohibited after that open parenthesis '('
> #929: FILE: drivers/clk/samsung/clk-exynos4415.c:929:
> +	PLL_35XX_RATE( 520000000, 260, 3,  2),
> 
> ERROR: space prohibited after that open parenthesis '('
> #930: FILE: drivers/clk/samsung/clk-exynos4415.c:930:
> +	PLL_35XX_RATE( 500000000, 250, 3,  2),
> 
> ERROR: space prohibited after that open parenthesis '('
> #931: FILE: drivers/clk/samsung/clk-exynos4415.c:931:
> +	PLL_35XX_RATE( 440000000, 220, 3,  2),
> 
> ERROR: space prohibited after that open parenthesis '('
> #932: FILE: drivers/clk/samsung/clk-exynos4415.c:932:
> +	PLL_35XX_RATE( 400000000, 200, 3,  2),
> 
> ERROR: space prohibited after that open parenthesis '('
> #933: FILE: drivers/clk/samsung/clk-exynos4415.c:933:
> +	PLL_35XX_RATE( 350000000, 175, 3,  2),
> 
> ERROR: space prohibited after that open parenthesis '('
> #934: FILE: drivers/clk/samsung/clk-exynos4415.c:934:
> +	PLL_35XX_RATE( 300000000, 300, 3,  3),
> #935: FILE: drivers/clk/samsung/clk-exynos4415.c:935:
> +	PLL_35XX_RATE( 266000000, 266, 3,  3),
> 
> ERROR: space prohibited after that open parenthesis '('
> #936: FILE: drivers/clk/samsung/clk-exynos4415.c:936:
> +	PLL_35XX_RATE( 200000000, 200, 3,  3),
> 
> ERROR: space prohibited after that open parenthesis '('
> #937: FILE: drivers/clk/samsung/clk-exynos4415.c:937:
> +	PLL_35XX_RATE( 160000000, 160, 3,  3),
> 
> ERROR: space prohibited after that open parenthesis '('
> #938: FILE: drivers/clk/samsung/clk-exynos4415.c:938:
> +	PLL_35XX_RATE( 100000000, 200, 3,  4),
> 
> ERROR: space prohibited after that open parenthesis '('
> #948: FILE: drivers/clk/samsung/clk-exynos4415.c:948:
> +	PLL_36XX_RATE( 96000000, 128, 2, 4,     0),
> 
> ERROR: space prohibited after that open parenthesis '('
> #949: FILE: drivers/clk/samsung/clk-exynos4415.c:949:
> +	PLL_36XX_RATE( 84000000, 112, 2, 4,     0),
> 
> ERROR: space prohibited after that open parenthesis '('
> #950: FILE: drivers/clk/samsung/clk-exynos4415.c:950:
> +	PLL_36XX_RATE( 80750011, 107, 2, 4, 43691),
> 
> ERROR: space prohibited after that open parenthesis '('
> #951: FILE: drivers/clk/samsung/clk-exynos4415.c:951:
> +	PLL_36XX_RATE( 73728004,  98, 2, 4, 19923),
> 
> ERROR: space prohibited after that open parenthesis '('
> #952: FILE: drivers/clk/samsung/clk-exynos4415.c:952:
> +	PLL_36XX_RATE( 67987602, 271, 3, 5, 62285),
> 
> ERROR: space prohibited after that open parenthesis '('
> #953: FILE: drivers/clk/samsung/clk-exynos4415.c:953:
> +	PLL_36XX_RATE( 65911004, 175, 2, 5, 49982),
> 
> ERROR: space prohibited after that open parenthesis '('
> #954: FILE: drivers/clk/samsung/clk-exynos4415.c:954:
> +	PLL_36XX_RATE( 50000000, 200, 3, 5,     0),
> 
> ERROR: space prohibited after that open parenthesis '('
> #955: FILE: drivers/clk/samsung/clk-exynos4415.c:955:
> +	PLL_36XX_RATE( 49152003, 131, 2, 5,  4719),
> 
> ERROR: space prohibited after that open parenthesis '('
> #956: FILE: drivers/clk/samsung/clk-exynos4415.c:956:
> +	PLL_36XX_RATE( 48000000, 128, 2, 5,     0),
> 
> ERROR: space prohibited after that open parenthesis '('
> #957: FILE: drivers/clk/samsung/clk-exynos4415.c:957:
> +	PLL_36XX_RATE( 45250000, 181, 3, 5,     0),
> 
> total: 30 errors, 4 warnings, 1133 lines checked
> 
> drivers/clk/samsung/clk-exynos4415.c has style problems, please review.
> 
>> ---
>>  drivers/clk/samsung/Makefile           |    1 +
>>  drivers/clk/samsung/clk-exynos4415.c   | 1133 ++++++++++++++++++++++++++++++++
>>  include/dt-bindings/clock/exynos4415.h |  360 ++++++++++
>>  3 files changed, 1494 insertions(+)
>>  create mode 100644 drivers/clk/samsung/clk-exynos4415.c
>>  create mode 100644 include/dt-bindings/clock/exynos4415.h
> 
>> diff --git a/drivers/clk/samsung/clk-exynos4415.c b/drivers/clk/samsung/clk-exynos4415.c
>> new file mode 100644
>> index 0000000..a4b6211
>> --- /dev/null
>> +++ b/drivers/clk/samsung/clk-exynos4415.c
>> @@ -0,0 +1,1133 @@
> 
>> +static struct samsung_clk_reg_dump *clk_regs;
>> +static struct samsung_clk_provider *ctx;
>> +
>> +static unsigned long cmu_clk_regs[] __initdata = {
> 
>> +};
>> +
>> +static int exynos_clk_suspend(void)
> 
> Please prefix such function (and above variable) names with exynos4415,
> as is done for other SoC drivers.

ok.

> 
>> +{
>> +	samsung_clk_save(ctx->reg_base, clk_regs, ARRAY_SIZE(cmu_clk_regs));
>> +
>> +	return 0;
>> +}
>> +
>> +static void exynos_clk_resume(void)
> 
> exynos4415_clk_resume ?

ok.

> 
>> +{
>> +	samsung_clk_restore(ctx->reg_base, clk_regs, ARRAY_SIZE(cmu_clk_regs));
>> +}
>> +
>> +static struct syscore_ops exynos_clk_syscore_ops = {
> 
> exynos4415_clk_syscore_ops ?

ok.

> 
>> +	.suspend = exynos_clk_suspend,
>> +	.resume = exynos_clk_resume,
>> +};
>> +
>> +static void exynos_clk_sleep_init(void)
> 
> exynos4415_clk_sleep_init ?
> 
>> +{
>> +	clk_regs = samsung_clk_alloc_reg_dump(cmu_clk_regs,
>> +						ARRAY_SIZE(cmu_clk_regs));
>> +	if (!clk_regs) {
>> +		pr_warn("%s: Failed to allocate sleep save data\n", __func__);
>> +		goto err;
> 
> You could just return here.

ok.

> 
>> +	}
>> +
>> +	register_syscore_ops(&exynos_clk_syscore_ops);
>> +
>> +	return;
>> +err:
>> +	if (clk_regs)
>> +		kfree(clk_regs);
> 
> kfree() can be removed (and the condition could never be true anyway).

You're right. I'll remove it.

> 
>> +}
>> +#else
>> +static inline void exynos_clk_sleep_init(void) { }
> 
> exynos4415_clk_sleep_init ?

ok.

> 
>> +#endif
> 
> How about prefixing the table names below with "exynos4415", rather than
> "samsung" ?

'struct samsung_fixed_factor_clock' is common for Exynos SoC.

Do you means that add 'exynos4415' prefix as following:
- fixed_factor_clks -> exynos4415_fixed_factor_clks

> 
>> +static struct samsung_fixed_factor_clock fixed_factor_clks[] __initdata = {
> 
>> +};
>> +
>> +static struct samsung_fixed_rate_clock fixed_rate_clks[] __initdata = {
>> +	FRATE(CLK_SCLK_HDMIPHY, "sclk_hdmiphy", NULL, CLK_IS_ROOT, 27000000),
>> +};
>> +
>> +static struct samsung_mux_clock mux_clks[] __initdata = {
> 
>> +};
>> +
>> +static struct samsung_div_clock div_clks[] __initdata = {
> 
>> +};
>> +
>> +static struct samsung_gate_clock gate_clks[] __initdata = {

Do you want to change structure naming as following?
fixed_factor_clks -> exynos4415_fixed_factor_clks
fixed_rate_clks -> exynos4415_fixed_rate_clks
mux_clks -> exynos4415_mux_clks
div_clks -> exynos4415_div_clks
gate_clks -> exynos4415_gate_clks

> 
>> +};
>> +
>> +/*
>> + * APLL & MPLL & BPLL & ISP_PLL & DISP_PLL & G3D_PLL
>> + */
>> +static struct samsung_pll_rate_table exynos4415_pll_rates[] = {
>> +	PLL_35XX_RATE(1600000000, 400, 3,  1),
>> +	PLL_35XX_RATE(1500000000, 250, 2,  1),
>> +	PLL_35XX_RATE(1400000000, 175, 3,  0),
>> +	PLL_35XX_RATE(1300000000, 325, 3,  1),
>> +	PLL_35XX_RATE(1200000000, 400, 4,  1),
>> +	PLL_35XX_RATE(1100000000, 275, 3,  1),
>> +	PLL_35XX_RATE(1066000000, 533, 6,  1),
>> +	PLL_35XX_RATE(1000000000, 250, 3,  1),
>> +	PLL_35XX_RATE( 960000000, 320, 4,  1),
>> +	PLL_35XX_RATE( 900000000, 300, 4,  1),
>> +	PLL_35XX_RATE( 850000000, 425, 6,  1),
>> +	PLL_35XX_RATE( 800000000, 200, 3,  1),
>> +	PLL_35XX_RATE( 700000000, 175, 3,  1),
>> +	PLL_35XX_RATE( 667000000, 667, 12, 1),
>> +	PLL_35XX_RATE( 600000000, 400, 4,  2),
>> +	PLL_35XX_RATE( 550000000, 275, 3,  2),
>> +	PLL_35XX_RATE( 533000000, 533, 6,  2),
>> +	PLL_35XX_RATE( 520000000, 260, 3,  2),
>> +	PLL_35XX_RATE( 500000000, 250, 3,  2),
>> +	PLL_35XX_RATE( 440000000, 220, 3,  2),
>> +	PLL_35XX_RATE( 400000000, 200, 3,  2),
>> +	PLL_35XX_RATE( 350000000, 175, 3,  2),
>> +	PLL_35XX_RATE( 300000000, 300, 3,  3),
>> +	PLL_35XX_RATE( 266000000, 266, 3,  3),
>> +	PLL_35XX_RATE( 200000000, 200, 3,  3),
>> +	PLL_35XX_RATE( 160000000, 160, 3,  3),
>> +	PLL_35XX_RATE( 100000000, 200, 3,  4),
>> +	{ /* sentinel */ }
>> +};
>> +
>> +/* EPLL */
>> +static struct samsung_pll_rate_table exynos4415_epll_rates[] = {
>> +	PLL_36XX_RATE(800000000, 200, 3, 1,     0),
>> +	PLL_36XX_RATE(288000000,  96, 2, 2,     0),
>> +	PLL_36XX_RATE(192000000, 128, 2, 3,     0),
>> +	PLL_36XX_RATE(144000000,  96, 2, 3,     0),
>> +	PLL_36XX_RATE( 96000000, 128, 2, 4,     0),
>> +	PLL_36XX_RATE( 84000000, 112, 2, 4,     0),
>> +	PLL_36XX_RATE( 80750011, 107, 2, 4, 43691),
>> +	PLL_36XX_RATE( 73728004,  98, 2, 4, 19923),
>> +	PLL_36XX_RATE( 67987602, 271, 3, 5, 62285),
>> +	PLL_36XX_RATE( 65911004, 175, 2, 5, 49982),
>> +	PLL_36XX_RATE( 50000000, 200, 3, 5,     0),
>> +	PLL_36XX_RATE( 49152003, 131, 2, 5,  4719),
>> +	PLL_36XX_RATE( 48000000, 128, 2, 5,     0),
>> +	PLL_36XX_RATE( 45250000, 181, 3, 5,     0),
>> +	{ /* sentinel */ }
>> +};
>> +
>> +static struct samsung_pll_clock plls[nr_plls] __initdata = {
> 
>> +};
>> +
>> +static void __init exynos4415_cmu_init(struct device_node *np)
>> +{
> 
>> +}
>> +CLK_OF_DECLARE(exynos4415_cmu, "samsung,exynos4415-cmu", exynos4415_cmu_init);
>> +
>> +/*
>> + * CMU DMC
>> + */
>> +
> 
>> +#ifdef CONFIG_PM_SLEEP
> 
> Similarly for dmc, can we have function, table and below two static
> variable names prefixed with exynos4415, like in exynos3250 driver ?

ok.

> 
>> +static struct samsung_clk_reg_dump *dmc_clk_regs;
>> +static struct samsung_clk_provider *dmc_ctx;
>> +
>> +static unsigned long dmc_save_list[] __initdata = {
> 
>> +};
>> +
>> +static int dmc_clk_suspend(void)
>> +{
>> +	samsung_clk_save(dmc_ctx->reg_base,
>> +				dmc_clk_regs, ARRAY_SIZE(dmc_save_list));
>> +	return 0;
>> +}
>> +
>> +static void dmc_clk_resume(void)
>> +{
>> +	samsung_clk_restore(dmc_ctx->reg_base,
>> +				dmc_clk_regs, ARRAY_SIZE(dmc_save_list));
>> +}
>> +
>> +static struct syscore_ops dmc_clk_syscore_ops = {
>> +	.suspend = dmc_clk_suspend,
>> +	.resume = dmc_clk_resume,
>> +};
>> +
>> +static void dmc_clk_sleep_init(void)
>> +{
> 
>> +}
>> +#else
>> +static inline void dmc_clk_sleep_init(void) { }
>> +#endif /* CONFIG_PM_SLEEP */
>> +
> 
>> +static struct samsung_mux_clock dmc_mux_clks[] __initdata = {
> 
>> +};
>> +
>> +static struct samsung_div_clock dmc_div_clks[] __initdata = {
> 
>> +};
>> +
>> +static struct samsung_pll_clock dmc_plls[nr_dmc_plls] __initdata = {
> 
>> +};

Best Regards,
Chanwoo Choi

