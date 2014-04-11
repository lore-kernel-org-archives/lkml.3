Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbaDKIj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 04:39:28 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43013 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbaDKIjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 04:39:24 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-72-5347aa3a59a7
Message-id: <5347AA35.4010504@samsung.com>
Date: Fri, 11 Apr 2014 10:39:17 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>
Cc: kgene.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 01/27] ARM: EXYNOS: Add Exynos3250 SoC ID
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
 <1397122658-16013-2-git-send-email-cw00.choi@samsung.com>
 <20140411014650.GB14934@quad.lixom.net> <53478C75.60302@samsung.com>
In-reply-to: <53478C75.60302@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t/xq7pWq9yDDTZOYrK4/uU5q8XnDy3s
	FpPuT2Cx6F1wlc3ibNMbdotNj6+xWlzeNYfNYsb5fUwWp65/BrImv2Sz2LtzMqMDt8fmJfUe
	V040sXr0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxsJntxgLvutULDs2h72B8YdKFyMHh4SA
	icSlWcldjJxAppjEhXvr2boYuTiEBJYySmz/c50RJCEk8JlRYupaERCbV0BLYvOyZrA4i4Cq
	RNezNjYQm01ATeJzwyMwmx+oZk3TdRYQW1QgQuJe42FWiF5BiR+T74HFRQQ8JZ783cUIsoxZ
	4B+jxPkV25lAEsICthInb9xngVh8glHi6TE/EJtTQFPi6uH1YIuZBawlVk7aBmXLS2xe85Z5
	AqPgLCQ7ZiEpm4WkbAEj8ypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkMj4soNx8TGrQ4wC
	HIxKPLwHLrkFC7EmlhVX5h5ilOBgVhLhfbbMPViINyWxsiq1KD++qDQntfgQIxMHp1QDIzPP
	puiTCwKNSn1uixe53VkVIJ0j1Fj1e/JZ0dbLC5KC5ywSeiLJ4LpF/73L07eHD5/4Y8pud+77
	pGWHY7nv+s5YVP6nrNF/5prQw9tfSb/rFZ72v+Tin4szNqQYTmk9N/nXzhtGGUvWqVQ9e/e5
	OvCQ55cS6R+P3Ku379OfZtD2UulSaEqo3kklluKMREMt5qLiRADnD2k5agIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.04.2014 08:32, Chanwoo Choi wrote:
> Hi,
>
> On 04/11/2014 10:46 AM, Olof Johansson wrote:
>> On Thu, Apr 10, 2014 at 06:37:12PM +0900, Chanwoo Choi wrote:
>>> This patch add Exynos3250's SoC ID. Exynos 3250 is System-On-Chip(SoC) that
>>> is based on the 32-bit RISC processor for Smartphone. Exynos3250 uses Cortex-A7
>>> dual cores and has a target speed of 1.0GHz.
>>>
>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>> ---
>>>   arch/arm/mach-exynos/Kconfig             | 22 ++++++++++++++++++++++
>>>   arch/arm/mach-exynos/exynos.c            |  1 +
>>>   arch/arm/plat-samsung/include/plat/cpu.h | 10 ++++++++++
>>>   3 files changed, 33 insertions(+)
>>>
>>> diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
>>> index fc8bf18..6da8a68 100644
>>> --- a/arch/arm/mach-exynos/Kconfig
>>> +++ b/arch/arm/mach-exynos/Kconfig
>>> @@ -11,6 +11,17 @@ if ARCH_EXYNOS
>>>
>>>   menu "SAMSUNG EXYNOS SoCs Support"
>>>
>>> +config ARCH_EXYNOS3
>>> +	bool "SAMSUNG EXYNOS3"
>>> +	select ARM_AMBA
>>> +	select CLKSRC_OF
>>> +	select HAVE_ARM_SCU if SMP
>>> +	select HAVE_SMP
>>> +	select PINCTRL
>>> +	select PM_GENERIC_DOMAINS if PM_RUNTIME
>>> +	help
>>> +	  Samsung EXYNOS3 SoCs based systems
>>> +
>>>   config ARCH_EXYNOS4
>>>   	bool "SAMSUNG EXYNOS4"
>>>   	default y
>>> @@ -41,6 +52,17 @@ config ARCH_EXYNOS5
>>>
>>>   comment "EXYNOS SoCs"
>>>
>>> +config SOC_EXYNOS3250
>>> +	bool "SAMSUNG EXYNOS3250"
>>> +	default y
>>> +	depends on ARCH_EXYNOS3
>>> +	select ARCH_HAS_BANDGAP
>>> +	select ARM_CPU_SUSPEND if PM
>>> +	select PINCTRL_EXYNOS
>>> +	select SAMSUNG_DMADEV
>>> +	help
>>> +	  Enable EXYNOS3250 CPU support
>>> +
>>>   config CPU_EXYNOS4210
>>>   	bool "SAMSUNG EXYNOS4210"
>>>   	default y
>>> diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
>>> index b32a907..b134868 100644
>>> --- a/arch/arm/mach-exynos/exynos.c
>>> +++ b/arch/arm/mach-exynos/exynos.c
>>> @@ -370,6 +370,7 @@ static void __init exynos_dt_machine_init(void)
>>>   }
>>>
>>>   static char const *exynos_dt_compat[] __initconst = {
>>> +	"samsung,exynos3250",
>>
>> Please consider samsung,exynos3 instead, so you don't have to update this table
>> for every SoC. We've talked about this before..
>
> This patchset included only exynos3250.dtsi without exynos3.dtsi.
> So, I added only "samsung,exynos3250" compatible name.

There is no direct relation between dts file names and compatible string 
(although usually they correspond). You don't need exynos3.dtsi (at 
least until another SoC from this family shows up).

