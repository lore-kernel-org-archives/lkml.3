Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934670AbaDJElH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 00:41:07 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:60117 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934634AbaDJEkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 00:40:52 -0400
X-AuditID: cbfee68f-b7f156d00000276c-9e-534620d22f4f
Message-id: <534624EA.2020406@samsung.com>
Date: Thu, 10 Apr 2014 13:58:18 +0900
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-version: 1.0
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, chow.kim@samsung.com
Subject: Re: [PATCH 05/10] ARM: EXYNOS: Move "regs-pmu" header inclusion in
 common.h
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
 <1396425058-4012-6-git-send-email-pankaj.dubey@samsung.com>
 <53441F25.9080801@samsung.com>
In-reply-to: <53441F25.9080801@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t8zY91LCm7BBg/vGFgsm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NarJ/xmsWB3aOluYfNY/OSeo++LasYPT5vkgtgieKySUnN
	ySxLLdK3S+DKeD5zA3vBOaWKv19+sDYwLpDpYuTkkBAwkWj8d54VwhaTuHBvPVsXIxeHkMAy
	Ron2/X/YYIo2Ld4AlZjOKLF64n5WCOc1o8TZxmlgVbwCWhLTVmxhBLFZBFQlNjY9ZQKx2QR0
	JZ68n8sMYosKhElsmt7HClEvKPFj8j0WEFtEQEXi8qnpjCBDmQU2MUpcOzwDyOHgEAZq+Dyj
	HO6kuV2H2EEaOAW0JW4+egG2jFnAWmLlpG1QtrzE5jVvmUEaJASOsUu8v76BFeIiAYlvkw+x
	gAyVEJCV2HSAGeI1SYmDK26wTGAUm4XkpllIxs5CMnYBI/MqRtHUguSC4qT0ImO94sTc4tK8
	dL3k/NxNjJBo69/BePeA9SHGZKCVE5mlRJPzgdGaVxJvaGxmZGFqYmpsZG5pRpqwkjjv/YdJ
	QUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYC4/X7a89sNj+dL3AQuf9xxvaHvCw8U+M61pQ
	6/lnpcKuBo4y3bVq80UelUc+uhHSY3wxuOTHD51Pil5/7oZ2tu2RFwg/f+vAtm0p0aIP2SL2
	mp4+n+UVfXzSn+fnCu8pbAy6osm9ZM61AuX10xa5z114z132pNIcldu7vB+k8Ll0i3jfvXho
	rxJLcUaioRZzUXEiADOtTiDMAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jQd1LCm7BBhe/aVssm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NarJ/xmsWB3aOluYfNY/OSeo++LasYPT5vkgtgiWpgtMlI
	TUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOkBJoSwxpxQo
	FJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmPF85gb2gnNKFX+//GBtYFwg08XIySEh
	YCKxafEGNghbTOLCvfVANheHkMB0RonVE/ezQjivGSXONk4Dq+IV0JKYtmILI4jNIqAqsbHp
	KROIzSagK/Hk/VxmEFtUIExi0/Q+Voh6QYkfk++xgNgiAioSl09NZwQZyiywiVHi2uEZQA4H
	hzBQw+cZ5RDLljFKzO06xA7SwCmgLXHz0QuwZcwC1hIrJ22DsuUlNq95yzyBUWAWkh2zkJTN
	QlK2gJF5FaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwLD+T3sG4qsHiEKMAB6MSD++BZa7B
	QqyJZcWVuYcYJTiYlUR4FYTcgoV4UxIrq1KL8uOLSnNSiw8xJgODYCKzlGhyPjDN5JXEGxqb
	mBlZGplZGJmYm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHpxQwCemcnH76kbvbYT5eg5l7
	br701P7WxVMiXr/G6PGe7//CmjyPFeVJbpXYuqj7aZX4BUX9LVFtpTrqfhc+r8rRmvW1fha3
	ad3fmj1+UUxzFPefTgmpFN0a+OG5GJvTFFvFM1Yl198+MmU7JbF1lfE0748Ppxqt8PrFeZLT
	oiqocN0mda5frdPmKLEUZyQaajEXFScCABkftj8pAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 04/09/2014 01:09 AM, Tomasz Figa wrote:
