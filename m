Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab3DBGRm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 02:17:42 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:35521 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251Ab3DBGRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 02:17:38 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68d-b7f786d000005188-0c-515a77fdfb3c
Content-transfer-encoding: 8BIT
Message-id: <515A77FC.70008@samsung.com>
Date: Tue, 02 Apr 2013 15:17:32 +0900
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
 <515A65DB.8070803@linaro.org>
In-reply-to: <515A65DB.8070803@linaro.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zPd2/5VGBBpfumlg8bfrBbnH9y3NW
	i3mfZS3ONr1ht3jzcDOjxeVdc9gsPvceYbRYe+Quu8XtxhVsFv0Le5ksZkx+yebA7XHn2h42
	j74tqxg9Hi1uYfT4vEkugCWKyyYlNSezLLVI3y6BK+Pb6VfMBeckK/Yc6mFqYFwn0sXIySEh
	YCLx8MhdRghbTOLCvfVsXYxcHEICyxgltrQfYoQpOjdvL1RiEaPEwTeTWUESvAKCEj8m32Pp
	YuTgYBaQlzhyKRskzCygLjFp3iJmiPqXjBJTlv9lh6jXkGhq6WcDqWcRUJX4P5MTJMwmICfx
	tukbI0hYVCBC4lc/B0hYREBPovF9GxPIGGaBG0wSy640s4AkhAUyJOY+usUCMX85o8Sja8/B
	DuUU0JL409oB1iEh8JZd4vi5W2CLWQQEJL5NPgR2qISArMSmA8wQj0lKHFxxg2UCo9gsJO/M
	QnhnFpJ3FjAyr2IUTS1ILihOSi8y1CtOzC0uzUvXS87P3cQIicjeHYy3D1gfYkwG2jiRWUo0
	OR8Y0Xkl8YbGZkYWpiamxkbmlmakCSuJ86q1WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRq
	YJz2vFBcv2f+mRmZB511ful1mnRNunm3spMxw+M4/zzZeWvDDwWtzXiyRviY+6q6dxPP/kgV
	99f0n7G2+Hbxfd4tgm2XHUpMYpRYl0Wq7dPPYnm7x9xpjlG+qL/BNcNZ1WzTV0RsZhPazPZ2
	j9n8w6/36nnu5ZnINUuUc8Flrrs7pzW8ev1gp6MSS3FGoqEWc1FxIgCLUKZC3gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jAd2/5VGBBgfX61k8bfrBbnH9y3NW
	i3mfZS3ONr1ht3jzcDOjxeVdc9gsPvceYbRYe+Quu8XtxhVsFv0Le5ksZkx+yebA7XHn2h42
	j74tqxg9Hi1uYfT4vEkugCWqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkh
	LzE31VbJxSdA1y0zB+gqJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPG
	t9OvmAvOSVbsOdTD1MC4TqSLkZNDQsBE4ty8vWwQtpjEhXvrgWwuDiGBRYwSB99MZgVJ8AoI
	SvyYfI+li5GDg1lAXuLIpWyQMLOAusSkeYuYIepfMkpMWf6XHaJeQ6KppZ8NpJ5FQFXi/0xO
	kDCbgJzE26ZvjCBhUYEIiV/9HCBhEQE9icb3bUwgY5gFbjBJLLvSzAKSEBbIkJj76BYLxPzl
	jBKPrj1nBElwCmhJ/GntYJrAKDALyXmzEM6bheS8BYzMqxhFUwuSC4qT0nMN9YoTc4tL89L1
	kvNzNzGC4/2Z1A7GlQ0WhxgFOBiVeHgd5kQGCrEmlhVX5h5ilOBgVhLh3aobFSjEm5JYWZVa
	lB9fVJqTWnyIMRnouYnMUqLJ+cBUlFcSb2hsYmZkaWRmbGJubEyasJI474FW60AhgfTEktTs
	1NSC1CKYLUwcnFINjF4fRbPazRR4C6YK10u2v2n7cOXQiRT2hS4Tnvkp7qv323aR++bROQfc
	ubcfuPuh2TOwifvNqqyE3LnNVvkWK/Z+sp+g616o9elJo1tY8SnmIyJn17+cUbZbcDl7pVre
	oUtlVr6Jd36paay5+O9Fu53ketYFFhV/D4c/qV38PyWLQYBvvTSfrBJLcUaioRZzUXEiAB7f
	w8M7AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013년 04월 02일 14:00, Daniel Lezcano wrote:

