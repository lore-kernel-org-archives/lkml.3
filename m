Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406AbaELBzP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:55:15 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36053 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932338AbaELBzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:55:06 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-70-537029f7284b
Message-id: <53702E45.30808@samsung.com>
Date: Mon, 12 May 2014 11:13:25 +0900
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
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 6/6] ARM: EXYNOS: Refactoring to remove soc_is_exynos
 macros from exynos
References: <1399706287-13919-1-git-send-email-y@samsung.com>
 <1399706287-13919-7-git-send-email-y@samsung.com>
 <CAOesGMj2OjoeebXNDmc-DVxfj+d4DvarS6rSq4AVU4B=YFiX0w@mail.gmail.com>
In-reply-to: <CAOesGMj2OjoeebXNDmc-DVxfj+d4DvarS6rSq4AVU4B=YFiX0w@mail.gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t8zA93vmgXBBitbZCz+TjrGbtG74Cqb
	xabH11gtLu+aw2Yx4/w+JotT1z+zWSza+oXdYv2M1ywOHB6/f01i9Ni8pN7jyokmVo++LasY
	PT5vkgtgjeKySUnNySxLLdK3S+DKmP34AFPBzFbGiieHr7I0ME5M6WLk5JAQMJFY+uIUK4Qt
	JnHh3nq2LkYuDiGBZYwS2/fOY4MpWvbxF1RiEaPEoe/HWCCc14wSt/obmEGqeAU0JL59/ArW
	wSKgKvHoUyc7iM0moCvx5P1csBpRgTCJTdP7WCHqBSV+TL7HAmKLCChLPGm7xAwylFngI5PE
	55lngBwODmGBRIl7yzwglu1glDj4t5MJpIFTIFhi27IvjCA2s4CZxKOWdcwQtrzE5jVvwQZJ
	CNxil1j6aCfURQIS3yYfYgEZKiEgK7HpADPEa5ISB1fcYJnAKDYLyU2zkIydhWTsAkbmVYyi
	qQXJBcVJ6UUmesWJucWleel6yfm5mxghUThhB+O9A9aHGJOBVk5klhJNzgdGcV5JvKGxmZGF
	qYmpsZG5pRlpwkrivGqPkoKEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MApt7puk2a0m3LJB
	actSrXNe2iUCKns6zwVuvTVFmFUjestzkfiuzyYWC87W/DP9UH2RtyVm7+Gunc9cnuUv+coo
	ffbH5c9Z72SLbHVvvFo4J+nHucfsy6cE3MurfpGwsItB03bObKWPx0X/r3qwbpdQkrELv4K+
	wZdJM9Y/EBTZ9W5NeOJqRQElluKMREMt5qLiRACZlPJF2AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEKsWRmVeSWpSXmKPExsVy+t9jAd3vmgXBBt8fi1j8nXSM3aJ3wVU2
	i02Pr7FaXN41h81ixvl9TBanrn9ms1i09Qu7xfoZr1kcODx+/5rE6LF5Sb3HlRNNrB59W1Yx
	enzeJBfAGtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6Dr
	lpkDdIuSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMWP24wNMBTNbGSue
	HL7K0sA4MaWLkZNDQsBEYtnHX2wQtpjEhXvrgWwuDiGBRYwSh74fY4FwXjNK3OpvYAap4hXQ
	kPj28StYB4uAqsSjT53sIDabgK7Ek/dzwWpEBcIkNk3vY4WoF5T4MfkeC4gtIqAs8aTtEjPI
	UGaBj0wSn2eeAXI4OIQFEiXuLfOAWLaDUeLg304mkAZOgWCJbcu+MILYzAJmEo9a1jFD2PIS
	m9e8ZZ7AKDALyY5ZSMpmISlbwMi8ilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4xp9J7WBc
	2WBxiFGAg1GJh/cDQ0GwEGtiWXFl7iFGCQ5mJRHeySxAId6UxMqq1KL8+KLSnNTiQ4zJwCCY
	yCwlmpwPTD95JfGGxiZmRpZGZhZGJubmpAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp1cCY
	5z3nRV927Q9lr6Ulx3jafz8pL+mKdrwZKbsoydmpTdWj5lzlTIHs4Dl/mXiffqnzzG7bKndz
	yufm7YumLk1lqD1w7qDAtMhvKs8q17/eEDLrPb956LeIaY/nlzmbCZ/v0Xp69OK+w6vqZZ5e
	srfT/flPnklot9PK39WhsxWfnbmc6i4j0NGixFKckWioxVxUnAgAkSXlWDUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2014 04:10 PM, Olof Johansson wrote:
