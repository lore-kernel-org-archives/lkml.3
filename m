Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbaDKFts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 01:49:48 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:60799 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589AbaDKFtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 01:49:46 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-8c-534782781d3c
Message-id: <53478692.3020406@samsung.com>
Date: Fri, 11 Apr 2014 15:07:14 +0900
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, chow.kim@samsung.com,
        Young-Gun Jang <yg1004.jang@samsung.com>
Subject: Re: [PATCH 03/10] ARM: EXYNOS: Move SYSREG definition into sys-reg
 specific file
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
 <1396425058-4012-4-git-send-email-pankaj.dubey@samsung.com>
 <533BF433.6000209@samsung.com>
In-reply-to: <533BF433.6000209@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zI92KJvdggx97RS2WTbrLZtG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3ktDr9pZ7XY0bKaxYHDo6W5h81j85J6j74tqxg9Pm+SC2CJ
	4rJJSc3JLEst0rdL4Mo4dTagoFmo4v2Je0wNjHP5uhg5OSQETCSmv53ABmGLSVy4tx7I5uIQ
	EljGKLHs5F02mKKOPfNZIBKLGCUmnnjBCuG8ZpQ4cfUvO0gVr4CWxI7nDSwgNouAqsSMp0/A
	bDYBXYkn7+cyg9iiAmESm6b3sULUC0r8mHwPrEZEQF9iyaqLYKuZBe4xSkw92M0EkhAWiJY4
	Mf0Uwk3npzaC3cQpoC1x+uVXsM3MAtYSKydtY4Sw5SU2r3nLDNIgIXCKXeL1lU42iJMEJL5N
	PgS0jgMoISux6QAzxG+SEgdX3GCZwCg2C8lRs5CMnYVk7AJG5lWMoqkFyQXFSelFhnrFibnF
	pXnpesn5uZsYIXHXu4Px9gHrQ4zJQCsnMkuJJucD4zavJN7Q2MzIwtTE1NjI3NKMNGElcd6k
	h0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhhrXrnavjgzR66oPHXf3tK9T57an25yl9+m
	tu7ffyGhFr2cxfrL3sn+zYy4K+E7U49Fuv+tqflkLz3RSc2ztsSZbFcI0+CteR35+rJb/ka2
	zb22S/MjdebILQn7YyF7MM3/vM63HZp2Nbkrzp5+5VsrMjc4aNLheVs9C578qKr/+2+i/M3g
	PR5KLMUZiYZazEXFiQBhz0Up0QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jAd2KJvdgg1ufBSyWTbrLZtG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3ktDr9pZ7XY0bKaxYHDo6W5h81j85J6j74tqxg9Pm+SC2CJ
	amC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6Qkmh
	LDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYcepsQEGzUMX7E/eYGhjn8nUx
	cnJICJhIdOyZzwJhi0lcuLeerYuRi0NIYBGjxMQTL1ghnNeMEieu/mUHqeIV0JLY8bwBrINF
	QFVixtMnYDabgK7Ek/dzmUFsUYEwiU3T+1gh6gUlfky+B1YjIqAvsWTVRbANzAL3GCWmHuxm
	AkkIC0RLnJh+Cmr1MkaJ81Mb2UASnALaEqdffgXbzCxgLbFy0jZGCFteYvOat8wTGAVmIVky
	C0nZLCRlCxiZVzGKphYkFxQnpeca6hUn5haX5qXrJefnbmIER/UzqR2MKxssDjEKcDAq8fBm
	XHALFmJNLCuuzD3EKMHBrCTCa+bvHizEm5JYWZValB9fVJqTWnyIMRkYBhOZpUST84EJJ68k
	3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKWAMfb7c4KZ1TWmC+Z7
	JG9/EW4UnsZ1S5F5fkuzIvdLOZWiL8dfn7OJvjb7d4tJgrJpUaey7itxy/WH3bzkgiLd/rPz
	7tjYqv3XcXf5nyfzKt4/na/U0mv2MmyatmvyltC6GazvWx/tTxRrSpY7kbQqdtlbNj2WmWW5
	ET8Tl9/XmMG75v0SxcZOJZbijERDLeai4kQAvkhuFi4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2014 08:27 PM, Sylwester Nawrocki wrote:
> Hi,
>
> On 02/04/14 09:50, Pankaj Dubey wrote:
>> From: Young-Gun Jang <yg1004.jang@samsung.com>
>>
>> While making PMU (Power Mengement Unit) implementation device tree based,
>> there are few offsets related with SYSREG present in regs-pmu.h, so let's
>> make a new header file "regs-sys.h" to keep all such SYSREG related
>> register definition and remove them from "regs-pmu.h"
>>
>> Signed-off-by: Young-Gun Jang <yg1004.jang@samsung.com>
>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>> ---
>>   arch/arm/mach-exynos/exynos.c   |    1 +
>>   arch/arm/mach-exynos/pm.c       |    1 +
>>   arch/arm/mach-exynos/regs-pmu.h |    3 ---
>>   arch/arm/mach-exynos/regs-sys.h |   22 ++++++++++++++++++++++
>>   4 files changed, 24 insertions(+), 3 deletions(-)
>>   create mode 100644 arch/arm/mach-exynos/regs-sys.h
> [...]
>> diff --git a/arch/arm/mach-exynos/regs-sys.h b/arch/arm/mach-exynos/regs-sys.h
>> new file mode 100644
>> index 0000000..84332b0
>> --- /dev/null
>> +++ b/arch/arm/mach-exynos/regs-sys.h
>> @@ -0,0 +1,22 @@
>> +/*
>> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
>> + *             http://www.samsung.com
>> + *
>> + * EXYNOS - system register definition
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> +*/
>> +
>> +#ifndef __ASM_ARCH_REGS_SYS_H
>> +#define __ASM_ARCH_REGS_SYS_H __FILE__
>> +
>> +#include <mach/map.h>
>> +
>> +#define S5P_SYSREG(x)                          (S3C_VA_SYS + (x))
>> +
>> +/* For EXYNOS5 */
>> +#define EXYNOS5_SYS_I2C_CFG                    S5P_SYSREG(0x0234)
> Can this be defined as a regular register offset in a header file
> placed at include/linux/mfd/syscon/ ? I.e. can the mfd syscon driver be
> used instead of these hacks ?
>
No. As currently SysRegs are being accessed via iodesc table and not via DT,
it has dependency on "mach/map.h".
We separated these definitions from "regs-pmu.h" as it does not belong to EXYNOS 
PMU IP.
But this can be done once we make some way of accessing SysReg register sets via DT.

-- 
Best Regards,
Pankaj Dubey

