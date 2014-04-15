Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482AbaDOIj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:39:28 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:60958 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaDOIjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:39:25 -0400
MIME-Version: 1.0
In-Reply-To: <534CEEA8.6020800@samsung.com>
References: <1397527192-21988-1-git-send-email-cw00.choi@samsung.com>
	<1397527192-21988-4-git-send-email-cw00.choi@samsung.com>
	<4788081.xvaJfdGTMu@wuerfel>
	<534CEEA8.6020800@samsung.com>
Date: Tue, 15 Apr 2014 14:09:24 +0530
Message-ID: <CAGm_ybhGBVmUu9PgppgWfH8b8=3JVhqK0v=ZR_yE8Cs42+VUOg@mail.gmail.com>
Subject: Re: [PATCHv2 3/8] ARM: EXYNOS: Add IO mapping for PMU of Exynos3250
From: Vikas Sajjan <sajjan.linux@gmail.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, ben-linux@fluff.org,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, sw0312.kim@samsung.com,
        hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, Olof Johansson <olof@lixom.net>,
        marc.zyngier@arm.com,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Apr 15, 2014 at 2:02 PM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> Hi,
>
> On 04/15/2014 05:11 PM, Arnd Bergmann wrote:
>> On Tuesday 15 April 2014 10:59:47 Chanwoo Choi wrote:
>>> This patch add memory mapping for PMU (Power Management Unit) which is used
>>> for power control of Exynos3250.
>>>
>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>> ---
>>> Arnd Bergmann suggested that need proper driver instead of static memory mapping.
>>> As Chanho Park reply[2], Sachin Kamat already posted the DT support patch[1]
>>> for memory mapping for SYSRAM.
>>> [1] http://www.spinics.net/lists/linux-samsung-soc/msg27647.html
>>> [2] https://lkml.org/lkml/2014/4/10/161
>>>
>>> So, I'm going to re-implement following patch related to static memory mapping
>>> after merged Sachin Kamat patch[1].
>>>   ARM: EXYNOS: Add IO mapping for PMU of Exynos3250
>>
>> I don't think we have a patch for the PMU yet, Sachin was looking at the SYSRAM
>> only.
>
> You are right. Sachin's patch only included the solution of SYSRAM memory mapping.
> I set out the plan that I would implment proper driver for PMU memory mapping
> instead of static method after merged Sachin's patch for SYSRAM.
>
> But,
> If you'd like me to implment PMU memory mapping instead of static mapping right now,
> I'll implement it for PMU such as Sachin's patch on next posting(v3).
>

I have already posted patch[1] for mapping PMU through DT as part of
my PMU series for exynos5260.
You can rebase on the same.


[1] http://www.spinics.net/lists/arm-kernel/msg316013.html


> Thanks for your review.
>
> Best Regards,
> Chanwoo Choi
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
