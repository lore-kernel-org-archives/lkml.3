Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965865AbaDJK4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:56:37 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:61355 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965541AbaDJK4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:56:34 -0400
X-AuditID: cbfee68f-b7f156d00000276c-fd-534678e019b3
Message-id: <534678E1.2000005@samsung.com>
Date: Thu, 10 Apr 2014 19:56:33 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "t.figa@samsung.com" <t.figa@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "hyunhee.kim@samsung.com" <hyunhee.kim@samsung.com>,
        "sw0312.kim@samsung.com" <sw0312.kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yj44.cho@samsung.com" <yj44.cho@samsung.com>,
        "inki.dae@samsung.com" <inki.dae@samsung.com>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 06/27] ARM: EXYNOS:: Enter a15 lowpower mode for Exynos3250
 based on Cortex-a7
References: <1397122124-15690-1-git-send-email-cw00.choi@samsung.com>
 <1397122124-15690-7-git-send-email-cw00.choi@samsung.com>
 <87d2gp3430.fsf@approximate.cambridge.arm.com>
In-reply-to: <87d2gp3430.fsf@approximate.cambridge.arm.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsWyRsSkSPdBhVuwwYmL6hafP7SwW0y6P4HF
	onfBVTaLs01v2C02Pb7GanF51xw2ixnn9zFZ/L3zD8ia/JLNYv2M1ywWe3dOZnTg9lgzbw2j
	x+Yl9R59W1YxenzeJBfAEsVlk5Kak1mWWqRvl8CV0brqBVNBs2DFhAWPGBsY9/B2MXJySAiY
	SHy6upEZwhaTuHBvPRuILSSwlFHi/+l0mJrLM34BxbmA4tMZJbauX8sC4bxmlHj7ej4rSBWv
	gJbEvR2XWUBsFgFVicmLLoBNYgOK739xA8wWFQiTWDn9CgtEvaDEj8n3wGwRAXWJp/3P2EGG
	MgscY5H4tHwGWEJYIEViQg9Eg5DAJkaJKz0ZIDangLVEW9M3RhCbWUBHYn/rNDYIW15i85q3
	zCCDJATusUvc+n0N6iIBiW+TDwHZHEAJWYlNB6BelpQ4uOIGywRGsVlIbpqFZOwsJGMXMDKv
	YhRNLUguKE5KLzLWK07MLS7NS9dLzs/dxAiMytP/nvXvYLx7wPoQYzLQyonMUqLJ+cCoziuJ
	NzQ2M7IwNTE1NjK3NCNNWEmc9/7DpCAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjLvunp/g
	ovP7VZ+nlvSvov0abUsfC7R6V2w6Ui/37rvJh3Xh/jX/habWm9QV3GwsnCodxXac4/+Pqneh
	z6b0qL2X+B0rdGbPWebvlzZLz01X3t8oOUFOwXvduSfLEvIvvup5uthb1KaocbrkZrera5+F
	5ywK3zm1w+aj986Zu++7TfvLc+nCRnMlluKMREMt5qLiRAC6USUQ4AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t9jQd0HFW7BBrOuy1l8/tDCbjHp/gQW
	i94FV9kszja9YbfY9Pgaq8XlXXPYLGac38dk8ffOPyBr8ks2i/UzXrNY7N05mdGB22PNvDWM
	HpuX1Hv0bVnF6PF5k1wAS1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJe
	Ym6qrZKLT4CuW2YO0FVKCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxozW
	VS+YCpoFKyYseMTYwLiHt4uRk0NCwETi8oxfbBC2mMSFe+uBbC4OIYHpjBJb169lgXBeM0q8
	fT2fFaSKV0BL4t6OyywgNouAqsTkRRfAutmA4vtf3ACzRQXCJFZOv8ICUS8o8WPyPTBbREBd
	4mn/M3aQocwCx1gkPi2fAZYQFkiRmNAD0SAksIlR4kpPBojNKWAt0db0jRHEZhbQkdjfOo0N
	wpaX2LzmLfMERoFZSHbMQlI2C0nZAkbmVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBUf9M
	agfjygaLQ4wCHIxKPLwHlrkGC7EmlhVX5h5ilOBgVhLh3Z3pFizEm5JYWZValB9fVJqTWnyI
	MRkYBBOZpUST84EJKa8k3tDYxMzI0sjc0MLI2Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4
	OKUaGBmPLNFX1IvbwHZi64c49p0HJLNEz7075v0pUdJt2s59DdN7p+45PPM8p+GbQPZaxRMv
	xE9cElzbI8yzff9WyWBPXm2tw0xp24ucLsfcWPpCNINrP//NH+wsosWpOd7V9R4LVyfkOdnf
	YU67Nfuw1T/Tp+2iG47aWrT5T754RcLCg0u5fa15qRJLcUaioRZzUXEiAMc000w+AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2014 06:51 PM, Marc Zyngier wrote:
> On Thu, Apr 10 2014 at 10:28:23 am BST, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> This patch decide proper lowpower mode of either a15 or a9 according to own ID
>> from Main ID register.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  arch/arm/mach-exynos/hotplug.c | 13 ++++++++++---
>>  1 file changed, 10 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
>> index 5eead53..36d3db6 100644
>> --- a/arch/arm/mach-exynos/hotplug.c
>> +++ b/arch/arm/mach-exynos/hotplug.c
>> @@ -135,13 +135,20 @@ void __ref exynos_cpu_die(unsigned int cpu)
>>  	int primary_part = 0;
>>  
>>  	/*
>> -	 * we're ready for shutdown now, so do it.
>> -	 * Exynos4 is A9 based while Exynos5 is A15; check the CPU part
>> +	 * we're ready for shutdown now, so do it. Exynos4 is A9 based
>> +	 * while Exynos5 is A15/Exynos7 is A7; check the CPU part
>>  	 * number by reading the Main ID register and then perform the
>>  	 * appropriate sequence for entering low power.
>>  	 */
>>  	asm("mrc p15, 0, %0, c0, c0, 0" : "=r"(primary_part) : : "cc");
> 
> While you're touching that code, how about using:
> 
>       primary_part = read_cpuid(CPUID_ID);

Or, 
I suggest read_cpuid_part_number() instead of assembler directly.

	primary_part = read_cpuid_part_number();

> 
>> -	if ((primary_part & 0xfff0) == 0xc0f0)
>> +
>> +	/*
>> +	 * Main ID register of Cortex series
>> +	 * - Cortex-a7  : 0x410F_C07x
>> +	 * - Cortex-a15 : 0x410F_C0Fx
>> +	 */
>> +	primary_part = primary_part & 0xfff0;
>> +	if (primary_part == 0xc0f0 || primary_part == 0xc070)
> 
> ARM_CPU_PART_CORTEX_A15, ARM_CPU_PART_CORTEX_A7

OK I'll use this defined constant as following:

	switch (primary_part)
	case ARM_CPU_PART_CORTEX_A7:
	case ARM_CPU_PART_CORTEX_A15:
		cpu_enter_lowpower_a15();
		break;
	default:
		cpu_enter_lowpower_a9();
		break;
	}

> 
>>  		cpu_enter_lowpower_a15();
>>  	else
>>  		cpu_enter_lowpower_a9();
> 

Best Regards,
Chanwoo Choi


