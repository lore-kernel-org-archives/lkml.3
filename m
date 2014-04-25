Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbaDYF4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 01:56:43 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43893 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbaDYF4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 01:56:39 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-0b-5359f91593ea
Message-id: <5359F915.6030009@samsung.com>
Date: Fri, 25 Apr 2014 14:56:37 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Tushar Behera <tushar.behera@linaro.org>
Cc: kgene.kim@samsung.com, t.figa@samsung.com, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, ben-linux@fluff.org, arnd@arndb.de,
        olof@lixom.net, marc.zyngier@arm.com, thomas.abraham@linaro.org,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, sajjan.linux@gmail.com,
        sachin.kamat@linaro.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCHv4 3/7] ARM: EXYNOS: Support secondary CPU boot of Exynos3250
References: <1398388572-30239-1-git-send-email-cw00.choi@samsung.com>
 <1398388572-30239-4-git-send-email-cw00.choi@samsung.com>
 <5359E4E6.90102@linaro.org> <5359F5F5.7030109@samsung.com>
 <5359F894.4070205@linaro.org>
In-reply-to: <5359F894.4070205@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsWyRsSkQFf0Z2SwwZIWQ4u/k46xW0xad4DJ
	4vJ+bYv5R86xWnz+0AIUuj+BxaJ3wVU2i7NNb9gtNj2+xmpxedccNosZ5/cxWdy+zGvx984/
	NotT1z+zWZz808to8eTwR1aLGZNfslmsn/GaxeLYjCWMFu1/97JZ7N05mdFB1GPNvDWMHi3N
	PWwev39NYvT4u+oFs8fOWXfZPe5c28PmsXlJvceVE02sHn1bVjF6fN4kF8AVxWWTkpqTWZZa
	pG+XwJWxYu9WpoImvor1ezazNzAu5O5i5OSQEDCRONuzmwnCFpO4cG89G4gtJLCUUeJJpzJM
	zc01u5i7GLmA4osYJZ5PPMkI4bxmlNiz4h9YN6+AlkTn4rvMIDaLgKrE/X+dYJPYgOL7X9wA
	s0UFwiRWTr/CAlEvKPFj8j0wW0RAR+LBor0sIEOZBf4yS7w6+JERJCEsECBx6+0kFoht9xgl
	tr7qANvACTL11g+wImag7v2t09ggbHmJzWvegt0qIXCBQ6Ll8l82iJMEJL5NPgQ0iQMoISux
	6QAzxG+SEgdX3GCZwCg2C8lRs5CMnYVk7AJG5lWMoqkFyQXFSelFxnrFibnFpXnpesn5uZsY
	gSnj9L9n/TsY7x6wPsSYDLRyIrOUaHI+MOXklcQbGpsZWZiamBobmVuakSasJM57/2FSkJBA
	emJJanZqakFqUXxRaU5q8SFGJg5OqQbGgxNyJ1Tyc4tErS68fnvXtk7lY1PtLz0Ly5/zY8ZX
	zvtLf1q65chnFT6yOJe0LTzSPEBl2a/dj64s+GLm5XBGoZZfYYlkp7Wgp1kO15b7dmddSx81
	XV60k31NnU2T874nLGofK9q+tPO5n7a4O+v2do2Y9bnTrs3eyZt7JnbxVZHrDCnaivdTlFiK
	MxINtZiLihMBJ58xAC8DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFKsWRmVeSWpSXmKPExsVy+t9jAV3Rn5HBBpO/qVn8nXSM3WLSugNM
	Fpf3a1vMP3KO1eLzhxag0P0JLBa9C66yWZxtesNusenxNVaLy7vmsFnMOL+PyeL2ZV6Lv3f+
	sVmcuv6ZzeLkn15GiyeHP7JazJj8ks1i/YzXLBbHZixhtGj/u5fNYu/OyYwOoh5r5q1h9Ghp
	7mHz+P1rEqPH31UvmD12zrrL7nHn2h42j81L6j2unGhi9ejbsorR4/MmuQCuqAZGm4zUxJTU
	IoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygH5UUyhJzSoFCAYnF
	xUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGSv2bmUqaOKrWL9nM3sD40LuLkZODgkBE4mb
	a3YxQ9hiEhfurWfrYuTiEBJYxCjxfOJJRgjnNaPEnhX/mECqeAW0JDoX3wXrYBFQlbj/r5MN
	xGYDiu9/cQPMFhUIk1g5/QoLRL2gxI/J98BsEQEdiQeL9rKADGUW+Mss8ergR0aQhLBAgMSt
	t5NYILbdY5TY+qoDbAMnyNRbP8CKmIG697dOY4Ow5SU2r3nLPIFRYBaSJbOQlM1CUraAkXkV
	o2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnBKeia9g3FVg8UhRgEORiUe3gmykcFCrIllxZW5
	hxglOJiVRHiVVwGFeFMSK6tSi/Lji0pzUosPMSYDw2Ais5Rocj4wXeaVxBsam5gZWRqZG1oY
	GZuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA+OyV4ZvbZ+EvrEU83Z+aDJT4EhytWtp
	X79OzndRgzjeV+dv+XemXddtYJ7x5fb3JU6B3V9ZKh8ukpTqMbHvcA8tuHzdkaVm+hXJ6/nM
	X7unt56WvsjPwWtoctV20Vynzxsv9SYm6K/7yiA+geHI3JTvBie/Otgfs6hiUGCK+dOR+Nxu
	l+mP80osxRmJhlrMRcWJAFU//4KNAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/25/2014 02:54 PM, Tushar Behera wrote:
> On 04/25/2014 11:13 AM, Chanwoo Choi wrote:
>> Hi,
>>
>> On 04/25/2014 01:30 PM, Tushar Behera wrote:
>>> On 04/25/2014 06:46 AM, Chanwoo Choi wrote:
>>>> This patch fix the offset of CPU boot address and don't need to send smc call
>>>> of SMC_CMD_CPU1BOOT command for secondary CPU boot because Exynos3250 removes
>>>> WFE in secure mode.
>>>>
>>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>> ---
>>>>  arch/arm/mach-exynos/firmware.c | 10 ++++++++--
>>>>  1 file changed, 8 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
>>>> index aa01c42..386d01d 100644
>>>> --- a/arch/arm/mach-exynos/firmware.c
>>>> +++ b/arch/arm/mach-exynos/firmware.c
>>>> @@ -31,11 +31,17 @@ static int exynos_do_idle(void)
>>>>  static int exynos_cpu_boot(int cpu)
>>>>  {
>>>>  	/*
>>>> +	 * Exynos3250 doesn't need to send smc command for secondary CPU boot
>>>> +	 * because Exynos3250 removes WFE in secure mode.
>>>> +	 */
>>>> +	if (soc_is_exynos3250())
>>>> +		return 0;
>>>> +	/*
>>>>  	 * The second parameter of SMC_CMD_CPU1BOOT command means CPU id.
>>>>  	 * But, Exynos4212 has only one secondary CPU so second parameter
>>>>  	 * isn't used for informing secure firmware about CPU id.
>>>>  	 */
>>>> -	if (soc_is_exynos4212())
>>>> +	else if (soc_is_exynos4212())
>>>
>>> This changes is not required.
>>
>> Do you mean it as following?
>>
>> 	if (soc_is_exynos3250())
>> 		return 0
>>
>> 	if (soc_is_exynos4212())
>> 		cpu = 0;
>>
> 
> Yes, logically the flow would be same and code would be more readable.

OK, I'll fix it.

Thanks,
Chanwoo Choi

