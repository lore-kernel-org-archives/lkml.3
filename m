Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965049Ab3FTKpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 06:45:42 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:63241 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957Ab3FTKpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 06:45:40 -0400
X-AuditID: cbfee691-b7fef6d000002d62-2a-51c2dd3d2d44
Message-id: <51C2DD3D.5040601@samsung.com>
Date: Thu, 20 Jun 2013 19:45:17 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v2] cpufreq: stats: Add 'load_table' debugfs file to show
 accumulated data of CPUs
References: <1371716524-19370-1-git-send-email-cw00.choi@samsung.com>
 <CAKohponD5s6-g0X9rgsVt0U4RutfyXSQJRZP3vT7EuczgMMQ2Q@mail.gmail.com>
In-reply-to: <CAKohponD5s6-g0X9rgsVt0U4RutfyXSQJRZP3vT7EuczgMMQ2Q@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsWyRsSkQNf27qFAg2OdghZnm96wW1zeNYfN
	4nbjCjaL/oW9TBYbv3o4sHrcubaHzaNvyypGj0eLWxg9Pm+SC2CJ4rJJSc3JLEst0rdL4Mro
	/NfKVjArpKLjzTO2BsZJNl2MnBwSAiYSx95cZ4WwxSQu3FvP1sXIxSEksJRR4sj8fWwwRXuO
	fmWGSExnlDi8/gEjhPOCUWLasWnsIFW8AloSJ65+YgaxWQRUJdavucMIYrMBxfe/uAE2SVQg
	TGLl9CssEPWCEj8m3wOyOThEgGpe3kwFCTMLtDJKXDjoCRIWFsiQmPC2CmJVD6PEsrXzwFZx
	CgRLNLddYYKo15HY3zqNDcKWl9i85i3YoRIC29glFi3uZIW4R0Di2+RDYLskBGQlNh1ghnhM
	UuLgihssExjFZiG5aBaSsbOQjF3AyLyKUTS1ILmgOCm9yFSvODG3uDQvXS85P3cTIzCuTv97
	NnEH4/0D1ocYk4FWTmSWEk3OB8ZlXkm8obGZkYWpiamxkbmlGWnCSuK86i3WgUIC6Yklqdmp
	qQWpRfFFpTmpxYcYmTg4pRoYFc/YT6g48mCGm98pDf47Z/clXXyzhG+v+R+7gzP7C9OEHvie
	C/69L1r2Xoz/yiBHV89nlnYnL0q9StU52n1IynF/dkqxR5eQ1qS8wEnGmnverMw4+LvCpOrf
	thXHfBdoXPFW748UkRZu3CTbaHs2w6Zg+ifhjbusp03t3tEwS3PST58Hf4IFlViKMxINtZiL
	ihMBOuYYIcECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xoK7t3UOBBrt+s1mcbXrDbnF51xw2
	i9uNK9gs+hf2Mlls/OrhwOpx59oeNo++LasYPR4tbmH0+LxJLoAlqoHRJiM1MSW1SCE1Lzk/
	JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdor5JCWWJOKVAoILG4WEnfDtOE
	0BA3XQuYxghd35AguB4jAzSQsIYxo/NfK1vBrJCKjjfP2BoYJ9l0MXJySAiYSOw5+pUZwhaT
	uHBvPVsXIxeHkMB0RonD6x8wQjgvGCWmHZvGDlLFK6AlceLqJ7AOFgFVifVr7jCC2GxA8f0v
	brCB2KICYRIrp19hgagXlPgx+R6QzcEhAlTz8mYqSJhZoJVR4sJBT5CwsECGxIS3VRCrehgl
	lq2dB7aKUyBYorntChNEvY7E/tZpbBC2vMTmNW+ZJzAKzEKyYRaSsllIyhYwMq9iFE0tSC4o
	TkrPNdIrTswtLs1L10vOz93ECI7aZ9I7GFc1WBxiFOBgVOLh1bh8MFCINbGsuDL3EKMEB7OS
	CG/qnEOBQrwpiZVVqUX58UWlOanFhxiTgQEwkVlKNDkfmFDySuINjU3MjCyNzA0tjIzNSRNW
	Euc92GodKCSQnliSmp2aWpBaBLOFiYNTChhdD1cWutgdEjph90nLhffQRZ4k0VkSHFYbLgm+
	NXF5MC2cxWeXHkOPusKnpCDhPeeb7bsFcyzMVa/nJWtdOSYqW777nFfpQc7t1QFLhFbzO55q
	Dne//u3FjK+7vr9+vCAxPetuodAB1z3sC8888+raedH5lP7/Uv7jWt9+69ddsJsvUnZO2kKJ
	pTgj0VCLuag4EQBpDmfIHgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 06:03 PM, Viresh Kumar wrote:
> On 20 June 2013 13:52, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
>> index 534fcb8..8a429b3 100644
>> --- a/drivers/cpufreq/Kconfig
>> +++ b/drivers/cpufreq/Kconfig
>> @@ -45,6 +45,12 @@ config CPU_FREQ_STAT_DETAILS
>>
>>           If in doubt, say N.
>>
>> +config NR_CPU_LOAD_STORAGE
>> +       int "Maximum storage size to save CPU load (10-100)"
>> +       range 10 100
>> +       depends on CPU_FREQ_STAT_DETAILS
>> +       default "10"
> 
> As we are adding it in debugfs, probably we can use
> CPU_FREQ_STAT instead of CPU_FREQ_STAT_DETAILS
> 

OK, If Rafael agree about using CPU_FREQ_STAT instead of CPU_FREQ_STAT_DETAILS, I'll fix it. 

> @Rafael?
> 
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> index 2d53f47..cbaaff0 100644
>> --- a/drivers/cpufreq/cpufreq.c
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -292,6 +292,10 @@ void __cpufreq_notify_transition(struct cpufreq_policy *policy,
>>                 if (likely(policy) && likely(policy->cpu == freqs->cpu))
>>                         policy->cur = freqs->new;
>>                 break;
>> +       case CPUFREQ_LOADCHECK:
>> +               srcu_notifier_call_chain(&cpufreq_transition_notifier_list,
>> +                               CPUFREQ_LOADCHECK, freqs);
>> +               break;
>>         }
>>  }
>>  /**
>> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
>> index dc9b72e..bca341b 100644
>> --- a/drivers/cpufreq/cpufreq_governor.c
>> +++ b/drivers/cpufreq/cpufreq_governor.c
>> @@ -90,6 +90,9 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
>>         unsigned int max_load = 0;
>>         unsigned int ignore_nice;
>>         unsigned int j;
>> +#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
>> +       struct cpufreq_freqs freq;
>> +#endif
>>
>>         if (dbs_data->cdata->governor == GOV_ONDEMAND)
>>                 ignore_nice = od_tuners->ignore_nice;
>> @@ -144,11 +147,17 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
>>                         idle_time += jiffies_to_usecs(cur_nice_jiffies);
>>                 }
>>
>> -               if (unlikely(!wall_time || wall_time < idle_time))
>> +               if (unlikely(!wall_time || wall_time < idle_time)) {
>> +#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
>> +                       freq.load[j] = 0;
>> +#endif
>>                         continue;
>> +               }
>>
>>                 load = 100 * (wall_time - idle_time) / wall_time;
>> -
>> +#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
>> +               freq.load[j] = load;
>> +#endif
> 
> Add blank line here

OK, I'll add blank.

> 
>>                 if (dbs_data->cdata->governor == GOV_ONDEMAND) {
>>                         int freq_avg = __cpufreq_driver_getavg(policy, j);
>>                         if (freq_avg <= 0)
>> @@ -161,6 +170,12 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
>>                         max_load = load;
>>         }
>>
>> +#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
>> +       freq.time = ktime_to_ms(ktime_get());
>> +       freq.old = freq.new = policy->cur;
>> +
>> +       cpufreq_notify_transition(policy, &freq, CPUFREQ_LOADCHECK);
>> +#endif
> 
> Add blank line here

OK, I'll add blank.

> 
>>         dbs_data->cdata->gov_check_cpu(cpu, max_load);
>>  }
>>  EXPORT_SYMBOL_GPL(dbs_check_cpu);
>> diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
>> index fb65dec..289d675 100644
>> --- a/drivers/cpufreq/cpufreq_stats.c
>> +++ b/drivers/cpufreq/cpufreq_stats.c
>> @@ -12,6 +12,7 @@
>>  #include <linux/kernel.h>
>>  #include <linux/slab.h>
>>  #include <linux/cpu.h>
>> +#include <linux/debugfs.h>
>>  #include <linux/sysfs.h>
>>  #include <linux/cpufreq.h>
>>  #include <linux/module.h>
>> @@ -23,6 +24,7 @@
>>  #include <asm/cputime.h>
>>
>>  static spinlock_t cpufreq_stats_lock;
>> +static spinlock_t cpufreq_stats_lock_load_table;
> 
> Why need an extra lock?

You're right. The extra spinlock isn't necessary.
I'll use only one spinlock.

> 
>>
>>  struct cpufreq_stats {
>>         unsigned int cpu;
>> @@ -35,6 +37,12 @@ struct cpufreq_stats {
>>         unsigned int *freq_table;
>>  #ifdef CONFIG_CPU_FREQ_STAT_DETAILS
>>         unsigned int *trans_table;
>> +
>> +       /* debugfs file for load_table */
>> +       struct cpufreq_freqs *load_table;
>> +       unsigned int load_last_index;
>> +       unsigned int load_max_index;
>> +       struct dentry *debugfs_cpufreq;
>>  #endif
>>  };
>>
>> @@ -149,6 +157,134 @@ static struct attribute_group stats_attr_group = {
>>         .name = "stats"
>>  };
>>
>> +#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
>> +#define MAX_LINE_SIZE          255
>> +static ssize_t load_table_read(struct file *file, char __user *user_buf,
>> +                                       size_t count, loff_t *ppos)
>> +{
>> +       struct cpufreq_policy *policy = file->private_data;
>> +       struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, policy->cpu);
>> +       struct cpufreq_freqs *load_table = stat->load_table;
>> +       unsigned int alloc_size_buf;
>> +       ssize_t len = 0;
>> +       char *buf;
>> +       int i, j, ret;
>> +
>> +       alloc_size_buf = MAX_LINE_SIZE * stat->load_max_index;
>> +       buf = kzalloc(alloc_size_buf, GFP_KERNEL);
>> +       if (!buf)
>> +               return 0;
>> +
>> +       spin_lock(&cpufreq_stats_lock_load_table);
>> +       len += sprintf(buf + len, "%10s %10s", "Time", "Frequency");
>> +       for (j = 0; j < NR_CPUS; j++)
>> +               len += sprintf(buf + len, " %3s%d", "cpu", j);
>> +       len += sprintf(buf + len, "\n");
>> +
>> +       i = stat->load_last_index;
>> +       do {
>> +               len += sprintf(buf + len, "%10lld %10d",
>> +                               load_table[i].time,
>> +                               load_table[i].old);
>> +
>> +               for (j = 0; j < NR_CPUS; j++)
> 
> Should we use, for_each_present_cpu() instead of NR_CPUS
> for both loops above?

OK, I'll use for_each_present_cpu() macro.

> 
>> +                       len += sprintf(buf + len, " %4d",
>> +                                       load_table[i].load[j]);
>> +               len += sprintf(buf + len, "\n");
>> +
>> +               if (++i == stat->load_max_index)
>> +                       i = 0;
>> +       } while (i != stat->load_last_index);
>> +       spin_unlock(&cpufreq_stats_lock_load_table);
>> +
>> +       ret = simple_read_from_buffer(user_buf, count, ppos, buf, len);
>> +       kfree(buf);
>> +
>> +       return ret;
>> +}
>> +
>> +static const struct file_operations load_table_fops = {
>> +       .read           = load_table_read,
>> +       .open           = simple_open,
>> +       .llseek         = no_llseek,
>> +};
>> +
>> +static void cpufreq_stats_store_load_table(struct cpufreq_freqs *freq)
>> +{
>> +       struct cpufreq_stats *stat;
>> +       int i, last_index;
>> +
>> +       stat = per_cpu(cpufreq_stats_table, freq->cpu);
>> +       if (!stat)
>> +               return;
>> +
>> +       spin_lock(&cpufreq_stats_lock_load_table);
>> +       last_index = stat->load_last_index;
>> +       stat->load_table[last_index].old = freq->old;
> 
> what about keeping valid value of freq->new here too? I now
> currently it is same as freq->old, but maybe we can fill it with
> what we tried to go for? Or what actually was programmed?
> 
Yes, freq->old is same freq->new.

The cpufreq gorvernor(dbs_check_cpu()) send CPUFREQ_LOADCHECK noti
right after calculating CPUs load, regardless of changing CPU frequency.
So, I use only freq->old value without using freq->new because load_table
debugfs file need current cpu frequency.

Now, I can't think of any proper usage for freq->new.
Do you have good way for using freq->new to include more useful data in load_table?

> Then this table will be even more useful.
> 
>> +       stat->load_table[last_index].time = freq->time;
>> +       for (i = 0; i < NR_CPUS; i++)
>> +               stat->load_table[last_index].load[i] = freq->load[i];
>> +
>> +       if (++stat->load_last_index == stat->load_max_index)
>> +               stat->load_last_index = 0;
>> +       spin_unlock(&cpufreq_stats_lock_load_table);
>> +}
>> +
>> +static int cpufreq_stats_create_debugfs(struct cpufreq_policy *policy)
>> +{
>> +       struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, policy->cpu);
>> +       unsigned int alloc_size_load;
> 
> s/alloc_size_load/size .. we don't need to name local variables
> very meaningfully, i.e. they should be short and precise.
> 

