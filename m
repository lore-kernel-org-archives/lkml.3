Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbaD0HLz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 03:11:55 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:64716 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbaD0HLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 03:11:52 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-b9-535cadb75c0b
Message-id: <535CB1E6.8070500@samsung.com>
Date: Sun, 27 Apr 2014 16:29:42 +0900
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, t.figa@samsung.com, chow.kim@samsung.com,
        yg1004.jang@samsung.com, vikas.sajjan@samsung.com,
        s.nawrocki@samsung.com, b.zolnierkie@samsung.com
Subject: Re: [PATCH v2 06/10] ARM: EXYNOS: Add support for mapping PMU base
 address via DT
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
 <1398429166-5539-1-git-send-email-pankaj.dubey@samsung.com>
 <1398429166-5539-7-git-send-email-pankaj.dubey@samsung.com>
 <535AD70F.20608@gmail.com>
In-reply-to: <535AD70F.20608@gmail.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zfd3ta2OCDd7MYbbYOGM9q8WySXfZ
	LHoXXGWz2PT4GqvF5V1z2CxmnN/HZHH7Mq/F4TftrBbrZ7xmsVi16w+jxc1n25ksdrSsZnHg
	8Whp7mHz2DnrLrvH5iX1Hn1bVjF6fN4kF8AaxWWTkpqTWZZapG+XwJXR9nwxW0GLdUXLzMuM
	DYwz9boYOTgkBEwklr817GLkBDLFJC7cW8/WxcjFISSwjFFibU8PO0TCROLt3w9MEIlFjBJ7
	/q9khXBeM0qcWDGfCaSKV0BLYsGJG2wgU1kEVCXWn2cBCbMJ6Eo8eT+XGcQWFQiT2DS9jxWi
	XFDix+R7YDUiAuoS36b0s4PMZBZYzyTRfHcH2GZhgRiJ91ues0Ase8Ao0dS4khEkwQnUsW/d
	Z7DFzALWEisnbWOEsOUlNq95ywzSICHwlV2i/cIUsNUsAgIS3yYfYoH4WVZi0wFmiNckJQ6u
	uMEygVFsFpKjZiEZOwvJ2AWMzKsYRVMLkguKk9KLjPWKE3OLS/PS9ZLzczcxQuK0fwfj3QPW
	hxiTgVZOZJYSTc4HxnleSbyhsZmRhamJqbGRuaUZacJK4rz3HyYFCQmkJ5akZqemFqQWxReV
	5qQWH2Jk4uCUamBc/fpi+kXvVbHebSffb9v5xEDy3z/1VT9cXrIt25Lp28C82/GKb9VBE+ay
	2CaNkk/2CzSUer8eXG93Z32nktth0/rb6dsv6Tb5R90+YceokvLqt572oqd3+0/OWZPxMu6k
	mt/tvYtXPBA9nhi+YD9XU4PAuT1zJt1hPXx9/epJHwWSNyvHllyWVWIpzkg01GIuKk4EAKZ6
	bfLpAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jAd1ta2OCDbbPs7LYOGM9q8WySXfZ
	LHoXXGWz2PT4GqvF5V1z2CxmnN/HZHH7Mq/F4TftrBbrZ7xmsVi16w+jxc1n25ksdrSsZnHg
	8Whp7mHz2DnrLrvH5iX1Hn1bVjF6fN4kF8Aa1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9q
	ZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0npJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35Ag
	uB4jAzSQsI4xo+35YraCFuuKlpmXGRsYZ+p1MXJySAiYSLz9+4EJwhaTuHBvPVsXIxeHkMAi
	Rok9/1eyQjivGSVOrJgPVsUroCWx4MQNoCoODhYBVYn151lAwmwCuhJP3s9lBrFFBcIkNk3v
	Y4UoF5T4MfkeWI2IgLrEtyn97CAzmQXWM0k0393BDpIQFoiReL/lOQvEsgeMEk2NKxlBEpxA
	HfvWfQZbzCxgLbFy0jZGCFteYvOat8wTGAVmIVkyC0nZLCRlCxiZVzGKphYkFxQnpeca6RUn
	5haX5qXrJefnbmIEp4Fn0jsYVzVYHGIU4GBU4uH9IR0TLMSaWFZcmXuIUYKDWUmEl3M6UIg3
	JbGyKrUoP76oNCe1+BBjMjAIJjJLiSbnA1NUXkm8obGJmZGlkZmFkYm5OWnCSuK8B1utA4UE
	0hNLUrNTUwtSi2C2MHFwSjUwRlpPaHxynXX6W8NbrUL/7qnZZRy5++j7ruuMB6VOJHxSud7H
	W7EpdlGzIFvcNq98qf296955hs31Tf6guCro5eK2xX4PmRlXzkw3PaGaNitBhPmfQtak2bzm
	X1PKayJ1k54tEPrZc4/tT1oGe8nfwknTeaNjFIJZfZdLTfjbqX3696Eo/okeSizFGYmGWsxF
	xYkAaObdzUcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