> On 04/01/2013 10:24 AM, Jonghwa Lee wrote:
>> This patch adds idle state time stamp to cpuidle device structure to
>> notify its current idle state. If last enter time is newer than last
>> exit time, then it means that the core is in idle now.
>>
>> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>> ---
> 
> The patch description does not explain what problem you want to solve,
> how to solve it and the patch itself shows nothing.
> 
> Could you elaborate ?


I'm sorry for lacking description. I supplement more.

This patch does add time-stamp for idle enter/exit only nothing more.
The reason why I needed them is that I wanted to know current cpu idle
state. It is hard to know whether cpu is in idle or not now.
When I check the cpuidle state usage, sometimes the information is wrong.
Because it is updated only when the cpu exits the idle state. So while the
cpu is idling, the cpuidle state usage holds past one. Therefore I put
the time-stamp for cpuidle enter/exit for checking current idling and
calculating idle state usage correctly.

I just make this patch temporary for my cpufreq governor work. So, it just
use time-stamp for all idle state together. After RFC working, I have a plan
to update this patch to use timestamp for each idle state.

Thanks,


And it also can be used to calculate cpuidle state usage even the cpu is idling.
I knew the code looks worthless, but as this patchset is just
suggesting idea,


> 
> Thanks
>   -- Daniel
> 
>>  drivers/cpuidle/cpuidle.c |    8 ++++----
>>  include/linux/cpuidle.h   |    4 ++++
>>  2 files changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
>> index eba6929..1e830cc 100644
>> --- a/drivers/cpuidle/cpuidle.c
>> +++ b/drivers/cpuidle/cpuidle.c
>> @@ -233,18 +233,18 @@ int cpuidle_wrap_enter(struct cpuidle_device *dev,
>>  				int (*enter)(struct cpuidle_device *dev,
>>  					struct cpuidle_driver *drv, int index))
>>  {
>> -	ktime_t time_start, time_end;
>>  	s64 diff;
>>  
>> -	time_start = ktime_get();
>> +	dev->last_idle_start = ktime_get();
>>  
>>  	index = enter(dev, drv, index);
>>  
>> -	time_end = ktime_get();
>> +	dev->last_idle_end = ktime_get();
>>  
>>  	local_irq_enable();
>>  
>> -	diff = ktime_to_us(ktime_sub(time_end, time_start));
>> +	diff = ktime_to_us(ktime_sub(dev->last_idle_end,
>> +				dev->last_idle_start));
>>  	if (diff > INT_MAX)
>>  		diff = INT_MAX;
>>  
>> diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
>> index 480c14d..d1af05f 100644
>> --- a/include/linux/cpuidle.h
>> +++ b/include/linux/cpuidle.h
>> @@ -16,6 +16,7 @@
>>  #include <linux/kobject.h>
>>  #include <linux/completion.h>
>>  #include <linux/hrtimer.h>
>> +#include <linux/ktime.h>
>>  
>>  #define CPUIDLE_STATE_MAX	8
>>  #define CPUIDLE_NAME_LEN	16
>> @@ -74,6 +75,9 @@ struct cpuidle_device {
>>  	struct kobject		kobj;
>>  	struct completion	kobj_unregister;
>>  
>> +	ktime_t			last_idle_start;
>> +	ktime_t			last_idle_end;
>> +
>>  #ifdef CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED
>>  	int			safe_state_index;
>>  	cpumask_t		coupled_cpus;
>>
> 
> 


