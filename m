Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321AbaLIBMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 20:12:54 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:60644 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaLIBMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 20:12:51 -0500
X-AuditID: cbfee68e-f79b46d000002b74-c3-54864c910554
Message-id: <54864C90.9040205@samsung.com>
Date: Tue, 09 Dec 2014 10:12:48 +0900
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
 <54858C13.8020704@samsung.com>
In-reply-to: <54858C13.8020704@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsWyRsSkUHeiT1uIwYaFMhaP1yxmsvg76Ri7
	xftlPYwWl/drW8w/co7V4s+EVjaLXX/vM1pMuj+BxeLGrzZWi94FV9kszja9YbfY9Pgaq8Xl
	XXPYLGac3wfUf+cfm8XS6xeZLE5d/8xmsWjrF3aLw2/aWS1mTH7JZrFq1x9Gi5cfT7A4iHms
	mbeG0eP3r0mMHjtn3WX32Lyk3uPKiSZWj74tqxg9Pm+SC2CP4rJJSc3JLEst0rdL4MrYt+EL
	U8E/yYojL4+wNjC2iHYxcnJICJhIvN23kQnCFpO4cG89G4gtJLCUUWJGvwVMzdH/fxi7GLmA
	4osYJVo+dLBAOK8ZJT5NbALr4BXQkjjS0ckIYrMIqEosnXACzGYDiu9/cQOsRlQgTGLl9Css
	EPWCEj8m3wOzRQS0JTov32MFGcossIhF4uOHHWANwkANPdNesENsW8AocWNRP5DDwcEJ1PHu
	VTKIySygJ3H/ohZIObOAvMTmNW+ZQcolBI5wSCx4t40N4iABiW+TD7GA1EsIyEpsOsAM8Zmk
	xMEVN1gmMIrNQnLSLISps5BMXcDIvIpRNLUguaA4Kb3ISK84Mbe4NC9dLzk/dxMjMDWc/ves
	bwfjzQPWhxgFOBiVeHg1LdtChFgTy4orcw8xmgIdMZFZSjQ5H5iA8kriDY3NjCxMTUyNjcwt
	zZTEeROkfgYLCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYFSc+GJ598tn/k7pl656b17vv+3N
	dcarnfnvI289Oy2wx8tH8ZG8lEjEhg7F6DV7921jO7b/WzVzx7nF65+ZfeE1vnB8Hscr4Q/L
	NFfXtaRteaf/+nf5KQeBi8tWfXL6L54nzOcif/dedncF/7mD/rZPiyUYXjQcvNVpenlx4qLu
	naGqr00t4o8psRRnJBpqMRcVJwIAeUkaRAgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAKsWRmVeSWpSXmKPExsVy+t9jAd2JPm0hBq9f81k8XrOYyeLvpGPs
	Fu+X9TBaXN6vbTH/yDlWiz8TWtksdv29z2gx6f4EFosbv9pYLXoXXGWzONv0ht1i0+NrrBaX
	d81hs5hxfh9Q/51/bBZLr19ksjh1/TObxaKtX9gtDr9pZ7WYMfklm8WqXX8YLV5+PMHiIOax
	Zt4aRo/fvyYxeuycdZfdY/OSeo8rJ5pYPfq2rGL0+LxJLoA9qoHRJiM1MSW1SCE1Lzk/JTMv
	3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoNSWFssScUqBQQGJxsZK+HaYJoSFu
	uhYwjRG6viFBcD1GBmggYQ1jxr4NX5gK/klWHHl5hLWBsUW0i5GTQ0LAROLo/z+MELaYxIV7
	69m6GLk4hAQWMUq0fOhggXBeM0p8mtjEBlLFK6AlcaSjE6yDRUBVYumEE2A2G1B8/4sbYDWi
	AmESK6dfYYGoF5T4MfkemC0ioC3RefkeK8hQZoFFLBIfP+wAaxAGauiZ9oIdYtsCRokbi/qB
	HA4OTqCOd6+SQUxmAT2J+xe1QMqZBeQlNq95yzyBUWAWkhWzEKpmIalawMi8ilE0tSC5oDgp
	PddQrzgxt7g0L10vOT93EyM49TyT2sG4ssHiEKMAB6MSD6+mZVuIEGtiWXFl7iFGCQ5mJRHe
	5TtbQ4R4UxIrq1KL8uOLSnNSiw8xmgIDYCKzlGhyPjAt5pXEGxqbmBlZGpkbWhgZmyuJ8yrZ
	A80RSE8sSc1OTS1ILYLpY+LglGpgbNhxfKbCsr9hCW0TVbceaBbWcpCZf3fC0lXMR3jMi9mu
	Tb3V0HDsz6FPCu+eSOuZKF6Ydfdxe7EVv0Bh6srEbd070x6xyG94+fjXl28Ot4OihBiVDgne
	9zq+WW2SvxyLqufv/HubkgSZcickLu99G8sZZcCxeT739B8zvauXfxWbeVQlKsqKTYmlOCPR
	UIu5qDgRAOvHyAZTAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

