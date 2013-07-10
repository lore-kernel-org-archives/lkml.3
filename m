Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab3GJIax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 04:30:53 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:17869 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab3GJIat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 04:30:49 -0400
X-AuditID: cbfee691-b7fef6d000002d62-fc-51dd1bb66222
Message-id: <51DD1BB6.3080304@samsung.com>
Date: Wed, 10 Jul 2013 17:30:46 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com
Subject: Re: [PATCH 1/6] cpufreq: Add debugfs directory for cpufreq
References: <1373014001-17746-1-git-send-email-cw00.choi@samsung.com>
 <1373014001-17746-2-git-send-email-cw00.choi@samsung.com>
 <CAKohpomriPXmK3TRFqinyEEuG39O1ppKmPuW0gvs3iRLnsoPrg@mail.gmail.com>
In-reply-to: <CAKohpomriPXmK3TRFqinyEEuG39O1ppKmPuW0gvs3iRLnsoPrg@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsWyRsSkUHeb9N1Ag9lflC2eNv1gtzjb9Ibd
	4vKuOWwWn3uPMFrcblzBZtG/sJfJYuNXDwd2jzvX9rB59G1ZxejxaHELo8fnTXIBLFFcNimp
	OZllqUX6dglcGVOecxecNa14fOgpUwPjVJUuRk4OCQETiYdLH7BC2GISF+6tZ+ti5OIQEljK
	KNEz+TMzTNGR+29YIBKLGCUmPr3GBOG8YpS4sWcHC0gVr4CWxMcbZ8E6WARUJX6/Bini5GAD
	iu9/cYMNxBYVCJNYOf0KVL2gxI/J94BsDg4RoJqXN1NBZjILTGeUmP5jF9gcYQFniWuHZrFD
	LDvBKPFj0jqwBKdAsMTmF18YQWxmAR2J/a3T2CBseYnNa94ygzRICBxjl1jWup0d4iIBiW+T
	D4FtkxCQldh0AOo1SYmDK26wTGAUm4XkpllIxs5CMnYBI/MqRtHUguSC4qT0IlO94sTc4tK8
	dL3k/NxNjMBoO/3v2cQdjPcPWB9iTAZaOZFZSjQ5HxiteSXxhsZmRhamJqbGRuaWZqQJK4nz
	qrdYBwoJpCeWpGanphakFsUXleakFh9iZOLglGpgbJBOWSQnEvr7Qsw0McdqZ+82jV+Ws0+t
	ME7gy1kwn8NC++/knffC9I+vPbDy574kpkkWC0wfTo1s69q8OXrhGZV1WgvWPDijfvLZlbyS
	S/9u3XtmWhno3psa8cYtfM6vFdvDr9zPPVTp7i8i8+hu7lW7+Xue731210Kd7d6Tbf9ezP8i
	5z9X5LMSS3FGoqEWc1FxIgBFhES0zAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jAd1t0ncDDSY9kLJ42vSD3eJs0xt2
	i8u75rBZfO49wmhxu3EFm0X/wl4mi41fPRzYPe5c28Pm0bdlFaPHo8UtjB6fN8kFsEQ1MNpk
	pCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAF2gpFCWmFMK
	FApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcyY8py74KxpxeNDT5kaGKeqdDFyckgI
	mEgcuf+GBcIWk7hwbz1bFyMXh5DAIkaJiU+vMUE4rxglbuzZAVbFK6Al8fHGWWYQm0VAVeL3
	a5AiTg42oPj+FzfYQGxRgTCJldOvQNULSvyYfA/I5uAQAap5eTMVZCazwHRGiek/doHNERZw
	lrh2aBY7xLITjBI/Jq0DS3AKBEtsfvGFEcRmFtCR2N86jQ3ClpfYvOYt8wRGgVlIdsxCUjYL
	SdkCRuZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMGx/ExqB+PKBotDjAIcjEo8vAcU7gQK
	sSaWFVfmHmKU4GBWEuH9dwkoxJuSWFmVWpQfX1Sak1p8iDEZGAQTmaVEk/OBaSavJN7Q2MTM
	yNLI3NDCyNicNGElcd4DrdaBQgLpiSWp2ampBalFMFuYODilGhh3h53l3Bx+7Mjm943z3lyS
	YtZkdz9q5sya0fW3aa5u2Fz5c3N3i216e7T4v8e6Lx8Tg+0PHj4S0P1WXOSVnOL8tGDnVbKN
	4gGTl9n0aroHbJ2l17KBsTxildka5bPCMWVc21T+a9y7n/NF5lDr3KdF07N+6GotWSa3ftH/
	i6fS2qW2LrxbtmaiEktxRqKhFnNRcSIA6SzMWykDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On 07/09/2013 06:23 PM, Viresh Kumar wrote:
