Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaDNFNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 01:13:54 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:35878 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaDNFNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 01:13:49 -0400
X-AuditID: cbfee68e-b7f566d000002344-cf-534b6e8b1858
Message-id: <534B6E8E.20506@samsung.com>
Date: Mon, 14 Apr 2014 14:13:50 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Tomasz Figa <t.figa@samsung.com>, Olof Johansson <olof@lixom.net>
Cc: kgene.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 01/27] ARM: EXYNOS: Add Exynos3250 SoC ID
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
 <1397122658-16013-2-git-send-email-cw00.choi@samsung.com>
 <20140411014650.GB14934@quad.lixom.net> <53478C75.60302@samsung.com>
 <5347AA35.4010504@samsung.com>
In-reply-to: <5347AA35.4010504@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsWyRsSkULc7zzvYYP1hDYvPH1rYLSbdn8Bi
	0bvgKpvF2aY37BabHl9jtbi8aw6bxYzz+5gsTl3/DGRNfslmsX7GaxaLvTsnMzpwe2xeUu9x
	5UQTq0ffllWMHp83yQWwRHHZpKTmZJalFunbJXBl3Gh7xFiwx6bi7OOQBsY5hl2MnBwSAiYS
	TTevMULYYhIX7q1n62Lk4hASWMoocba/gR2m6OLjeawQiUWMEp/+v2WGcF4zSqydvI0JpIpX
	QENi9el1rCA2i4CqxI+9D8DGsgloSex/cYMNxBYVCJNYOf0KC0S9oMSPyffAbBEBV4lHi48y
	ggxlFvjHKHF+xXawocICthInb9xngdj2klHiz9T3YBs4BbQlHp5ZB9bNLKAjsb91GhuELS+x
	eQ3EeRICL9klOq7MY4Q4SUDi2+RDQA0cQAlZiU0HmCF+k5Q4uOIGywRGsVlIjpqFZOwsJGMX
	MDKvYhRNLUguKE5KLzLSK07MLS7NS9dLzs/dxAiMy9P/nvXtYLx5wPoQYzLQyonMUqLJ+cC4
	ziuJNzQ2M7IwNTE1NjK3NCNNWEmcd9HDpCAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjKpu
	xxl6uQLLX3FPfHHtO2toSB0nc/gb81kTvD6s3dcbHPO26423n2Jp5aSi/n0f7C9or8+9Lch9
	SW7zdb4DdvpOsQFzm4RmvN6zq9zlFtfcKSa863Sm6d86oysceupHblX63DsbU4/bXZ65b8vU
	b2tfrHXaHlbo/GCZZubizszlk29J62dK+SqxFGckGmoxFxUnAgBDv7GP4QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t9jAd3uPO9gg30T5Sw+f2hht5h0fwKL
	Re+Cq2wWZ5vesFtsenyN1eLyrjlsFjPO72OyOHX9M5A1+SWbxfoZr1ks9u6czOjA7bF5Sb3H
	lRNNrB59W1YxenzeJBfAEtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCX
	mJtqq+TiE6DrlpkDdJWSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMeNG
	2yPGgj02FWcfhzQwzjHsYuTkkBAwkbj4eB4rhC0mceHeerYuRi4OIYFFjBKf/r9lhnBeM0qs
	nbyNCaSKV0BDYvXpdWAdLAKqEj/2PmAEsdkEtCT2v7jBBmKLCoRJrJx+hQWiXlDix+R7YLaI
	gKvEo8VHGUGGMgv8Y5Q4v2I72FBhAVuJkzfus0Bse8ko8Wfqe7ANnALaEg/PrAPrZhbQkdjf
	Oo0NwpaX2LzmLfMERoFZSJbMQlI2C0nZAkbmVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjB
	Uf9MagfjygaLQ4wCHIxKPLwJ2z2DhVgTy4orcw8xSnAwK4nwbsvwChbiTUmsrEotyo8vKs1J
	LT7EmAwMg4nMUqLJ+cCElFcSb2hsYmZkaWRuaGFkbE6asJI474FW60AhgfTEktTs1NSC1CKY
	LUwcnFINjH7bkyRWHl4zQ0XZKidtYd6treEC392N+Db17HBO0Qk+v8koNv1Sv8pXtzsixp8r
	TjcsNGS636dQHSvz+iubSOPq5BUHfvSs6xTWetqz8tm19SE3ap6HrP9/dtZR+f8nPnVMPHBw
	xvFv6b23zQsn8joUpThLcMUuinjrcOro2cKD5tOiny/bGKLEUpyRaKjFXFScCADryBWDPgMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Olof and Tomasz,

