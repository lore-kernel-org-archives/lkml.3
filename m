Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbaLIGNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 01:13:06 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:19339 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756266AbaLIGND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 01:13:03 -0500
X-AuditID: cbfee68f-f791c6d000004834-20-548692e8841f
Message-id: <548692ED.4080301@samsung.com>
Date: Tue, 09 Dec 2014 11:43:01 +0530
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
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
In-reply-to: <54864C90.9040205@samsung.com>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsWyRsSkSvfFpLYQgxUrtC0er1nMZPF30jF2
	i/fLehgtLu/Xtrj+5Tmrxfwj51gt/kxoZbPY9fc+o8Wk+xNYLG78amO16F1wlc3ibNMbdotN
	j6+xWlzeNYfNYsb5fUBD7vxjs1h6/SKTxanrn9ksDr9pZ7WYMfklm8WqXX8YLV5+PMHiIOax
	Zt4aRo/fvyYxeuycdZfdY/OSeo8rJ5pYPfq2rGL0+LxJLoA9issmJTUnsyy1SN8ugSuj4Z9E
	wT7Zitnbd7E0MD4U72Lk4JAQMJE41eXWxcgJZIpJXLi3nq2LkYtDSGApo0T7n6eMEAkTiU0L
	ZzJCJKYzSnTPWA7ltDJJLFm4mhWkildAS+LY999MIFNZBFQl/q5QBgmzCehKPHk/lxnEFhWI
	kLiyZg4jRLmgxI/J91hAbBEBDYmZf6+AzWQWWMQi8fHDDjaQhLBAmETPtBfsEMv2M0qsnX8F
	bBmngLbE2WPbwKYyC9hKLHi/jgXClpfYvOYtM8TZJzgkjt9QALFZBAQkvk0+xALxsqzEpgNQ
	JZISB1fcYJnAKDYLyU2zkEydhWTqAkbmVYyiqQXJBcVJ6UXGesWJucWleel6yfm5mxiBqeH0
	v2f9OxjvHrA+xCjAwajEw6th2RYixJpYVlyZe4jRFOiKicxSosn5wASUVxJvaGxmZGFqYmps
	ZG5ppiTOu1DqZ7CQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxsQNKh3vFq27ZmnHtELd/Pb6
	t+ceuglrHC1TDg2YfuJpE+PLt71Pj77dM2ni+ydTLsbNLVZnnmjxK1Po4vfPrj+3HXRq9bx1
	4+H+7bPOJafk7vo2+9pWq29fVtSp+/wuvxVuq8apxFPpVPPwfdAfjxXd9q7XnBunKD2pYtN/
	87SHc5PDQyG+B7uUWIozEg21mIuKEwF650sWCAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsVy+t9jQd0Xk9pCDKacU7B4vGYxk8XfScfY
	Ld4v62G0uLxf2+L6l+esFvOPnGO1+DOhlc1i19/7jBaT7k9gsbjxq43VonfBVTaLs01v2C02
	Pb7GanF51xw2ixnn9wENufOPzWLp9YtMFqeuf2azOPymndVixuSXbBardv1htHj58QSLg5jH
	mnlrGD1+/5rE6LFz1l12j81L6j2unGhi9ejbsorR4/MmuQD2qAZGm4zUxJTUIoXUvOT8lMy8
	dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg15QUyhJzSoFCAYnFxUr6dpgmhIa4
	6VrANEbo+oYEwfUYGaCBhDWMGQ3/JAr2yVbM3r6LpYHxoXgXIyeHhICJxKaFMxkhbDGJC/fW
	s3UxcnEICUxnlOiesZwRwmllkliycDUrSBWvgJbEse+/mboYOThYBFQl/q5QBgmzCehKPHk/
	lxnEFhWIkLiyZg4jRLmgxI/J91hAbBEBDYmZf6+AzWQWWMQi8fHDDjaQhLBAmETPtBfsEMv2
	M0qsnX8FbBmngLbE2WPbwKYyC9hKLHi/jgXClpfYvOYt8wRGgVlIlsxCUjYLSdkCRuZVjKKp
	BckFxUnpuYZ6xYm5xaV56XrJ+bmbGMHJ55nUDsaVDRaHGAU4GJV4eDUt20KEWBPLiitzDzFK
	cDArifDerwMK8aYkVlalFuXHF5XmpBYfYjQFBsFEZinR5HxgYswriTc0NjE3NTa1NLEwMbNU
	EudVsgdqEkhPLEnNTk0tSC2C6WPi4JRqYCzKe+hQZ7Iycv3jz1WMSQoFPzsnHD/+6FRzmPzp
	/2YeAq1CyyRtphZeYPjyPm2yxvTVvUqi/zZmsMhydkbFtccWzPvfNTf5B3Px2Yo2Ax/zBfYL
	7F/FMhje2ij/ZuObaMZJbC5uBQzWvIpvbh/Yv6Xvd57yAhu+pqNNFdHqc65+rwjO0Qz5r8RS
	nJFoqMVcVJwIAFT1thFUAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tuesday 09 December 2014 06:42 AM, Chanwoo Choi wrote:
