Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbaLACVx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 21:21:53 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:50741 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbaLACVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 21:21:50 -0500
X-AuditID: cbfee68f-f791c6d000004834-05-547bd0bbc8ba
Message-id: <547BD0BA.7080809@samsung.com>
Date: Mon, 01 Dec 2014 11:21:46 +0900
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
        Marc Zyngier <Marc.Zyngier@arm.com>
Subject: Re: [PATCH 16/19] arm64: dts: exynos: Add dts files for 64-bit
 Exynos5433 SoC
References: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
 <1417073716-22997-17-git-send-email-cw00.choi@samsung.com>
 <20141127111834.GB857@leverpostej> <54787621.4000503@samsung.com>
 <20141128140059.GH25883@leverpostej>
In-reply-to: <20141128140059.GH25883@leverpostej>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsWyRsSkUHf3heoQg187+C0er1nMZPF30jF2
	i/fLehgtLu/Xtph/5ByrxZ8JrWwWk+5PYLG48auN1aJ3wVU2i7NNb9gtpvxZzmSx6fE1VovL
	u+awWcw4vw+o/84/Noul1y8yWZy6/pnN4vCbdlaLGZNfslkcm7GE0WLVrj+MFi8/nmBxEPNY
	M28No8fvX5MYPXbOusvucefaHjaPzUvqPa6caGL16NuyitHj8ya5AI4oLpuU1JzMstQifbsE
	rowF1z8zFcyLr5j+/DFbA+NT+y5GTg4JAROJw2/3M0HYYhIX7q1n62Lk4hASWMooMe/3NCaY
	oj8/zjBBJBYxSrz6vQrKec0o8f/YL1aQKl4BLYmDaw+xg9gsAqoSPy98ZQSx2YDi+1/cYAOx
	RQXCJFZOv8ICUS8o8WPyPTBbREBdomfXFxaQocwCDzkkjh85DzZIWCBCYu/eu1Db3jJKzFyz
	lBkkwSlgKPF41yqwbmYBHYn9rdPYIGx5ic1r3jKDNEgIXOCQ2NaxiA3iJAGJb5MPATVwACVk
	JTYdYIb4TVLi4IobLBMYxWYhOWoWkrGzkIxdwMi8ilE0tSC5oDgpvchYrzgxt7g0L10vOT93
	EyMwWZz+96x/B+PdA9aHGAU4GJV4eCXmV4cIsSaWFVfmHmI0BbpiIrOUaHI+MCXllcQbGpsZ
	WZiamBobmVuaKYnzLpT6GSwkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBUV21MXrVW7F3u+dW
	HrKL1FnpFcdc2Txlr9XVlKMdy+e2lQdJL+L0XJG65EefVMTm3jBzrypjyY8MJ3ukfk+8ECfN
	c7Nq/pbM67PWn/N09PT5KJTc1cTSuHHz4rpf+ncv7rDIbDgiEjn1lMKGH6HqrQl8bYwXjQ6W
	znlyvPhRTaWn8oUVZg15SizFGYmGWsxFxYkAqz3Z9hEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBKsWRmVeSWpSXmKPExsVy+t9jAd3dF6pDDPa+ZrJ4vGYxk8XfScfY
	Ld4v62G0uLxf22L+kXOsFn8mtLJZTLo/gcXixq82VoveBVfZLM42vWG3mPJnOZPFpsfXWC0u
	75rDZjHj/D6g/jv/2CyWXr/IZHHq+mc2i8Nv2lktZkx+yWZxbMYSRotVu/4wWrz8eILFQcxj
	zbw1jB6/f01i9Ng56y67x51re9g8Ni+p97hyoonVo2/LKkaPz5vkAjiiGhhtMlITU1KLFFLz
	kvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4D+U1IoS8wpBQoFJBYXK+nb
	YZoQGuKmawHTGKHrGxIE12NkgAYS1jBmLLj+malgXnzF9OeP2RoYn9p3MXJySAiYSPz5cYYJ
	whaTuHBvPVsXIxeHkMAiRolXv1cxQTivGSX+H/vFClLFK6AlcXDtIXYQm0VAVeLnha+MIDYb
	UHz/ixtsILaoQJjEyulXWCDqBSV+TL4HZosIqEv07PrCAjKUWeAhh8TxI+fBBgkLREjs3XsX
	attbRomZa5YygyQ4BQwlHu9aBdbNLKAjsb91GhuELS+xec1b5gmMArOQLJmFpGwWkrIFjMyr
	GEVTC5ILipPScw31ihNzi0vz0vWS83M3MYJT0TOpHYwrGywOMQpwMCrx8B6cUx0ixJpYVlyZ
	e4hRgoNZSYT3nAdQiDclsbIqtSg/vqg0J7X4EKMpMAwmMkuJJucD02ReSbyhsYmZkaWRuaGF
	kbG5kjjvjZu5IUIC6YklqdmpqQWpRTB9TBycUg2MxX9Wrv0h2ldv9+D5Ru4u5psn2Cd/auqZ
	XsJd8IyN7S/j+Qedp+qmmUpIyIY+TzisXnEkTrlVpPb6SymnRl+x+rzWSw3B3gIqu/K0jU4t
	u2+yQGb75tB3jzOLLolbRLDqhISkuR5cd9aGr2VfcJzoz7X6kn97pEWjJQ6IffM+mPeuJ3Jz
	zV0lluKMREMt5qLiRAC/TzhpWwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mark,

