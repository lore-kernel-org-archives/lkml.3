Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbaAOJGD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 04:06:03 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:36638 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaAOJFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 04:05:53 -0500
MIME-Version: 1.0
In-Reply-To: <52D0188A.2080709@samsung.com>
References: <1389095509-14357-6-git-send-email-ch.naveen@samsung.com>
 <1389354229-31936-1-git-send-email-ch.naveen@samsung.com> <52D0188A.2080709@samsung.com>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Wed, 15 Jan 2014 14:35:32 +0530
Message-ID: <CAHfPSqC9CjNre9Tj_QZsUNH5BKYvC7FB0do=-YfgLZrKUg0z+w@mail.gmail.com>
Subject: Re: [PATCH 5/8 v3] clk:exynos-5250: Add gate clock for SSS module
To: Tomasz Figa <t.figa@samsung.com>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-crypto@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Vladimir Zapolskiy <vzapolskiy@gmail.com>, herbert@gondor.apana.org.au,
        cpgs@samsung.com, tomasz.figa@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tomasz,

On 10 January 2014 21:28, Tomasz Figa <t.figa@samsung.com> wrote:
> Hi Naveen,
>
>
> On 10.01.2014 12:43, Naveen Krishna Chatradhi wrote:
>>
>> This patch adds gating clock for SSS(Security SubSystem)
>> module on Exynos5250.
>>
>> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>> ---
>> Changes since v2:
>> This is a new change to support SSS on Exynos5250
>>
>>   drivers/clk/samsung/clk-exynos5250.c |    3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/clk/samsung/clk-exynos5250.c
>> b/drivers/clk/samsung/clk-exynos5250.c
>> index adf3234..b47bf0a 100644
>> --- a/drivers/clk/samsung/clk-exynos5250.c
>> +++ b/drivers/clk/samsung/clk-exynos5250.c
>> @@ -120,7 +120,7 @@ enum exynos5250_clks {
>>         spi2, i2s1, i2s2, pcm1, pcm2, pwm, spdif, ac97, hsi2c0, hsi2c1,
>> hsi2c2,
>>         hsi2c3, chipid, sysreg, pmu, cmu_top, cmu_core, cmu_mem, tzpc0,
>> tzpc1,
>>         tzpc2, tzpc3, tzpc4, tzpc5, tzpc6, tzpc7, tzpc8, tzpc9, hdmi_cec,
>> mct,
>> -       wdt, rtc, tmu, fimd1, mie1, dsim0, dp, mixer, hdmi, g2d,
>> +       wdt, rtc, tmu, fimd1, mie1, dsim0, dp, mixer, hdmi, g2d, sss,
>
>
> Please base changes to Samsung clock drivers on Mike Turquette's clk-next
> [1] or ideally on my samsung-next branch on samsung-clk-tree [2].
>
> By the way, if you assign an ID to a clock, you need to document this in
> respective clock bindings documentation.
>
> [1] - https://git.linaro.org/people/mike.turquette/linux.git
> [2] - https://git.kernel.org/cgit/linux/kernel/git/tfiga/samsung-clk.git/
Sure Tomasz, Will rebase this changes on to your samsung-clk.git tree
>
> Best regards,
> Tomasz



-- 
Shine bright,
(: Nav :)