> On Sat, May 10, 2014 at 12:18 AM,  <y@samsung.com> wrote:
>> From: Pankaj Dubey <pankaj.dubey@samsung.com>
>>
>> This patch enables chipid driver for ARCH_EXYNOS and refactors
>> machine code as well as exynos cpufreq driver code for using
>> chipid driver for identification of SoC ID and SoC rev.
>>
>> This patch also updates DT binding information in exynos4 and
>> exynos5 dtsi file. As to differentiate product id bit-mask we need
>> separate compatible string for exynos4 and exynos5. Hoping this will
>> be helpful in future as bit-mask and bit-shift bit may differ.
>> Added binding information as well.
>>
>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>> ---
>>   .../bindings/arm/samsung/exynos-chipid.txt         |   21 ++++++++
>>   arch/arm/Kconfig                                   |    1 +
>>   arch/arm/boot/dts/exynos4.dtsi                     |    2 +-
>>   arch/arm/boot/dts/exynos5.dtsi                     |    2 +-
>>   arch/arm/mach-exynos/exynos.c                      |   47 ++++------------
>>   arch/arm/mach-exynos/platsmp.c                     |   11 ++--
>>   arch/arm/mach-exynos/pm.c                          |   26 ++++-----
>>   arch/arm/plat-samsung/include/plat/cpu.h           |   57 --------------------
>>   drivers/clk/samsung/clk-exynos4.c                  |    2 +-
>>   drivers/cpufreq/exynos-cpufreq.c                   |    9 ++--
>>   drivers/cpufreq/exynos-cpufreq.h                   |    1 -
>>   drivers/cpufreq/exynos4x12-cpufreq.c               |    5 +-
>>   12 files changed, 61 insertions(+), 123 deletions(-)
>>   create mode 100644 Documentation/devicetree/bindings/arm/samsung/exynos-chipid.txt
>>
>> diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-chipid.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-chipid.txt
>> new file mode 100644
>> index 0000000..a496459
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/arm/samsung/exynos-chipid.txt
>> @@ -0,0 +1,21 @@
>> +SAMSUNG Exynos4/Exynos5 SoCs Chipid driver.
>> +
>> +Required properties:
>> +- compatible : Should at least contain "samsung,exynos4210-chipid". More
>> +       specific compatible string specify which SoC version (exynos4 or
>> +       exynos5) are paired with.
>> +  Details:
>> +  samsung,exynos4-chipid: Exynos4 SoCs has Chip ID block that can provide
>> +       product id, revision number and package information.
>> +       It has different product-id bit-mask than Exynos5 series SoC.
>> +  samsung,exynos5-chipid: Exynos5 SoCs has Chip ID block that can provide
>> +       product id, revision number and package information.
>> +       It has different product-id bit-mask then Exynos4 series SoC.
>> +
>> +- reg: offset and length of the register set
>> +
>> +Example:
>> +       chipid@10000000 {
>> +               compatible = "samsung,exynos4210-chipid", "samsung,exynos4-chipid";
>> +               reg = <0x10000000 0x100>;
>> +       };
> This needs to go with the patch adding the driver.

OK, will make this along with driver.

