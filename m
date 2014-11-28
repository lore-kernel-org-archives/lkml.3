Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338AbaK1NSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 08:18:31 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:25515 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaK1NS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 08:18:28 -0500
X-AuditID: cbfee68e-f79b46d000002b74-d0-5478762199ed
Message-id: <54787621.4000503@samsung.com>
Date: Fri, 28 Nov 2014 22:18:25 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "arnd@arndb.de" <arnd@arndb.de>, "olof@lixom.net" <olof@lixom.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "s.nawrocki@samsung.com" <s.nawrocki@samsung.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "inki.dae@samsung.com" <inki.dae@samsung.com>,
        "chanho61.park@samsung.com" <chanho61.park@samsung.com>,
        "geunsik.lim@samsung.com" <geunsik.lim@samsung.com>,
        "sw0312.kim@samsung.com" <sw0312.kim@samsung.com>,
        "jh80.chung@samsung.com" <jh80.chung@samsung.com>,
        "a.kesavan@samsung.com" <a.kesavan@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        marc.zyngier@arm.com
Subject: Re: [PATCH 16/19] arm64: dts: exynos: Add dts files for 64-bit
 Exynos5433 SoC
References: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
 <1417073716-22997-17-git-send-email-cw00.choi@samsung.com>
 <20141127111834.GB857@leverpostej>
In-reply-to: <20141127111834.GB857@leverpostej>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsWyRsSkQFexrCLE4MA6M4vHaxYzWfyddIzd
	4v2yHkaLy/u1LeYfOcdq8WdCK5vFpPsTWCxu/GpjtehdcJXN4mzTG3aLKX+WM1lsenyN1eLy
	rjlsFjPO7wPqv/OPzWLp9YtMFqeuf2azOPymndVixuSXbBbHZixhtFi16w+jxcuPJ1gcxDzW
	zFvD6PH71yRGj52z7rJ73Lm2h81j85J6jysnmlg9+rasYvT4vEkugCOKyyYlNSezLLVI3y6B
	K+PCmyusBYujKlYt+cDcwPjXqouRk0NCwETi4f0/bBC2mMSFe+vBbCGBpYwSf+aJwtS0ti9l
	7mLkAopPZ5RYe+wuC4TzmlFi7oeHLCBVvAJaEv8OTgezWQRUJb6eXQY2iQ0ovv/FDTBbVCBM
	YuX0K1D1ghI/Jt8Ds0UE1CV6dn0Bs5kFLnFILPuuDGILC0RI7N17lwli2XJGiR9PfjGDJDgF
	9CVaP25lg2jQkdjfOg3KlpfYvOYt2KkSAic4JL4dX8MGcZGAxLfJh4A2cAAlZCU2HWCGeE1S
	4uCKGywTGMVmIblpFpKxs5CMXcDIvIpRNLUguaA4Kb3ISK84Mbe4NC9dLzk/dxMjMFGc/ves
	bwfjzQPWhxgFOBiVeHh//CsPEWJNLCuuzD3EaAp0xURmKdHkfGA6yiuJNzQ2M7IwNTE1NjK3
	NFMS502Q+hksJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgTF/ad9J/oNnM/f4qDSHBEX+fX53
	oUDLO9mNhxlbDKY8fPVvifQ53/wsUzGtgwpTTrqHr1M3n9r1qICvp4dTVaRydlrzzufVwedL
	JUU/VrufnqFQa37dT+O835yXzz1aXl1aXnUuZse9F3N0Nj758zFYXtjrxjejK3wbLFy7Wj5x
	KkVcE/zSpqfEUpyRaKjFXFScCAA61hXzDwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsVy+t9jQV3FsooQg8YGLYvHaxYzWfyddIzd
	4v2yHkaLy/u1LeYfOcdq8WdCK5vFpPsTWCxu/GpjtehdcJXN4mzTG3aLKX+WM1lsenyN1eLy
	rjlsFjPO7wPqv/OPzWLp9YtMFqeuf2azOPymndVixuSXbBbHZixhtFi16w+jxcuPJ1gcxDzW
	zFvD6PH71yRGj52z7rJ73Lm2h81j85J6jysnmlg9+rasYvT4vEkugCOqgdEmIzUxJbVIITUv
	OT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+g/JYWyxJxSoFBAYnGxkr4d
	pgmhIW66FjCNEbq+IUFwPUYGaCBhDWPGhTdXWAsWR1WsWvKBuYHxr1UXIyeHhICJRGv7UmYI
	W0ziwr31bF2MXBxCAtMZJdYeu8sC4bxmlJj74SELSBWvgJbEv4PTwWwWAVWJr2eXsYHYbEDx
	/S9ugNmiAmESK6dfgaoXlPgx+R6YLSKgLtGz6wuYzSxwiUNi2XdlEFtYIEJi7967TBDLljNK
	/HjyC+wkTgF9idaPW9kgGnQk9rdOg7LlJTavecs8gVFgFpIds5CUzUJStoCReRWjaGpBckFx
	UnqukV5xYm5xaV66XnJ+7iZGcCJ6Jr2DcVWDxSFGAQ5GJR7en//KQ4RYE8uKK3MPMUpwMCuJ
	8KaXVIQI8aYkVlalFuXHF5XmpBYfYjQFBsFEZinR5HxgkswriTc0NjEzsjQyN7QwMjZXEue9
	cTM3REggPbEkNTs1tSC1CKaPiYNTqoGxVuxvvLD1lIPHb67YWdjqK9mssua1q8OVoPZExx8R
	mXlnv220YTc9MN/D9ErxrKyNulyhCXvufaybpKHzfGaVFeNkB8m1n7JOr9k4y/PerbfarvJF
	SvUvJkxOyWi49erUF7MFu9z//rY8e8Dz6Fq24r+BUpscUioMeDLVQxknvlLb1PFOYkqIEktx
	RqKhFnNRcSIA0VUe9VoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mark,

