Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559AbaAJP6O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 10:58:14 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:50063 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaAJP6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 10:58:12 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-77-52d01891dfae
Message-id: <52D0188A.2080709@samsung.com>
Date: Fri, 10 Jan 2014 16:58:02 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, tomasz.figa@gmail.com
Subject: Re: [PATCH 5/8 v3] clk:exynos-5250: Add gate clock for SSS module
References: <1389095509-14357-6-git-send-email-ch.naveen@samsung.com>
 <1389354229-31936-1-git-send-email-ch.naveen@samsung.com>
In-reply-to: <1389354229-31936-1-git-send-email-ch.naveen@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t/xa7oTJS4EGSz7omFx9/lhRouXhzQt
	ul/JWNy/95PJ4vKuOWwWM87vY7JYtO0/s8WqXX8YLc7OOcTkwOmxc9Zddo9tB1Q9+rasYvT4
	vEkugCWKyyYlNSezLLVI3y6BK+PU08eMBbu5Kw42FzYw7ufsYuTgkBAwkTj+t6SLkRPIFJO4
	cG89G4gtJLCUUaL1rVsXIxeQ/ZlRYtmlI8wgCV4BLYmLn2YxgtgsAqoST/fMYwGx2QTUJD43
	PAJrFhWIkPg7bz0jRL2gxI/J98BqRATKJf7dWMMGMpRZYA6jxMMl7WAJYQEviZlb7zFBbGtk
	lLj59wArSIJTwE3i5e8dYJuZBawlVk7axghhy0tsXvOWeQKjwCwkS2YhKZuFpGwBI/MqRtHU
	0uSC4qT0XEO94sTc4tK8dL3k/NxNjJBA/7KDcfExq0OMAhyMSjy8ASIXgoRYE8uKK3MPMUpw
	MCuJ8F4TBArxpiRWVqUW5ccXleakFh9iZOLglGpglLVqzzHUKpSQrEp/9cd706qL33Y/f+f7
	jGVdZppSxO6W/aEhN6UvlG7eVlmR2K6YXpznYTD30dQlH/fP6EmxWT2p65ep40xpVqnq/UE+
	PnNy7DMn5wf5syVW7D1yId+471vTU4YLFiZ1RZai097Jz386QempUYGE+Pcv/9fFPgtWn+FU
	yfpFiaU4I9FQi7moOBEAKT+zVFICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

On 10.01.2014 12:43, Naveen Krishna Chatradhi wrote:
> This patch adds gating clock for SSS(Security SubSystem)
> module on Exynos5250.
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> ---
> Changes since v2:
> This is a new change to support SSS on Exynos5250
>
>   drivers/clk/samsung/clk-exynos5250.c |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/clk/samsung/clk-exynos5250.c b/drivers/clk/samsung/clk-exynos5250.c
> index adf3234..b47bf0a 100644
> --- a/drivers/clk/samsung/clk-exynos5250.c
> +++ b/drivers/clk/samsung/clk-exynos5250.c
> @@ -120,7 +120,7 @@ enum exynos5250_clks {
>   	spi2, i2s1, i2s2, pcm1, pcm2, pwm, spdif, ac97, hsi2c0, hsi2c1, hsi2c2,
>   	hsi2c3, chipid, sysreg, pmu, cmu_top, cmu_core, cmu_mem, tzpc0, tzpc1,
>   	tzpc2, tzpc3, tzpc4, tzpc5, tzpc6, tzpc7, tzpc8, tzpc9, hdmi_cec, mct,
> -	wdt, rtc, tmu, fimd1, mie1, dsim0, dp, mixer, hdmi, g2d,
> +	wdt, rtc, tmu, fimd1, mie1, dsim0, dp, mixer, hdmi, g2d, sss,

Please base changes to Samsung clock drivers on Mike Turquette's 
clk-next [1] or ideally on my samsung-next branch on samsung-clk-tree [2].

By the way, if you assign an ID to a clock, you need to document this in 
respective clock bindings documentation.

[1] - https://git.linaro.org/people/mike.turquette/linux.git
[2] - https://git.kernel.org/cgit/linux/kernel/git/tfiga/samsung-clk.git/

Best regards,
Tomasz
