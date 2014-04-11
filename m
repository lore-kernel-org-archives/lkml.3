Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbaDKGHc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 02:07:32 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:26566 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612AbaDKGH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 02:07:29 -0400
X-AuditID: cbfee68e-b7f566d000002344-3a-5347869cbc7d
Message-id: <5347869E.9070504@samsung.com>
Date: Fri, 11 Apr 2014 15:07:26 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>, hyunhee.kim@samsung.com,
        yj44.cho@samsung.com, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 01/27] ARM: EXYNOS: Add Exynos3250 SoC ID
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
 <1397122658-16013-2-git-send-email-cw00.choi@samsung.com>
 <CAK9yfHzZEh8m2y77DrqHtEFEMnwC_NBMUk=H+MP6oSV5PWArTQ@mail.gmail.com>
 <534783AB.2070601@samsung.com>
 <CAK9yfHyDLq6W_Vhuxg3zhvwBq6tHaN_BEG39WUcQMYxOBqnidg@mail.gmail.com>
In-reply-to: <CAK9yfHyDLq6W_Vhuxg3zhvwBq6tHaN_BEG39WUcQMYxOBqnidg@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsWyRsSkRHdOm3uwwefpyhafP7SwW0y6P4HF
	onfBVTaLs01v2C02Pb7GanF51xw2ixnn9zFZnPzTy2gxY/JLNov1M16zWOzdOZnRgdvjzrU9
	bB6bl9R79G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8aH15vZC3aIViy+3MbcwHheoIuRk0NC
	wETiwaG9jBC2mMSFe+vZuhi5OIQEljJKbN+4kgWm6FZbGyNEYhGjxLln71khnNeMEr97XrGC
	VPEKaEmc2bAPzGYRUJXYvuUzmM0GFN//4gYbiC0qECaxcvoVFoh6QYkfk++B2SJANS+7lzOB
	DGUW6GKWeHxmIlhCWMBW4uSN+ywQ2zYwSSzvmgs2lVMgWKL97VcmEJtZQEdif+s0NghbXmLz
	mrfMIA0SAo/YJX417GCCOElA4tvkQ0CTOIASshKbDjBD/CYpcXDFDZYJjGKzkBw1C8nYWUjG
	LmBkXsUomlqQXFCclF5kpFecmFtcmpeul5yfu4kRGJmn/z3r28F484D1IcZkoJUTmaVEk/OB
	kZ1XEm9obGZkYWpiamxkbmlGmrCSOO+ih0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhjX
	b3nm6yb77uTXL5m9612mtcrLtpxbncTDP21uVEvixx0ra2qN+E+9nSr87cxb3kLBlHU3lm9h
	ThYJtPV+LVL5/3meTsqZm9+/fo3SFEsVNGKbwX3pd8f01EvO/8+9L2lxP7ZcSGGLxbrv5+cf
	2di39/jk6v2Hn8xOC5l2OYJXSf/G66cX5bt8lViKMxINtZiLihMB6Bd5j+ICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsVy+t9jAd05be7BBi9PSll8/tDCbjHp/gQW
	i94FV9kszja9YbfY9Pgaq8XlXXPYLGac38dkcfJPL6PFjMkv2SzWz3jNYrF352RGB26PO9f2
	sHlsXlLv0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koK
	eYm5qbZKLj4Bum6ZOUBXKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgz
	PrzezF6wQ7Ri8eU25gbG8wJdjJwcEgImErfa2hghbDGJC/fWs3UxcnEICSxilDj37D0rhPOa
	UeJ3zytWkCpeAS2JMxv2gdksAqoS27d8BrPZgOL7X9xgA7FFBcIkVk6/wgJRLyjxY/I9MFsE
	qOZl93ImkKHMAl3MEo/PTARLCAvYSpy8cZ8FYtsGJonlXXPBpnIKBEu0v/3KBGIzC+hI7G+d
	xgZhy0tsXvOWeQKjwCwkS2YhKZuFpGwBI/MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOC4
	fya1g3Flg8UhRgEORiUe3owLbsFCrIllxZW5hxglOJiVRHjN/N2DhXhTEiurUovy44tKc1KL
	DzEmA8NgIrOUaHI+MCXllcQbGpuYGVkamRtaGBmbkyasJM57oNU6UEggPbEkNTs1tSC1CGYL
	EwenVANjA3frT7ZCL+4Zqu5BGWLWBQ6XJTujxX9dmr/UO6Hs0oujKfyBFYKR2nKG/9OkOgxl
	bumaJPAdc2xc+jtmg4v2q+X9p4/Gfiias+zqaXbzBV+vHkryZZx+j+W9q9caDm/DjH+TGT7f
	9NvP03TxRXThYXufA2+C3836Fd3xUDCUT6CJP8tKZYkSS3FGoqEWc1FxIgArcOhQPwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sachin,