>
>> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>> index a4eac2f..06f14a4 100644
>> --- a/arch/arm/Kconfig
>> +++ b/arch/arm/Kconfig
>> @@ -856,6 +856,7 @@ config ARCH_EXYNOS
>>          select SRAM
>>          select USE_OF
>>          select MFD_SYSCON
>> +       select EXYNOS_CHIPID
>>          help
>>            Support for SAMSUNG's EXYNOS SoCs (EXYNOS4/5)
>>
>> diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
>> index 2f8bcd0..d4c0657 100644
>> --- a/arch/arm/boot/dts/exynos4.dtsi
>> +++ b/arch/arm/boot/dts/exynos4.dtsi
>> @@ -46,7 +46,7 @@
>>          };
>>
>>          chipid@10000000 {
>> -               compatible = "samsung,exynos4210-chipid";
>> +               compatible = "samsung,exynos4210-chipid", "samsung,exynos4-chipid";
> Only 4210-chipid. We normally don't use generic names on any drivers
> (we might on system level, but not on drivers).
>
>>                  reg = <0x10000000 0x100>;
>>          };
>>
>> diff --git a/arch/arm/boot/dts/exynos5.dtsi b/arch/arm/boot/dts/exynos5.dtsi
>> index 3027e37..1d0b569 100644
>> --- a/arch/arm/boot/dts/exynos5.dtsi
>> +++ b/arch/arm/boot/dts/exynos5.dtsi
>> @@ -19,7 +19,7 @@
>>          interrupt-parent = <&gic>;
>>
>>          chipid@10000000 {
>> -               compatible = "samsung,exynos4210-chipid";
>> +               compatible = "samsung,exynos4210-chipid", "samsung,exynos5-chipid";
> Same here. Each SoC should probably have:
>
> samsung,exynos<soc>-chipid, samsung,exynos4210-chipid
>
> At least if you think there will ever be a difference in how the
> driver has to work when interacting with this IP block compared to
> 4210.
>
>>                  reg = <0x10000000 0x100>;
>>          };
>>
>> diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
>> index 9902e52..26f5e8c 100644
>> --- a/arch/arm/mach-exynos/exynos.c
>> +++ b/arch/arm/mach-exynos/exynos.c
>> @@ -21,6 +21,7 @@
>>   #include <linux/pm_domain.h>
>>   #include <linux/mfd/syscon.h>
>>   #include <linux/regmap.h>
>> +#include <linux/exynos-soc.h>
>>
>>   #include <asm/cacheflush.h>
>>   #include <asm/hardware/cache-l2x0.h>
>> @@ -28,7 +29,6 @@
>>   #include <asm/mach/map.h>
>>   #include <asm/memory.h>
>>
>> -#include <plat/cpu.h>
>>   #include <mach/map.h>
>>
>>   #include "common.h"
>> @@ -171,29 +171,6 @@ static void __init exynos_init_late(void)
>>          exynos_pm_init();
>>   }
>>
>> -static int __init exynos_fdt_map_chipid(unsigned long node, const char *uname,
>> -                                       int depth, void *data)
>> -{
>> -       struct map_desc iodesc;
>> -       __be32 *reg;
>> -       unsigned long len;
>> -
>> -       if (!of_flat_dt_is_compatible(node, "samsung,exynos4210-chipid") &&
>> -               !of_flat_dt_is_compatible(node, "samsung,exynos5440-clock"))
>> -               return 0;
>> -
>> -       reg = of_get_flat_dt_prop(node, "reg", &len);
>> -       if (reg == NULL || len != (sizeof(unsigned long) * 2))
>> -               return 0;
>> -
>> -       iodesc.pfn = __phys_to_pfn(be32_to_cpu(reg[0]));
>> -       iodesc.length = be32_to_cpu(reg[1]) - 1;
>> -       iodesc.virtual = (unsigned long)S5P_VA_CHIPID;
>> -       iodesc.type = MT_DEVICE;
>> -       iotable_init(&iodesc, 1);
>> -       return 1;
>> -}
>> -
>>   static const struct of_device_id exynos_dt_pmu_match[] = {
>>          { .compatible = "samsung,exynos4210-pmu" },
>>          { .compatible = "samsung,exynos4212-pmu" },
>> @@ -202,25 +179,15 @@ static const struct of_device_id exynos_dt_pmu_match[] = {
>>          {},
>>   };
>>
>> -static void __init exynos_init_io(void)
>> -{
>> -       debug_ll_io_init();
>> -
>> -       of_scan_flat_dt(exynos_fdt_map_chipid, NULL);
>> -
>> -       /* detect cpu id and rev. */
>> -       s5p_init_cpu(S5P_VA_CHIPID);
>> -}
>> -
>>   static void __init exynos5_init_io(void)
>>   {
>> -       exynos_init_io();
>> +       debug_ll_io_init();
>>          iotable_init(exynos5_iodesc, ARRAY_SIZE(exynos5_iodesc));
>>   }
>>
>>   static void __init exynos4_init_io(void)
>>   {
>> -       exynos_init_io();
>> +       debug_ll_io_init();
>>          iotable_init(exynos4_iodesc, ARRAY_SIZE(exynos4_iodesc));
>>   }
>>
>> @@ -279,14 +246,18 @@ void __init exynos_map_pmu(void)
>>
>>   static void __init exynos_dt_machine_init(void)
>>   {
>> +       struct device *parent;
>> +
>>          exynos_map_pmu();
>>
>> -       if (!soc_is_exynos5440())
>> +       parent = exynos_soc_device_init();
>> +
>> +       if (is_soc_id_compatible(EXYNOS5440))
>>                  platform_device_register(&exynos_cpuidle);
>>
>>          platform_device_register_simple("exynos-cpufreq", -1, NULL, 0);
>>
>> -       of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
>> +       of_platform_populate(NULL, of_default_bus_match_table, NULL, parent);
>>   }
>>
>>   static char const *exynos4_dt_compat[] __initconst = {
>> diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
>> index d0482c2..9d6ec84 100644
>> --- a/arch/arm/mach-exynos/platsmp.c
>> +++ b/arch/arm/mach-exynos/platsmp.c
>> @@ -20,13 +20,13 @@
>>   #include <linux/smp.h>
>>   #include <linux/io.h>
>>   #include <linux/of_address.h>
>> +#include <linux/exynos-soc.h>
>>
>>   #include <asm/cacheflush.h>
>>   #include <asm/smp_plat.h>
>>   #include <asm/smp_scu.h>
>>   #include <asm/firmware.h>
>>
>> -#include <plat/cpu.h>
>>   #include <mach/map.h>
>>
>>   #include "common.h"
>> @@ -59,7 +59,8 @@ static void __init exynos_smp_prepare_sram(void)
>>
>>   static inline void __iomem *cpu_boot_reg_base(void)
>>   {
>> -       if (soc_is_exynos4210() && samsung_rev() == EXYNOS4210_REV_1_1)
>> +       if (is_soc_id_compatible(EXYNOS4210) &&
>> +                       is_soc_rev_compatible(EXYNOS4210_REV_1_1))
>>                  return pmu_base + S5P_INFORM5;
>>
>>          return sram_base_addr;
>> @@ -72,9 +73,10 @@ static inline void __iomem *cpu_boot_reg(int cpu)
>>          boot_reg = cpu_boot_reg_base();
>>          if (!boot_reg)
>>                  return ERR_PTR(-ENODEV);
>> -       if (soc_is_exynos4412())
>> +
>> +       if (is_soc_id_compatible(EXYNOS4412))
>>                  boot_reg += 4*cpu;
>> -       else if (soc_is_exynos5420())
>> +       else if (is_soc_id_compatible(EXYNOS5420))
>>                  boot_reg += 4;
> This won't work much longer. You'll need to add another check for any
> other SoC that has another register layout. This is probably one of
> these cases where it makes more sense to describe the register
> offset/layout in the DT.
>
>
>>          return boot_reg;
>>   }
>> @@ -264,6 +266,7 @@ static void __init exynos_smp_init_cpus(void)
>>   static void __init exynos_smp_prepare_cpus(unsigned int max_cpus)
>>   {
>>          int i;
>> +       early_exynos_chipid_init();
>>
>>          pmu_base = pmu_base_addr();
>>
>> diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
>> index 59e5604..5cb5449 100644
>> --- a/arch/arm/mach-exynos/pm.c
>> +++ b/arch/arm/mach-exynos/pm.c
>> @@ -22,13 +22,13 @@
>>   #include <linux/err.h>
>>   #include <linux/clk.h>
>>   #include <linux/regmap.h>
>> +#include <linux/exynos-soc.h>
>>
>>   #include <asm/cacheflush.h>
>>   #include <asm/hardware/cache-l2x0.h>
>>   #include <asm/smp_scu.h>
>>   #include <asm/suspend.h>
>>
>> -#include <plat/cpu.h>
>>   #include <plat/pm-common.h>
>>   #include <plat/pll.h>
>>   #include <plat/regs-srom.h>
>> @@ -82,7 +82,7 @@ static int exynos_irq_set_wake(struct irq_data *data, unsigned int state)
>>   {
>>          const struct exynos_wkup_irq *wkup_irq;
>>
>> -       if (soc_is_exynos5250())
>> +       if (is_soc_id_compatible(EXYNOS5250))
>>                  wkup_irq = exynos5250_wkup_irq;
>>          else
>>                  wkup_irq = exynos4_wkup_irq;
>> @@ -101,11 +101,11 @@ static int exynos_irq_set_wake(struct irq_data *data, unsigned int state)
>>          return -ENOENT;
>>   }
>>
>> -#define EXYNOS_BOOT_VECTOR_ADDR        (samsung_rev() == EXYNOS4210_REV_1_1 ? \
>> -                       S5P_INFORM7 : (samsung_rev() == EXYNOS4210_REV_1_0 ? \
>> +#define EXYNOS_BOOT_VECTOR_ADDR        (is_soc_rev_compatible(EXYNOS4210_REV_1_1) ? \
>> +                       S5P_INFORM7 : (is_soc_rev_compatible(EXYNOS4210_REV_1_0) ? \
>>                          0x24 : S5P_INFORM0))
>> -#define EXYNOS_BOOT_VECTOR_FLAG        (samsung_rev() == EXYNOS4210_REV_1_1 ? \
>> -                       S5P_INFORM6 : (samsung_rev() == EXYNOS4210_REV_1_0 ? \
>> +#define EXYNOS_BOOT_VECTOR_FLAG        (is_soc_rev_compatible(EXYNOS4210_REV_1_1) ? \
>> +                       S5P_INFORM6 : (is_soc_rev_compatible(EXYNOS4210_REV_1_0) ? \
>>                          0x20 : S5P_INFORM1))
>>
>>   #define S5P_CHECK_AFTR  0xFCBA0D10
>> @@ -119,7 +119,7 @@ static void exynos_set_wakeupmask(long mask)
>>
>>   static void exynos_cpu_set_boot_vector(long flags)
>>   {
>> -       if (samsung_rev() == EXYNOS4210_REV_1_0) {
>> +       if (is_soc_rev_compatible(EXYNOS4210_REV_1_0)) {
>>                  __raw_writel(virt_to_phys(exynos_cpu_resume),
>>                                  S5P_VA_SYSRAM + EXYNOS_BOOT_VECTOR_ADDR);
>>                  __raw_writel(flags, S5P_VA_SYSRAM + EXYNOS_BOOT_VECTOR_FLAG);
>> @@ -183,7 +183,7 @@ static int exynos_cpu_suspend(unsigned long arg)
>>          outer_flush_all();
>>   #endif
>>
>> -       if (soc_is_exynos5250())
>> +       if (is_soc_id_compatible(EXYNOS5250))
>>                  flush_cache_all();
>>
>>          /* issue the standby signal into the pm unit. */
>> @@ -205,7 +205,7 @@ static void exynos_pm_prepare(void)
>>
>>          s3c_pm_do_save(exynos_core_save, ARRAY_SIZE(exynos_core_save));
>>
>> -       if (soc_is_exynos5250()) {
>> +       if (is_soc_id_compatible(EXYNOS5250)) {
>>                  /* Disable USE_RETENTION of JPEG_MEM_OPTION */
>>                  regmap_read(pmu_regmap, EXYNOS5_JPEG_MEM_OPTION, &tmp);
>>                  tmp &= ~EXYNOS5_OPTION_USE_RETENTION;
>> @@ -243,7 +243,7 @@ static int exynos_pm_suspend(void)
>>          tmp = (S5P_USE_STANDBY_WFI0 | S5P_USE_STANDBY_WFE0);
>>          regmap_write(pmu_regmap, S5P_CENTRAL_SEQ_OPTION, tmp);
>>
>> -       if (!soc_is_exynos5250())
>> +       if (!is_soc_id_compatible(EXYNOS5250))
>>                  exynos_cpu_save_register();
> These kind of constructs don't work well, you will have to address
> them too. I know there'll be need for code here for 5420/5422 already,
> for example.

Well in "pm.c" we are doing many SoC specific stuffs. So until all these are
not being handled in generic way, I could not see we can get rid of such
if/else. If we do not use "is_soc_id_compatible" then it might be old 
"soc_is_exynosXYZ"
or as you said it might be "is_soc_compatible" any case we would end up
doing if/else.

Only advantage in choosing chipid driver APIs or "is_soc_compatible" API
I can see that it will allow us to get rid of #ifdef based macros 
soc_is_exynosxyz,
which requires Kconfig changes also. Otherwise every time new SoC comes
(e.g Exynos5260, and Exynos5410) we will see more and more such additions.

In my attempt to remove such usage from mach-exynos, I have done for two
files (exynos.c and pmu.c) in different patch sets, and hope in near future we
should be able to get rid of such things from left over files such as 
platsmp.c and
pm.c.


>
>> diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
>> index b4f9672..7b0ea1f 100644
>> --- a/drivers/clk/samsung/clk-exynos4.c
>> +++ b/drivers/clk/samsung/clk-exynos4.c
>> @@ -1030,7 +1030,7 @@ static unsigned long exynos4_get_xom(void)
>>          void __iomem *chipid_base;
>>          struct device_node *np;
>>
>> -       np = of_find_compatible_node(NULL, NULL, "samsung,exynos4210-chipid");
>> +       np = of_find_compatible_node(NULL, NULL, "samsung,exynos4-chipid");
> This should likely still say 4210.
OK.
>
>>          if (np) {
>>                  chipid_base = of_iomap(np, 0);
>>
>> diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
>> index f99cfe2..5fe84a1 100644
>> --- a/drivers/cpufreq/exynos-cpufreq.c
>> +++ b/drivers/cpufreq/exynos-cpufreq.c
>> @@ -17,8 +17,7 @@
>>   #include <linux/regulator/consumer.h>
>>   #include <linux/cpufreq.h>
>>   #include <linux/platform_device.h>
>> -
>> -#include <plat/cpu.h>
>> +#include <linux/exynos-soc.h>
>>
>>   #include "exynos-cpufreq.h"
>>
>> @@ -163,11 +162,11 @@ static int exynos_cpufreq_probe(struct platform_device *pdev)
>>          if (!exynos_info)
>>                  return -ENOMEM;
>>
>> -       if (soc_is_exynos4210())
>> +       if (is_soc_id_compatible(EXYNOS4210))
>>                  ret = exynos4210_cpufreq_init(exynos_info);
>> -       else if (soc_is_exynos4212() || soc_is_exynos4412())
>> +       else if (is_soc_id_compatible(EXYNOS4212) || is_soc_id_compatible(EXYNOS4412))
>>                  ret = exynos4x12_cpufreq_init(exynos_info);
>> -       else if (soc_is_exynos5250())
>> +       else if (is_soc_id_compatible(EXYNOS5250))
>>                  ret = exynos5250_cpufreq_init(exynos_info);
> Many drivers tend to use of_machine_is_compatible here. I wonder if
> that'll solve most of your problems in a more generic way. Any machine
> based on an SoC should have the SoC somewhere in the compatible array
> for the board anyway.
>
> Actually, I think using that approach in most of your patch set will
> remove the need for the chipid driver alltogether, and just using
> machine compatibles instead.
>
>
> -Olof
>


-- 
Best Regards,
Pankaj Dubey

