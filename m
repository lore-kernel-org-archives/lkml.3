Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbaLIGav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 01:30:51 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:34504 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbaLIGat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 01:30:49 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-b3-548697097ebf
Message-id: <54869708.6000303@samsung.com>
Date: Tue, 09 Dec 2014 15:30:32 +0900
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
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Inha Song <ideal.song@samsung.com>
Subject: Re: [PATCH 03/19] clk: samsung: exynos5433: Add clocks for CMU_PERIC
 domain
References: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
 <1417510196-6714-4-git-send-email-cw00.choi@samsung.com>
 <54858C13.8020704@samsung.com> <54864C90.9040205@samsung.com>
 <548692ED.4080301@samsung.com>
In-reply-to: <548692ED.4080301@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsWyRsSkUJdzeluIwd9XchaP1yxmsvg76Ri7
	xftlPYwWl/drW8w/co7V4s+EVjaLXX/vM1pMuj+BxeLGrzZWi94FV9kszja9YbfY9Pgaq8Xl
	XXPYLGac3wfUf+cfm8XS6xeZLE5d/8xmsWjrF3aLw2/aWS1mTH7JZrFq1x9Gi5cfT7A4iHms
	mbeG0eP3r0mMHjtn3WX32Lyk3uPKiSZWj74tqxg9Pm+SC2CP4rJJSc3JLEst0rdL4Mr4vmc2
	c8EFhYrFV06yNjCukupi5OSQEDCReLZrKjOELSZx4d56ti5GLg4hgaWMEkse/GGFKTracZ8F
	IjGdUWLxsjlMEM5rIOfgArB2XgEtiSeLNrKD2CwCqhIHGj+zgNhsQPH9L26wgdiiAmESK6df
	YYGoF5T4MfkemC0ioC3RefkeK8hQZoFFLBIfP+wAaxAGauiZ9oIdYtsDRomDn48CbePg4ATq
	uHw0GMRkFtCTuH9RC6ScWUBeYvOat8wg5RICRzgkZq3eywZxkIDEt8mHWEDqJQRkJTYdgHpZ
	UuLgihssExjFZiE5aRbC1FlIpi5gZF7FKJpakFxQnJReZKJXnJhbXJqXrpecn7uJEZgcTv97
	NmEH470D1ocYBTgYlXh4NSzbQoRYE8uKK3MPMZoCHTGRWUo0OR+YgvJK4g2NzYwsTE1MjY3M
	Lc2UxHlfS/0MFhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cA4+eR93xiuH9nBeXebN2783XtG
	7s5e41CzJ3fv3Qm98SfZxIQrtfOcrPHiRdU8HK5LPD87NPFEnEqo+J1w+NS1hjfCnh37V7Pe
	OjCVOzSlsE7R3iNuXtb+fduuHHrYv+ZbtnrS7jTbGUdaeFfePrx6rpjz/ki+72WsWze1nvx5
	Zleo5vNLuw74KLEUZyQaajEXFScCAOURLBYJAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAKsWRmVeSWpSXmKPExsVy+t9jQV3O6W0hBiseCFs8XrOYyeLvpGPs
	Fu+X9TBaXN6vbTH/yDlWiz8TWtksdv29z2gx6f4EFosbv9pYLXoXXGWzONv0ht1i0+NrrBaX
	d81hs5hxfh9Q/51/bBZLr19ksjh1/TObxaKtX9gtDr9pZ7WYMfklm8WqXX8YLV5+PMHiIOax
	Zt4aRo/fvyYxeuycdZfdY/OSeo8rJ5pYPfq2rGL0+LxJLoA9qoHRJiM1MSW1SCE1Lzk/JTMv
	3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoNSWFssScUqBQQGJxsZK+HaYJoSFu
	uhYwjRG6viFBcD1GBmggYQ1jxvc9s5kLLihULL5ykrWBcZVUFyMnh4SAicTRjvssELaYxIV7
	69m6GLk4hASmM0osXjaHCcJ5DeQcXMAMUsUroCXxZNFGdhCbRUBV4kDjZ7BuNqD4/hc32EBs
	UYEwiZXTr7BA1AtK/Jh8D8wWEdCW6Lx8jxVkKLPAIhaJjx92gDUIAzX0THvBDrHtAaPEwc9H
	gbZxcHACdVw+GgxiMgvoSdy/qAVSziwgL7F5zVvmCYwCs5CsmIVQNQtJ1QJG5lWMoqkFyQXF
	Sem5hnrFibnFpXnpesn5uZsYwannmdQOxpUNFocYBTgYlXh4NS3bQoRYE8uKK3MPMUpwMCuJ
	8N6vAwrxpiRWVqUW5ccXleakFh9iNAUGwERmKdHkfGBazCuJNzQ2MTOyNDI3tDAyNlcS51Wy
	B2oSSE8sSc1OTS1ILYLpY+LglGpgdE87o6w5M9fzoHVG+s0Lsjd5m3X0bv9l9Jxc57+VpbRJ
	cVH3w4TOdH6f/AL9H2ni7tdeT3FfsK3y484Npw4x3LuaXXL6xcTko7euvsh9onwx5fS39t1b
	+aPD4l9JHD27wH12caf1Za1fJi7phzb1ztSr8mP4IqXAnBLoynTqcL165uFAk/uOSizFGYmG
	WsxFxYkAWJCNGlMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2014 03:13 PM, Pankaj Dubey wrote:
> 
> 
> On Tuesday 09 December 2014 06:42 AM, Chanwoo Choi wrote:
>> Hi Pankaj,
>>
>> On 12/08/2014 08:31 PM, Pankaj Dubey wrote:
>>> Hi Chanwoo,
>>>
>>> On Tuesday 02 December 2014 02:19 PM, Chanwoo Choi wrote:
>>>> This patch adds missing divider/gate clocks of CMU_PERIC domain
>>>> which includes I2S/PCM/SPDIF/PWM/SLIMBUS IPs. The SPI/I2S may use
>>>> external input clock which has 'ioclk_*' prefix.
>>>>
>>>> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
>>>> Cc: Tomasz Figa <tomasz.figa@gmail.com>
>>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>>> [ideal.song: Change clk flags of to pclk_gpio_* clk, pclk_gpio_* should be always on.]
>>>> Signed-off-by: Inha Song <ideal.song@samsung.com>
>>>> Acked-by: Inki Dae <inki.dae@samsung.com>
>>>> Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
>>>> ---
>>>>    drivers/clk/samsung/clk-exynos5433.c   | 80 +++++++++++++++++++++++++++++++++-
>>>>    include/dt-bindings/clock/exynos5433.h | 34 ++++++++++++++-
>>>>    2 files changed, 112 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/clk/samsung/clk-exynos5433.c b/drivers/clk/samsung/clk-exynos5433.c
>>>> index 88e8cac..a48b36c 100644
>>>> --- a/drivers/clk/samsung/clk-exynos5433.c
>>>> +++ b/drivers/clk/samsung/clk-exynos5433.c
>>>> @@ -256,6 +256,14 @@ static struct samsung_fixed_rate_clock top_fixed_clks[] __initdata = {
>>>>        FRATE(0, "ioclk_audiocdclk0", NULL, CLK_IS_ROOT, 100000000),
>>>>        /* Xi2s1SDI input clock for SPDIF */
>>>>        FRATE(0, "ioclk_spdif_extclk", NULL, CLK_IS_ROOT, 100000000),
>>>> +    /* XspiCLK[4:0] input clock for SPI */
>>>> +    FRATE(0, "ioclk_spi4_clk_in", NULL, CLK_IS_ROOT, 50000000),
>>>> +    FRATE(0, "ioclk_spi3_clk_in", NULL, CLK_IS_ROOT, 50000000),
>>>> +    FRATE(0, "ioclk_spi2_clk_in", NULL, CLK_IS_ROOT, 50000000),
>>>> +    FRATE(0, "ioclk_spi1_clk_in", NULL, CLK_IS_ROOT, 50000000),
>>>> +    FRATE(0, "ioclk_spi0_clk_in", NULL, CLK_IS_ROOT, 50000000),
>>>> +    /* Xi2s1SCLK input clock for I2S1_BCLK */
>>>> +    FRATE(0, "ioclk_i2s1_bclk_in", NULL, CLK_IS_ROOT, 12288000),
>>>>    };
>>>>
>>>>    static struct samsung_mux_clock top_mux_clks[] __initdata = {
>>>> @@ -760,6 +768,7 @@ CLK_OF_DECLARE(exynos5433_cmu_mif, "samsung,exynos5433-cmu-mif",
>>>>     * Register offset definitions for CMU_PERIC
>>>>     */
>>>>    #define DIV_PERIC            0x0600
>>>> +#define DIV_STAT_PERIC            0x0700
>>>>    #define ENABLE_ACLK_PERIC        0x0800
>>>>    #define ENABLE_PCLK_PERIC0        0x0900
>>>>    #define ENABLE_PCLK_PERIC1        0x0904
>>>> @@ -770,6 +779,7 @@ CLK_OF_DECLARE(exynos5433_cmu_mif, "samsung,exynos5433-cmu-mif",
>>>>
>>>>    static unsigned long peric_clk_regs[] __initdata = {
>>>>        DIV_PERIC,
>>>> +    DIV_STAT_PERIC,
>>>
>>> IMO, this line should have been added in first place itself when you added peric_clk_regs.
>>
>> Why? I want to locate it according to address base.
> 
> Since DIV_PERIC and DIV_STAT_PERIC both has same address base, why not to add DIV_STAT_PERIC at the same place when you added DIV_PERIC?

I mean the register offset instead of address base.
DIV_PERIC(0x0600) is less than DIV_STAT_PERIC(0x0700).
So, I want to locate DIV_STAT_PERIC on behind DIV_PERIC in ascending order.

But, It is just minor issue.

Best Regards,
Chanwoo Choi

> 
> Anyways, this was just my opinion as I don't see any dependency why we should add it here? I left this up to you.
> 
>>
>>>
>>>>        ENABLE_ACLK_PERIC,
>>>>        ENABLE_PCLK_PERIC0,
>>>>        ENABLE_PCLK_PERIC1,
>>>> @@ -779,14 +789,57 @@ static unsigned long peric_clk_regs[] __initdata = {
>>>>        ENABLE_IP_PERIC2,
>>>>    };
>>>>
>>>> +static struct samsung_div_clock peric_div_clks[] __initdata = {
>>>> +    /* DIV_PERIC */
>>>> +    DIV(CLK_DIV_SCLK_SCI, "div_sclk_sci", "fin_pll", DIV_PERIC, 4, 8),
>>>
>>> As per UM I have DIV_SCLK_SCI has 4 bit wide as [7:4] please cross verify.
>>
>> You're right. It is my mistake. I'll fix it.
>>
>> Best Regards,
>> Chanwoo Choi
>>
> Thanks,
> Pankaj Dubey
> 