On 04/11/2014 02:56 PM, Sachin Kamat wrote:
> Hi Chanwoo,
> 
> On 11 April 2014 11:24, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> Hi Sachin,
>>
>> On 04/11/2014 12:56 PM, Sachin Kamat wrote:
>>> Hi Chanwoo,
>>>
>>> On 10 April 2014 15:07, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>>>> This patch add Exynos3250's SoC ID. Exynos 3250 is System-On-Chip(SoC) that
>>>> is based on the 32-bit RISC processor for Smartphone. Exynos3250 uses Cortex-A7
>>>> dual cores and has a target speed of 1.0GHz.
>>>>
>>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>> ---
>>>>  arch/arm/mach-exynos/Kconfig             | 22 ++++++++++++++++++++++
>>>>  arch/arm/mach-exynos/exynos.c            |  1 +
>>>>  arch/arm/plat-samsung/include/plat/cpu.h | 10 ++++++++++
>>>>  3 files changed, 33 insertions(+)
>>>>
>>>> diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
>>>> index fc8bf18..6da8a68 100644
>>>> --- a/arch/arm/mach-exynos/Kconfig
>>>> +++ b/arch/arm/mach-exynos/Kconfig
>>>> @@ -11,6 +11,17 @@ if ARCH_EXYNOS
>>>>
>>>>  menu "SAMSUNG EXYNOS SoCs Support"
>>>>
>>>> +config ARCH_EXYNOS3
>>>> +       bool "SAMSUNG EXYNOS3"
>>>> +       select ARM_AMBA
>>>> +       select CLKSRC_OF
>>>> +       select HAVE_ARM_SCU if SMP
>>>> +       select HAVE_SMP
>>>> +       select PINCTRL
>>>> +       select PM_GENERIC_DOMAINS if PM_RUNTIME
>>>> +       help
>>>> +         Samsung EXYNOS3 SoCs based systems
>>>> +
>>>>  config ARCH_EXYNOS4
>>>>         bool "SAMSUNG EXYNOS4"
>>>>         default y
>>>> @@ -41,6 +52,17 @@ config ARCH_EXYNOS5
>>>>
>>>>  comment "EXYNOS SoCs"
>>>>
>>>> +config SOC_EXYNOS3250
>>>> +       bool "SAMSUNG EXYNOS3250"
>>>> +       default y
>>>> +       depends on ARCH_EXYNOS3
>>>> +       select ARCH_HAS_BANDGAP
>>>> +       select ARM_CPU_SUSPEND if PM
>>>> +       select PINCTRL_EXYNOS
>>>> +       select SAMSUNG_DMADEV
>>>> +       help
>>>> +         Enable EXYNOS3250 CPU support
>>>
>>> There is a Kconfig consolidation patch submitted by me [1]. Please base your
>>> code on that one to avoid merge conflicts.
>>>
>>> [1] http://article.gmane.org/gmane.linux.kernel.samsung-soc/28642
>>>
>>
>> Your patch is applied? I can't find merged patch on linux-samsung.git and arm-soc.git.
>> If this patch is applied, I will rebase this patchset. Thanks.
> 
> This patch hasn't been merged yet but has been agreed upon by Kukjin,
> Tomasz and others.
> You may follow the mailing list for details.
> 

OK, I checked mailied list for your patch.
As my previous reply, if your patch is merged, I'll rebase it.

Thanks,
Chanwoo Choi
