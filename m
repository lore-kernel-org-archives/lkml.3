Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbaDKBbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 21:31:10 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:48811 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbaDKBbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 21:31:07 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-e5-534745d769b9
Message-id: <534745D9.30604@samsung.com>
Date: Fri, 11 Apr 2014 10:31:05 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com, t.figa@samsung.com
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        hyunhee.kim@samsung.com, sw0312.kim@samsung.com,
        linux-kernel@vger.kernel.org, yj44.cho@samsung.com,
        inki.dae@samsung.com, kyungmin.park@samsung.com
Subject: Re: [PATCH 01/27] ARM: EXYNOS: Add Exynos3250 SoC ID
References: <1397122124-15690-1-git-send-email-cw00.choi@samsung.com>
 <1397122124-15690-2-git-send-email-cw00.choi@samsung.com>
 <5032959.JQvlxpLHiQ@wuerfel>
In-reply-to: <5032959.JQvlxpLHiQ@wuerfel>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsWyRsSkSPe6q3uwwZnTehZ/Jx1jt/j8oYXd
	YtL9CSwWvQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8lixuSXbBbrZ7xmsdi7czKjA7fH71+T
	GD02L6n36NuyitHj8ya5AJYoLpuU1JzMstQifbsEroxDDcEF3bwVU27sZ2lgPMjVxcjJISFg
	ItH36ycThC0mceHeerYuRi4OIYGljBLT/3xmhSna/7qBFSKxiFFi4cZPzCAJIYHXjBK3LgmB
	2LwCGhJX/p1hA7FZBFQldnZ1g01lE9CS2P/iBlhcVCBMYuX0KywQ9YISPybfA7NFBHwkNj9f
	AbaZWeApo8SdefsZQRLCArYSJ2/cZ4HYvIBR4sfrc2AncQpoSqy4ewGsm1lAR2J/6zQ2CFte
	YvOat8wgDRICL9klNndOYYU4SUDi2+RDQA0cQAlZiU0HmCFek5Q4uOIGywRGsVlIjpqFZOws
	JGMXMDKvYhRNLUguKE5KLzLVK07MLS7NS9dLzs/dxAiMytP/nk3cwXj/gPUhxmSglROZpUST
	84FRnVcSb2hsZmRhamJqbGRuaUaasJI4b/qjpCAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFIN
	jLpPXqgLyp6cJ/b+RthPoz/13L/WiHiWPLFmjcl+vmzfnw6vqokaF6N4zB3Xlp+dfSz0xUIj
	yxUMK+rqRKp+L/q7br7PCpfv5+9p6jVt0Ux/P33Va+frVUvTYzhfpfK9uiV4wW1FjQf7+04F
	q+Xhy6XflQZ+/bX2Y0b5iZ/PjjfIBN+4lFrhIa/EUpyRaKjFXFScCAAFqIsX4AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jAd3rru7BBm8Wqln8nXSM3eLzhxZ2
	i0n3J7BY9C64ymZxtukNu8Wmx9dYLS7vmsNmMeP8PiaLGZNfslmsn/GaxWLvzsmMDtwev39N
	YvTYvKTeo2/LKkaPz5vkAliiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU
	8hJzU22VXHwCdN0yc4CuUlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBm
	HGoILujmrZhyYz9LA+NBri5GTg4JAROJ/a8bWCFsMYkL99azdTFycQgJLGKUWLjxEzNIQkjg
	NaPErUtCIDavgIbElX9n2EBsFgFViZ1d3UwgNpuAlsT+FzfA4qICYRIrp19hgagXlPgx+R6Y
	LSLgI7H5+QqwBcwCTxkl7szbzwiSEBawlTh54z4LxOYFjBI/Xp8DO4lTQFNixd0LYN3MAjoS
	+1unsUHY8hKb17xlnsAoMAvJkllIymYhKVvAyLyKUTS1ILmgOCk911CvODG3uDQvXS85P3cT
	Izjmn0ntYFzZYHGIUYCDUYmHN+OCW7AQa2JZcWXuIUYJDmYlEd6eH0Ah3pTEyqrUovz4otKc
	1OJDjMnAMJjILCWanA9MR3kl8YbGJmZGlkbmhhZGxuakCSuJ8x5otQ4UEkhPLEnNTk0tSC2C
	2cLEwSnVwLjXacuG51dl9FlP+KupPYzNtzrXObMu3WKXx7OLD+Wdjp8RfPz6961TFx0X5O6R
	tkjrs1+0SWr+gpAqm41FC339np7aLi7DOK1Gcn+AwspffWfenJsc5nnFP3z+luthzeVcbm0W
	O6XPPuKQODXvz4k5X9WPe3U6LvumNfX4uf0Nx2/cTLo95ZifEktxRqKhFnNRcSIA80fdPT0D	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/10/2014 06:43 PM, Arnd Bergmann wrote:
> On Thursday 10 April 2014 18:28:18 Chanwoo Choi wrote:
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
>> +	bool "SAMSUNG EXYNOS3"
>> +	select ARM_AMBA
>> +	select CLKSRC_OF
>> +	select HAVE_ARM_SCU if SMP
>> +	select HAVE_SMP
>> +	select PINCTRL
>> +	select PM_GENERIC_DOMAINS if PM_RUNTIME
>> +	help
>> +	  Samsung EXYNOS3 SoCs based systems
>> +
> 
> Isn't S5PV210 also called an Exynos3 these days? Are we going to get
> any conflicts here when merging that code into Exynos as Tomasz has
> suggested in the past?

I knew. But, S5PV210/S5PC110 has not yet included in Exynos3 category on mainline.
Need opinion of Exynos SoC Maintainer to clear this ambiguous stuff.

Dear Kukjin and Tomasz,
I need your opinion about this patch.

Best Regards,
Chanwoo Choi


