Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbaDKAgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 20:36:51 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:46305 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbaDKAgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 20:36:49 -0400
X-AuditID: cbfee690-b7f266d00000287c-e5-5347391d478e
Message-id: <5347391E.7010201@samsung.com>
Date: Fri, 11 Apr 2014 09:36:46 +0900
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
 <87d2gp3430.fsf@approximate.cambridge.arm.com> <534678E1.2000005@samsung.com>
 <87mwft1j7f.fsf@approximate.cambridge.arm.com>
In-reply-to: <87mwft1j7f.fsf@approximate.cambridge.arm.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsWyRsSkWFfW0j3Y4O48XYvPH1rYLSbdn8Bi
	0bvgKpvF2aY37BabHl9jtbi8aw6bxYzz+5gs/t75B2RNfslmsX7GaxaLvTsnMzpwe6yZt4bR
	Y/OSeo++LasYPT5vkgtgieKySUnNySxLLdK3S+DK+P7gHlPBP6GKtf/msjQwTufvYuTkkBAw
	kdjRvpoVwhaTuHBvPVsXIxeHkMBSRomLS3cywRRNXLaWBSKxiFHizYGT7BDOa0aJles3s4FU
	8QpoSdyefZYFxGYRUJW40HoRrJsNKL7/xQ2wGlGBMImV06+wQNQLSvyYfA/MFhFQl3ja/wxs
	KLPAMRaJT8tngCWEBVIkJvRcgVrdxCSx5Mk+xi5GDg5OAWuJ9Z3MIDXMAjoS+1unsUHY8hKb
	17xlBqmXEHjELtFx5yozxEUCEt8mH2IB6ZUQkJXYdIAZ4jVJiYMrbrBMYBSbheSmWUjGzkIy
	dgEj8ypG0dSC5ILipPQiE73ixNzi0rx0veT83E2MwLg8/e/ZhB2M9w5YH2JMBlo5kVlKNDkf
	GNd5JfGGxmZGFqYmpsZG5pZmpAkrifOqPUoKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cDo
	H+JUeuPY0XXBtx28VmVq8S3X/f3+gtr3wsWfpns03zDZ7zhT8Xzj4tjHD06f0NSX797plSV+
	6O2JjnrJRxqy5eveNTmzzaqb3njj6fGJXs4Fs1179790uv1OLeG7xsoiGUbti5rXWj7riR9Z
	sHtNvtkjL+UdKZc2yz94eWflZJuVupwCEV8uKLEUZyQaajEXFScCAI+V1CPhAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t9jAV1ZS/dggzsrVSw+f2hht5h0fwKL
	Re+Cq2wWZ5vesFtsenyN1eLyrjlsFjPO72Oy+HvnH5A1+SWbxfoZr1ks9u6czOjA7bFm3hpG
	j81L6j36tqxi9Pi8SS6AJaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEv
	MTfVVsnFJ0DXLTMH6ColhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8b3
	B/eYCv4JVaz9N5elgXE6fxcjJ4eEgInExGVrWSBsMYkL99azdTFycQgJLGKUeHPgJDuE85pR
	YuX6zWwgVbwCWhK3Z58F62ARUJW40HqRCcRmA4rvf3EDrEZUIExi5fQrLBD1ghI/Jt8Ds0UE
	1CWe9j8DG8oscIxF4tPyGWAJYYEUiQk9IA0g25qYJJY82cfYxcjBwSlgLbG+kxmkhllAR2J/
	6zQ2CFteYvOat8wTGAVmIdkxC0nZLCRlCxiZVzGKphYkFxQnpeca6hUn5haX5qXrJefnbmIE
	R/0zqR2MKxssDjEKcDAq8fBmXHALFmJNLCuuzD3EKMHBrCTC2/MDKMSbklhZlVqUH19UmpNa
	fIgxGRgEE5mlRJPzgQkpryTe0NjEzMjSyNzQwsjYnDRhJXHeA63WgUIC6YklqdmpqQWpRTBb
	mDg4pRoY2Vsq9KKMJi84XvHRV943saZ0g/us8vKbqmV9e77U5f90ZGiUTLGefLGRd0ejnNQf
	gY/JEw/8ufs27utJias7Vl1x0T7eIiH8vlqxbOKVd6Ephze3XezQuihs+m1zsuPxb+E37Lzl
	lxybtDTS8N6UC20F9Zm+v6N+/L73T29P+8W4N46bd/AzKbEUZyQaajEXFScCAJnmTak+AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2014 09:07 PM, Marc Zyngier wrote:
> On Thu, Apr 10 2014 at 11:56:33 am BST, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> On 04/10/2014 06:51 PM, Marc Zyngier wrote:
>>> On Thu, Apr 10 2014 at 10:28:23 am BST, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>>>> This patch decide proper lowpower mode of either a15 or a9 according to own ID
>>>> from Main ID register.
>>>>
>>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>> ---
>>>>  arch/arm/mach-exynos/hotplug.c | 13 ++++++++++---
>>>>  1 file changed, 10 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
>>>> index 5eead53..36d3db6 100644
>>>> --- a/arch/arm/mach-exynos/hotplug.c
>>>> +++ b/arch/arm/mach-exynos/hotplug.c
>>>> @@ -135,13 +135,20 @@ void __ref exynos_cpu_die(unsigned int cpu)
>>>>  	int primary_part = 0;
>>>>  
>>>>  	/*
>>>> -	 * we're ready for shutdown now, so do it.
>>>> -	 * Exynos4 is A9 based while Exynos5 is A15; check the CPU part
>>>> +	 * we're ready for shutdown now, so do it. Exynos4 is A9 based
>>>> +	 * while Exynos5 is A15/Exynos7 is A7; check the CPU part
>>>>  	 * number by reading the Main ID register and then perform the
>>>>  	 * appropriate sequence for entering low power.
>>>>  	 */
>>>>  	asm("mrc p15, 0, %0, c0, c0, 0" : "=r"(primary_part) : : "cc");
>>>
>>> While you're touching that code, how about using:
>>>
>>>       primary_part = read_cpuid(CPUID_ID);
>>
>> Or, 
>> I suggest read_cpuid_part_number() instead of assembler directly.
>>
>> 	primary_part = read_cpuid_part_number();
> 
> Yup, even better.
> 
>>>
>>>> -	if ((primary_part & 0xfff0) == 0xc0f0)
>>>> +
>>>> +	/*
>>>> +	 * Main ID register of Cortex series
>>>> +	 * - Cortex-a7  : 0x410F_C07x
>>>> +	 * - Cortex-a15 : 0x410F_C0Fx
>>>> +	 */
>>>> +	primary_part = primary_part & 0xfff0;
>>>> +	if (primary_part == 0xc0f0 || primary_part == 0xc070)
>>>
>>> ARM_CPU_PART_CORTEX_A15, ARM_CPU_PART_CORTEX_A7
>>
>> OK I'll use this defined constant as following:
>>
>> 	switch (primary_part)
>> 	case ARM_CPU_PART_CORTEX_A7:
>> 	case ARM_CPU_PART_CORTEX_A15:
>> 		cpu_enter_lowpower_a15();
>> 		break;
>> 	default:
>> 		cpu_enter_lowpower_a9();
>> 		break;
>> 	}
> 
> Looks good.
> 

Thanks for your review.

Best Regards,
Chanwoo Choi

