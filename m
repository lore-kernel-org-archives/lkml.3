Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab3GBKtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 06:49:35 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:64707 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab3GBKtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 06:49:32 -0400
X-AuditID: cbfee68e-b7f276d000002279-c4-51d2b03accc1
Message-id: <51D2B03A.3010806@samsung.com>
Date: Tue, 02 Jul 2013 19:49:30 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com
Subject: Re: [PATCH v4] cpufreq: stats: Add 'load_table' debugfs file to show
 accumulated data of CPUs
References: <1372405697-13556-1-git-send-email-cw00.choi@samsung.com>
 <CAKohpon6AaSRQKvffPG+J=NUU+5JdVhFo-_uMm=2H3u-yT5h0A@mail.gmail.com>
 <51CD55E2.5060205@samsung.com>
 <CAKohpokY+GEt9UaU5inWaiooLq8sX7jy63sok+FFvs_KyQpcKg@mail.gmail.com>
In-reply-to: <CAKohpokY+GEt9UaU5inWaiooLq8sX7jy63sok+FFvs_KyQpcKg@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsWyRsSkSNdqw6VAg42LNS2eNv1gtzjb9Ibd
	4vKuOWwWn3uPMFrcblzBZtG/sJfJYuNXDwd2jzvX9rB59G1ZxejxaHELo8fnTXIBLFFcNimp
	OZllqUX6dglcGWf+trMXLFKtWN7t3sD4WaqLkZNDQsBEYkr7LBYIW0ziwr31bF2MXBxCAksZ
	Jaa++8wCU/R6Qi87RGIRo0Tj+XuMEM4LRomORd1MXYwcHLwCWhLn5geDNLAIqEr0zG5nArHZ
	gML7X9xgA7FFBcIkVk6/AjaUV0BQ4sfkeywgrSJANS9vpoKMZBaYzigx/ccuZpAaYYEMievH
	P0Bd9IVR4sGESYwgCU6BYInnr7aBDWIW0JHY3zqNDcKWl9i85i0zSIOEwDl2ib2fupkhLhKQ
	+Db5ENg2CQFZiU0HmCE+k5Q4uOIGywRGsVlIbpqFZOwsJGMXMDKvYhRNLUguKE5KLzLSK07M
	LS7NS9dLzs/dxAiMtdP/nvXtYLx5wPoQYzLQyonMUqLJ+cBYzSuJNzQ2M7IwNTE1NjK3NCNN
	WEmcV63FOlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QD45rP3oldnhaP7uotOMBxa9mnswaJ
	UqWzTxt7XbG7ELXawKxOuUyl9VAP/4vSlI7ls98vetQza6nW9cDjbQ2/Gjfky9rEtN38nRt2
	22X3UbsmL+ffk4+GPvla8umN43rNuQs3NzddNmlIfRrgXn+D82lR9I/v/Q2S+1kvF7e9v79d
	INZazF6iXomlOCPRUIu5qDgRAKcX3bbLAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t9jAV2rDZcCDT4eULB42vSD3eJs0xt2
	i8u75rBZfO49wmhxu3EFm0X/wl4mi41fPRzYPe5c28Pm0bdlFaPHo8UtjB6fN8kFsEQ1MNpk
	pCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAF2gpFCWmFMK
	FApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcw487edvWCRasXybvcGxs9SXYycHBIC
	JhKvJ/SyQ9hiEhfurWfrYuTiEBJYxCjReP4eI4TzglGiY1E3UxcjBwevgJbEufnBIA0sAqoS
	PbPbmUBsNqDw/hc32EBsUYEwiZXTr7CA2LwCghI/Jt9jAWkVAap5eTMVZCSzwHRGiek/djGD
	1AgLZEhcP/4BavEXRokHEyYxgiQ4BYIlnr/aBjaIWUBHYn/rNDYIW15i85q3zBMYBWYh2TEL
	SdksJGULGJlXMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgRH8jOpHYwrGywOMQpwMCrx8CrM
	uxgoxJpYVlyZe4hRgoNZSYT31JpLgUK8KYmVValF+fFFpTmpxYcYk4FBMJFZSjQ5H5hk8kri
	DY1NzIwsjcwNLYyMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBUXD2pRNKbxnzf8+v
	ub7Z3c5tjv3L3sMXKtT2H7kyc0ZIvcSRvOJJF37tDmHtOLLoQvwng/KPZqu50uY/N7stFKK+
	7X3OEacPl4UeMu2RDcmytjPRWGxzMN384417KZKbYu698OVtP2GyZtLmT8as59auT26ut7QT
	Kr/9mvvdd65lXOu8xVce2qLEUpyRaKjFXFScCABzneBlKAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

Previously, I sent two reply about your reply. But, Please ignore previous reply.
Those have wrong function flow about creating sysfs file and poor wrong opinion.

