Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab3GBHDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 03:03:50 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:38886 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab3GBHDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 03:03:48 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-a1-51d27b52d280
Message-id: <51D27B51.2050404@samsung.com>
Date: Tue, 02 Jul 2013 16:03:45 +0900
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
 <51D276E3.9030206@samsung.com>
In-reply-to: <51D276E3.9030206@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsWyRsSkQDeo+lKgwavDchZPm36wW5xtesNu
	cXnXHDaLz71HGC1uN65gs+hf2MtksfGrhwO7x51re9g8+rasYvR4tLiF0ePzJrkAligum5TU
	nMyy1CJ9uwSujNNzjrIUTNetmPuxmamBsUWpi5GTQ0LARKJj9nU2CFtM4sK99UA2F4eQwFJG
	iYnLbzDDFPX/WMAEkVjEKLFwwSdGCOcFo8TVhYvZQap4BbQkpt78ytrFyMHBIqAqsfOqNEiY
	DSi8/8UNsA2iAmESK6dfYYEoF5T4MfkeC0i5CFDNy5upICOZBaYzSkz/sQtssbBAhsT14x/A
	eoUEpjJJ3PnJB2JzCmhLrJ1ylxHEZhbQkdjfOo0NwpaX2LzmLdTRp9glJnQagdgsAgIS3yYf
	AtslISArsekAVImkxMEVN1gmMIrNQnLRLCRTZyGZuoCReRWjaGpBckFxUnqRoV5xYm5xaV66
	XnJ+7iZGYKSd/vesdwfj7QPWhxiTgVZOZJYSTc4HRmpeSbyhsZmRhamJqbGRuaUZacJK4rxq
	LdaBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhhTttx4IXl6rbzbIqkfP/72nuAUPV+TwdiU
	kJF90K4mOZLv3tNPkvOS8r6vTRX41N+pUNi0mPHZNevUiKM/nygdSJuTVCfsFPtymfVUgaAP
	X70fnDc1+rdFWKWRKyAjuKn3Fo/oZCZPl/s7/zK7cly9s3nmZEUmQf3mA54Zn7hmxXLpTQwX
	5lRiKc5INNRiLipOBAAqu0PFygIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t9jAd2g6kuBBn0rRC2eNv1gtzjb9Ibd
	4vKuOWwWn3uPMFrcblzBZtG/sJfJYuNXDwd2jzvX9rB59G1ZxejxaHELo8fnTXIBLFENjDYZ
	qYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QBcoKZQl5pQC
	hQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDNOzznKUjBdt2Lux2amBsYWpS5GTg4J
	AROJ/h8LmCBsMYkL99azdTFycQgJLGKUWLjgEyOE84JR4urCxewgVbwCWhJTb35l7WLk4GAR
	UJXYeVUaJMwGFN7/4gYbiC0qECaxcvoVFohyQYkfk++xgJSLANW8vJkKMpJZYDqjxPQfu5hB
	aoQFMiSuH/8A1iskMJVJ4s5PPhCbU0BbYu2Uu4wgNrOAjsT+1mlsELa8xOY1b5knMArMQrJi
	FpKyWUjKFjAyr2IUTS1ILihOSs810itOzC0uzUvXS87P3cQIjuRn0jsYVzVYHGIU4GBU4uFV
	mHcxUIg1say4MvcQowQHs5II701voBBvSmJlVWpRfnxRaU5q8SHGZGAATGSWEk3OByaZvJJ4
	Q2MTMyNLI3NDCyNjc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpgNOl+d/PMnbCFE1yC
	4tqEQ+8s991afmyyxwQFQY7at9s/6rrJZ3GbPQm6d/FX6onIGTsEsmYdYJz5r9jsxKy7pTM3
	71YOcXB/1W45bRXXmn05gocWXmvwXaR7lTHtn33HuZvfHNfybRO3+LiPLaU1/2RGuc/lv8lp
	Mk+2ikkxxpYt/x4kIbhYQYmlOCPRUIu5qDgRAGboY4EoAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2013 03:44 PM, Chanwoo Choi wrote:
> On 06/28/2013 07:13 PM, Viresh Kumar wrote:
>> On 28 June 2013 14:52, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>>> On 06/28/2013 05:18 PM, Viresh Kumar wrote:
>>>> On 28 June 2013 13:18, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>>
>>>> Can you describe a bit about the layout this will create in debugfs?
>>>> I thought you will have a load_table file per policy->cpu ??
>>>>
>>>
>>> The debugfs_cpufreq is debugfs root directory (/sys/kernel/debug/cpufreq)
>>
>> Which you are creating anyway in your patch.
>>
>>> and debugfs_cpufreq has many child directory for Per-CPU debugfs according to NR_CPUS number (/sys/kernel/debug/cpufreq/cpuX).
>>
>> Even you are creating this only for policy->cpu
>>
>>> Finally, Per-CPU debugfs create load_table debugfs file (/sys/kernel/debug/cpufreq/cpuX/load_table).
>>>
>>> For example, only CPU0 create sysfs directory and file (/sys/devices/system/cpu/cpu0/cpufreq)
>>> and then other CPUx create link of created sysfs directory by CPU0 in cpufreq_add_dev_symlink().
>>
>> This isn't how its happening now. You aren't creating any links.
> 
> You're right. This patch didn't create link for CPU1/2/3.
> 
>>
>>> So, I'm considering whether to create link of CPUx's debugfs file except for CPU0 as sysfs file.
>>> - /sys/kernel/debug/cpufreq/cpu1/
>>> - /sys/kernel/debug/cpufreq/cpu2/
>>> - /sys/kernel/debug/cpufreq/cpu3/
>>
>> Yes please.
> 
> OK. I'll create link for CPU1,2,3 if all CPUs is included in one cluster.
> 
> I explain the sequence for creating sysfs file of CPU0/1/2/3.
> There are difference about sysfs file. Only, CPU0 creates sysfs file
> and then CPU1/2/3 create a link to CPU0 sysfs file. If we want to create
> debugfs link for CPU1/2/3, I should have to create debugfs file for CPU0 /
I made wrong sentence and then change it.
: I should have to debugfs -> I should have to create debugfs file
> debugfs link for CPU1/2/3 when cpufreq_register_driver() is operated.
> This proposal won't always remove debugfs file for cpufreq when user change
> cpufreq governor from ondemand/conservative to performance/powersave.
> 
> So, I suggest that cpufreq core executes dbs_check_cpu() to calculate
> CPUx load when cpufreq governor is performance/powersave. While maintaing
> same cpu frequency on performance/powersave governor, there are different
> power-consumption according to CPUx load. I think we need to check CPUs load
> on peformance/powersave governor.
> 
> [Flow sequence for CPU0]
> cpufreq_register_driver()
> ->subsys_interface_register()
> -->sif->add_dev()
> ---> cpufreq_add_dev()
> ----> cpufreq_add_policy_cpu()
> -----> sysfs_create_link(&dev->kboj, &policy->kobj, "cpufreq");	: Create sysfs file (/sys/devices/system/cpu/cpu0/cpufreq)
> 
> [Flow sequence for CPU1/2/3]
> cpufreq_register_driver()
> ->subsys_interface_register()
> -->sif->add_dev()
> ---> cpufreq_add_dev()
> ----> cpufreq_add_policy_cpu()
> -----> cpufreq_add_dev_interface(cpu, ...)
> ------> cpufreq_add_dev_symlink(cpu, ...) : Create sysfs link about CPU0 sysfs file(/sys/devices/system/cpu/cpu0/cpufreq)
> 
>>
>>> - A number of online CPU is 4
>>> Time(ms)   Old Freq(Hz) New Freq(Hz) CPU0 CPU1 CPU2 CPU3
>>> 23165      200000       200000       2    0    0    0
>>> 23370      200000       200000       2    0    0    0
>>> 23575      200000       200000       2    0    1    0
>>> 23640      200000       200000       5    1    1    0
>>> 23780      200000       200000       3    0    1    0
>>> 23830      200000       200000       7    1    0    0
>>> 23985      200000       200000       1    0    0    0
>>> 24190      200000       200000       2    0    1    1
>>> 24385      200000       200000       2    0    0    0
>>> 24485      200000       200000       6    0    1    0
>>>
>>> - A number of online CPU is 2
>>> Time(ms)   Old Freq(Hz) New Freq(Hz) CPU0 CPU3
>>> 37615      200000       200000       0    0
>>> 37792      200000       200000       0    5
>>> 38015      200000       200000       21   8
>>> 38215      200000       200000       0    0
>>> 38275      200000       200000       5    0
>>> 38415      200000       200000       15   3
>>> 38615      200000       200000       0    0
>>> 38730      200000       200000       1    0
>>> 38945      200000       200000       0    0
>>> 39155      200000       200000       1    1
>>
>> If you do the loop over for_each_cpu(cpu, policy->cpus),
>> this problem will be resolved. You will see only online cpus.
>>
>>> I'm considering whether to check the kind of cpufreq governor for creating load_table
>>> in cpufreq_stats or execute dbs_check_cpu() on performance/powersave governor to check
>>> CPUx load. If you have opinion about this, I'd like to listen it.
>>
>> Maybe create these directories and do this stuff only when
>> the first CPUFREQ_LOADCHECK notification is received inside
>> cpufreq_stats.c
>>
>> Also don't create debug/cpufreq directory unless you have any
>> stuff to be created within this directory. Like, don't create it
>> if we are using performance governor for all cpus.
>>
> 
> If core create debugfs/cpufreq directory when first CPUFREQ_LOADCHECK
> notification is received inside cpufreq_stats.c, CPU1/2/3 don't send
> CPUFREQ_LOADCHECK notification. In result, cpufreq_stats.c couldn't
> create link for /sys/kernel/debug/cpufreq/cpu[1-3].
> 
> Best Regards,
> Chanwoo Choi
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

