Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbaDNGU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 02:20:29 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:51507 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbaDNGU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 02:20:26 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-ed-534b7e26c466
Message-id: <534B7E29.5090601@samsung.com>
Date: Mon, 14 Apr 2014 15:20:25 +0900
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
 <5032959.JQvlxpLHiQ@wuerfel> <534745D9.30604@samsung.com>
In-reply-to: <534745D9.30604@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsWyRsSkSFetzjvY4PB0Lou/k46xW3z+0MJu
	Men+BBaL3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2QxY/JLNov1M16zWOzdOZnRgdvj969J
	jB6bl9R79G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8b8q+wFx/gq3l+/yNTAeIO7i5GTQ0LA
	ROLB5ycsELaYxIV769m6GLk4hASWMkqsbNjJDFO06tgrFojEdEaJF482gCWEBF4zSry/aQFi
	8wpoScz6CFLEwcEioCrxaJ0KSJgNKLz/xQ02EFtUIExi5fQrLBDlghI/Jt8Ds0UEfCQ2P18B
	tphZ4CmjxJ15+xlBEsICthInb9yHWryXUWLh4x4mkASngKbEt8dNYEXMAjoS+1unsUHY8hKb
	17xlBmmQEHjJLnFqRSNYgkVAQOLb5ENg10kIyEpsOgD1maTEwRU3WCYwis1CctQsJGNnIRm7
	gJF5FaNoakFyQXFSepGhXnFibnFpXrpecn7uJkZgTJ7+96x3B+PtA9aHGJOBVk5klhJNzgfG
	dF5JvKGxmZGFqYmpsZG5pRlpwkrivEkPk4KEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MN7b
	nGb+2LphxWmBV4ulPbuiMyQvNsVvCbjseXbZWf/l/wQN5adkc9Ssf/pJp+ZpHNuVDwc6H23l
	X5q9/Occg2veczyYJyo92Jgbkhnkv2PtfX+rFv+i70XhB2cttTXeLjO75ey3zR8PLF4azdQd
	1b9M/UPS/DlzOheI/co2a7UNKz/KxLXz01olluKMREMt5qLiRABx8XnX3wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jQV21Ou9gg1nnGS3+TjrGbvH5Qwu7
	xaT7E1gsehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PFjMkv2SzWz3jNYrF352RGB26P378m
	MXpsXlLv0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koK
	eYm5qbZKLj4Bum6ZOUBXKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgz
	5l9lLzjGV/H++kWmBsYb3F2MnBwSAiYSq469YoGwxSQu3FvP1sXIxSEkMJ1R4sWjDcwgCSGB
	14wS729agNi8AloSsz6CNHBwsAioSjxapwISZgMK739xgw3EFhUIk1g5/QoLRLmgxI/J98Bs
	EQEfic3PV4DNZxZ4yihxZ95+RpCEsICtxMkb91kgFu9llFj4uIcJJMEpoCnx7XETWBGzgI7E
	/tZpbBC2vMTmNW+ZJzAKzEKyZBaSsllIyhYwMq9iFE0tSC4oTkrPNdIrTswtLs1L10vOz93E
	CI74Z9I7GFc1WBxiFOBgVOLhTdjuGSzEmlhWXJl7iFGCg1lJhHdbhlewEG9KYmVValF+fFFp
	TmrxIcZkYBBMZJYSTc4HJqO8knhDYxMzI0sjc0MLI2Nz0oSVxHkPtloHCgmkJ5akZqemFqQW
	wWxh4uCUamC0bN2/rPtLnIrEk6mSLql33b29Qq21LqYfClMIUPRc03Z28iatzW4/fv3ZJD3R
	NndniNNXJz/VnxP2frt8tnHHvsIHLuvD7t659bZEfpP+CbcrfwuEb++9uEVS9Nce1+nFc3Mv
	Tn6hqHRyz59dUxSfMnV0MLc93tDb+kci/uM/maL2jBm7Sjq7lFiKMxINtZiLihMB1KdA/zwD	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Kukjin and Tomasz,

On 04/11/2014 10:31 AM, Chanwoo Choi wrote:
> Hi,
> 
> On 04/10/2014 06:43 PM, Arnd Bergmann wrote:
>> On Thursday 10 April 2014 18:28:18 Chanwoo Choi wrote:
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
>>
>> Isn't S5PV210 also called an Exynos3 these days? Are we going to get
>> any conflicts here when merging that code into Exynos as Tomasz has
>> suggested in the past?
> 
> I knew. But, S5PV210/S5PC110 has not yet included in Exynos3 category on mainline.
> Need opinion of Exynos SoC Maintainer to clear this ambiguous stuff.
> 
> Dear Kukjin and Tomasz,
> I need your opinion about this patch.
> 

Please review this patch and reply about Arnd's comment.

Best Regards,
Chanwoo Choi

