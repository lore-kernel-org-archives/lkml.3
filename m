Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751214Ab3GXB4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 21:56:40 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15253 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab3GXB4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 21:56:38 -0400
X-AuditID: cbfee68f-b7f436d000000f81-ba-51ef345565c0
Message-id: <51EF3454.50807@samsung.com>
Date: Wed, 24 Jul 2013 10:56:36 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com
Subject: Re: [PATCH 2/3 v6] cpufreq: stats: Add 'load_table' debugfs file to
 show accumulated data of CPUs
References: <1374146275-5758-1-git-send-email-cw00.choi@samsung.com>
 <1374146275-5758-3-git-send-email-cw00.choi@samsung.com>
 <CAKohponVEJv9e9V5qz+iugSMzu1zp1BeFf58W8m0qAV3_m6U1w@mail.gmail.com>
In-reply-to: <CAKohponVEJv9e9V5qz+iugSMzu1zp1BeFf58W8m0qAV3_m6U1w@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsWyRsSkQDfU5H2gwY/j7BZPm36wW5xtesNu
	cXnXHDaLz71HGC1uN65gs+hf2MtksfGrhwO7x51re9g8+rasYvR4tLiF0ePzJrkAligum5TU
	nMyy1CJ9uwSujIc7m1kLJtlU/Pl+g6WB8YJaFyMnh4SAicSu19fZIWwxiQv31rOB2EICSxkl
	elrSuhg5wGpe3rHqYuQCCk9nlGhY+owNwnnFKLH753ZGkCJeAQ2JziO1IL0sAqoSU66dYQSx
	2QS0JPa/uAE2U1QgTGLl9CssIDavgKDEj8n3WEBaRYBqXt5MBRnJDDJ/+o9dzCA1wgI5Elca
	7zFC7DrGKPHv601WkASnQLDEr74lYEXMAjoS+1unsUHY8hKb17xlBmmQEDjFLnH+9zs2iIsE
	JL5NPsQC8Y2sxKYDzBAPS0ocXHGDZQKj2CwkN81CMnYWkrELGJlXMYqmFiQXFCelFxnrFSfm
	Fpfmpesl5+duYgRG2ul/z/p3MN49YH2IMRlo5URmKdHkfGCk5pXEGxqbGVmYmpgaG5lbmpEm
	rCTOq9ZiHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBcYvVJbWJ9nLHzgha3EllM3id/C3r
	Kr+0vOn5hzEKz13kq+r6p6eedM5wN2269bRKNeJx6Hud/C8ee6vcki93dfN96t+b/lzozK80
	dQ67OwEbFmY279C1kHw56fBfxd5fbUmaBkoz64/OuCguFnOR1+inpIHCmRtOztsXOBnsjizK
	6JOqEvykxFKckWioxVxUnAgA0JPSv8oCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t9jQd0Qk/eBBo2HrS2eNv1gtzjb9Ibd
	4vKuOWwWn3uPMFrcblzBZtG/sJfJYuNXDwd2jzvX9rB59G1ZxejxaHELo8fnTXIBLFENjDYZ
	qYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QBcoKZQl5pQC
	hQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDMe7mxmLZhkU/Hn+w2WBsYLal2MHBwS
	AiYSL+9YdTFyApliEhfurWfrYuTiEBKYzijRsPQZlPOKUWL3z+2MIA28AhoSnUdqQRpYBFQl
	plw7wwhiswloSex/cYMNxBYVCJNYOf0KC4jNKyAo8WPyPRaQVhGgmpc3U0FGMoPMn/5jFzNI
	jbBAjsSVxnuMELuOMUr8+3qTFSTBKRAs8atvCVgRs4COxP7WaWwQtrzE5jVvmScwCsxCsmMW
	krJZSMoWMDKvYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiO5GdSOxhXNlgcYhTgYFTi4S2Y
	9S5QiDWxrLgy9xCjBAezkgjvC5n3gUK8KYmVValF+fFFpTmpxYcYk4FBMJFZSjQ5H5hk8kri
	DY1NzIwsjcwNLYyMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBcfLEksXBd84tiDZs
	Or/nXXX91w6r4kOXdc2tz1d0VCSxRrIxBwrO3h86lYFnvkzK5D9PpgVOkTT5UtH258xqm3N+
	p6uv/p7XOcXk/S+ee89Fts07oKB/qHvadfNtedN2ywjO1U0zXLu9vmPS8ciO3VLxHNs1JVyc
	dTLttuZv3SouvLxg16lpeUosxRmJhlrMRcWJAOiX42koAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On 07/22/2013 08:05 PM, Viresh Kumar wrote:
