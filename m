Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762622Ab3DCGKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 02:10:16 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43615 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761746Ab3DCGKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 02:10:12 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68e-b7f946d000001e37-a5-515bc7c10f27
Content-transfer-encoding: 8BIT
Message-id: <515BC7C0.3090009@samsung.com>
Date: Wed, 03 Apr 2013 15:10:08 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, sw0312.kim@samsung.com,
        m.szyprowski@samsung.com
Subject: Re: [RFC PATCH 1/2] cpuidle: Add idle enter/exit time stamp for
 notifying current idle state.
References: <1364804657-16590-1-git-send-email-jonghwa3.lee@samsung.com>
 <1364804657-16590-2-git-send-email-jonghwa3.lee@samsung.com>
 <515A65DB.8070803@linaro.org> <515A77FC.70008@samsung.com>
 <515A8A21.6070509@linaro.org> <515AA6C3.3060408@samsung.com>
 <515AAE2C.3040407@linaro.org> <515ABC0C.1090102@samsung.com>
 <515ABE83.3070200@linaro.org>
In-reply-to: <515ABE83.3070200@linaro.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zPd2Dx6MDDc5fMbd42vSD3eL6l+es
	FvM+y1qcbXrDbvHm4WZGi8u75rBZfO49wmix9shddovbjSvYLPoX9jJZzJj8ks2B2+POtT1s
	Hn1bVjF6PFrcwujxeZNcAEsUl01Kak5mWWqRvl0CV8bXH8EFj1Qrtq+bxdzAOE2ui5GTQ0LA
	ROLr8jnMELaYxIV769m6GLk4hASWMUoc+nWFCaZo/fyjzBCJ6YwSC2Z0g3XwCghK/Jh8j6WL
	kYODWUBe4silbJAws4C6xKR5i8BKhAReMko0znCDKNeSaDh5GSzOIqAqcWPeCnYQm01ATuJt
	0zdGkDGiAhESv/o5QMIiAnoSje/bmEDWMgvcYJJYdqWZBSQhLJAhMffRLRaIex4xSfx6e5kV
	JMEJtODG+Wlgh0oIvGWXOP2mmwlim4DEt8mHwA6VEJCV2HQA6mNJiYMrbrBMYBSbheSdWQjv
	zELyzgJG5lWMoqkFyQXFSelFRnrFibnFpXnpesn5uZsYIfHYt4Px5gHrQ4zJQBsnMkuJJucD
	4zmvJN7Q2MzIwtTE1NjI3NKMNGElcV61FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYwl
	T9I1WdQ3W7g8dXVd8FVKo6FOXk+B6aFnZUS/XNZ6yVu6bBO+TlzNtG2ZkUvMwsXP7Fwv9N6Y
	Kbm+c7LjNbOnxjYx+05ZxOx3/TDpz6EYvox9h8wjHOu3RfEX7b3EVZDyVmhWxWPTrll71ky7
	1GrHOfs224n1Lp/s8l7MeK0kzM3yJHDrvQdKLMUZiYZazEXFiQBwUZzR3QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jQd2Dx6MDDf6vMLR42vSD3eL6l+es
	FvM+y1qcbXrDbvHm4WZGi8u75rBZfO49wmix9shddovbjSvYLPoX9jJZzJj8ks2B2+POtT1s
	Hn1bVjF6PFrcwujxeZNcAEtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJC
	XmJuqq2Si0+ArltmDtBVSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCOsaM
	rz+CCx6pVmxfN4u5gXGaXBcjJ4eEgInE+vlHmSFsMYkL99azdTFycQgJTGeUWDCjGyzBKyAo
	8WPyPZYuRg4OZgF5iSOXskHCzALqEpPmLQIrERJ4ySjROMMNolxLouHkZbA4i4CqxI15K9hB
	bDYBOYm3Td8YQcaICkRI/OrnAAmLCOhJNL5vYwJZyyxwg0li2ZVmFpCEsECGxNxHt1gg7nnE
	JPHr7WVWkAQn0IIb56cxT2AUmIXkvFkI581Cct4CRuZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ
	+bmbGMHR/kx6B+OqBotDjAIcjEo8vCe+RAUKsSaWFVfmHmKU4GBWEuE9HRYdKMSbklhZlVqU
	H19UmpNafIgxGei7icxSosn5wESUVxJvaGxiZmRpZGZsYm5sTJqwkjjvwVbrQCGB9MSS1OzU
	1ILUIpgtTBycUg2Mk48wlLMtT/bJnn38GlvOwpbZf47N/RDD0mlw0Fbp+KnvSyVNKnp2rLb4
	NzF5ampJiXP9ohXt+yf/L59Vdvy+j0xqjt39mScqC1dyJyvM3HDiyJIVEeqSMfcYhAJCagTe
	bsh2Pn3v7pPLlxUO1Bp8N5ile9m6jSenvOUBA+vcfyfuGvy4KjlzkRJLcUaioRZzUXEiAJ+m
	o4s6AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013년 04월 02일 20:18, Daniel Lezcano wrote:

> On 04/02/2013 01:07 PM, jonghwa3.lee@samsung.com wrote:
>> On 2013년 04월 02일 19:08, Daniel Lezcano wrote:
>>
>>> On 04/02/2013 11:37 AM, jonghwa3.lee@samsung.com wrote:
>>>> On 2013년 04월 02일 16:34, Daniel Lezcano wrote:
>>>>
>>>>> On 04/02/2013 08:17 AM, jonghwa3.lee@samsung.com wrote:
>>>>>> On 2013년 04월 02일 14:00, Daniel Lezcano wrote:
>>>>>>
>>>>>>> On 04/01/2013 10:24 AM, Jonghwa Lee wrote:
>>>>>>>> This patch adds idle state time stamp to cpuidle device structure to
>>>>>>>> notify its current idle state. If last enter time is newer than last
>>>>>>>> exit time, then it means that the core is in idle now.
>>>>>>>>
>>>>>>>> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>>>>>>>> ---
>>>>>>>
>>>>>>> The patch description does not explain what problem you want to solve,
>>>>>>> how to solve it and the patch itself shows nothing.
>>>>>>>
>>>>>>> Could you elaborate ?
>>>>>>
>>>>>>
>>>>>> I'm sorry for lacking description. I supplement more.
>>>>>>
>>>>>> This patch does add time-stamp for idle enter/exit only nothing more.
>>>>>> The reason why I needed them is that I wanted to know current cpu idle
>>>>>> state. It is hard to know whether cpu is in idle or not now.
>>>>>
>>>>> Did you looked at:
>>>>>
>>>>> include/linux/sched.h:extern int idle_cpu(int cpu);
>>>>>
>>>>
>>>>
>>>> Yes, I did.
>>>>
>>>>> ?
>>>>>
>>>>>> When I check the cpuidle state usage, sometimes the information is wrong.
>>>>>> Because it is updated only when the cpu exits the idle state. So while the
>>>>>> cpu is idling, the cpuidle state usage holds past one. Therefore I put
>>>>>> the time-stamp for cpuidle enter/exit for checking current idling and
>>>>>> calculating idle state usage correctly.
>>>>>>
>>>>>> I just make this patch temporary for my cpufreq governor work. So, it just
>>>>>> use time-stamp for all idle state together. After RFC working, I have a plan
>>>>>> to update this patch to use timestamp for each idle state.
>>>>>
>>>>> I suggest you look at the enter_idle / exit_idle function and make your
>>>>> governor to subscribe to the IDLE_START/EXIT notifiers.
>>>>>
>>>>> arch/x86/kernel/process.c
>>>>>
>>>>> These are defined for the x86 architecture, maybe worth to add it to
>>>>> another architecture.
>>>>>
>>>>
>>>>
>>>> Thanks for your opinion.
>>>>
>>>> Actually, I work on ARM architecture and I knew that the attempt of applying
>>>> idle notifier was failed. You probably knew it, because the link you gave me
>>>> before is that attempt. (https://lkml.org/lkml/2012/2/7/504) :)
>>>
>>> Yeah, now I recall this thread.
>>>
>>
>>
>> Oh my, I thought you gave the link but you didn't. It was Viresh Kumar from
>> other patch of the patchset. Sorry.
>>
>>>> Currently, there
>>>> is only notifying call which is for led in arch/arm/kernel/process.c and I think
>>>> it isn't for me to use. Anyway, Do you really think it is better way to use
>>>> notifier than my way? Because I think it is too heavy for me. On my board,
>>>> sometimes entering idle happened hundreds times during the 100ms. I don't want
>>>> to call notifier that much time. IMO, just moving local variable to per-cpu
>>>> variable for showing the enter/exit time looks better although it requires code
>>>> modification on cpudile side.  What do you think?
>>>
>>> Sorry, but it is hard to figure out what you are trying to achieve with
>>> a single patch.
>>>
>>> IIUC, you want to know how long the cpu is idle including the current
>>> state, right ? So you need to know if the cpu is idle and when it
>>> entered the idle state, correct ?
>>>
>>
>>
>> Exactly.
>>
>>  
>>> If the cpu is idle and the information is per cpu, how will you read
>>> this value from another cpu without introducing a locking mechanism ?
>>>
>>
>>
>> I think it might be tolerated for incoherency of that data. Governor reads the
>> data only, and if recoded start time or end time are different in few usec with
>> real one then it doesn't effect to the result much.
>>
>>
>>> Does it mean the cpufreq governor needs cpuidle ? I am wondering if
>>> these informations shouldn't be retrieved from the scheduler, not from
>>> cpuidle.
>>>
>>
>>
>> Yes, tick_sched per-cpu variable has all information that I need. But it isn't
>> global variable. And I'm afraid to change static variable to global one as my
>> pleases.
> 
> It is a global variable but there is a function to get access:
> 
> extern struct tick_sched *tick_get_tick_sched(int cpu);
> 
> Does it fit better for what you want to achieve ?


Yes, it seems exactly what I needed. I'll check it.
Thanks for your advice :)

Thanks,
Jonghwa.

> 
> Thanks
>   -- Daniel
> 
> 