I'm so sorry if you're confused.

On 06/28/2013 07:13 PM, Viresh Kumar wrote:
> On 28 June 2013 14:52, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> On 06/28/2013 05:18 PM, Viresh Kumar wrote:
>>> On 28 June 2013 13:18, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> 
>>> Can you describe a bit about the layout this will create in debugfs?
>>> I thought you will have a load_table file per policy->cpu ??
>>>
>>
>> The debugfs_cpufreq is debugfs root directory (/sys/kernel/debug/cpufreq)
> 
> Which you are creating anyway in your patch.
> 
>> and debugfs_cpufreq has many child directory for Per-CPU debugfs according to NR_CPUS number (/sys/kernel/debug/cpufreq/cpuX).
> 
> Even you are creating this only for policy->cpu
> 
>> Finally, Per-CPU debugfs create load_table debugfs file (/sys/kernel/debug/cpufreq/cpuX/load_table).
>>
>> For example, only CPU0 create sysfs directory and file (/sys/devices/system/cpu/cpu0/cpufreq)
>> and then other CPUx create link of created sysfs directory by CPU0 in cpufreq_add_dev_symlink().
> 
> This isn't how its happening now. You aren't creating any links.

You're right. This patch didn't create link for CPU1/2/3.

> 
>> So, I'm considering whether to create link of CPUx's debugfs file except for CPU0 as sysfs file.
>> - /sys/kernel/debug/cpufreq/cpu1/
>> - /sys/kernel/debug/cpufreq/cpu2/
>> - /sys/kernel/debug/cpufreq/cpu3/
> 
> Yes please.

OK. I'll create link for CPU[1-3] if multiple core use one cpufreq policy.
In result, we can check below directory structure.

sh-4.1# ls -al /sys/kernel/debug/cpufreq/
total 0
drwxr-xr-x  3 root root 0 Jan  1 09:00 .
drwx------ 26 root root 0 Jan  1 09:00 ..
drwxr-xr-x  2 root root 0 Jan  1 09:00 cpu0
lrwxrwxrwx  1 root root 0 Jan  1 09:00 cpu1 -> ./cpu0
lrwxrwxrwx  1 root root 0 Jan  1 09:00 cpu2 -> ./cpu0
lrwxrwxrwx  1 root root 0 Jan  1 09:00 cpu3 -> ./cpu0

And then I will create load_table debugfs file below of /sys/kernel/debug/cpufreq/cpu0
in cpufreq_stats.c

> 
>> - A number of online CPU is 4
>> Time(ms)   Old Freq(Hz) New Freq(Hz) CPU0 CPU1 CPU2 CPU3
>> 23165      200000       200000       2    0    0    0
>> 23370      200000       200000       2    0    0    0
>> 23575      200000       200000       2    0    1    0
>> 23640      200000       200000       5    1    1    0
>> 23780      200000       200000       3    0    1    0
>> 23830      200000       200000       7    1    0    0
>> 23985      200000       200000       1    0    0    0
>> 24190      200000       200000       2    0    1    1
>> 24385      200000       200000       2    0    0    0
>> 24485      200000       200000       6    0    1    0
>>
>> - A number of online CPU is 2
>> Time(ms)   Old Freq(Hz) New Freq(Hz) CPU0 CPU3
>> 37615      200000       200000       0    0
>> 37792      200000       200000       0    5
>> 38015      200000       200000       21   8
>> 38215      200000       200000       0    0
>> 38275      200000       200000       5    0
>> 38415      200000       200000       15   3
>> 38615      200000       200000       0    0
>> 38730      200000       200000       1    0
>> 38945      200000       200000       0    0
>> 39155      200000       200000       1    1
> 
> If you do the loop over for_each_cpu(cpu, policy->cpus),
> this problem will be resolved. You will see only online cpus.
> 
>> I'm considering whether to check the kind of cpufreq governor for creating load_table
>> in cpufreq_stats or execute dbs_check_cpu() on performance/powersave governor to check
>> CPUx load. If you have opinion about this, I'd like to listen it.
> 
> Maybe create these directories and do this stuff only when
> the first CPUFREQ_LOADCHECK notification is received inside
> cpufreq_stats.c
> 
> Also don't create debug/cpufreq directory unless you have any
> stuff to be created within this directory. Like, don't create it
> if we are using performance governor for all cpus.

I understand your opinion. But I have a suggestion for using load_table debugfs file
if cpufreq governor is performance/powersave.

So, I suggest that performance/powersave governor may need to executes dbs_check_cpu()
to calculate CPUx load. Sometimes, we need CPUs load on performance/powersave
govenor because we could get different power-consumption according to CPUs load
on same cpu frequency when we estimate power-consumption on specific test case.

I think we need to check CPUs load on peformance/powersave governor.

What is your opinion?

Best Regards,
Chanwoo Choi


