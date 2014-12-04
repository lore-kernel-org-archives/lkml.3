Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbaLDDdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 22:33:00 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:25279 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaLDDc6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 22:32:58 -0500
X-AuditID: cbfee68d-f79296d000004278-27-547fd5d72dba
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 8BIT
Message-id: <547FD5C6.3030308@samsung.com>
Date: Thu, 04 Dec 2014 09:02:22 +0530
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
To: jonghwa3.lee@samsung.com
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        amit.daniel@samsung.com, kgene.kim@samsung.com, arnd@arndb.de,
        thomas.ab@samsung.com
Subject: Re: [PATCH] soc: samsung: pmu: split up SoC specific PMU data
References: <1417364162-29981-1-git-send-email-pankaj.dubey@samsung.com>
 <547EA0DC.70800@samsung.com>
In-reply-to: <547EA0DC.70800@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsWyRsSkRvf61foQg66VUhYNV0Ms/k46xm6x
	ccZ6VovOs0+YLXoXXGWz2PT4GqvF5V1z2CxmnN/HZNGxjNGB0+P3r0mMHpuX1Hv0bVnF6PF5
	k1wASxSXTUpqTmZZapG+XQJXxuZjh5kKbspW7O2cwNTAuFKii5GDQ0LARGJ9i10XIyeQKSZx
	4d56ti5GLg4hgaWMEms3N7BAJEwkrk3YwgyRmM4ocefpPHaQBK+AoMSPyffAipgFzCS+vDzM
	CmGLSKyd9ocRwtaWWLbwNVRzK5PEvhW9jBDNWhL3V0EUsQioSpx50c8MYrMJ6Eo8eT8XzBYV
	iJC4smYOWI2IgIzEyqs/mUAGMQvcZ5S40D0brEhYwE1i1u5/YBcJCaRL/Lt2mwnE5hTQlFh1
	uZsdpEFC4BK7xIIlTWwQ2wQkvk0+xALxv6zEpgPMEG9KShxccYNlAqP4LCTPzULy3Cwkz81C
	8twCRpZVjKKpBckFxUnpRYZ6xYm5xaV56XrJ+bmbGIHRevrfs94djLcPWB9iFOBgVOLhLdhd
	HyLEmlhWXJl7iNEU6KKJzFKiyfnAlJBXEm9obGZkYWpiamxkbmmmJM6rKPUzGOixxJLU7NTU
	gtSi+KLSnNTiQ4xMHJxSDYzdW9SnWFw4muvIoJ2Zb1VUFRb+7d2O/Mkb305dKZzJ8cvr6Ixo
	6aUb7y56JWTAul3a4triP3PuSfkIllb5cM1W3uI24Txr4tRmy/jvNgenWq/xkCufk9P44rl4
	yMm+ZKPQmWsuVkWoM/hbit8wTTQ17+T/rqikyFg75xIDf+riGI/yr58vPVJiKc5INNRiLipO
	BAAB8qhq0QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsVy+t9jQd3rV+tDDC7tELBouBpi8XfSMXaL
	jTPWs1p0nn3CbNG74CqbxabH11gtLu+aw2Yx4/w+JouOZYwOnB6/f01i9Ni8pN6jb8sqRo/P
	m+QCWKIaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJz
	gC5RUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGZMvHmYueC4bMWD85OZ
	GxinS3QxcnJICJhIXJuwhRnCFpO4cG89WxcjF4eQwHRGiTtP57GDJHgFBCV+TL7H0sXIwcEs
	IC9x5FI2SJhZwEziy8vDrBD1rUwS+1b0MkLUa0ncX/UHzGYRUJU486IfbAGbgK7Ek/dzwWxR
	gQiJK2vmgNWICMhIrLz6kwlkELPAfUaJC92zwYqEBdwkZu3+B3aEkEC6xL9rt5lAbE4BTYlV
	l7vZJzAKzEJy3yyE+2YhuW8BI/MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjODIfia9g3FV
	g8UhRgEORiUe3oLd9SFCrIllxZW5hxglOJiVRHjnHQEK8aYkVlalFuXHF5XmpBYfYjQF+m4i
	s5Rocj4w6eSVxBsam5ibGptamliYmFkqifPeuJkbAnR2YklqdmpqQWoRTB8TB6dUA6NQfuW5
	FVzT/V4Lb3MtnzPHYRuD2wx37etP+Njvv292lb23XsHk0crGnh/XL8yU+SVRn3Eus4Fxf5RI
	5lL93nmNT8RXWx5krqiN3bjwQfjB6vfnPC45bLSUDNz7WTWDNf7D5N9VH71ubW96JlUixP5T
	YWqbApM/x9bfMSfsaxVDU9zEmAq5nJRYijMSDbWYi4oTAXlrfZQCAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 December 2014 11:04 AM, jonghwa3.lee@samsung.com wrote:
