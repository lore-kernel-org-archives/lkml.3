Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695AbaDQBhd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 21:37:33 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:13879 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbaDQBha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 21:37:30 -0400
X-AuditID: cbfee68e-b7f566d000002344-34-534f3058b38b
Message-id: <534F305C.2050407@samsung.com>
Date: Thu, 17 Apr 2014 10:37:32 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Tomasz Figa <t.figa@samsung.com>
Cc: Olof Johansson <olof@lixom.net>, kgene.kim@samsung.com,
        linux-samsung-soc@vger.kernel.org, kyungmin.park@samsung.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com, hyunhee.kim@samsung.com,
        yj44.cho@samsung.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 01/27] ARM: EXYNOS: Add Exynos3250 SoC ID
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
 <1397122658-16013-2-git-send-email-cw00.choi@samsung.com>
 <20140411014650.GB14934@quad.lixom.net> <53478C75.60302@samsung.com>
 <5347AA35.4010504@samsung.com> <534B6E8E.20506@samsung.com>
 <534EA773.30006@samsung.com>
In-reply-to: <534EA773.30006@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsWyRsSkWDfCwD/Y4NobBYtXZzayWXz+0MJu
	Men+BBaL3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2Sx9PpFJotT1z+zWbTuPcJuMWPySzaL
	9TNes1js3TmZ0YHPY828NYwem1Z1snlsXlLvceVEE6tH35ZVjB4/X+p4fN4kF8AexWWTkpqT
	WZZapG+XwJXROOECa8EKjYrtjyYzNzD2K3YxcnJICJhIvD9/kRXCFpO4cG89WxcjF4eQwFJG
	iSvPnrHAFPX/eM8KkVjEKHFz1RZmCOc1o8SpU5fBqngFtCR23bvFDmKzCKhKNP6YwARiswHF
	97+4wQZiiwqESaycfgWqXlDix+R7YLaIgIrE5VPTGUGGMgtMYZZYeKMf7CZhAVuJkzfus0Dd
	xCSx4v1vsA2cApoSS7regRUxC+hI7G+dxgZhy0tsXvMW7DwJgYkcErNnL4E6SUDi2+RDQJM4
	gBKyEpsOMEP8JilxcMUNlgmMYrOQHDULydhZSMYuYGRexSiaWpBcUJyUXmSkV5yYW1yal66X
	nJ+7iREY06f/PevbwXjzgPUhxmSglROZpUST84EpIa8k3tDYzMjC1MTU2Mjc0ow0YSVx3kUP
	k4KEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MM5ROjzNJNyNRfvTi2hz31KL1HkfKrfNqogs
	vmH/6oiSRbXjM8OH9wPcdrIXrlxx6O6nB/Z3QlULnxgdPSJ3uerO/IO/nwfvXTHBsS7iyENd
	P1E25ySPb0ITOE/XhTLmX071cJx8rqI5bmb5XXbbB52VP98Z7P+7t4tf6OWtTeac3bny7zXm
	uiuxFGckGmoxFxUnAgAjZQ0u/wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsVy+t9jAd0IA/9gg+0rxCxendnIZvH5Qwu7
	xaT7E1gsehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PF0usXmSxOXf/MZtG69wi7xYzJL9ks
	1s94zWKxd+dkRgc+jzXz1jB6bFrVyeaxeUm9x5UTTawefVtWMXr8fKnj8XmTXAB7VAOjTUZq
	YkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QyUoKZYk5pUCh
	gMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjMYJF1gLVmhUbH80mbmBsV+xi5GTQ0LA
	RKL/x3tWCFtM4sK99WxdjFwcQgKLGCVurtrCDOG8ZpQ4deoyC0gVr4CWxK57t9hBbBYBVYnG
	HxOYQGw2oPj+FzfYQGxRgTCJldOvQNULSvyYfA/MFhFQkbh8ajojyFBmgSnMEgtv9IOtFhaw
	lTh54z4LxLalTBIr3v8G28ApoCmxpOsdWBGzgI7E/tZpbBC2vMTmNW+ZJzAKzEKyZBaSsllI
	yhYwMq9iFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECE4Yz6R3MK5qsDjEKMDBqMTDy/nbL1iI
	NbGsuDL3EKMEB7OSCK+7uH+wEG9KYmVValF+fFFpTmrxIcZkYBhMZJYSTc4HJrO8knhDYxMz
	I0sjc0MLI2Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamDMl1Dm5Z6iGTPF7nmYtQn7
	WatH4S+103ZfCF0S4nvZwO7FtqaaWB3XaQnGC63XFLaKGPV/cslXyjyh+pfRX3+j+ulAv9iH
	helrDt+c3xtQGfbl/nLduats/+RIvClbLmGyf+ku8WPrFZJuce3fzFK07fnSj74ButfiBAyW
	Hg6Ifx/UXitY46bEUpyRaKjFXFScCABza2X0XAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 04/17/2014 12:53 AM, Tomasz Figa wrote:
