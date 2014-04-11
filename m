Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbaDKHKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 03:10:00 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15947 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbaDKHJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 03:09:58 -0400
X-AuditID: cbfee68e-b7f566d000002344-d7-53479544b464
Message-id: <53479545.4050707@samsung.com>
Date: Fri, 11 Apr 2014 16:09:57 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Olof Johansson <olof@lixom.net>
Cc: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org, kyungmin.park@samsung.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com, hyunhee.kim@samsung.com,
        yj44.cho@samsung.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 01/27] ARM: EXYNOS: Add Exynos3250 SoC ID
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
 <1397122658-16013-2-git-send-email-cw00.choi@samsung.com>
 <20140411014650.GB14934@quad.lixom.net> <53478C75.60302@samsung.com>
In-reply-to: <53478C75.60302@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsWyRsSkRNdlqnuwwYvnXBafP7SwW0y6P4HF
	onfBVTaLs01v2C02Pb7GanF51xw2ixnn9zFZnLr+Gcia/JLNYv2M1ywWe3dOZnTg9ti8pN7j
	yokmVo++LasYPT5vkgtgieKySUnNySxLLdK3S+DKuHtlG1PBYbWK649+sjUwPpfvYuTkkBAw
	kbjW/4UVwhaTuHBvPVsXIxeHkMBSRonjv++wwRR9v/6GBSIxnVGis+0ElPOaUWLHlNVAVRwc
	vAJaEsf3VII0sAioSrT1rAKbygYU3v/iBtggUYEwiZXTr7CA2LwCghI/Jt8Ds0UElCWetF1i
	BpnJLDCFSeLuyw9gCWEBW4mTN+6D2UICJxglnh7zA7E5BTQlrh5ezwhiMwvoSOxvncYGYctL
	bF7zFmyQhMBLdon7b9+yQlwkIPFt8iEWkEMlBGQlNh1ghvhMUuLgihssExjFZiG5aRaSsbOQ
	jF3AyLyKUTS1ILmgOCm9yEivODG3uDQvXS85P3cTIzAqT/971reD8eYB60OMyUArJzJLiSbn
	A6M6ryTe0NjMyMLUxNTYyNzSjDRhJXHeRQ+TgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUw
	zgw+Zda47xmjOcfsvhJvnqWM33aafty44p1O3L7vH+q/r7nGefAsZ+exm9Hf/vbVb7y+78Tp
	yFmhxe8/PC/m/z5z6cMNj59eCOdefq/jF+cH3ckbz86Y4rvnpFjGBs8dHx/q39102P5E9obP
	jS9C/juu+rb6V7z9LK9e8QYR/35T+20LGBaHnl6lxFKckWioxVxUnAgAmluVlOACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jQV2Xqe7BBs9LLD5/aGG3mHR/AotF
	74KrbBZnm96wW2x6fI3V4vKuOWwWM87vY7I4df0zkDX5JZvF+hmvWSz27pzM6MDtsXlJvceV
	E02sHn1bVjF6fN4kF8AS1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeY
	m2qr5OIToOuWmQN0lJJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYx4+6V
	bUwFh9Uqrj/6ydbA+Fy+i5GTQ0LAROL79TcsELaYxIV769m6GLk4hASmM0p0tp1ggXBeM0rs
	mLIaKMPBwSugJXF8TyVIA4uAqkRbzypWEJsNKLz/xQ02EFtUIExi5fQrYEN5BQQlfky+B2aL
	CChLPGm7xAwyk1lgCpPE3ZcfwBLCArYSJ2/cB7OFBE4wSjw95gdicwpoSlw9vJ4RxGYW0JHY
	3zqNDcKWl9i85i3zBEaBWUh2zEJSNgtJ2QJG5lWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsY
	wRH/THoH46oGi0OMAhyMSjy8By65BQuxJpYVV+YeYpTgYFYS4eWY7B4sxJuSWFmVWpQfX1Sa
	k1p8iDEZGAQTmaVEk/OBySivJN7Q2MTMyNLI3NDCyNicNGElcd6DrdaBQgLpiSWp2ampBalF
	MFuYODilGhhnP5Vzv+wtuKrjgNizmTNu5+Ze18j7ElyifpkxWMDcuvSztBvXEQNpe4FzKb3L
	2l9zTrmrNuf3PJ9L7wLqepYeWyfZuF22pna5ykHub9EfcneHXNPWemH5b+WSZNGgtbsvxC6a
	3Nfy+NYX8dazjy6az20sD57Y+q/sfEHW9dWnP+Y1sqTZPb+lxFKckWioxVxUnAgA+VG9fTwD	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 03:32 PM, Chanwoo Choi wrote:
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
>>>  arch/arm/mach-exynos/Kconfig             | 22 ++++++++++++++++++++++
>>>  arch/arm/mach-exynos/exynos.c            |  1 +
>>>  arch/arm/plat-samsung/include/plat/cpu.h | 10 ++++++++++
>>>  3 files changed, 33 insertions(+)
>>>
>>> diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
>>> index fc8bf18..6da8a68 100644
>>> --- a/arch/arm/mach-exynos/Kconfig
>>> +++ b/arch/arm/mach-exynos/Kconfig
>>> @@ -11,6 +11,17 @@ if ARCH_EXYNOS
>>>  
>>>  menu "SAMSUNG EXYNOS SoCs Support"
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
>>>  config ARCH_EXYNOS4
>>>  	bool "SAMSUNG EXYNOS4"
>>>  	default y
>>> @@ -41,6 +52,17 @@ config ARCH_EXYNOS5
>>>  
>>>  comment "EXYNOS SoCs"
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
>>>  config CPU_EXYNOS4210
>>>  	bool "SAMSUNG EXYNOS4210"
>>>  	default y
>>> diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
>>> index b32a907..b134868 100644
>>> --- a/arch/arm/mach-exynos/exynos.c
>>> +++ b/arch/arm/mach-exynos/exynos.c
>>> @@ -370,6 +370,7 @@ static void __init exynos_dt_machine_init(void)
>>>  }
>>>  
>>>  static char const *exynos_dt_compat[] __initconst = {
>>> +	"samsung,exynos3250",
>>
>> Please consider samsung,exynos3 instead, so you don't have to update this table
>> for every SoC. We've talked about this before..
> 
> This patchset included only exynos3250.dtsi without exynos3.dtsi.
> So, I added only "samsung,exynos3250" compatible name.
> 
> Do you prefer to add SoC version as following?
> +       "samsung,exynos3",
> +       "samsung,exynos3250",
> 
> or ?
> +       "samsung,exynos3",
> 
>>
>>>  	"samsung,exynos4",
>>>  	"samsung,exynos4210",
>>>  	"samsung,exynos4212",
>>> diff --git a/arch/arm/plat-samsung/include/plat/cpu.h b/arch/arm/plat-samsung/include/plat/cpu.h
>>> index 5992b8d..3d808f6b 100644
>>> --- a/arch/arm/plat-samsung/include/plat/cpu.h
>>> +++ b/arch/arm/plat-samsung/include/plat/cpu.h
>>> @@ -43,6 +43,9 @@ extern unsigned long samsung_cpu_id;
>>>  #define S5PV210_CPU_ID		0x43110000
>>>  #define S5PV210_CPU_MASK	0xFFFFF000
>>>  
>>> +#define EXYNOS3250_SOC_ID       0xE3472000
>>> +#define EXYNOS3_SOC_MASK        0xFFFFF000
>>> +
>>>  #define EXYNOS4210_CPU_ID	0x43210000
>>>  #define EXYNOS4212_CPU_ID	0x43220000
>>>  #define EXYNOS4412_CPU_ID	0xE4412200
>>> @@ -68,6 +71,7 @@ IS_SAMSUNG_CPU(s5p6440, S5P6440_CPU_ID, S5P64XX_CPU_MASK)
>>>  IS_SAMSUNG_CPU(s5p6450, S5P6450_CPU_ID, S5P64XX_CPU_MASK)
>>>  IS_SAMSUNG_CPU(s5pc100, S5PC100_CPU_ID, S5PC100_CPU_MASK)
>>>  IS_SAMSUNG_CPU(s5pv210, S5PV210_CPU_ID, S5PV210_CPU_MASK)
>>> +IS_SAMSUNG_CPU(exynos3250, EXYNOS3250_SOC_ID, EXYNOS3_SOC_MASK)
>>>  IS_SAMSUNG_CPU(exynos4210, EXYNOS4210_CPU_ID, EXYNOS4_CPU_MASK)
>>>  IS_SAMSUNG_CPU(exynos4212, EXYNOS4212_CPU_ID, EXYNOS4_CPU_MASK)
>>>  IS_SAMSUNG_CPU(exynos4412, EXYNOS4412_CPU_ID, EXYNOS4_CPU_MASK)
>>> @@ -126,6 +130,12 @@ IS_SAMSUNG_CPU(exynos5440, EXYNOS5440_SOC_ID, EXYNOS5_SOC_MASK)
>>>  # define soc_is_s5pv210()	0
>>>  #endif
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

I think of_machine_is_compatible() is not proper alternative method.
of_machine_is_compatible can be only used if CONFIG_OF is enabled.

Best Regards,
Chanwoo Choi