On 11/27/2014 08:18 PM, Mark Rutland wrote:
> On Thu, Nov 27, 2014 at 07:35:13AM +0000, Chanwoo Choi wrote:
>> This patch adds new Exynos5433 dtsi to support 64-bit Exynos5433 SoC
>> based on Octal core CPUs (quad Cortex-A57 and quad Cortex-A53).
>>
>> Cc: Kukjin Kim <kgene.kim@samsung.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Olof Johansson <olof@lixom.net>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will.deacon@arm.com>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Inki Dae <inki.dae@samsung.com>
>> Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
>> ---
>>  arch/arm64/boot/dts/exynos/exynos5433-pinctrl.dtsi | 698 +++++++++++++++++++++
>>  arch/arm64/boot/dts/exynos/exynos5433.dtsi         | 523 +++++++++++++++
>>  2 files changed, 1221 insertions(+)
>>  create mode 100644 arch/arm64/boot/dts/exynos/exynos5433-pinctrl.dtsi
>>  create mode 100644 arch/arm64/boot/dts/exynos/exynos5433.dtsi
> 
> [...]
> 
>> diff --git a/arch/arm64/boot/dts/exynos/exynos5433.dtsi b/arch/arm64/boot/dts/exynos/exynos5433.dtsi
>> new file mode 100644
>> index 0000000..3d8b576
>> --- /dev/null
>> +++ b/arch/arm64/boot/dts/exynos/exynos5433.dtsi
>> @@ -0,0 +1,523 @@
>> +/*
>> + * Samsung's Exynos5433 SoC device tree source
>> + *
>> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
>> + *             http://www.samsung.com
>> + *
>> + * Samsung's Exynos5433 SoC device nodes are listed in this file. Exynos5433
>> + * based board files can include this file and provide values for board specfic
>> + * bindings.
>> + *
>> + * Note: This file does not include device nodes for all the controllers in
>> + * Exynos5433 SoC. As device tree coverage for Exynos5433 increases, additional
>> + * nodes can be added to this file.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include "skeleton.dtsi"
>> +#include <dt-bindings/clock/exynos5433.h>
>> +
> 
> Just to check: no memory reservations required for any reason?
> 
> There also don't appear to be any memory nodes. Typically if that's
> filled in by the bootloader/FW we'd have an empty node (or one with a
> zero size entry) and a comment regarding the FW.

I add the memory node to board dtsi file because memory information
is more dependent on on h/w target than SoC.

> 
>> +/ {
>> +       compatible = "samsung,exynos5433";
>> +       #address-cells = <1>;
>> +       #size-cells = <1>;
> 
> Not two, on both counts? The CPUs can address more than 32 bits.

You're right. I'll fix it as two and then retry to test it.

> 
> Is there nothing in the physical address space above 0xffffffff?
> 
> [...]
> 
>> +       cpus {
>> +               #address-cells = <2>;
>> +               #size-cells = <0>;
>> +
>> +               cpu0: cpu@100 {
>> +                       device_type = "cpu";
>> +                       compatible = "arm,cortex-a53", "arm,armv8";
>> +                       enable-method = "psci";
> 
> While the CPU nodes have enable-methods, I didn't spot a PSCI node
> anywhere, so this dts cannot possibly have been used to bring up an SMP
> system.
> 
> How has this dts been tested?
> 
> What PSCI revision have you implemented? Have have you tested it?

My mistake,
Exynos5433 supports PSCI v0.1. I'll add following PSCI nodes: 
I tested the boot of secondary cpu.

	psci {
		compatible = "arm,psci";
		method = "smc";
		cpu_off = <0x84000002>;
		cpu_on = <0xC4000003>;
	};

> 
> I take it from the presence of GICH/GICV in the gic node that CPUs enter
> the kernel at EL2?
> 
>> +                       reg = <0x0 0x100>;
>> +                       clock-frequency = <1050000000>;
> 
> What uses this?

It is un-used. I'll drop it.

> 
>> +               };
> 
> [...]
> 
>> +       soc: soc {
>> +               compatible = "simple-bus";
>> +               #address-cells = <1>;
>> +               #size-cells = <1>;
>> +               ranges;
>> +
>> +               fixed-rate-clocks {
>> +                       #address-cells = <1>;
>> +                       #size-cells = <0>;
>> +
>> +                       xusbxti: clock@0 {
>> +                               compatible = "fixed-clock";
>> +                               clock-output-names = "xusbxti";
>> +                               #clock-cells = <0>;
>> +                       };
>> +               };
> 
> Get rid of the fixed-rate-clocks container node. It's pointless and
> messy. Given you only have one there's no need for the bogus
> unit-address either.

OK, I'll remove unneeded code and will add following dt node for fin_pll.

	fin_pll: xxti {
		compatible = "fixed-clock";
		clock-output-names = "fin_pll";
		#clock-cells = <0>;
	};

> 
>> +
>> +               cmu_top: clock-controller@0x10030000{
> 
> s/@0x/@/ -- a unit-address should not have the leading '0x'. Please
> apply that to the rest of the file.

I'll remove '0x'.

> 
>> +                       compatible = "samsung,exynos5433-cmu-top";
>> +                       reg = <0x10030000 0x0c04>;
>> +                       #clock-cells = <1>;
>> +               };
> 
> [...]
> 
>> +               mct@101c0000 {
>> +                       compatible = "samsung,exynos4210-mct";
>> +                       reg = <0x101c0000 0x800>;
>> +                       interrupts = <0 102 0>, <0 103 0>, <0 104 0>, <0 105 0>,
>> +                               <0 106 0>, <0 107 0>, <0 108 0>, <0 109>,
>> +                               <0 110 0>, <0 111 0>, <0 112 0>, <0 113 0>;
>> +                       clocks = <&cmu_top CLK_FIN_PLL>, <&cmu_peris CLK_PCLK_MCT>;
>> +                       clock-names = "fin_pll", "mct";
>> +               };
> 
> Hase this block had no changes whatsoever since its use in Exynos4210?
> Do we not need a "samsung,exynos5433-mct" comaptible string too?

The type of Exynos5433's MCT(Multi-Core Timer) IP is the same with the type of Exynos4210 MCT.
Just Exynos5433 have eight local timer for Octa cores.

           CPU0       CPU1       CPU2       CPU3       CPU4       CPU5       CPU6       CPU7       
134:          0          0          0          0          0          0          0          0       GIC 134  mct_comp_irq
138:       3189          0          0          0          0          0          0          0       GIC 138  mct_tick0
139:          0       2670          0          0          0          0          0          0       GIC 139  mct_tick1
140:          0          0       2763          0          0          0          0          0       GIC 140  mct_tick2
141:          0          0          0       2732          0          0          0          0       GIC 141  mct_tick3
142:          0          0          0          0       2998          0          0          0       GIC 142  mct_tick4
143:          0          0          0          0          0       2664          0          0       GIC 143  mct_tick5
144:          0          0          0          0          0          0       2485          0       GIC 144  mct_tick6
145:          0          0          0          0          0          0          0       2681       GIC 145  mct_tick7

But, existing exynos-mct.c driver(drivers/clocksource/exynos-mct.c) used
'register_current_timer_delay()' function which is supported on arm 32bit.
I fix it as following diff and then I'll send it to support 64-bit Exynos SoC on exynos-mct.c.

 drivers/clocksource/Kconfig      | 1 -
 drivers/clocksource/exynos_mct.c | 4 ++++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 9042060..27ef3fa 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -134,7 +134,6 @@ config CLKSRC_METAG_GENERIC

 config CLKSRC_EXYNOS_MCT
        def_bool y if ARCH_EXYNOS
-       depends on !ARM64
        help
          Support for Multi Core Timer controller on Exynos SoCs.

diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
index 9403061..d9c7dbb 100644
--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -223,6 +223,7 @@ static u64 notrace exynos4_read_sched_clock(void)
        return exynos4_read_count_32();
 }

+#if !defined(CONFIG_ARM64)
 static struct delay_timer exynos4_delay_timer;

 static cycles_t exynos4_read_current_timer(void)
@@ -231,14 +232,17 @@ static cycles_t exynos4_read_current_timer(void)
                         "cycles_t needs to move to 32-bit for ARM64 usage");
        return exynos4_read_count_32();
 }
+#endif

 static void __init exynos4_clocksource_init(void)
 {
        exynos4_mct_frc_start();

+#if !defined(CONFIG_ARM64)
        exynos4_delay_timer.read_current_timer = &exynos4_read_current_timer;
        exynos4_delay_timer.freq = clk_rate;
        register_current_timer_delay(&exynos4_delay_timer);
+#endif

> 
>> +
>> +               gic:interrupt-controller@11001000 {
>> +                       compatible = "arm,cortex-a15-gic";
> 
> Given this is multi-cluster, surely this is an external GIC-400, for
> which we have a supported compatible string?
> 
> So this should at least be:
> 
> 	compatible = "arm,gic-400", "arm,cortex-a15-gic";

Exynos5433 used GIC-400. I'll modify it as following:

 	compatible = "arm,gic-400";

> 
>> +                       #interrupt-cells = <3>;
>> +                       interrupt-controller;
>> +                       reg =   <0x11001000 0x1000>,
>> +                               <0x11002000 0x1000>,
>> +                               <0x11004000 0x2000>,
>> +                               <0x11006000 0x2000>;
> 
> As far as I am aware, the GICC size is 8KiB. Regardless of whether we
> currently use the second page of registers, they should be described.

The GICC (CPU Interface Register) register of Exynos5433 is range of 0x1100_2000 ~ 0x1100_2100.
But, I'll modify GICC size from 4KiB to 8KiB as following according to your comment:
	<0x11002000 0x1000> -> <0x11002000 0x2000>

> 
>> +                       interrupts = <1 9 0xf04>;
>> +               };
>> +
>> +               serial_0: serial@14C10000 {
> 
> Nit: Please be consistent with capitalisation of hex. IMO it's better
> to leave it all lower-case.

I'll use the lower-case for all base address.

> 
> [...]
> 
>> +               timer {
>> +                       compatible = "arm,armv8-timer";
>> +                       interrupts = <1 13 0xff01>,
>> +                                    <1 14 0xff01>,
>> +                                    <1 11 0xff01>,
>> +                                    <1 10 0xff01>;
>> +                       clock-frequency = <24000000>;
>> +                       use-clocksource-only;
>> +                       use-physical-timer;
> 
> As Marc said, NAK for these last three properties.
> 
> There is no excuse for not setting CNTFRQ_EL0, especially given a PSCI
> implementation. The last two properties have never been supported in
> mainline, and shouldn't be necessary regardless.

OK, I'll remove last three properties.

Thanks for your review sincerely.

Best Regards,
Chanwoo Choi