> Hi Chanwoo,
> 
> On 14.04.2014 07:13, Chanwoo Choi wrote:
>> On 04/11/2014 05:39 PM, Tomasz Figa wrote:
>>> On 11.04.2014 08:32, Chanwoo Choi wrote:
>>>> On 04/11/2014 10:46 AM, Olof Johansson wrote:
>>>>> On Thu, Apr 10, 2014 at 06:37:12PM +0900, Chanwoo Choi wrote:
>>>>>> diff --git a/arch/arm/plat-samsung/include/plat/cpu.h b/arch/arm/plat-samsung/include/plat/cpu.h
>>>>>> index 5992b8d..3d808f6b 100644
>>>>>> --- a/arch/arm/plat-samsung/include/plat/cpu.h
>>>>>> +++ b/arch/arm/plat-samsung/include/plat/cpu.h
>>>>>> @@ -43,6 +43,9 @@ extern unsigned long samsung_cpu_id;
>>>>>>    #define S5PV210_CPU_ID        0x43110000
>>>>>>    #define S5PV210_CPU_MASK    0xFFFFF000
>>>>>>
>>>>>> +#define EXYNOS3250_SOC_ID       0xE3472000
>>>>>> +#define EXYNOS3_SOC_MASK        0xFFFFF000
>>>>>> +
>>>>>>    #define EXYNOS4210_CPU_ID    0x43210000
>>>>>>    #define EXYNOS4212_CPU_ID    0x43220000
>>>>>>    #define EXYNOS4412_CPU_ID    0xE4412200
>>>>>> @@ -68,6 +71,7 @@ IS_SAMSUNG_CPU(s5p6440, S5P6440_CPU_ID, S5P64XX_CPU_MASK)
>>>>>>    IS_SAMSUNG_CPU(s5p6450, S5P6450_CPU_ID, S5P64XX_CPU_MASK)
>>>>>>    IS_SAMSUNG_CPU(s5pc100, S5PC100_CPU_ID, S5PC100_CPU_MASK)
>>>>>>    IS_SAMSUNG_CPU(s5pv210, S5PV210_CPU_ID, S5PV210_CPU_MASK)
>>>>>> +IS_SAMSUNG_CPU(exynos3250, EXYNOS3250_SOC_ID, EXYNOS3_SOC_MASK)
>>>>>>    IS_SAMSUNG_CPU(exynos4210, EXYNOS4210_CPU_ID, EXYNOS4_CPU_MASK)
>>>>>>    IS_SAMSUNG_CPU(exynos4212, EXYNOS4212_CPU_ID, EXYNOS4_CPU_MASK)
>>>>>>    IS_SAMSUNG_CPU(exynos4412, EXYNOS4412_CPU_ID, EXYNOS4_CPU_MASK)
>>>>>> @@ -126,6 +130,12 @@ IS_SAMSUNG_CPU(exynos5440, EXYNOS5440_SOC_ID, EXYNOS5_SOC_MASK)
>>>>>>    # define soc_is_s5pv210()    0
>>>>>>    #endif
>>>>>>
>>>>>> +#if defined(CONFIG_SOC_EXYNOS3250)
>>>>>> +# define soc_is_exynos3250()    is_samsung_exynos3250()
>>>>>> +#else
>>>>>> +# define soc_is_exynos3250()    0
>>>>>> +#endif
>>>>>
>>>>> In general, I think we have too much code littered with soc_is_<foo>() going
>>>>> on, so please try to avoid adding more for this SoC. Especially in cases where
>>>>> you just want to bail out of certain features where we might already have
>>>>> function pointers to control if a function is called or not, such as the
>>>>> firmware interfaces.
>>>>>
>>>>
>>>> Do you prefer dt helper function such as following function instead of new soc_is_xx() ?
>>>> - of_machine_is_compatible("samsung,exynos3250")
>>>>
>>>> If you are OK, I'll use of_machine_is_compatible() instead of soc_is_xx().
>>>
>>> First of all, there is still a lot of code in mach-exynos/ using the soc_is_xx() macros, so having some SoCs use them and other SoCs use of_machine_is_compatible() wouldn't make the code cleaner.
>>>
>>> For now, I wouldn't mind adding soc_is_exynos3250(), but in general such code surrounded with if (soc_is_xx()) blocks should be reworked to use something better, for example function pointers, as Olof suggested.
>>
>> I thought 'function pointers' method instead of soc_is_xxx() macro as following two case:
>> I need more detailed explanation/example of "for example function pointers, as Olof suggested." sentence.
>>
>> [case 1]
>> Each Exynos SoC has other function pointers according to compatible name of DT.
>>
>> For example, arch/arm/mach-exynos/firmware.c
>>
>> static const struct firmware_ops exynos_firmware_ops = {
>>     .do_idle        = exynos_do_idle,
>>     .set_cpu_boot_addr    = exynos_set_cpu_boot_addr,
>>     .cpu_boot        = exynos_cpu_boot,
>> };
>> static const struct firmware_ops exynos3250_firmware_ops = {
>>     .do_idle        = exynos_do_idle,
>>     .set_cpu_boot_addr    = exynos4212_set_cpu_boot_addr,
>>     .cpu_boot        = exynos3250_cpu_boot,
>> };
>>
>> static const struct firmware_ops exynos4212_firmware_ops = {
>>     .do_idle        = exynos_do_idle,
>>     .set_cpu_boot_addr    = exynos4212_set_cpu_boot_addr,
>>     .cpu_boot        = exynos4212_cpu_boot,
>> };
>>
>> struct secure_firmware {
>>     char *name;
>>     const struct firmware_ops *ops;
>> } exynos_secure_firmware[] __initconst = {
>>     { "samsung,secure-firmware",        &exynos_firmware_ops },
>>     { "samsung,exynos3250-secure-firmware", &exynos3250_firmware_ops },
>>     { "samsung,exynos4212-secure-firmware", &exynos4212_firmware_ops },
>> };
>>
> 
> This is probably the right solution. Another would be to detect which firmware ops to use by matching root node with particular SoC compatible strings.
> 

OK, I'll modify firmware.c using this method on separated patch apart from Exynos3250 patchset.
But, I want to implment it after completed Exynos3250 patchset.
Because Exynos3250 patchset needs other patch such as following patch:
Following patches has not yet to be confirmed or merged.

[PATCH Resend] ARM: EXYNOS: Map SYSRAM address through DT
- http://www.spinics.net/lists/arm-kernel/msg323011.html

[PATCH v2 1/3] ARM: EXYNOS: Map PMU address through DT
- http://www.spinics.net/lists/arm-kernel/msg316013.html
 
Thanks for your review.

Best regards,
Chanwoo Choi