> On 18 July 2013 16:47, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
> 
>> +static int cpufreq_stats_reset_debugfs(struct cpufreq_policy *policy)
>> +{
>> +       struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, policy->cpu);
>> +       int size;
>> +
>> +       if (!stat)
>> +               return -EINVAL;
>> +
>> +       if (stat->load_table)
>> +               kfree(stat->load_table);
>> +       stat->load_last_index = 0;
>> +
>> +       size = sizeof(*stat->load_table) * stat->load_max_index;
>> +       stat->load_table = kzalloc(size, GFP_KERNEL);
>> +       if (!stat->load_table)
>> +               return -ENOMEM;
> 
> Why are you freeing memory and allocating it again ??

This purpose is reseting the data of stat->load_table.
If you don't agree this, I'll initizliae stat->load_table array as zero(0) with loop statement.

> 
>> +       return 0;
>> +}
>> +
>> +static int cpufreq_stats_create_debugfs(struct cpufreq_policy *policy)
>> +{
>> +       struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, policy->cpu);
>> +       unsigned int idx, size;
>> +       int ret = 0;
>> +
>> +       if (!stat)
>> +               return -EINVAL;
>> +
>> +       if (!policy->cpu_debugfs)
>> +               return -EINVAL;
>> +
>> +       stat->load_last_index = 0;
>> +       stat->load_max_index = CONFIG_NR_CPU_LOAD_STORAGE;
>> +
>> +       /* Allocate memory for storage of CPUs load */
>> +       size = sizeof(*stat->load_table) * stat->load_max_index;
>> +       stat->load_table = kzalloc(size, GFP_KERNEL);
>> +       if (!stat->load_table)
>> +               return -ENOMEM;
>> +
>> +       /* Create debugfs directory and file for cpufreq */
>> +       idx = cpumask_weight(policy->cpus) > 1 ? policy->cpu : 0;
> 
> idx is broken again..

OK, I'll fix it.

> 
>> +       stat->debugfs_load_table = debugfs_create_file("load_table", S_IWUSR,
>> +                                       policy->cpu_debugfs[idx],
>> +                                       policy, &load_table_fops);
>> +       if (!stat->debugfs_load_table) {
>> +               ret = -ENOMEM;
>> +               goto err;
>> +       }
>> +
>> +       pr_debug("Creating debugfs file for CPU%d \n", policy->cpu);
> 
> s/Creating/Created

OK, I'll fixt it.

> 
>> +
>> +       return 0;
>> +err:
>> +       kfree(stat->load_table);
>> +       return ret;
>> +}
>> +
>> +/* should be called late in the CPU removal sequence so that the stats
>> + * memory is still available in case someone tries to use it.
>> + */
> 
> Please write multiline comment correctly..

OK.