On 12/08/2014 08:31 PM, Pankaj Dubey wrote:
> Hi Chanwoo,
> 
> On Tuesday 02 December 2014 02:19 PM, Chanwoo Choi wrote:
>> This patch adds missing divider/gate clocks of CMU_PERIC domain
>> which includes I2S/PCM/SPDIF/PWM/SLIMBUS IPs. The SPI/I2S may use
>> external input clock which has 'ioclk_*' prefix.
>>
>> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Cc: Tomasz Figa <tomasz.figa@gmail.com>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> [ideal.song: Change clk flags of to pclk_gpio_* clk, pclk_gpio_* should be always on.]
>> Signed-off-by: Inha Song <ideal.song@samsung.com>
>> Acked-by: Inki Dae <inki.dae@samsung.com>
>> Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
>> ---
>>   drivers/clk/samsung/clk-exynos5433.c   | 80 +++++++++++++++++++++++++++++++++-
>>   include/dt-bindings/clock/exynos5433.h | 34 ++++++++++++++-
>>   2 files changed, 112 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/clk/samsung/clk-exynos5433.c b/drivers/clk/samsung/clk-exynos5433.c
>> index 88e8cac..a48b36c 100644
>> --- a/drivers/clk/samsung/clk-exynos5433.c
>> +++ b/drivers/clk/samsung/clk-exynos5433.c
>> @@ -256,6 +256,14 @@ static struct samsung_fixed_rate_clock top_fixed_clks[] __initdata = {
>>       FRATE(0, "ioclk_audiocdclk0", NULL, CLK_IS_ROOT, 100000000),
>>       /* Xi2s1SDI input clock for SPDIF */
>>       FRATE(0, "ioclk_spdif_extclk", NULL, CLK_IS_ROOT, 100000000),
>> +    /* XspiCLK[4:0] input clock for SPI */
>> +    FRATE(0, "ioclk_spi4_clk_in", NULL, CLK_IS_ROOT, 50000000),
>> +    FRATE(0, "ioclk_spi3_clk_in", NULL, CLK_IS_ROOT, 50000000),
>> +    FRATE(0, "ioclk_spi2_clk_in", NULL, CLK_IS_ROOT, 50000000),
>> +    FRATE(0, "ioclk_spi1_clk_in", NULL, CLK_IS_ROOT, 50000000),
>> +    FRATE(0, "ioclk_spi0_clk_in", NULL, CLK_IS_ROOT, 50000000),
>> +    /* Xi2s1SCLK input clock for I2S1_BCLK */
>> +    FRATE(0, "ioclk_i2s1_bclk_in", NULL, CLK_IS_ROOT, 12288000),
>>   };
>>
>>   static struct samsung_mux_clock top_mux_clks[] __initdata = {
>> @@ -760,6 +768,7 @@ CLK_OF_DECLARE(exynos5433_cmu_mif, "samsung,exynos5433-cmu-mif",
>>    * Register offset definitions for CMU_PERIC
>>    */
>>   #define DIV_PERIC            0x0600
>> +#define DIV_STAT_PERIC            0x0700
>>   #define ENABLE_ACLK_PERIC        0x0800
>>   #define ENABLE_PCLK_PERIC0        0x0900
>>   #define ENABLE_PCLK_PERIC1        0x0904
>> @@ -770,6 +779,7 @@ CLK_OF_DECLARE(exynos5433_cmu_mif, "samsung,exynos5433-cmu-mif",
>>
>>   static unsigned long peric_clk_regs[] __initdata = {
>>       DIV_PERIC,
>> +    DIV_STAT_PERIC,
> 
> IMO, this line should have been added in first place itself when you added peric_clk_regs.

Why? I want to locate it according to address base.

> 
>>       ENABLE_ACLK_PERIC,
>>       ENABLE_PCLK_PERIC0,
>>       ENABLE_PCLK_PERIC1,
>> @@ -779,14 +789,57 @@ static unsigned long peric_clk_regs[] __initdata = {
>>       ENABLE_IP_PERIC2,
>>   };
>>
>> +static struct samsung_div_clock peric_div_clks[] __initdata = {
>> +    /* DIV_PERIC */
>> +    DIV(CLK_DIV_SCLK_SCI, "div_sclk_sci", "fin_pll", DIV_PERIC, 4, 8),
> 
> As per UM I have DIV_SCLK_SCI has 4 bit wide as [7:4] please cross verify.

You're right. It is my mistake. I'll fix it.

Best Regards,
Chanwoo Choi