> Hi Pankaj,
>
> On 02.04.2014 09:50, Pankaj Dubey wrote:
>> There are many machine files under "mach-exynos" including "regs-pmu.h"
>> as well as "common.h", so better we move this header inclusion in common.h.
>>
>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>> ---
>>   arch/arm/mach-exynos/common.h  |    1 +
>>   arch/arm/mach-exynos/cpuidle.c |    1 -
>>   arch/arm/mach-exynos/exynos.c  |    1 -
>>   arch/arm/mach-exynos/hotplug.c |    1 -
>>   arch/arm/mach-exynos/platsmp.c |    1 -
>>   arch/arm/mach-exynos/pm.c      |    1 -
>>   arch/arm/mach-exynos/pmu.c     |    1 -
>>   7 files changed, 1 insertion(+), 6 deletions(-)
>>
>> diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
>> index 277a83e..ff28334 100644
>> --- a/arch/arm/mach-exynos/common.h
>> +++ b/arch/arm/mach-exynos/common.h
>> @@ -14,6 +14,7 @@
>>
>>   #include <linux/reboot.h>
>>   #include <linux/of.h>
>> +#include "regs-pmu.h"
>>
>>   void exynos_init_io(void);
>>   void exynos_restart(enum reboot_mode mode, const char *cmd);
>> diff --git a/arch/arm/mach-exynos/cpuidle.c b/arch/arm/mach-exynos/cpuidle.c
>> index b530231..b9dd8c3 100644
>> --- a/arch/arm/mach-exynos/cpuidle.c
>> +++ b/arch/arm/mach-exynos/cpuidle.c
>> @@ -29,7 +29,6 @@
>>   #include <mach/map.h>
>>
>>   #include "common.h"
>> -#include "regs-pmu.h"
>>
>>   #define REG_DIRECTGO_ADDR    (samsung_rev() == EXYNOS4210_REV_1_1 ? \
>>               S5P_INFORM7 : (samsung_rev() == EXYNOS4210_REV_1_0 ? \
>> diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
>> index 57bd1cd..a5e1349 100644
>> --- a/arch/arm/mach-exynos/exynos.c
>> +++ b/arch/arm/mach-exynos/exynos.c
>> @@ -30,7 +30,6 @@
>>
>>   #include "common.h"
>>   #include "mfc.h"
>> -#include "regs-pmu.h"
>>   #include "regs-sys.h"
>>
>>   #define L2_AUX_VAL 0x7C470001
>> diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
>> index 5eead53..33db6ee 100644
>> --- a/arch/arm/mach-exynos/hotplug.c
>> +++ b/arch/arm/mach-exynos/hotplug.c
>> @@ -22,7 +22,6 @@
>>   #include <plat/cpu.h>
>>
>>   #include "common.h"
>> -#include "regs-pmu.h"
>>
>>   static inline void cpu_enter_lowpower_a9(void)
>>   {
>> diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
>> index d8d1555..3ebb03f 100644
>> --- a/arch/arm/mach-exynos/platsmp.c
>> +++ b/arch/arm/mach-exynos/platsmp.c
>> @@ -29,7 +29,6 @@
>>   #include <plat/cpu.h>
>>
>>   #include "common.h"
>> -#include "regs-pmu.h"
>>
>>   extern void exynos4_secondary_startup(void);
>>
>> diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
>> index 723c988..875151f 100644
>> --- a/arch/arm/mach-exynos/pm.c
>> +++ b/arch/arm/mach-exynos/pm.c
>> @@ -34,7 +34,6 @@
>>   #include <mach/map.h>
>>
>>   #include "common.h"
>> -#include "regs-pmu.h"
>>   #include "regs-sys.h"
>>
>>   /**
>> diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
>> index 05c7ce1..fb44352 100644
>> --- a/arch/arm/mach-exynos/pmu.c
>> +++ b/arch/arm/mach-exynos/pmu.c
>> @@ -16,7 +16,6 @@
>>   #include <plat/cpu.h>
>>
>>   #include "common.h"
>> -#include "regs-pmu.h"
>>
>>   static const struct exynos_pmu_conf *exynos_pmu_config;
>>
>>
>
> I don't think this is a good idea. It adds hidden indirect dependencies 
> between source files and thus reduces maintainability and readability. In 
> addition it causes the file to be included even by files that don't need it.
>
Thanks for review.
I did this change because:
1: Currently only these 6 files (under "arm/mach-exynos/") are including 
"regs-pmu.h"
as well as "common.h" so all these source files requires "regs-pmu.h" can get it 
included via "common.h".
2: Next if we change location/rename "regs-pmu.h", we need to update all these 
source files. On the other hand
if it's present in common.h it can be done at single place in "common.h".
3:  More over just checked that even currently common.h has some hidden includes 
such as ("linux/of.h") which is not
required by all source files (I can see only pm.c needs it).
So let me know if still you think it's not good idea, I will consider to drop 
this patch in next version of patch series.

> Best regards,
> Tomasz
>


-- 
Best Regards,
Pankaj Dubey