On 04/11/2014 05:39 PM, Tomasz Figa wrote:
> On 11.04.2014 08:32, Chanwoo Choi wrote:
>> Hi,
>>
>> On 04/11/2014 10:46 AM, Olof Johansson wrote:
>>> On Thu, Apr 10, 2014 at 06:37:12PM +0900, Chanwoo Choi wrote:
>>>> This patch add Exynos3250's SoC ID. Exynos 3250 is System-On-Chip(SoC) that
>>>> is based on the 32-bit RISC processor for Smartphone. Exynos3250 uses Cortex-A7
>>>> dual cores and has a target speed of 1.0GHz.
>>>>
>>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>> ---
>>>>   arch/arm/mach-exynos/Kconfig             | 22 ++++++++++++++++++++++
>>>>   arch/arm/mach-exynos/exynos.c            |  1 +
>>>>   arch/arm/plat-samsung/include/plat/cpu.h | 10 ++++++++++
>>>>   3 files changed, 33 insertions(+)
>>>>
>>>> diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
>>>> index fc8bf18..6da8a68 100644
>>>> --- a/arch/arm/mach-exynos/Kconfig
>>>> +++ b/arch/arm/mach-exynos/Kconfig
>>>> @@ -11,6 +11,17 @@ if ARCH_EXYNOS
>>>>
>>>>   menu "SAMSUNG EXYNOS SoCs Support"
>>>>
>>>> +config ARCH_EXYNOS3
>>>> +    bool "SAMSUNG EXYNOS3"
>>>> +    select ARM_AMBA
>>>> +    select CLKSRC_OF
>>>> +    select HAVE_ARM_SCU if SMP
>>>> +    select HAVE_SMP
>>>> +    select PINCTRL
>>>> +    select PM_GENERIC_DOMAINS if PM_RUNTIME
>>>> +    help
>>>> +      Samsung EXYNOS3 SoCs based systems
>>>> +
>>>>   config ARCH_EXYNOS4
>>>>       bool "SAMSUNG EXYNOS4"
>>>>       default y
>>>> @@ -41,6 +52,17 @@ config ARCH_EXYNOS5
>>>>
>>>>   comment "EXYNOS SoCs"
>>>>
>>>> +config SOC_EXYNOS3250
>>>> +    bool "SAMSUNG EXYNOS3250"
>>>> +    default y
>>>> +    depends on ARCH_EXYNOS3
>>>> +    select ARCH_HAS_BANDGAP
>>>> +    select ARM_CPU_SUSPEND if PM
>>>> +    select PINCTRL_EXYNOS
>>>> +    select SAMSUNG_DMADEV
>>>> +    help
>>>> +      Enable EXYNOS3250 CPU support
>>>> +
>>>>   config CPU_EXYNOS4210
>>>>       bool "SAMSUNG EXYNOS4210"
>>>>       default y
>>>> diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
>>>> index b32a907..b134868 100644
>>>> --- a/arch/arm/mach-exynos/exynos.c
>>>> +++ b/arch/arm/mach-exynos/exynos.c
>>>> @@ -370,6 +370,7 @@ static void __init exynos_dt_machine_init(void)
>>>>   }
>>>>
>>>>   static char const *exynos_dt_compat[] __initconst = {
>>>> +    "samsung,exynos3250",
>>>
>>> Please consider samsung,exynos3 instead, so you don't have to update this table
>>> for every SoC. We've talked about this before..
>>
>> This patchset included only exynos3250.dtsi without exynos3.dtsi.
>> So, I added only "samsung,exynos3250" compatible name.
> 
> There is no direct relation between dts file names and compatible string (although usually they correspond). You don't need exynos3.dtsi (at least until another SoC from this family shows up).
> 
>>
>> Do you prefer to add SoC version as following?
>> +       "samsung,exynos3",
>> +       "samsung,exynos3250",
>>
>> or ?
>> +       "samsung,exynos3",
> 
> This is actually a good question. If adding exynos3 anyway, it probably wouldn't hurt to add exynos3250 anyway, to avoid adding it in future if some SoC specific quirks show up, especially when both of compatible strings need to be documented anyway.
> 
>>
>>>
>>>>       "samsung,exynos4",
>>>>       "samsung,exynos4210",
>>>>       "samsung,exynos4212",
>>>> diff --git a/arch/arm/plat-samsung/include/plat/cpu.h b/arch/arm/plat-samsung/include/plat/cpu.h
>>>> index 5992b8d..3d808f6b 100644
>>>> --- a/arch/arm/plat-samsung/include/plat/cpu.h
>>>> +++ b/arch/arm/plat-samsung/include/plat/cpu.h
>>>> @@ -43,6 +43,9 @@ extern unsigned long samsung_cpu_id;
>>>>   #define S5PV210_CPU_ID        0x43110000
>>>>   #define S5PV210_CPU_MASK    0xFFFFF000
>>>>
>>>> +#define EXYNOS3250_SOC_ID       0xE3472000
>>>> +#define EXYNOS3_SOC_MASK        0xFFFFF000
>>>> +
>>>>   #define EXYNOS4210_CPU_ID    0x43210000
>>>>   #define EXYNOS4212_CPU_ID    0x43220000
>>>>   #define EXYNOS4412_CPU_ID    0xE4412200
>>>> @@ -68,6 +71,7 @@ IS_SAMSUNG_CPU(s5p6440, S5P6440_CPU_ID, S5P64XX_CPU_MASK)
>>>>   IS_SAMSUNG_CPU(s5p6450, S5P6450_CPU_ID, S5P64XX_CPU_MASK)
>>>>   IS_SAMSUNG_CPU(s5pc100, S5PC100_CPU_ID, S5PC100_CPU_MASK)
>>>>   IS_SAMSUNG_CPU(s5pv210, S5PV210_CPU_ID, S5PV210_CPU_MASK)
>>>> +IS_SAMSUNG_CPU(exynos3250, EXYNOS3250_SOC_ID, EXYNOS3_SOC_MASK)
>>>>   IS_SAMSUNG_CPU(exynos4210, EXYNOS4210_CPU_ID, EXYNOS4_CPU_MASK)
>>>>   IS_SAMSUNG_CPU(exynos4212, EXYNOS4212_CPU_ID, EXYNOS4_CPU_MASK)
>>>>   IS_SAMSUNG_CPU(exynos4412, EXYNOS4412_CPU_ID, EXYNOS4_CPU_MASK)
>>>> @@ -126,6 +130,12 @@ IS_SAMSUNG_CPU(exynos5440, EXYNOS5440_SOC_ID, EXYNOS5_SOC_MASK)
>>>>   # define soc_is_s5pv210()    0
>>>>   #endif
>>>>
>>>> +#if defined(CONFIG_SOC_EXYNOS3250)
>>>> +# define soc_is_exynos3250()    is_samsung_exynos3250()
>>>> +#else
>>>> +# define soc_is_exynos3250()    0
>>>> +#endif
>>>
>>> In general, I think we have too much code littered with soc_is_<foo>() going
>>> on, so please try to avoid adding more for this SoC. Especially in cases where
>>> you just want to bail out of certain features where we might already have
>>> function pointers to control if a function is called or not, such as the
>>> firmware interfaces.
>>>
>>
>> Do you prefer dt helper function such as following function instead of new soc_is_xx() ?
>> - of_machine_is_compatible("samsung,exynos3250")
>>
>> If you are OK, I'll use of_machine_is_compatible() instead of soc_is_xx().
> 
> First of all, there is still a lot of code in mach-exynos/ using the soc_is_xx() macros, so having some SoCs use them and other SoCs use of_machine_is_compatible() wouldn't make the code cleaner.
> 
> For now, I wouldn't mind adding soc_is_exynos3250(), but in general such code surrounded with if (soc_is_xx()) blocks should be reworked to use something better, for example function pointers, as Olof suggested.

I thought 'function pointers' method instead of soc_is_xxx() macro as following two case:
I need more detailed explanation/example of "for example function pointers, as Olof suggested." sentence.

[case 1]
Each Exynos SoC has other function pointers according to compatible name of DT.

For example, arch/arm/mach-exynos/firmware.c

static const struct firmware_ops exynos_firmware_ops = {
	.do_idle		= exynos_do_idle,
	.set_cpu_boot_addr	= exynos_set_cpu_boot_addr,
	.cpu_boot		= exynos_cpu_boot,
};
static const struct firmware_ops exynos3250_firmware_ops = {
	.do_idle		= exynos_do_idle,
	.set_cpu_boot_addr	= exynos4212_set_cpu_boot_addr,
	.cpu_boot		= exynos3250_cpu_boot,
};

static const struct firmware_ops exynos4212_firmware_ops = {
	.do_idle		= exynos_do_idle,
	.set_cpu_boot_addr	= exynos4212_set_cpu_boot_addr,
	.cpu_boot		= exynos4212_cpu_boot,
};

struct secure_firmware {
	char *name;
	const struct firmware_ops *ops;
} exynos_secure_firmware[] __initconst = {
	{ "samsung,secure-firmware",		&exynos_firmware_ops },
	{ "samsung,exynos3250-secure-firmware", &exynos3250_firmware_ops },
	{ "samsung,exynos4212-secure-firmware", &exynos4212_firmware_ops },
};


[case 2]
Delete all the soc_is_xxx() macro and then
use only get_samsung_soc_id() function as following:
	 
	switch (get_samsung_soc_id()) {
	case EXYNOS3250_SOC_ID:
		// ...
		break;
	case EXYNOS4210_CPU_ID:
		// ...
		break;
	case EXYNOS4212_CPU_ID:
		// ...
		break;
	case EXYNOS4412_CPU_ID:
		// ...
		break;
	case EXYNOS5250_SOC_ID:
		// ...
		break;
	case EXYNOS5420_SOC_ID:
		// ...
		break;
	case EXYNOS5440_SOC_ID:
		// ...
		break;
	};

Best Regards,
Chanwoo Choi