> On 5 July 2013 14:16, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> 
>> +/* The cpufreq_debugfs is used to create debugfs root directory for CPUFreq. */
>> +#define MAX_DEBUGFS_NAME_LEN   CPUFREQ_NAME_LEN
> 
> Why declare MAX_DEBUGFS_NAME_LEN if it is going to be equal to
> CPUFREQ_NAME_LEN. Simply use CPUFREQ_NAME_LEN everywhere.

OK, I'll use CPUFREQ_NAME_LEN instead of defining CPUFREQ_NAME_LEN.

> 
>> +static struct dentry *cpufreq_debugfs;
> 
> Probably make this dependent on CONFIG_CPU_FREQ_STAT?

I thought that '/sys/kernel/debug/cpufreq' is always created in the same as sysfs file
when added cpufreq driver. Only the debugfs file(/sys/kernel/debug/cpufreq/load_table)
has the dependency on CONFIG_CPU_FREQ_STAT.

If *cpufreq_debugfs has the dependency on CONFIG_CPU_FREQ_STAT,
I should add checking statement with '#ifdef CONFIG_CPU_FREQ_STAT' keyword in cpufreq.c.

What is your opinion to add the dependency of CONFIG_CPU_FREQ_STAT
in cpufreq.c?

> 
>>  /*
>>   * cpu_policy_rwsem is a per CPU reader-writer semaphore designed to cure
>>   * all cpufreq/hotplug/workqueue/etc related lock issues.
>> @@ -726,6 +731,20 @@ static int cpufreq_add_dev_symlink(unsigned int cpu,
>>                         cpufreq_cpu_put(managed_policy);
>>                         return ret;
>>                 }
>> +
>> +               if (cpufreq_debugfs) {
>> +                       char symlink_name[MAX_DEBUGFS_NAME_LEN];
>> +                       char target_name[MAX_DEBUGFS_NAME_LEN];
>> +
>> +                       sprintf(symlink_name, "cpu%d", j);
>> +                       sprintf(target_name, "./cpu%d", cpu);
>> +                       managed_policy->cpu_debugfs[j] = debugfs_create_symlink(
>> +                                                       symlink_name,
>> +                                                       cpufreq_debugfs,
>> +                                                       target_name);
>> +                       if (!managed_policy->cpu_debugfs[j])
>> +                               pr_debug("creating debugfs symlink failed\n");
> 
> pr_err?

I'll fix it.

> 
>> +               }
>>         }
>>         return ret;
>>  }
>> @@ -746,6 +765,22 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
>>         if (ret)
>>                 return ret;
>>
>> +       /* prepare interface data for debugfs */
>> +       if (cpufreq_debugfs) {
>> +               char name[MAX_DEBUGFS_NAME_LEN];
>> +               int size, i;
>> +
>> +               sprintf(name, "cpu%d", policy->cpu);
>> +               size = sizeof(struct dentry*) * NR_CPUS;
> 
> NR_CPUS? You only need to take care of cpus that belong to this
> policy, isn't it? policy->related_cpus should be good enough for you.

You're right. I'll fix it.
I didn't think using policy->related_cpus instead of NR_CPUS.

> 
>> +               i = cpu;
>> +
>> +               policy->cpu_debugfs = devm_kzalloc(dev, size, GFP_KERNEL);
>> +               policy->cpu_debugfs[i] = debugfs_create_dir(name,
>> +                                                           cpufreq_debugfs);
>> +               if (!policy->cpu_debugfs[i])
>> +                       pr_debug("creating debugfs directory failed\n");
>> +       }
> 
> pr_err?

