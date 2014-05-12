Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbaELCD4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:03:56 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:28575 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbaELCDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 22:03:51 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-de-53702c045669
Message-id: <53703053.2090404@samsung.com>
Date: Mon, 12 May 2014 11:22:11 +0900
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-version: 1.0
To: Olof Johansson <olof@lixom.net>
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Thomas Abraham <thomas.abraham@linaro.org>
Subject: Re: [PATCH v3 3/6] ARM: EXYNOS: Remove soc_is_exynos4/5 from exynos.c
References: <1399706287-13919-1-git-send-email-y@samsung.com>
 <1399706287-13919-4-git-send-email-y@samsung.com>
 <CAOesGMgfHLKLG=O=4kxtpFcMn-U3zmCuYRXdUyB8Xq6FALqc8Q@mail.gmail.com>
In-reply-to: <CAOesGMgfHLKLG=O=4kxtpFcMn-U3zmCuYRXdUyB8Xq6FALqc8Q@mail.gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zI10WnYJggzeLzS3+TjrGbtG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3ktTl3/zGaxaOsXdov1M16zWBybsYTRgcujpbmHzeP3r0mM
	Hneu7WHz2Lyk3uPKiSZWj74tqxg9Pm+SC2CP4rJJSc3JLEst0rdL4Mp4dOIJU8FKuYrTk18w
	NjD2incxcnJICJhIrLm2mAnCFpO4cG89WxcjF4eQwDJGiQ37zjHCFL1cf4sdIrGIUaLpQQcT
	hPOaUWLr13fMIFW8AloSu//eBRvFIqAqMX3NZ7BuNgFdiSfv54LViAqESWya3scKUS8o8WPy
	PRYQW0RAWeJJ2yVmkKHMAseYJSb/PAg2SFjAT+LXhY+MENt2MEpcWv8CrJtTIFji16VJYDaz
	gJnEo5Z1zBC2vMTmNW/BJkkIfGWX2LZ5AzPESQIS3yYfAlrHAZSQldh0gBniN0mJgytusExg
	FJuF5KhZSMbOQjJ2ASPzKkbR1ILkguKk9CITveLE3OLSvHS95PzcTYyQWJ2wg/HeAetDjMlA
	KycyS4km5wNjPa8k3tDYzMjC1MTU2Mjc0ow0YSVxXrVHSUFCAumJJanZqakFqUXxRaU5qcWH
	GJk4OKUaGNVrn84+Pm3+1hvZLiXXhLc7PX0al7zuQuvxPL+ultXGIT0iZ/QnzT+zsWHjC3Xv
	SYdZawLPfdH40XBmwjYTFo6IqmU3Q9iMk3YbhrRedtD33pAle0i7jaPmi2ZMwrNdjR+/v7e0
	6U8u9FqgVcHky3HU1UPp3+uwV3HBRcbnrVprNvJrrghkU2Ipzkg01GIuKk4EAKVixTHrAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jAV0WnYJggxkdRhZ/Jx1jt+hdcJXN
	YtPja6wWl3fNYbOYcX4fk8Xty7wWp65/ZrNYtPULu8X6Ga9ZLI7NWMLowOXR0tzD5vH71yRG
	jzvX9rB5bF5S73HlRBOrR9+WVYwenzfJBbBHNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5ua
	GRjqGlpamCsp5CXmptoqufgE6Lpl5gCdp6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQI
	rsfIAA0krGPMeHTiCVPBSrmK05NfMDYw9op3MXJySAiYSLxcf4sdwhaTuHBvPVsXIxeHkMAi
	RommBx1MEM5rRomtX98xg1TxCmhJ7P57lwnEZhFQlZi+5jMjiM0moCvx5P1csBpRgTCJTdP7
	WCHqBSV+TL7HAmKLCChLPGm7xAwylFngGLPE5J8HwQYJC/hJ/LrwkRFi2w5GiUvrX4B1cwoE
	S/y6NAnMZhYwk3jUso4ZwpaX2LzmLfMERoFZSJbMQlI2C0nZAkbmVYyiqQXJBcVJ6bmGesWJ
	ucWleel6yfm5mxjBieCZ1A7GlQ0WhxgFOBiVeHg/MBQEC7EmlhVX5h5ilOBgVhLhncwCFOJN
	SaysSi3Kjy8qzUktPsSYDAyDicxSosn5wCSVVxJvaGxiZmRpZGZhZGJuTpqwkjjvgVbrQCGB
	9MSS1OzU1ILUIpgtTBycUg2MrdO//50YbsQfvTT4ktti76aH8gu/7gyW8ahYtVRrSUyR6+/v
	AbafKi5zPT7+SN7tHYO044dUPua2jdd+vLX9FD09Nbh844TTMj5xXp7shj8OPpm29tS6MBmb
	959EImw/Fa2/kbD7Xf20pGT291dM4yc+bGB5IxwiHl7YxZ34nD3f6HU957f3SizFGYmGWsxF
	xYkA9km9S0gDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2014 03:52 PM, Olof Johansson wrote:
> On Sat, May 10, 2014 at 12:18 AM,  <y@samsung.com> wrote:
>> From: Pankaj Dubey <pankaj.dubey@samsung.com>
>>
>> This patch removes usage of soc_is_exynos4/5 from exynos.c.
>> For this we need to separate machine descriptors for exynos4
>> and exynos5. While doing this patch does some consolidation also.
>>
>> CC: Russell King <linux@arm.linux.org.uk>
>> CC: Thomas Abraham <thomas.abraham@linaro.org>
>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>> ---
>>   arch/arm/mach-exynos/exynos.c            |   52 +++++++++++++++++++-----------
>>   arch/arm/plat-samsung/include/plat/cpu.h |    3 --
>>   2 files changed, 33 insertions(+), 22 deletions(-)
>>
>> diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
>> index 09063ee..9902e52 100644
>> --- a/arch/arm/mach-exynos/exynos.c
>> +++ b/arch/arm/mach-exynos/exynos.c
>> @@ -202,20 +202,6 @@ static const struct of_device_id exynos_dt_pmu_match[] = {
>>          {},
>>   };
>>
>> -/*
>> - * exynos_map_io
>> - *
>> - * register the standard cpu IO areas
>> - */
>> -static void __init exynos_map_io(void)
>> -{
>> -       if (soc_is_exynos4())
>> -               iotable_init(exynos4_iodesc, ARRAY_SIZE(exynos4_iodesc));
>> -
>> -       if (soc_is_exynos5())
>> -               iotable_init(exynos5_iodesc, ARRAY_SIZE(exynos5_iodesc));
>> -}
>> -
>>   static void __init exynos_init_io(void)
>>   {
>>          debug_ll_io_init();
>> @@ -224,8 +210,18 @@ static void __init exynos_init_io(void)
>>
>>          /* detect cpu id and rev. */
>>          s5p_init_cpu(S5P_VA_CHIPID);
>> +}
>> +
>> +static void __init exynos5_init_io(void)
>> +{
>> +       exynos_init_io();
>> +       iotable_init(exynos5_iodesc, ARRAY_SIZE(exynos5_iodesc));
>> +}
>>
>> -       exynos_map_io();
>> +static void __init exynos4_init_io(void)
>> +{
>> +       exynos_init_io();
>> +       iotable_init(exynos4_iodesc, ARRAY_SIZE(exynos4_iodesc));
>>   }
>>
>>   struct bus_type exynos_subsys = {
>> @@ -293,11 +289,15 @@ static void __init exynos_dt_machine_init(void)
>>          of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
>>   }
>>
>> -static char const *exynos_dt_compat[] __initconst = {
>> +static char const *exynos4_dt_compat[] __initconst = {
>>          "samsung,exynos4",
>>          "samsung,exynos4210",
>>          "samsung,exynos4212",
>>          "samsung,exynos4412",
>> +       NULL
>> +};
>> +
>> +static char const *exynos5_dt_compat[] __initconst = {
>>          "samsung,exynos5",
>>          "samsung,exynos5250",
>>          "samsung,exynos5420",
>> @@ -321,15 +321,29 @@ static void __init exynos_reserve(void)
>>   #endif
>>   }
>>
>> -DT_MACHINE_START(EXYNOS_DT, "SAMSUNG EXYNOS (Flattened Device Tree)")
>> +DT_MACHINE_START(EXYNOS5_DT, "SAMSUNG EXYNOS (Flattened Device Tree)")
> SAMSUNG EXYNOS5
>
>> +       /* Maintainer: Thomas Abraham <thomas.abraham@linaro.org> */
>> +       /* Maintainer: Kukjin Kim <kgene.kim@samsung.com> */
>> +       .smp            = smp_ops(exynos_smp_ops),
>> +       .map_io         = exynos5_init_io,
>> +       .init_early     = exynos_firmware_init,
>> +       .init_machine   = exynos_dt_machine_init,
>> +       .init_late      = exynos_init_late,
>> +       .dt_compat      = exynos5_dt_compat,
>> +       .restart        = exynos_restart,
>> +       .reserve        = exynos_reserve,
>> +MACHINE_END
>> +
>> +
>> +DT_MACHINE_START(EXYNOS4_DT, "SAMSUNG EXYNOS (Flattened Device Tree)")
> SAMSUNG EXYNOS4
>
> ... so you can tell the difference if you for some reason probed with
> the wrong one.
>
> Also, you should order these with 4 before 5.
>

Thanks for review. I will take care of this in next revision.

> -Olof
>


-- 
Best Regards,
Pankaj Dubey

