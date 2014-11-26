Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751120AbaKZJzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 04:55:40 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:13986 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaKZJzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 04:55:35 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-79-5475a39609c1
Message-id: <5475A397.9020004@samsung.com>
Date: Wed, 26 Nov 2014 15:25:35 +0530
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: amit.daniel@samsung.com, b.zolnierkie@samsung.com
Cc: linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk
Subject: Re: [PATCH v4 0/5] exynos: Move pmu driver to driver/soc folder and
 add exynos7 support
References: <E1XtXCn-0007Sm-GE@feisty.vs19.net>
In-reply-to: <E1XtXCn-0007Sm-GE@feisty.vs19.net>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsWyRsSkTnfa4tIQg9N31CwaroZYbJyxntWi
	d8FVNotNj6+xWlzeNYfN4vZlXgc2j5bmHjaPzUvqPfq2rGL0+LxJLoAlissmJTUnsyy1SN8u
	gStj+u8XrAX/TSpW/VnJ1MD4UaOLkZNDQsBEovnbPhYIW0ziwr31bF2MXBxCAksZJfb07mWF
	Kdp1fSUjRGIRo8TPvR9YIJxWJol7Mx4ygVTxCmhJrNl6jxnEZhFQlZg5YyFYN5uArsST93PB
	4qICERJX1sxhhKgXlPgx+R7YahEBU4lva6+B2cwC5RLbz/awgdjCAkkS+3Z/AesVEtCXmLp2
	L1gNp4CBxLNv75kg6m0lFrxfB9UrL7F5zVtmiKu3sUt8usAKcY+AxLfJh4BqOIDishKbDkCV
	SEocXHGDZQKj2CwkF81CMnUWkqkLGJlXMYqmFiQXFCelF5noFSfmFpfmpesl5+duYgRG1+l/
	zybsYLx3wPoQowAHoxIPb4RUaYgQa2JZcWXuIUZToCsmMkuJJucDYzivJN7Q2MzIwtTE1NjI
	3NJMSZz3tdTPYCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MHAfq59vdvH8xerlMsk/qxcV/
	Qw61ZV5dZJoS6V5WbL5k+oke7pkrfCebrFuYe4T92DbmX6kHDy1jEpp4nW3ihuol38Vnzpui
	wF95Zt/iS5dlOEKq23kZf6SHNE9zblXYstSg3mNaq9TKX3/rSt6/2Ts3RtfjwvUXNvqbW4qU
	SpeL3s/yOp11W4mlOCPRUIu5qDgRAOMK8uypAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t9jAd1pi0tDDI70yVk0XA2x2DhjPatF
	74KrbBabHl9jtbi8aw6bxe3LvA5sHi3NPWwem5fUe/RtWcXo8XmTXABLVAOjTUZqYkpqkUJq
	XnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QaiWFssScUqBQQGJxsZK+
	HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxvTfL1gL/ptUrPqzkqmB8aNGFyMnh4SAicSu6ysZ
	IWwxiQv31rN1MXJxCAksYpT4ufcDC4TTyiRxb8ZDJpAqXgEtiTVb7zGD2CwCqhIzZyxkBbHZ
	BHQlnryfCxYXFYiQuLJmDiNEvaDEj8n3WEBsEQFTiW9rr4HZzALlEtvP9rCB2MICSRL7dn8B
	6xUS0JeYunYvWA2ngIHEs2/vmSDqbSUWvF8H1SsvsXnNW+YJjAKzkKyYhaRsFpKyBYzMqxhF
	UwuSC4qT0nON9IoTc4tL89L1kvNzNzGCo/eZ9A7GVQ0WhxgFOBiVeHgjpEpDhFgTy4orcw8x
	SnAwK4nwmtQBhXhTEiurUovy44tKc1KLDzGaAkNgIrOUaHI+MLHklcQbGpuYmxqbWppYmJhZ
	Konz3riZGyIkkJ5YkpqdmlqQWgTTx8TBKdXA2BYUeyKkud9I1ab35GKRRtONNRnhjz4U9y9a
	1h2ovNhpM1Nlk6O1Ukejh+62i+sWzGo/tj/Lss/ywNS1ngpPdiYs2H82KJpV5cAH7c/SbBPW
	Zs6fqy/beG+XfLWVtZb30+X2q93WVrV/27TtxmklD8W3f/n0lz3PzJh6ID91V5Lm+XUvQt5N
	UmIpzkg01GIuKk4EAF7s3Y/0AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2014 13:46:54, Amit Daniel Kachhap wrote:
> On Mon, Nov 24, 2014 at 6:50 PM, Bartlomiej Zolnierkiewicz
> <b.zolnierkie@samsung.com> wrote:
>>
>> Hi,
>>
>> On Monday, November 24, 2014 07:36:10 AM Amit Daniel Kachhap wrote:
>>> This patch series [1 - 5] performs,
>>>
>>> 1) Moves pmu driver to driver/soc/samsung folder. This is needed as exynos7 is
>>>     an arm64 based platform and hence PMU driver should be in driver folder.
>>>     Some discussion happened about this in the v1 version. Finally adding it in
>>>     driver/soc folder as it too SoC specific and not a general driver.
>>>     Entire discussion can be found here (A).
>>> 2) Add exynos7 PMU support.
>>
>> Some months ago (when the work on moving PMU driver out of mach-exynos
>> started) I asked how much code would be shared between arm32 and arm64
>> SoCs.  Now it seems that the code in question is minimal so I still
>> wonder whether it is really worth to have a common driver (please note
>> that in case of arm32 kernel all arm64 PMU code is just a dead code,
>> similarly for arm64 kernel and arm32 PMU code).  Would it be possible
>> to do the analysis of the additional source code needed vs saved code
>> in the resulting binary for the case of having separate drivers?

Hi Bartlomiej,

It is not just matter of sharing code between ARM and ARM64 SoC's also 
we have single binding for PMU in case of both kinds of SoC, so keeping 
same driver makes sense.
Also please note that Amit is working on pm_domain. sleep specific 
functionality by moving them in drivers/soc which relies on PMU driver 
and that would be useful in case of Samsung's ARM SoCs.

So I think it's worth to move this out of mach-exynos. As far as code 
reusability and question of dead code or SoC specific PMU implementation 
is concerned please see my suggestion below:

> yes your suggestion is good. It may done by keeping the data pmu_config[]
> arrays in .h file under CONFIG_ARM(or CONFIG_ARM64) and NULL for non required
> platforms. Keep them in 2 separate files may be confusing.
>
Hi Amit,

I don't think so keeping data such as pmu_config or pmu_extra_config in 
.h file is good idea. I would rather suggest we can separate SoC 
specific data and it's handling in SoC specific PMU files such as 
exynos5250-pmu.c, exynos5420-pmu.c, exynos7-pmu.c etc. and these files 
will be picked up for compilation either based on CONFIG_SOC_EXYNOSNNNN 
macros or ARCH_EXYNOS4/5/7 macros. Thus ARM64 specific PMU files can be 
opted out for compilation in case of ARM32 kernel compilation.
In other thread (Exynos3250 PMU support) Kukjin also pointing out 
something similar if I understood correctly. I am currently looking into 
this approach, once something substantial is ready I will post for review.

>>
>> Could you also please take a look into fixing patch #4 to be compatible
>> with http://lkml.iu.edu/hypermail/linux/kernel/1407.1/00298.html ?
> This patch makes sense. Thanks for pointing out.
>> (It seems that just adding separate struct exynos_pmu_conf_extra for
>> ->pmu_config_extra shold be okay.)
> Yes right struct exynos_pmu_conf_extra should work for exynos7.
>
> I think both of the above optimizations may go as a separate patch.
>