> Hi Pankaj,
>
> On 12/08/2014 08:31 PM, Pankaj Dubey wrote:
>> Hi Chanwoo,
>>
>> On Tuesday 02 December 2014 02:19 PM, Chanwoo Choi wrote:
>>> This patch adds missing divider/gate clocks of CMU_PERIC domain
>>> which includes I2S/PCM/SPDIF/PWM/SLIMBUS IPs. The SPI/I2S may use
>>> external input clock which has 'ioclk_*' prefix.
>>>
>>> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
>>> Cc: Tomasz Figa <tomasz.figa@gmail.com>
>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>> [ideal.song: Change clk flags of to pclk_gpio_* clk, pclk_gpio_* should be always on.]
>>> Signed-off-by: Inha Song <ideal.song@samsung.com>
>>> Acked-by: Inki Dae <inki.dae@samsung.com>
>>> Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
>>> ---
>>>    drivers/clk/samsung/clk-exynos5433.c   | 80 +++++++++++++++++++++++++++++++++-
>>>    include/dt-bindings/clock/exynos5433.h | 34 ++++++++++++++-
>>>    2 files changed, 112 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/clk/samsung/clk-exynos5433.c b/drivers/clk/samsung/clk-exynos5433.c
>>> index 88e8cac..a48b36c 100644
>>> --- a/drivers/clk/samsung/clk-exynos5433.c
>>> +++ b/drivers/clk/samsung/clk-exynos5433.c
>>> @@ -256,6 +256,14 @@ static struct samsung_fixed_rate_clock top_fixed_clks[] __initdata = {
>>>        FRATE(0, "ioclk_audiocdclk0", NULL, CLK_IS_ROOT, 100000000),
>>>        /* Xi2s1SDI input clock for SPDIF */
>>>        FRATE(0, "ioclk_spdif_extclk", NULL, CLK_IS_ROOT, 100000000),
>>> +    /* XspiCLK[4:0] input clock for SPI */
>>> +    FRATE(0, "ioclk_spi4_clk_in", NULL, CLK_IS_ROOT, 50000000),
>>> +    FRATE(0, "ioclk_spi3_clk_in", NULL, CLK_IS_ROOT, 50000000),
>>> +    FRATE(0, "ioclk_spi2_clk_in", NULL, CLK_IS_ROOT, 50000000),
>>> +    FRATE(0, "ioclk_spi1_clk_in", NULL, CLK_IS_ROOT, 50000000),
>>> +    FRATE(0, "ioclk_spi0_clk_in", NULL, CLK_IS_ROOT, 50000000),
>>> +    /* Xi2s1SCLK input clock for I2S1_BCLK */
>>> +    FRATE(0, "ioclk_i2s1_bclk_in", NULL, CLK_IS_ROOT, 12288000),
>>>    };
>>>
>>>    static struct samsung_mux_clock top_mux_clks[] __initdata = {
>>> @@ -760,6 +768,7 @@ CLK_OF_DECLARE(exynos5433_cmu_mif, "samsung,exynos5433-cmu-mif",
>>>     * Register offset definitions for CMU_PERIC
>>>     */
>>>    #define DIV_PERIC            0x0600
>>> +#define DIV_STAT_PERIC            0x0700
>>>    #define ENABLE_ACLK_PERIC        0x0800
>>>    #define ENABLE_PCLK_PERIC0        0x0900
>>>    #define ENABLE_PCLK_PERIC1        0x0904
>>> @@ -770,6 +779,7 @@ CLK_OF_DECLARE(exynos5433_cmu_mif, "samsung,exynos5433-cmu-mif",
>>>
>>>    static unsigned long peric_clk_regs[] __initdata = {
>>>        DIV_PERIC,
>>> +    DIV_STAT_PERIC,
>>
>> IMO, this line should have been added in first place itself when you added peric_clk_regs.
>
> Why? I want to locate it according to address base.

Since DIV_PERIC and DIV_STAT_PERIC both has same address base, why not 
to add DIV_STAT_PERIC at the same place when you added DIV_PERIC?

Anyways, this was just my opinion as I don't see any dependency why we 
should add it here? I left this up to you.

>
>>
>>>        ENABLE_ACLK_PERIC,
>>>        ENABLE_PCLK_PERIC0,
>>>        ENABLE_PCLK_PERIC1,
>>> @@ -779,14 +789,57 @@ static unsigned long peric_clk_regs[] __initdata = {
>>>        ENABLE_IP_PERIC2,
>>>    };
>>>
>>> +static struct samsung_div_clock peric_div_clks[] __initdata = {
>>> +    /* DIV_PERIC */
>>> +    DIV(CLK_DIV_SCLK_SCI, "div_sclk_sci", "fin_pll", DIV_PERIC, 4, 8),
>>
>> As per UM I have DIV_SCLK_SCI has 4 bit wide as [7:4] please cross verify.
>
> You're right. It is my mistake. I'll fix it.
>
> Best Regards,
> Chanwoo Choi
>
Thanks,
Pankaj Dubey