>
> Do you prefer to add SoC version as following?
> +       "samsung,exynos3",
> +       "samsung,exynos3250",
>
> or ?
> +       "samsung,exynos3",

This is actually a good question. If adding exynos3 anyway, it probably 
wouldn't hurt to add exynos3250 anyway, to avoid adding it in future if 
some SoC specific quirks show up, especially when both of compatible 
strings need to be documented anyway.

>
>>
>>>   	"samsung,exynos4",
>>>   	"samsung,exynos4210",
>>>   	"samsung,exynos4212",
>>> diff --git a/arch/arm/plat-samsung/include/plat/cpu.h b/arch/arm/plat-samsung/include/plat/cpu.h
>>> index 5992b8d..3d808f6b 100644
>>> --- a/arch/arm/plat-samsung/include/plat/cpu.h
>>> +++ b/arch/arm/plat-samsung/include/plat/cpu.h
>>> @@ -43,6 +43,9 @@ extern unsigned long samsung_cpu_id;
>>>   #define S5PV210_CPU_ID		0x43110000
>>>   #define S5PV210_CPU_MASK	0xFFFFF000
>>>
>>> +#define EXYNOS3250_SOC_ID       0xE3472000
>>> +#define EXYNOS3_SOC_MASK        0xFFFFF000
>>> +
>>>   #define EXYNOS4210_CPU_ID	0x43210000
>>>   #define EXYNOS4212_CPU_ID	0x43220000
>>>   #define EXYNOS4412_CPU_ID	0xE4412200
>>> @@ -68,6 +71,7 @@ IS_SAMSUNG_CPU(s5p6440, S5P6440_CPU_ID, S5P64XX_CPU_MASK)
>>>   IS_SAMSUNG_CPU(s5p6450, S5P6450_CPU_ID, S5P64XX_CPU_MASK)
>>>   IS_SAMSUNG_CPU(s5pc100, S5PC100_CPU_ID, S5PC100_CPU_MASK)
>>>   IS_SAMSUNG_CPU(s5pv210, S5PV210_CPU_ID, S5PV210_CPU_MASK)
>>> +IS_SAMSUNG_CPU(exynos3250, EXYNOS3250_SOC_ID, EXYNOS3_SOC_MASK)
>>>   IS_SAMSUNG_CPU(exynos4210, EXYNOS4210_CPU_ID, EXYNOS4_CPU_MASK)
>>>   IS_SAMSUNG_CPU(exynos4212, EXYNOS4212_CPU_ID, EXYNOS4_CPU_MASK)
>>>   IS_SAMSUNG_CPU(exynos4412, EXYNOS4412_CPU_ID, EXYNOS4_CPU_MASK)
>>> @@ -126,6 +130,12 @@ IS_SAMSUNG_CPU(exynos5440, EXYNOS5440_SOC_ID, EXYNOS5_SOC_MASK)
>>>   # define soc_is_s5pv210()	0
>>>   #endif
>>>
>>> +#if defined(CONFIG_SOC_EXYNOS3250)
>>> +# define soc_is_exynos3250()    is_samsung_exynos3250()
>>> +#else
>>> +# define soc_is_exynos3250()    0
>>> +#endif
>>
>> In general, I think we have too much code littered with soc_is_<foo>() going
>> on, so please try to avoid adding more for this SoC. Especially in cases where
>> you just want to bail out of certain features where we might already have
>> function pointers to control if a function is called or not, such as the
>> firmware interfaces.
>>
>
> Do you prefer dt helper function such as following function instead of new soc_is_xx() ?
> - of_machine_is_compatible("samsung,exynos3250")
>
> If you are OK, I'll use of_machine_is_compatible() instead of soc_is_xx().

First of all, there is still a lot of code in mach-exynos/ using the 
soc_is_xx() macros, so having some SoCs use them and other SoCs use 
of_machine_is_compatible() wouldn't make the code cleaner.

For now, I wouldn't mind adding soc_is_exynos3250(), but in general such 
code surrounded with if (soc_is_xx()) blocks should be reworked to use 
something better, for example function pointers, as Olof suggested.

Best regards,
Tomasz