Thanks for review.

On 04/26/2014 06:43 AM, Tomasz Figa wrote:
> Hi,
>
> On 25.04.2014 14:32, Pankaj Dubey wrote:
>> From: Young-Gun Jang <yg1004.jang@samsung.com>
>>
>> Add support for mapping Samsung Power Management Unit (PMU) base address
>> from device tree. Code will use existing samsung pmu binding information.
>> This patch also adds two helper functions as "get_exynos_pmuregmap" and
>> "get_exynos_pmuaddr".
>> "get_exynos_pmuregmap" returns a regmap based PMU register handle where as
>> "get_exynos_pmuaddr" returns ioremap virtual address.
>>
>> Signed-off-by: Young-Gun Jang <yg1004.jang@samsung.com>
>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>> ---
>>   arch/arm/mach-exynos/Kconfig  |    2 ++
>>   arch/arm/mach-exynos/common.h |    3 ++
>>   arch/arm/mach-exynos/exynos.c |   78 +++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 83 insertions(+)
>>
>> diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
>> index fc8bf18..2f60c90 100644
>> --- a/arch/arm/mach-exynos/Kconfig
>> +++ b/arch/arm/mach-exynos/Kconfig
>> @@ -26,6 +26,7 @@ config ARCH_EXYNOS4
>>       select PINCTRL
>>       select PM_GENERIC_DOMAINS if PM_RUNTIME
>>       select S5P_DEV_MFC
>> +    select MFD_SYSCON
>>       help
>>         Samsung EXYNOS4 SoCs based systems
>>
>> @@ -36,6 +37,7 @@ config ARCH_EXYNOS5
>>       select HAVE_ARM_SCU if SMP
>>       select HAVE_SMP
>>       select PINCTRL
>> +    select MFD_SYSCON
>>       help
>>         Samsung EXYNOS5 (Cortex-A15) SoC based systems
>>
>> diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
>> index 31c5964..ecfd0fc 100644
>> --- a/arch/arm/mach-exynos/common.h
>> +++ b/arch/arm/mach-exynos/common.h
>> @@ -57,4 +57,7 @@ struct exynos_pmu_conf {
>>
>>   extern void exynos_sys_powerdown_conf(enum sys_powerdown mode);
>>
>> +extern struct regmap *get_exynos_pmuregmap(void);
>> +extern void __iomem *get_exynos_pmuaddr(void);
>
> Do you really need these functions? Couldn't all the drivers using PMU simply 
> call syscon_regmap_lookup_by_phandle() or of_iomap() directly?

Well, currently "get_exynos_pmuregmap" is used in three location under
mach-exynos as "exynos.c", "pm.c" and "hotplug.c" so just to avoid duplicate code
in all these files I added "get_exynos_pmuregmap" as helper function in "exynos.c".
So in my opinion it should be fine. What do you say?

Regarding "get_exynos_pmuaddr", only user of this function is "platsmp.c" so I can
move this function in platsmp.c and remove this helper. This will also solve the 
other
issue of early mapping as you raised below.

>
>> +
>>   #endif /* __ARCH_ARM_MACH_EXYNOS_COMMON_H */
>> diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
>> index d6f405f..68f60e1 100644
>> --- a/arch/arm/mach-exynos/exynos.c
>> +++ b/arch/arm/mach-exynos/exynos.c
>> @@ -19,6 +19,7 @@
>>   #include <linux/of_platform.h>
>>   #include <linux/platform_device.h>
>>   #include <linux/pm_domain.h>
>> +#include <linux/mfd/syscon.h>
>>
>>   #include <asm/cacheflush.h>
>>   #include <asm/hardware/cache-l2x0.h>
>> @@ -36,6 +37,9 @@
>>   #define L2_AUX_VAL 0x7C470001
>>   #define L2_AUX_MASK 0xC200ffff
>>
>> +static struct regmap *exynos_pmu_regmap;
>> +static void __iomem *exynos_pmu_base;
>> +
>>   static struct map_desc exynos4_iodesc[] __initdata = {
>>       {
>>           .virtual    = (unsigned long)S3C_VA_SYS,
>> @@ -269,6 +273,46 @@ static int __init exynos_fdt_map_chipid(unsigned long 
>> node, const char *uname,
>>       return 1;
>>   }
>>
>> +static const struct of_device_id exynos_dt_pmu_match[] = {
>> +    { .compatible = "samsung,exynos4210-pmu" },
>> +    { .compatible = "samsung,exynos4212-pmu" },
>> +    { .compatible = "samsung,exynos4412-pmu" },
>> +    { .compatible = "samsung,exynos5250-pmu" },
>> +    {},
>> +};
>> +
>> +static int __init exynos_fdt_map_pmu(unsigned long node,
>> +        const char *uname, int depth, void *data)
>> +{
>> +    struct map_desc iodesc;
>> +    __be32 *reg;
>> +    unsigned long len;
>> +    phys_addr_t phys_addr;
>> +    const struct of_device_id *matches = exynos_dt_pmu_match;
>> +
>> +    for (; matches->compatible[0]; matches++) {
>> +        if (!of_flat_dt_is_compatible(node, matches->compatible))
>> +            continue;
>> +        reg = of_get_flat_dt_prop(node, "reg", &len);
>> +        if (reg == NULL || len != (sizeof(unsigned long) * 2))
>> +            return 0;
>> +
>> +        phys_addr = be32_to_cpu(reg[0]);
>> +        iodesc.pfn = __phys_to_pfn(phys_addr);
>> +        iodesc.length = be32_to_cpu(reg[1]) - 1;
>> +        iodesc.virtual = (unsigned long)S5P_VA_PMU;
>> +        iodesc.type = MT_DEVICE;
>> +        iotable_init(&iodesc, 1);
>> +
>> +        exynos_pmu_base = ioremap(phys_addr, be32_to_cpu(reg[1]));
>> +        if (WARN_ON(!exynos_pmu_base))
>> +            return -EFAULT;
>> +        return 1;
>> +    }
>> +
>> +    return 0;
>> +}
>
> Is such early mapping really needed? Couldn't the code using PMU be deferred 
> to the stage that memory management is available and then of_iomap() used 
> directly?

OK, not really required, If I move mapping of PMU base address to platsmp.c.
As "exynos_pmu_base" is only required in platsmp.c during "exynos_smp_prepare_cpus"
function call, I can move mapping of PMU address in platsmp.c itself and there I 
can use of_iomap.

>
>> +
>>   /*
>>    * exynos_map_io
>>    *
>> @@ -302,6 +346,7 @@ static void __init exynos_init_io(void)
>>       debug_ll_io_init();
>>
>>       of_scan_flat_dt(exynos_fdt_map_chipid, NULL);
>> +    of_scan_flat_dt(exynos_fdt_map_pmu, NULL);
>>
>>       /* detect cpu id and rev. */
>>       s5p_init_cpu(S5P_VA_CHIPID);
>> @@ -336,6 +381,38 @@ static int __init exynos4_l2x0_cache_init(void)
>>   }
>>   early_initcall(exynos4_l2x0_cache_init);
>>
>> +
>> +inline struct regmap *get_exynos_pmuregmap()
>> +{
>> +    return exynos_pmu_regmap;
>> +}
>> +
>> +inline void __iomem *get_exynos_pmuaddr()
>> +{
>> +    return exynos_pmu_base;
>> +}
>
> Hmm, non-static inline inside a C file? Probably should be either static 
> inline or non-static non-inline. (Assuming that both are really needed, as I 
> pointed in the comments above.)

OK, will remove "get_exynos_pmuaddr" and make "get_exynos_pmuregmap" as 
non-static non-inline.

>
>> +
>> +
>> +void __init exynos_map_pmu(void)
>> +{
>> +    struct device_node *np = NULL;
>> +
>> +    early_syscon_init();
>> +
>> +    np = of_find_matching_node(NULL, exynos_dt_pmu_match);
>> +
>> +    if (!np) {
>> +        pr_err("Failed to find PMU node\n");
>> +        return;
>> +    } else {
>> +        exynos_pmu_regmap = syscon_early_regmap_lookup_by_phandle(np,
>> +                "samsung,syscon-phandle");
>
> Do you need this regmap really here? I believe it should be the code using PMU 
> registers which calls this function directly to retrieve a handle to the syscon.
>

Yes, as "exynos_restart" is accessing one PMU register. So even though all callers
(pm.c and hotplug.c) directly retrieve a regmap handle to PMU, we need regmap handle
in this file also. So as I mentioned above just to avoid duplicate code in all 
files we can
retrieve regmap handle in "exynos.c" and using helper function other files can 
use it.

> Best regards,
> Tomasz
>


-- 
Best Regards,
Pankaj Dubey