OK, I'll fix from 'alloc_size_load' to 'size'.

>> +       int ret = 0;
>> +
>> +       stat->load_last_index = 0;
>> +       stat->load_max_index = CONFIG_NR_CPU_LOAD_STORAGE;
>> +       alloc_size_load = sizeof(*stat->load_table) * stat->load_max_index;
>> +       stat->load_table = kzalloc(alloc_size_load, GFP_KERNEL);
>> +       if (!stat->load_table) {
>> +               ret = -ENOMEM;
>> +               goto err;
>> +       }
>> +
>> +       stat->debugfs_cpufreq = debugfs_create_dir("cpufreq", NULL);
>> +       if (!stat->debugfs_cpufreq) {
>> +               ret = -EINVAL;
>> +               goto err;
>> +       }
>> +
>> +       debugfs_create_file("load_table", S_IWUSR, stat->debugfs_cpufreq,
>> +                               (void *)policy, &load_table_fops);
>> +err:
>> +       return ret;
>> +}
>> +
>> +static void cpufreq_stats_free_debugfs(unsigned int cpu)
>> +{
>> +       struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
> 
> you need to put it too

OK. I'll put cpufreq_policy.

> 
>> +       struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, cpu);
>> +
>> +       if (!policy)
>> +               return;
>> +
>> +       if (!policy_is_shared(policy)) {
> 
> why ??
> 

I thought wrong. It isn't necessary for debugfs file.
I'll remove it.

>> +               pr_debug("%s: Free debugfs stat\n", __func__);
>> +               debugfs_remove(stat->debugfs_cpufreq);
>> +       }
>> +}
>> +#else
>> +static void cpufreq_stats_store_load_table(struct cpufreq_freqs *freq)
>> +{
>> +       return 0;
>> +}
>> +static int cpufreq_stats_create_debugfs(struct cpufreq_policy *policy)
>> +{
>> +       return 0;
>> +}
>> +static void cpufreq_stats_free_debugfs(unsigned int cpu)
>> +{
>> +       return;
> 
> you don't need this
> 

OK, I'll remove it.

Thanks for your comment.

Best Regards,
Chanwoo Choi

