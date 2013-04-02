Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761351Ab3DBJhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:37:14 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:18330 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760147Ab3DBJhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:37:11 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee691-b7f5f6d000002fda-b2-515aa6c4ccd3
Content-transfer-encoding: 8BIT
Message-id: <515AA6C3.3060408@samsung.com>
Date: Tue, 02 Apr 2013 18:37:07 +0900
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
 <515A8A21.6070509@linaro.org>
In-reply-to: <515A8A21.6070509@linaro.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zXd0jy6ICDSa2qFo8bfrBbnH9y3NW
	i3mfZS3ONr1ht3jzcDOjxeVdc9gsPvceYbRYe+Quu8XtxhVsFv0Le5ksZkx+yebA7XHn2h42
	j74tqxg9Hi1uYfT4vEkugCWKyyYlNSezLLVI3y6BK2PhsfvMBfdFK1YseMTWwLhYsIuRk0NC
	wETiwbm1zBC2mMSFe+vZuhi5OIQEljFKrD10l6mLkQOsaOphKYj4dKD43GVMIA28AoISPybf
	YwGpYRaQlzhyKRskzCygLjFp3iJmiPqXjBKfr15mh6jXkpjyB6Sek4NFQFVi69EvYIvZBOQk
	3jZ9YwSZIyoQIfGrnwMkLCKgJ9H4vo0JZA6zwA0miWVXmsF6hQUyJOY+usUCseAJo8THhr9g
	CU6gBRcaT4MlJAQ+sktcOPqAEWKbgMS3yYdYIL6Rldh0AOpjSYmDK26wTGAUm4Xkn1kI/8xC
	8s8CRuZVjKKpBckFxUnpRaZ6xYm5xaV56XrJ+bmbGCEROXEH4/0D1ocYk4E2TmSWEk3OB0Z0
	Xkm8obGZkYWpiamxkbmlGWnCSuK86i3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYj/pE
	y2Q1n/N80SKUc/yGl/PD+LkdOn8S7k+P+NVjnCQrUsZfNcNihk+CDsOpA5//efzQ1/5s7tw5
	5fEpvcbqRXrd6hGnIixXr9Sf03PPbYlGoqORxiX5BHNTh6p/gWcdO+pP5l1qKFBmK6quC04w
	vDhhyvcjZhmH/nH4y55kl7j6UHGBZrwSS3FGoqEWc1FxIgD5JlmB3gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jQd0jy6ICDRY9krN42vSD3eL6l+es
	FvM+y1qcbXrDbvHm4WZGi8u75rBZfO49wmix9shddovbjSvYLPoX9jJZzJj8ks2B2+POtT1s
	Hn1bVjF6PFrcwujxeZNcAEtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJC
	XmJuqq2Si0+ArltmDtBVSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCOsaM
	hcfuMxfcF61YseARWwPjYsEuRg4OCQETiamHpboYOYFMMYkL99azdTFycQgJTGeUWDt3GRNI
	gldAUOLH5HssIPXMAvISRy5lg4SZBdQlJs1bxAxR/5JR4vPVy+wQ9VoSU/6A1HNysAioSmw9
	+oUZxGYTkJN42/SNEWSOqECExK9+DpCwiICeROP7NiaQOcwCN5gkll1pBusVFsiQmPvoFgvE
	gieMEh8b/oIlOIEWXGg8zTKBUWAWkvtmIdw3C8l9CxiZVzGKphYkFxQnpeca6hUn5haX5qXr
	JefnbmIEx/szqR2MKxssDjEKcDAq8fA6zIkMFGJNLCuuzD3EKMHBrCTCu1U3KlCINyWxsiq1
	KD++qDQntfgQYzLQdxOZpUST84GpKK8k3tDYxMzI0sjM2MTc2Jg0YSVx3gOt1oFCAumJJanZ
	qakFqUUwW5g4OKUaGLN9fmj9en30tbxQYdGH7AKDxUfO2kUvnMQ2geHahuZW2T1mm831Gs+n
	yDt4lstNsq1+UFUko1MmcL43QdVuzsaIKNOr5va7q8rZVwt93TrVIFXmQdr/P7zPyqcG/5q0
	VO8kh9rVp/zVrzpnME84d/P6iX27VltcuRKwqaHao758/dFLdyXOrFJiKc5INNRiLipOBAAl
	dC4fOwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013년 04월 02일 16:34, Daniel Lezcano wrote:

> On 04/02/2013 08:17 AM, jonghwa3.lee@samsung.com wrote:
>> On 2013년 04월 02일 14:00, Daniel Lezcano wrote:
>>
>>> On 04/01/2013 10:24 AM, Jonghwa Lee wrote:
>>>> This patch adds idle state time stamp to cpuidle device structure to
>>>> notify its current idle state. If last enter time is newer than last
>>>> exit time, then it means that the core is in idle now.
>>>>
>>>> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>>>> ---
>>>
>>> The patch description does not explain what problem you want to solve,
>>> how to solve it and the patch itself shows nothing.
>>>
>>> Could you elaborate ?
>>
>>
>> I'm sorry for lacking description. I supplement more.
>>
>> This patch does add time-stamp for idle enter/exit only nothing more.
>> The reason why I needed them is that I wanted to know current cpu idle
>> state. It is hard to know whether cpu is in idle or not now.
> 
> Did you looked at:
> 
> include/linux/sched.h:extern int idle_cpu(int cpu);
> 


Yes, I did.

> ?
> 
>> When I check the cpuidle state usage, sometimes the information is wrong.
>> Because it is updated only when the cpu exits the idle state. So while the
>> cpu is idling, the cpuidle state usage holds past one. Therefore I put
>> the time-stamp for cpuidle enter/exit for checking current idling and
>> calculating idle state usage correctly.
>>
>> I just make this patch temporary for my cpufreq governor work. So, it just
>> use time-stamp for all idle state together. After RFC working, I have a plan
>> to update this patch to use timestamp for each idle state.
> 
> I suggest you look at the enter_idle / exit_idle function and make your
> governor to subscribe to the IDLE_START/EXIT notifiers.
> 
> arch/x86/kernel/process.c
> 
> These are defined for the x86 architecture, maybe worth to add it to
> another architecture.
> 


Thanks for your opinion.

Actually, I work on ARM architecture and I knew that the attempt of applying
idle notifier was failed. You probably knew it, because the link you gave me
before is that attempt. (https://lkml.org/lkml/2012/2/7/504) :) Currently, there
is only notifying call which is for led in arch/arm/kernel/process.c and I think
it isn't for me to use. Anyway, Do you really think it is better way to use
notifier than my way? Because I think it is too heavy for me. On my board,
sometimes entering idle happened hundreds times during the 100ms. I don't want
to call notifier that much time. IMO, just moving local variable to per-cpu
variable for showing the enter/exit time looks better although it requires code
modification on cpudile side.  What do you think?

Thanks,
Jonghwa.

> Thanks
>   -- Daniel
> 


