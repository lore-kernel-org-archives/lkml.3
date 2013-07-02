Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab3GBGo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 02:44:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:17594 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab3GBGoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 02:44:54 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-ee-51d276e37807
Message-id: <51D276E3.9030206@samsung.com>
Date: Tue, 02 Jul 2013 15:44:51 +0900
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsWyRsSkUPdx2aVAg91LTC2eNv1gtzjb9Ibd
	4vKuOWwWn3uPMFrcblzBZtG/sJfJYuNXDwd2jzvX9rB59G1ZxejxaHELo8fnTXIBLFFcNimp
	OZllqUX6dglcGY9WzWcsOK9R8X7XNJYGxvVyXYycHBICJhKbfy1mh7DFJC7cW8/WxcjFISSw
	lFFi8qTtjDBFvY9BbJDEdEaJRTeWMIEkhAReMErMWl4KYvMKaEnM/9PFCmKzCKhK3DlyihnE
	ZgOK739xgw3EFhUIk1g5/QoLRL2gxI/J94BsDg4RoJqXN1NB5jODzJ/+YxdYr7BAhsT14x+g
	LvrCKPFgwiSwizgFgiWev9oGNohZQEdif+s0NghbXmLzmrfMIA0SAsfYJT7eewR1kYDEt8mH
	wLZJCMhKbDrADPGZpMTBFTdYJjCKzUJy0ywkY2chGbuAkXkVo2hqQXJBcVJ6kaFecWJucWle
	ul5yfu4mRmC0nf73rHcH4+0D1ocYk4FWTmSWEk3OB0ZrXkm8obGZkYWpiamxkbmlGWnCSuK8
	ai3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYrYvzzXKt93y1vLSJT92Nd3vy5yk97r8K
	KsWNX/vkrd+ws2of3+zwXpFYabELNm3Z2+eE6pyTMFA9HRrNv+9e6yVurV5Zx1aWnBvsR0sX
	TDCz++o0/4RmvmMm48yUKcvuPLSvmfFk6RnlP5NKy/fO/X9Yz9y+O5/5iwZDQEOz4YnjIWyG
	dUuUWIozEg21mIuKEwEzcPHgzAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jQd3HZZcCDe7u0LF42vSD3eJs0xt2
	i8u75rBZfO49wmhxu3EFm0X/wl4mi41fPRzYPe5c28Pm0bdlFaPHo8UtjB6fN8kFsEQ1MNpk
	pCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAF2gpFCWmFMK
	FApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcx4tGo+Y8F5jYr3u6axNDCul+ti5OSQ
	EDCR6H28nRHCFpO4cG89WxcjF4eQwHRGiUU3ljCBJIQEXjBKzFpeCmLzCmhJzP/TxQpiswio
	Stw5cooZxGYDiu9/cYMNxBYVCJNYOf0KC0S9oMSPyfeAbA4OEaCalzdTQeYzg8yf/mMXWK+w
	QIbE9eMfoBZ/YZR4MGES2EWcAsESz19tAxvELKAjsb91GhuELS+xec1b5gmMArOQ7JiFpGwW
	krIFjMyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYJj+ZnUDsaVDRaHGAU4GJV4eBXmXQwU
	Yk0sK67MPcQowcGsJMJ70xsoxJuSWFmVWpQfX1Sak1p8iDEZGAQTmaVEk/OBaSavJN7Q2MTM
	yNLI3NDCyNicNGElcd4DrdaBQgLpiSWp2ampBalFMFuYODilGhgZWoI0A2vW2FffmtH+Utdt
	QsJHdeYZG9pdpxTEJrSE67UdkbCwN+JySe75LXNhy4sA37cL378P3DoxauNRlg63rzH3a1Jv
	f8pU3f/kv/DeD9HhYR4SjpxHxBv+VTDO4L/92mJd7QP5+u6M0v1Ra+MEX6bNlvy6T6iH+2xi
	9hr1r2VprHc/FSixFGckGmoxFxUnAgBWDlscKQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

OK. I'll create link for CPU1,2,3 if all CPUs is included in one cluster.

I explain the sequence for creating sysfs file of CPU0/1/2/3.
There are difference about sysfs file. Only, CPU0 creates sysfs file
and then CPU1/2/3 create a link to CPU0 sysfs file. If we want to create
debugfs link for CPU1/2/3, I should have to debugfs file for CPU0 /
debugfs link for CPU1/2/3 when cpufreq_register_driver() is operated.
This proposal won't always remove debugfs file for cpufreq when user change
cpufreq governor from ondemand/conservative to performance/powersave.

So, I suggest that cpufreq core executes dbs_check_cpu() to calculate
CPUx load when cpufreq governor is performance/powersave. While maintaing
same cpu frequency on performance/powersave governor, there are different
power-consumption according to CPUx load. I think we need to check CPUs load
on peformance/powersave governor.

[Flow sequence for CPU0]
cpufreq_register_driver()
->subsys_interface_register()
-->sif->add_dev()
---> cpufreq_add_dev()
----> cpufreq_add_policy_cpu()
-----> sysfs_create_link(&dev->kboj, &policy->kobj, "cpufreq");	: Create sysfs file (/sys/devices/system/cpu/cpu0/cpufreq)

[Flow sequence for CPU1/2/3]
cpufreq_register_driver()
->subsys_interface_register()
-->sif->add_dev()
---> cpufreq_add_dev()
----> cpufreq_add_policy_cpu()
-----> cpufreq_add_dev_interface(cpu, ...)
------> cpufreq_add_dev_symlink(cpu, ...) : Create sysfs link about CPU0 sysfs file(/sys/devices/system/cpu/cpu0/cpufreq)

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
> 

If core create debugfs/cpufreq directory when first CPUFREQ_LOADCHECK
notification is received inside cpufreq_stats.c, CPU1/2/3 don't send
CPUFREQ_LOADCHECK notification. In result, cpufreq_stats.c couldn't
create link for /sys/kernel/debug/cpufreq/cpu[1-3].

Best Regards,
Chanwoo Choi