I'll fix it.

> 
> And move this code just before the call to cpufreq_add_dev_symlink().

OK, I'll move it.

> 
>>         /* set up files for this cpu device */
>>         drv_attr = cpufreq_driver->attr;
>>         while ((drv_attr) && (*drv_attr)) {
>> @@ -839,6 +874,20 @@ static int cpufreq_add_policy_cpu(unsigned int cpu, unsigned int sibling,
>>                 return ret;
>>         }
>>
>> +       if (cpufreq_debugfs) {
>> +               char symlink_name[MAX_DEBUGFS_NAME_LEN];
>> +               char target_name[MAX_DEBUGFS_NAME_LEN];
>> +
>> +               sprintf(symlink_name, "cpu%d", cpu);
>> +               sprintf(target_name, "./cpu%d", sibling);
>> +               policy->cpu_debugfs[cpu] = debugfs_create_symlink(
>> +                                               symlink_name,
>> +                                               cpufreq_debugfs,
>> +                                               target_name);
>> +               if (!policy->cpu_debugfs[cpu])
>> +                       pr_debug("creating debugfs symlink failed\n");
>> +       }
> 
> This is purely replication of same code. Create a routine to
> hold these lines and call it from wherever it is required.

OK, I'll create a routine which create symbolic link of debugfs directory.

> 
>>         return 0;
>>  }
>>  #endif
>> @@ -1046,6 +1095,7 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
>>
>>         if (cpu != data->cpu) {
>>                 sysfs_remove_link(&dev->kobj, "cpufreq");
>> +               debugfs_remove(data->cpu_debugfs[cpu]);
>>         } else if (cpus > 1) {
>>                 /* first sibling now owns the new sysfs dir */
>>                 cpu_dev = get_cpu_device(cpumask_first(data->cpus));
>> @@ -1068,6 +1118,9 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
>>                         return -EINVAL;
>>                 }
>>
>> +               debugfs_remove_recursive(data->cpu_debugfs[cpu]);
> 
> So you removed load_table here? What about other cpus that were
> there in policy->cpus?

You're right. This code is wrong. I'll consider other way to resolve this case.

> 
>> +               debugfs_remove(cpufreq_debugfs);
> 
> Who will create this again? Also, there might be multiple policy struct's
> in a system and here we have reached to removal of all cpus of
> a policy. Other policies are still alive.

OK, I'll control 'debugfs' directory in cpufreq_register/unregister_driver().

> 
>>                 WARN_ON(lock_policy_rwsem_write(cpu));
>>                 update_policy_cpu(data, cpu_dev->id);
>>                 unlock_policy_rwsem_write(cpu);
>> @@ -1976,6 +2029,10 @@ static int __init cpufreq_core_init(void)
>>         BUG_ON(!cpufreq_global_kobject);
>>         register_syscore_ops(&cpufreq_syscore_ops);
>>
>> +       cpufreq_debugfs = debugfs_create_dir("cpufreq", NULL);
>> +       if (!cpufreq_debugfs)
>> +               pr_debug("creating debugfs root failed\n");
> 
> So, you just added this directory once.. So you must not
> remove it.

I'll add 'debugfs' directory in cpufreq_register_driver()
and remove it in cpufreq_unregister_driver().

> 
>>         return 0;
>>  }
>>  core_initcall(cpufreq_core_init);
> 

Thanks for your comment.

Best Regards,
Chanwoo Choi