> 
>> +static void cpufreq_stats_free_load_table(unsigned int cpu)
>> +{
>> +       struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, cpu);
>> +
>> +       if (stat) {
>> +               pr_debug("Free memory of load_table\n");
>> +               kfree(stat->load_table);
>> +       }
>> +}
>> +
>> +/* must be called early in the CPU removal sequence (before
>> + * cpufreq_remove_dev) so that policy is still valid.
>> + */
>> +static void cpufreq_stats_free_debugfs(unsigned int cpu)
>> +{
>> +       struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, cpu);
>> +
>> +       if (stat) {
>> +               pr_debug("Remove load_table debugfs file\n");
>> +               debugfs_remove(stat->debugfs_load_table);
>> +       }
>> +}
>> +
>> +static void cpufreq_stats_store_load_table(struct cpufreq_freqs *freq,
>> +                                          unsigned long val)
>> +{
>> +       struct cpufreq_stats *stat;
>> +       int cpu, last_idx;
>> +
>> +       stat = per_cpu(cpufreq_stats_table, freq->cpu);
>> +       if (!stat)
>> +               return;
>> +
>> +       spin_lock(&cpufreq_stats_lock);
>> +
>> +       switch (val) {
>> +       case CPUFREQ_POSTCHANGE:
>> +               if (!stat->load_last_index)
>> +                       last_idx = stat->load_max_index;
>> +               else
>> +                       last_idx = stat->load_last_index - 1;
>> +
>> +               stat->load_table[last_idx].new = freq->new;
>> +               break;
>> +       case CPUFREQ_LOADCHECK:
>> +               last_idx = stat->load_last_index;
>> +
>> +               stat->load_table[last_idx].time = freq->time;
>> +               stat->load_table[last_idx].old = freq->old;
>> +               stat->load_table[last_idx].new = freq->old;
>> +               for_each_present_cpu(cpu)
>> +                       stat->load_table[last_idx].load[cpu] = freq->load[cpu];
>> +
>> +               if (++stat->load_last_index == stat->load_max_index)
>> +                       stat->load_last_index = 0;
>> +               break;
>> +       }
>> +
>> +       spin_unlock(&cpufreq_stats_lock);
>> +}
>> +
>>  static int freq_table_get_index(struct cpufreq_stats *stat, unsigned int freq)
>>  {
>>         int index;
>> @@ -204,7 +386,7 @@ static int cpufreq_stats_create_table(struct cpufreq_policy *policy,
>>         unsigned int alloc_size;
>>         unsigned int cpu = policy->cpu;
>>         if (per_cpu(cpufreq_stats_table, cpu))
>> -               return -EBUSY;
>> +               return 0;
>>         stat = kzalloc(sizeof(struct cpufreq_stats), GFP_KERNEL);
>>         if ((stat) == NULL)
>>                 return -ENOMEM;
>> @@ -257,6 +439,14 @@ static int cpufreq_stats_create_table(struct cpufreq_policy *policy,
>>         spin_lock(&cpufreq_stats_lock);
>>         stat->last_time = get_jiffies_64();
>>         stat->last_index = freq_table_get_index(stat, policy->cur);
>> +
>> +       ret = cpufreq_stats_create_debugfs(data);
>> +       if (ret < 0) {
>> +               spin_unlock(&cpufreq_stats_lock);
>> +               ret = -EINVAL;
>> +               goto error_out;
>> +       }
>> +
>>         spin_unlock(&cpufreq_stats_lock);
>>         cpufreq_cpu_put(data);
>>         return 0;
>> @@ -297,11 +487,18 @@ static int cpufreq_stat_notifier_policy(struct notifier_block *nb,
>>         if (val != CPUFREQ_NOTIFY)
>>                 return 0;
>>         table = cpufreq_frequency_get_table(cpu);
>> -       if (!table)
>> -               return 0;
>> -       ret = cpufreq_stats_create_table(policy, table);
>> -       if (ret)
>> +       if (table) {
>> +               ret = cpufreq_stats_create_table(policy, table);
>> +               if (ret)
>> +                       return ret;
>> +       }
>> +
>> +       ret = cpufreq_stats_reset_debugfs(policy);
> 
> Why?

When cpufreq governor is changed, always reset stats->load_table for performance/powersave/userspace governor.

-sh-4.1# cat /sys/kernel/debug/cpufreq/cpu0/load_table
Time(ms)   Old Freq(Hz) New Freq(Hz) CPU0 CPU1 CPU3
0          0            0            0    0    0
0          0            0            0    0    0
0          0            0            0    0    0
0          0            0            0    0    0
0          0            0            0    0    0
0          0            0            0    0    0
0          0            0            0    0    0
0          0            0            0    0    0
0          0            0            0    0    0
0          0            0            0    0    0

> 
>> +       if (ret < 0) {
>> +               pr_debug("Failed to reset CPUs data of debugfs\n");
>>                 return ret;
>> +       }
>> +
>>         return 0;
>>  }
> 

Thanks for your comment.

Best Regards,
Chanwoo Choi