Amit, as far as I can see this series is not getting applied cleanly on 
kgene/for-next, as Kukjin has taken Exynos3250 PMU patches in his tree. 
So may be you need to respin this once more, that time better we can do 
all these changes. I have already suggested Bartlomiej to resend his 
above mentioned change which significantly reducing pmu.o size.

Thanks,
Pankaj Dubey
> Regards,
> Amit D
>>
>> Best regards,
>> --
>> Bartlomiej Zolnierkiewicz
>> Samsung R&D Institute Poland
>> Samsung Electronics
>>
>>> 3) Enables the driver for 32bit arm exynos platforms.
>>>
>>> Changes from V3:
>>> * Fixed Kconfig as per Russell feedback
>>> * Rebased the series against Pankaj SoC restart consolidation patches (D) as per
>>>    Kukjin request.
>>> * Link to V3 can be found here (C)
>>>
>>> Changes from V2:
>>> * Added review comment changes suggested by Pankaj.
>>> * Removed mfd client support in this patch series. This will be added later in
>>>    the power domain patch series.
>>> * Link to V2 can be found here (B)
>>>
>>> Changes from V1:
>>> * Move pmu driver in driver/soc/samsung folder
>>> * Removed the power domain features. They will posted as a separate series.
>>> * Added exynos7 PMU support.
>>> * Link to v1 can be found here (A)
>>>
>>> This complete patch series is rebased on Kukjin for-next tree.
>>>
>>> (A) - http://www.spinics.net/lists/linux-samsung-soc/msg38442.html
>>> (B) - http://www.spinics.net/lists/arm-kernel/msg375910.html
>>> (C) - http://www.spinics.net/lists/linux-samsung-soc/msg39237.html
>>> (D) - http://www.spinics.net/lists/linux-samsung-soc/msg39095.html
>>>
>>> Amit Daniel Kachhap (5):
>>>    ARM: EXYNOS: Move pmu specific header files under "linux/soc/samsung"
>>>    drivers: soc: Add support for Exynos PMU driver
>>>    driver: soc: exynos-pmu: Add an API to be called after wakeup
>>>    drivers: soc: exynos-pmu: Add support for Exynos7
>>>    arm: exynos: Select SOC_SAMSUNG config option
>>>
>>>   .../devicetree/bindings/arm/samsung/pmu.txt        |    1 +
>>>   arch/arm/mach-exynos/Kconfig                       |    1 +
>>>   arch/arm/mach-exynos/Makefile                      |    2 +-
>>>   arch/arm/mach-exynos/exynos.c                      |    2 +-
>>>   arch/arm/mach-exynos/mcpm-exynos.c                 |    2 +-
>>>   arch/arm/mach-exynos/platsmp.c                     |    2 +-
>>>   arch/arm/mach-exynos/pm.c                          |    4 +-
>>>   arch/arm/mach-exynos/suspend.c                     |    4 +-
>>>   drivers/soc/Kconfig                                |    1 +
>>>   drivers/soc/Makefile                               |    1 +
>>>   drivers/soc/samsung/Kconfig                        |   20 +
>>>   drivers/soc/samsung/Makefile                       |    1 +
>>>   .../pmu.c => drivers/soc/samsung/exynos-pmu.c      |  442 +++++++++++++++++++-
>>>   .../linux/soc/samsung}/exynos-pmu.h                |    1 +
>>>   .../linux/soc/samsung/exynos-regs-pmu.h            |  273 ++++++++++++
>>>   15 files changed, 744 insertions(+), 13 deletions(-)
>>>   create mode 100644 drivers/soc/samsung/Kconfig
>>>   create mode 100644 drivers/soc/samsung/Makefile
>>>   rename arch/arm/mach-exynos/pmu.c => drivers/soc/samsung/exynos-pmu.c (64%)
>>>   rename {arch/arm/mach-exynos => include/linux/soc/samsung}/exynos-pmu.h (89%)
>>>   rename arch/arm/mach-exynos/regs-pmu.h => include/linux/soc/samsung/exynos-regs-pmu.h (63%)
>>
>> --
