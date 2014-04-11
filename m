Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbaDKFyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 01:54:54 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:62293 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaDKFyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 01:54:51 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-91-534783aab569
Message-id: <534783AB.2070601@samsung.com>
Date: Fri, 11 Apr 2014 14:54:51 +0900
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
In-reply-to: <CAK9yfHzZEh8m2y77DrqHtEFEMnwC_NBMUk=H+MP6oSV5PWArTQ@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsWyRsSkUHdVs3uwwb4N/BafP7SwW0y6P4HF
	onfBVTaLs01v2C02Pb7GanF51xw2ixnn9zFZnPzTy2gxY/JLNov1M16zWOzdOZnRgdvjzrU9
	bB6bl9R79G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8b5zasYC1YJVjTcOMncwDidt4uRk0NC
	wETixo437BC2mMSFe+vZQGwhgaWMEnPmSMPUvHq3DSjOBRSfzigxb0crE4TzmlHiasccVpAq
	XgEtiQcPTzKB2CwCqhKLOi8wg9hsQPH9L26ATRUVCJNYOf0KC0S9oMSPyffAbBGgmpfdy8GG
	Mgt0MUs8PjMRLCEsYCtx8sZ9FohtJ4BWHz8ENolTIFji4oTXYEXMAjoS+1unsUHY8hKb17xl
	BmmQELjHLnH6yjNWiJMEJL5NPgTUwAGUkJXYdIAZ4jdJiYMrbrBMYBSbheSoWUjGzkIydgEj
	8ypG0dSC5ILipPQiU73ixNzi0rx0veT83E2MwLg8/e/ZxB2M9w9YH2JMBlo5kVlKNDkfGNd5
	JfGGxmZGFqYmpsZG5pZmpAkrifOmP0oKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cComfi9
	wKGE7fHixtY4+d2tM+y213omsln2doh1XpReJ9LDtIThaN+J15Lq8UqpsjHP7P2vpRsEG9qV
	T6zYv2CPSrrhmws6Kdsu3f/u/qObM+33+dz42OeuP9TDAqV+fdcJKmhd9vjVnZe6e0MCrzWY
	MVxn6/etvmsWOKn7twF7XqseB690oBJLcUaioRZzUXEiALlhCADhAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsVy+t9jQd1Vze7BBtsesFl8/tDCbjHp/gQW
	i94FV9kszja9YbfY9Pgaq8XlXXPYLGac38dkcfJPL6PFjMkv2SzWz3jNYrF352RGB26PO9f2
	sHlsXlLv0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koK
	eYm5qbZKLj4Bum6ZOUBXKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgz
	zm9exViwSrCi4cZJ5gbG6bxdjJwcEgImEq/ebWODsMUkLtxbD2RzcQgJTGeUmLejlQnCec0o
	cbVjDitIFa+AlsSDhyeZQGwWAVWJRZ0XmEFsNqD4/hc3wCaJCoRJrJx+hQWiXlDix+R7YLYI
	UM3L7uVgQ5kFupglHp+ZCJYQFrCVOHnjPgvEthNAq48fApvEKRAscXHCa7AiZgEdif2t09gg
	bHmJzWveMk9gFJiFZMksJGWzkJQtYGRexSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREc98+k
	djCubLA4xCjAwajEw5txwS1YiDWxrLgy9xCjBAezkgivmb97sBBvSmJlVWpRfnxRaU5q8SHG
	ZGAYTGSWEk3OB6akvJJ4Q2MTMyNLI3NDCyNjc9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLg
	lGpgzJqVKrTVbMfbl49j3qt95X/h/GBPbjH//5jmjWenqE25wS795+m9mAs7Tus/0tVcxyUq
	eZDJNdbwdWRz5FGBqBeTOC02hG27lVabZKHAlS6yZlOvdjfzkpoWntcJyj0mL7dpvPrrmnFk
	9Q5vL0G79UuYw3M6rLY0Lfnzf+7OT4sWM+3UZRU1VWIpzkg01GIuKk4EAGwWu2A/AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sachin,

On 04/11/2014 12:56 PM, Sachin Kamat wrote:
> Hi Chanwoo,
> 
> On 10 April 2014 15:07, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> This patch add Exynos3250's SoC ID. Exynos 3250 is System-On-Chip(SoC) that
>> is based on the 32-bit RISC processor for Smartphone. Exynos3250 uses Cortex-A7
>> dual cores and has a target speed of 1.0GHz.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  arch/arm/mach-exynos/Kconfig             | 22 ++++++++++++++++++++++
>>  arch/arm/mach-exynos/exynos.c            |  1 +
>>  arch/arm/plat-samsung/include/plat/cpu.h | 10 ++++++++++
>>  3 files changed, 33 insertions(+)
>>
>> diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
>> index fc8bf18..6da8a68 100644
>> --- a/arch/arm/mach-exynos/Kconfig
>> +++ b/arch/arm/mach-exynos/Kconfig
>> @@ -11,6 +11,17 @@ if ARCH_EXYNOS
>>
>>  menu "SAMSUNG EXYNOS SoCs Support"
>>
>> +config ARCH_EXYNOS3
>> +       bool "SAMSUNG EXYNOS3"
>> +       select ARM_AMBA
>> +       select CLKSRC_OF
>> +       select HAVE_ARM_SCU if SMP
>> +       select HAVE_SMP
>> +       select PINCTRL
>> +       select PM_GENERIC_DOMAINS if PM_RUNTIME
>> +       help
>> +         Samsung EXYNOS3 SoCs based systems
>> +
>>  config ARCH_EXYNOS4
>>         bool "SAMSUNG EXYNOS4"
>>         default y
>> @@ -41,6 +52,17 @@ config ARCH_EXYNOS5
>>
>>  comment "EXYNOS SoCs"
>>
>> +config SOC_EXYNOS3250
>> +       bool "SAMSUNG EXYNOS3250"
>> +       default y
>> +       depends on ARCH_EXYNOS3
>> +       select ARCH_HAS_BANDGAP
>> +       select ARM_CPU_SUSPEND if PM
>> +       select PINCTRL_EXYNOS
>> +       select SAMSUNG_DMADEV
>> +       help
>> +         Enable EXYNOS3250 CPU support
> 
> There is a Kconfig consolidation patch submitted by me [1]. Please base your
> code on that one to avoid merge conflicts.
> 
> [1] http://article.gmane.org/gmane.linux.kernel.samsung-soc/28642
> 

Your patch is applied? I can't find merged patch on linux-samsung.git and arm-soc.git.
If this patch is applied, I will rebase this patchset. Thanks.

Best Regards,
Chanwoo Choi