> On 2014년 12월 01일 01:16, Pankaj Dubey wrote:
>
>> This patch splits up exynos-pmu.c file, and moves PMU configuration data
>> and functions handing those data into SoC specific PMU files, keeping
>> driver structure and common functionality into exynos-pmu.c.
>>
>> At the same time it also separates compilation of these different SoC PMU files
>> based on CONFIG_ARM64 and CONFIG_ARM. This way we can reduce overhead of ARM64
>> SoC's PMU getting compiled when kernel is built for ARM and vice-versa.
>>
>> This patch also removes .owner field from exynos-pmu.c as it's redundant for
>> drivers calling platform_driver_register to register platform_driver.
>>
>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>> ---
>> This patch is prepared on top of kgene/for-next and following patch [1] from
>> Amit Daniel.
>>
>> [1]: http://www.spinics.net/lists/linux-samsung-soc/msg39797.html
>>
>> This patch tries to address some of concerns raised for using exynos-pmu.c for
>> ARM and ARM64 based SoC at these threads [2], [3].
>>
>> [2]: http://www.spinics.net/lists/linux-samsung-soc/msg39809.html
>> [3]: https://lkml.org/lkml/2014/11/24/322
>>
>> Since Exynos SoC's has similar PMU IP, and already existing bindings can be
>> used, it makes sense to keep single driver for both ARM and ARM64 based SoCs.
>> All common functionalties are in exynos-pmu.c whereas SoC specific data and
>> handling are moved into SoC specific exynosNNNN-pmu files.
>>
>> All changes are compiled tested only. Any improvements/suggestions are most
>> welcome.
>>
>>   drivers/soc/samsung/Makefile         |    9 +-
>>   drivers/soc/samsung/exynos-pmu.c     | 1293 +---------------------------------
>>   drivers/soc/samsung/exynos-pmu.h     |   63 ++
>>   drivers/soc/samsung/exynos3250-pmu.c |  176 +++++
>>   drivers/soc/samsung/exynos4-pmu.c    |  223 ++++++
>>   drivers/soc/samsung/exynos5250-pmu.c |  196 ++++++
>>   drivers/soc/samsung/exynos5420-pmu.c |  298 ++++++++
>>   drivers/soc/samsung/exynos7-pmu.c    |  441 ++++++++++++
>>   8 files changed, 1412 insertions(+), 1287 deletions(-)
>>   create mode 100644 drivers/soc/samsung/exynos-pmu.h
>>   create mode 100644 drivers/soc/samsung/exynos3250-pmu.c
>>   create mode 100644 drivers/soc/samsung/exynos4-pmu.c
>>   create mode 100644 drivers/soc/samsung/exynos5250-pmu.c
>>   create mode 100644 drivers/soc/samsung/exynos5420-pmu.c
>>   create mode 100644 drivers/soc/samsung/exynos7-pmu.c
>>
>
> ...
>
>> diff --git a/drivers/soc/samsung/exynos-pmu.h b/drivers/soc/samsung/exynos-pmu.h
>> new file mode 100644
>> index 0000000..4adc5a3
>> --- /dev/null
>> +++ b/drivers/soc/samsung/exynos-pmu.h
>> @@ -0,0 +1,63 @@
>> +/*
>> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
>> + *		http://www.samsung.com
>> + *
>> + * Header for EXYNOS PMU Driver support
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#ifndef __EXYNOSPMU_H
>> +#define __EXYNOSPMU_H
>> +
>> +#include <linux/io.h>
>> +
>> +#define PMU_TABLE_END	(-1U)
>> +
>> +static void __iomem *pmu_base_addr;
>> +
>
> AFAIK, static variable in header file can't be used globally. It would be placed
> in exynos-pmu.c or elsewhere and then only extern declaration is allowed here.
> If I'm wrong, please let me know.
>

Thanks for review.
You are right. I will change this.
I am waiting for review from other concerned people so that if any 
suggestions or improvements I can do it in next version.

> Thanks.
> Jonghwa
>
