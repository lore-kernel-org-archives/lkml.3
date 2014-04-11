Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbaDKF4b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 01:56:31 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:42072 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986AbaDKF42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 01:56:28 -0400
MIME-Version: 1.0
In-Reply-To: <534783AB.2070601@samsung.com>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
	<1397122658-16013-2-git-send-email-cw00.choi@samsung.com>
	<CAK9yfHzZEh8m2y77DrqHtEFEMnwC_NBMUk=H+MP6oSV5PWArTQ@mail.gmail.com>
	<534783AB.2070601@samsung.com>
Date: Fri, 11 Apr 2014 11:26:28 +0530
Message-ID: <CAK9yfHyDLq6W_Vhuxg3zhvwBq6tHaN_BEG39WUcQMYxOBqnidg@mail.gmail.com>
Subject: Re: [PATCH 01/27] ARM: EXYNOS: Add Exynos3250 SoC ID
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>, hyunhee.kim@samsung.com,
        yj44.cho@samsung.com, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 11 April 2014 11:24, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> Hi Sachin,
>
> On 04/11/2014 12:56 PM, Sachin Kamat wrote:
>> Hi Chanwoo,
>>
>> On 10 April 2014 15:07, Chanwoo Choi <cw00.choi@samsung.com> wrote:
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
>>> +       bool "SAMSUNG EXYNOS3"
>>> +       select ARM_AMBA
>>> +       select CLKSRC_OF
>>> +       select HAVE_ARM_SCU if SMP
>>> +       select HAVE_SMP
>>> +       select PINCTRL
>>> +       select PM_GENERIC_DOMAINS if PM_RUNTIME
>>> +       help
>>> +         Samsung EXYNOS3 SoCs based systems
>>> +
>>>  config ARCH_EXYNOS4
>>>         bool "SAMSUNG EXYNOS4"
>>>         default y
>>> @@ -41,6 +52,17 @@ config ARCH_EXYNOS5
>>>
>>>  comment "EXYNOS SoCs"
>>>
>>> +config SOC_EXYNOS3250
>>> +       bool "SAMSUNG EXYNOS3250"
>>> +       default y
>>> +       depends on ARCH_EXYNOS3
>>> +       select ARCH_HAS_BANDGAP
>>> +       select ARM_CPU_SUSPEND if PM
>>> +       select PINCTRL_EXYNOS
>>> +       select SAMSUNG_DMADEV
>>> +       help
>>> +         Enable EXYNOS3250 CPU support
>>
>> There is a Kconfig consolidation patch submitted by me [1]. Please base your
>> code on that one to avoid merge conflicts.
>>
>> [1] http://article.gmane.org/gmane.linux.kernel.samsung-soc/28642
>>
>
> Your patch is applied? I can't find merged patch on linux-samsung.git and arm-soc.git.
> If this patch is applied, I will rebase this patchset. Thanks.

This patch hasn't been merged yet but has been agreed upon by Kukjin,
Tomasz and others.
You may follow the mailing list for details.

-- 
With warm regards,
Sachin