On 11/28/2014 11:00 PM, Mark Rutland wrote:
> On Fri, Nov 28, 2014 at 01:18:25PM +0000, Chanwoo Choi wrote:
>> Dear Mark,
>>
>> On 11/27/2014 08:18 PM, Mark Rutland wrote:
>>> On Thu, Nov 27, 2014 at 07:35:13AM +0000, Chanwoo Choi wrote:
>>>> This patch adds new Exynos5433 dtsi to support 64-bit Exynos5433 SoC
>>>> based on Octal core CPUs (quad Cortex-A57 and quad Cortex-A53).
>>>>
>>>> Cc: Kukjin Kim <kgene.kim@samsung.com>
>>>> Cc: Mark Rutland <mark.rutland@arm.com>
>>>> Cc: Arnd Bergmann <arnd@arndb.de>
>>>> Cc: Olof Johansson <olof@lixom.net>
>>>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>>>> Cc: Will Deacon <will.deacon@arm.com>
>>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>>> Acked-by: Inki Dae <inki.dae@samsung.com>
>>>> Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
>>>> ---
>>>>  arch/arm64/boot/dts/exynos/exynos5433-pinctrl.dtsi | 698 +++++++++++++++++++++
>>>>  arch/arm64/boot/dts/exynos/exynos5433.dtsi         | 523 +++++++++++++++
>>>>  2 files changed, 1221 insertions(+)
>>>>  create mode 100644 arch/arm64/boot/dts/exynos/exynos5433-pinctrl.dtsi
>>>>  create mode 100644 arch/arm64/boot/dts/exynos/exynos5433.dtsi
>>>
> 
> [...]
> 
>>>> +       cpus {
>>>> +               #address-cells = <2>;
>>>> +               #size-cells = <0>;
>>>> +
>>>> +               cpu0: cpu@100 {
>>>> +                       device_type = "cpu";
>>>> +                       compatible = "arm,cortex-a53", "arm,armv8";
>>>> +                       enable-method = "psci";
>>>
>>> While the CPU nodes have enable-methods, I didn't spot a PSCI node
>>> anywhere, so this dts cannot possibly have been used to bring up an SMP
>>> system.
>>>
>>> How has this dts been tested?
>>>
>>> What PSCI revision have you implemented? Have have you tested it?
>>
>> My mistake,
>> Exynos5433 supports PSCI v0.1. I'll add following PSCI nodes:
>> I tested the boot of secondary cpu.
>>
>>         psci {
>>                 compatible = "arm,psci";
>>                 method = "smc";
>>                 cpu_off = <0x84000002>;
>>                 cpu_on = <0xC4000003>;
>>         };
> 
> Ok. I take it _any_ CPU may be hotplugged (including CPU0), given that
> you don't have MIGRATE_INFO_TYPE from PSCI 0.2 to tell you that this is
> not possible? If not, attempting to hotplug CPU0 will result in a BUG()
> and the kernel will explode.
> 
> Has that been tested? 

I just tested secondary CPU on during kernel booting after added 'psci' dt node.
So, I got the ON state of Octa CPUs.

Maybe I need more time to implement CPU0 and secondary cpu hotplugged dynamically on runtime.

> 
> Do all CPUs enter the kernel at EL2?

I didn't consider EL2 for hypervisor mode.
First role of this job, I'll implement CPU on/off and suspend by using PSCI.

> 
>>>> +       soc: soc {
>>>> +               compatible = "simple-bus";
>>>> +               #address-cells = <1>;
>>>> +               #size-cells = <1>;
>>>> +               ranges;
>>>> +
>>>> +               fixed-rate-clocks {
>>>> +                       #address-cells = <1>;
>>>> +                       #size-cells = <0>;
>>>> +
>>>> +                       xusbxti: clock@0 {
>>>> +                               compatible = "fixed-clock";
>>>> +                               clock-output-names = "xusbxti";
>>>> +                               #clock-cells = <0>;
>>>> +                       };
>>>> +               };
>>>
>>> Get rid of the fixed-rate-clocks container node. It's pointless and
>>> messy. Given you only have one there's no need for the bogus
>>> unit-address either.
>>
>> OK, I'll remove unneeded code and will add following dt node for fin_pll.
>>
>>         fin_pll: xxti {
>>                 compatible = "fixed-clock";
>>                 clock-output-names = "fin_pll";
>>                 #clock-cells = <0>;
>>         };
> 
> That looks fine to me.
> 
> [...]
> 
>>>> +               mct@101c0000 {
>>>> +                       compatible = "samsung,exynos4210-mct";
>>>> +                       reg = <0x101c0000 0x800>;
>>>> +                       interrupts = <0 102 0>, <0 103 0>, <0 104 0>, <0 105 0>,
>>>> +                               <0 106 0>, <0 107 0>, <0 108 0>, <0 109>,
>>>> +                               <0 110 0>, <0 111 0>, <0 112 0>, <0 113 0>;
>>>> +                       clocks = <&cmu_top CLK_FIN_PLL>, <&cmu_peris CLK_PCLK_MCT>;
>>>> +                       clock-names = "fin_pll", "mct";
>>>> +               };
>>>
>>> Hase this block had no changes whatsoever since its use in Exynos4210?
>>> Do we not need a "samsung,exynos5433-mct" comaptible string too?
>>
>> The type of Exynos5433's MCT(Multi-Core Timer) IP is the same with the type of Exynos4210 MCT.
>> Just Exynos5433 have eight local timer for Octa cores.
> 
> So "samsung,exynos4210-mct" should appear in the list. I'm just
> wondering if it's worth having:
> 
> 	compatible = "samsung,exynos5433-mct", "samsung,exynos4210-mct";
> 
> Just in case we need to special-case the 5433 MCT for some reason later.

OK, I'll add "samsung,exynos5433-mct" compatible string in exynos5433.dtsi
according to your comment.

> 
>>
>>            CPU0       CPU1       CPU2       CPU3       CPU4       CPU5       CPU6       CPU7
>> 134:          0          0          0          0          0          0          0          0       GIC 134  mct_comp_irq
>> 138:       3189          0          0          0          0          0          0          0       GIC 138  mct_tick0
>> 139:          0       2670          0          0          0          0          0          0       GIC 139  mct_tick1
>> 140:          0          0       2763          0          0          0          0          0       GIC 140  mct_tick2
>> 141:          0          0          0       2732          0          0          0          0       GIC 141  mct_tick3
>> 142:          0          0          0          0       2998          0          0          0       GIC 142  mct_tick4
>> 143:          0          0          0          0          0       2664          0          0       GIC 143  mct_tick5
>> 144:          0          0          0          0          0          0       2485          0       GIC 144  mct_tick6
>> 145:          0          0          0          0          0          0          0       2681       GIC 145  mct_tick7
>>
>> But, existing exynos-mct.c driver(drivers/clocksource/exynos-mct.c) used
>> 'register_current_timer_delay()' function which is supported on arm 32bit.
>> I fix it as following diff and then I'll send it to support 64-bit Exynos SoC on exynos-mct.c.
>>
>>  drivers/clocksource/Kconfig      | 1 -
>>  drivers/clocksource/exynos_mct.c | 4 ++++
>>  2 files changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
>> index 9042060..27ef3fa 100644
>> --- a/drivers/clocksource/Kconfig
>> +++ b/drivers/clocksource/Kconfig
>> @@ -134,7 +134,6 @@ config CLKSRC_METAG_GENERIC
>>
>>  config CLKSRC_EXYNOS_MCT
>>         def_bool y if ARCH_EXYNOS
>> -       depends on !ARM64
>>         help
>>           Support for Multi Core Timer controller on Exynos SoCs.
>>
>> diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
>> index 9403061..d9c7dbb 100644
>> --- a/drivers/clocksource/exynos_mct.c
>> +++ b/drivers/clocksource/exynos_mct.c
>> @@ -223,6 +223,7 @@ static u64 notrace exynos4_read_sched_clock(void)
>>         return exynos4_read_count_32();
>>  }
>>
>> +#if !defined(CONFIG_ARM64)
>>  static struct delay_timer exynos4_delay_timer;
>>
>>  static cycles_t exynos4_read_current_timer(void)
>> @@ -231,14 +232,17 @@ static cycles_t exynos4_read_current_timer(void)
>>                          "cycles_t needs to move to 32-bit for ARM64 usage");
>>         return exynos4_read_count_32();
>>  }
>> +#endif
>>
>>  static void __init exynos4_clocksource_init(void)
>>  {
>>         exynos4_mct_frc_start();
>>
>> +#if !defined(CONFIG_ARM64)
>>         exynos4_delay_timer.read_current_timer = &exynos4_read_current_timer;
>>         exynos4_delay_timer.freq = clk_rate;
>>         register_current_timer_delay(&exynos4_delay_timer);
>> +#endif
> 
> Why not make both of these depend on CONFIG_ARM, rather than
> !CONFIG_ARM64? We care about the presence of the delay_timer struct and
> functions, which (from grepping around) exist in arch/arm and nowhere
> else.

You're right.
I'll fix it by using CONFIG_ARM instead of !CONFIG_ARM64.

> 
>>>> +               gic:interrupt-controller@11001000 {
>>>> +                       compatible = "arm,cortex-a15-gic";
>>>
>>> Given this is multi-cluster, surely this is an external GIC-400, for
>>> which we have a supported compatible string?
>>>
>>> So this should at least be:
>>>
>>>       compatible = "arm,gic-400", "arm,cortex-a15-gic";
>>
>> Exynos5433 used GIC-400. I'll modify it as following:
>>
>>         compatible = "arm,gic-400";
> 
> Ok. The former variant (with "arm,cortex-a15-gic" later in the list) has
> the benefit of working with KVM today (which doesn't currently look for
> "arm,gic-400").
> 
>>>> +                       #interrupt-cells = <3>;
>>>> +                       interrupt-controller;
>>>> +                       reg =   <0x11001000 0x1000>,
>>>> +                               <0x11002000 0x1000>,
>>>> +                               <0x11004000 0x2000>,
>>>> +                               <0x11006000 0x2000>;
>>>
>>> As far as I am aware, the GICC size is 8KiB. Regardless of whether we
>>> currently use the second page of registers, they should be described.
>>
>> The GICC (CPU Interface Register) register of Exynos5433 is range of 0x1100_2000 ~ 0x1100_2100.
> 
> That does not sound right. Per the GICv2 architecture, GICC is at least
> 0x1004 bytes long (as GICC_DIR lives at offset 0x1000).

You're right. I replied it on below .

> 
>> But, I'll modify GICC size from 4KiB to 8KiB as following according to your comment:
>>         <0x11002000 0x1000> -> <0x11002000 0x2000>
> 
> To clarify: is GICC_DIR accessible in Exynos5433 systems, or is
> everything past offset 0x100 not physically mapped?
> 

I checked the base address of GICC_DIR on Exynos3250/Exynos5433/Exynos7 using gic-400.

GICC_DIR is 1048_3000 on Exynos3250.
GICC_DIR is 1100_2100 on Exynos5433.
GICC_DIR is 1100_2100 on Exynos7.

I think that TRM includes incorrect base address of GICC_DIR on Exynos5433/Exynos7.
GICC_DIR of Exynos3250 is GICC_DIR is 1048_2000 + 0x1000 offset as you commented.

Thanks for your review.

Best Regards,
Chanwoo Choi


>>>> +                       interrupts = <1 9 0xf04>;
>>>> +               };
>>>> +
>>>> +               serial_0: serial@14C10000 {
>>>
>>> Nit: Please be consistent with capitalisation of hex. IMO it's better
>>> to leave it all lower-case.
>>
>> I'll use the lower-case for all base address.
> 
> Thanks.
> 
>>
>>>
>>> [...]
>>>
>>>> +               timer {
>>>> +                       compatible = "arm,armv8-timer";
>>>> +                       interrupts = <1 13 0xff01>,
>>>> +                                    <1 14 0xff01>,
>>>> +                                    <1 11 0xff01>,
>>>> +                                    <1 10 0xff01>;
>>>> +                       clock-frequency = <24000000>;
>>>> +                       use-clocksource-only;
>>>> +                       use-physical-timer;
>>>
>>> As Marc said, NAK for these last three properties.
>>>
>>> There is no excuse for not setting CNTFRQ_EL0, especially given a PSCI
>>> implementation. The last two properties have never been supported in
>>> mainline, and shouldn't be necessary regardless.
>>
>> OK, I'll remove last three properties.
> 
> Thanks.
> 
> Mark.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

