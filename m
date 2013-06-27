Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab3F0KO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 06:14:58 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:38557 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab3F0KOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 06:14:55 -0400
X-AuditID: cbfee68e-b7f276d000002279-c4-51cc10982f08
Message-id: <51CC1099.5060201@samsung.com>
Date: Thu, 27 Jun 2013 19:14:49 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com
Subject: Re: [PATCH v3] cpufreq: stats: Add 'load_table' debugfs file to show
 accumulated data of CPUs
References: <1372064549-5872-1-git-send-email-cw00.choi@samsung.com>
 <CAKohpokvK0fBbfH_L8DETpMPr9UKzTtRRnzOzHOrHmX=NC-jDg@mail.gmail.com>
In-reply-to: <CAKohpokvK0fBbfH_L8DETpMPr9UKzTtRRnzOzHOrHmX=NC-jDg@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsWyRsSkRHeGwJlAg0nXbCyeNv1gtzjb9Ibd
	4vKuOWwWn3uPMFrcblzBZtG/sJfJYuNXDwd2jzvX9rB59G1ZxejxaHELo8fnTXIBLFFcNimp
	OZllqUX6dglcGZMXHGYqmNPEWHHq0DLGBsb7EV2MnBwSAiYSjYs+s0DYYhIX7q1n62Lk4hAS
	WMoo8aq3i7WLkQOsqOO0OER8EaPE0/vr2EAahAReMEpc+V4HYvMKaElMmLUJbBCLgKrEx+MH
	WUFsNqD4/hc3wOpFBcIkVk6/wgJRLyjxY/I9FpD5IkA1L2+mgsxnFpjOKDH9xy5mkBphgQyJ
	/1deMEEs7maU+HmqGyzBKRAssXrFarAFzAI6Evtbp7FB2PISm9e8ZQZpkBA4xy5xYXIXG8RF
	AhLfJh9igfhGVmLTAWaIjyUlDq64wTKBUWwWkptmIRk7C8nYBYzMqxhFUwuSC4qT0ouM9IoT
	c4tL89L1kvNzNzECo+30v2d9OxhvHrA+xJgMtHIis5Rocj4wWvNK4g2NzYwsTE1MjY3MLc1I
	E1YS51VrsQ4UEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwNic5a+Zn2wZfjpuV9CDpW/vr7p0
	82CsWfd5zrfhQUZsqscDV5oun/s3Uuir1rOEk7dzKwqWfFK7uUXL3YZpl8rE+Tms0oumPd+j
	vSyyOFnfzf+08VQX13NT7n0+0rT5LKuX1wb1jamOjn8mSi2pXnKuS/Eyn6GkbFjuFcHmP7u8
	r+u8LP+zLkyJpTgj0VCLuag4EQDcCT75zAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jAd0ZAmcCDXZ/MrR42vSD3eJs0xt2
	i8u75rBZfO49wmhxu3EFm0X/wl4mi41fPRzYPe5c28Pm0bdlFaPHo8UtjB6fN8kFsEQ1MNpk
	pCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAF2gpFCWmFMK
	FApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcyYvOAwU8GcJsaKU4eWMTYw3o/oYuTg
	kBAwkeg4Ld7FyAlkiklcuLeerYuRi0NIYBGjxNP769hAEkICLxglrnyvA7F5BbQkJszaxAJi
	swioSnw8fpAVxGYDiu9/cQOsXlQgTGLl9CssEPWCEj8m32MB2SUCVPPyZirIfGaB6YwS03/s
	YgapERbIkPh/5QUTxOJuRomfp7rBEpwCwRKrV6wGW8AsoCOxv3UaG4QtL7F5zVvmCYwCs5Ds
	mIWkbBaSsgWMzKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgmP5mfQOxlUNFocYBTgYlXh4
	PzCeDhRiTSwrrsw9xCjBwawkwmvIdSZQiDclsbIqtSg/vqg0J7X4EGMyMAgmMkuJJucD00xe
	SbyhsYmZkaWRuaGFkbE5acJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTDWfpC57P5R7Yvw
	/qOJXW/ytsQr/rv2dE3WYr9tWwMXv9LdXVraU2BaPVuazXRvuxvnu7yTL84XaXJsW7t4+74H
	jAsYP8tOWSKbV6iUUPP5xrJtl7Zeyro08ebsG3/NPkfELf207E59t+d3A/a3cWEK7w/tWRLt
	eYN99RFJFwkh2+VCRxZcZ2ScrcRSnJFoqMVcVJwIAPoQ7WgpAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 05:04 PM, Viresh Kumar wrote:
> On 24 June 2013 14:32, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>>       Time Old Frequency New Frequency CPU0 CPU1 CPU2 CPU3
>>     347000       1600000       1600000   12   33   86    8
>>     347100       1600000       1600000    4   30   72    4
>>     347200       1600000       1600000   20   18   15   80
>>     347300       1600000       1500000   61   20   56   66
>>     347400       1500000       1300000   64    5   58   52
>>     347500       1300000       1100000   39   19   57   59
> ...
> 
> Maybe we need to add units of time and freq too in the header of
> this table.

OK, I'll add unit of data as following:

       Time(ms) Old Frequency(Hz) New Frequency(Hz) CPU0 CPU1 CPU2 CPU3

> 
> Also, shouldn't we left indent this table, like start 3 of 347000 exactly
> below T of Time ? That will look better I guess.

OK, I'll modify it.

> 
>> drivers/cpufreq/Kconfig            |   6 +
>>  drivers/cpufreq/cpufreq.c          |   4 +
>>  drivers/cpufreq/cpufreq_governor.c |  19 +++-
>>  drivers/cpufreq/cpufreq_stats.c    | 227 +++++++++++++++++++++++++++++++++----
>>  include/linux/cpufreq.h            |   6 +
>>  5 files changed, 242 insertions(+), 20 deletions(-)
>>
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
> 
> Maybe 10 to 1000.. Lets give others a chance to see long logs :)
> 

OK, I'll extend the maximum value from 100 to 1000.

>> +       depends on CPU_FREQ_STAT_DETAILS
> 
> Probably you are waiting for Rafael's nod to make it CPU_FREQ_STAT?

As you comment, I'll change the dependency of load_table file
from CPU_FREQ_STAT_DETAILS to CPU_FREQ_STAT as following.

+       depends on CPU_FREQ_STAT

> 
>> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
>> index dc9b72e..7f19394 100644
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
>> @@ -144,10 +147,17 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
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
>> +#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
>> +               freq.load[j] = load;
>> +#endif
>>
>>                 if (dbs_data->cdata->governor == GOV_ONDEMAND) {
>>                         int freq_avg = __cpufreq_driver_getavg(policy, j);
>> @@ -161,6 +171,13 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
>>                         max_load = load;
>>         }
>>
>> +#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
>> +       freq.time = ktime_to_ms(ktime_get());
>> +       freq.old = freq.new = policy->cur;
> 
> No need to set freq.new here.

If cpufreq governor don't change cpu frequency on specific situation,
cpufreq SoC driver won't send CPUFREQ_POSTCHANGE. In case of this situation,
I store current cpu frequency to freq.new field.

> 
>> +       cpufreq_notify_transition(policy, &freq, CPUFREQ_LOADCHECK);
>> +#endif
>> +
>>         dbs_data->cdata->gov_check_cpu(cpu, max_load);
>>  }
>>  EXPORT_SYMBOL_GPL(dbs_check_cpu);
>> diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
>> index fb65dec..1b74b03 100644
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
>> @@ -24,6 +25,10 @@
>>
>>  static spinlock_t cpufreq_stats_lock;
>>
>> +#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
>> +static struct dentry *debugfs_cpufreq;
>> +#endif
>> +
>>  struct cpufreq_stats {
>>         unsigned int cpu;
>>         unsigned int total_trans;
>> @@ -35,6 +40,12 @@ struct cpufreq_stats {
>>         unsigned int *freq_table;
>>  #ifdef CONFIG_CPU_FREQ_STAT_DETAILS
>>         unsigned int *trans_table;
>> +
>> +       /* debugfs file for load_table */
>> +       struct cpufreq_freqs *load_table;
>> +       unsigned int load_last_index;
>> +       unsigned int load_max_index;
>> +       struct dentry *debugfs_cpu;
>>  #endif
>>  };
>>
>> @@ -149,6 +160,163 @@ static struct attribute_group stats_attr_group = {
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
>> +       ssize_t len = 0;
>> +       char *buf;
>> +       int i, cpu, ret;
>> +
>> +       buf = kzalloc(MAX_LINE_SIZE * stat->load_max_index, GFP_KERNEL);
>> +       if (!buf)
>> +               return 0;
> 
> Above use of stat->load_max_index must be inside locks I guess. Otherwise
> you may allocate memory for 10 lines and by the time lock is taken, we
> already have 12 entries. And so, below loop will go beyond array limits.
> 

I store CONFIG_NR_CPU_LOAD_STORAGE to stat->load_max_index in cpufreq_stats_create_debugfs()
So, stat->load_max_index value isn't always 10. 

If I misunderstood for your comment, I'd like you to explain more detailed about this comment.

>> +       spin_lock(&cpufreq_stats_lock);
>> +       len += sprintf(buf + len, "%10s %13s %13s", "Time", "Old Frequency",
>> +                                                   "New Frequency");
>> +       for_each_present_cpu(cpu)
>> +               len += sprintf(buf + len, " %3s%d", "CPU", cpu);
>> +       len += sprintf(buf + len, "\n");
>> +
>> +       i = stat->load_last_index;
>> +       do {
>> +               len += sprintf(buf + len, "%10lld %13d %13d",
>> +                               load_table[i].time,
>> +                               load_table[i].old,
>> +                               load_table[i].new);
>> +
>> +               for_each_present_cpu(cpu)
>> +                       len += sprintf(buf + len, " %4d",
>> +                                       load_table[i].load[cpu]);
>> +               len += sprintf(buf + len, "\n");
>> +
>> +               if (++i == stat->load_max_index)
>> +                       i = 0;
>> +       } while (i != stat->load_last_index);
>> +       spin_unlock(&cpufreq_stats_lock);
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
>> +static int cpufreq_stats_create_debugfs(struct cpufreq_policy *policy)
>> +{
>> +       struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, policy->cpu);
>> +       char buf[10];
>> +       int size, ret = 0;
>> +
>> +       if (!stat)
>> +               return -EINVAL;
>> +
>> +       stat->load_last_index = 0;
>> +       stat->load_max_index = CONFIG_NR_CPU_LOAD_STORAGE;
>> +
>> +       size = sizeof(*stat->load_table) * stat->load_max_index;
>> +       stat->load_table = kzalloc(size, GFP_KERNEL);
>> +       if (!stat->load_table) {
>> +               ret = -ENOMEM;
>> +               goto err_alloc;
>> +       }
>> +
>> +       /* Create debugfs root and file for cpufreq */
>> +       if (!debugfs_cpufreq) {
>> +               debugfs_cpufreq = debugfs_create_dir("cpufreq", NULL);
>> +               if (!debugfs_cpufreq) {
>> +                       ret = -EINVAL;
>> +                       goto err_alloc;
>> +               }
>> +       }
>> +
>> +       sprintf(buf, "cpu%d", policy->cpu);
>> +
>> +       stat->debugfs_cpu = debugfs_create_dir(buf, debugfs_cpufreq);
>> +       if (!stat->debugfs_cpu) {
>> +               ret = -EINVAL;
>> +               goto err_alloc;
>> +       }
>> +
>> +       debugfs_create_file("load_table", S_IWUSR, stat->debugfs_cpu,
>> +                               (void *)policy, &load_table_fops);
>> +
>> +       return 0;
>> +
>> +err_alloc:
>> +       kfree(stat->load_table);
> 
> What about reverse of
> 
> debugfs_create_dir("cpufreq", NULL) ??


My mistake.

I'll add debugfs_remove_recursive(debugfs_cpufreq) when happen error.


Best Regards,
Chanwoo Choi

> 
>> +
>> +       return ret;
>> +}
>> +
>> +static void cpufreq_stats_free_debugfs(unsigned int cpu)
>> +{
>> +       struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, cpu);
>> +
>> +       if (!stat)
>> +               return;
>> +
>> +       pr_debug("%s: Free debugfs stat\n", __func__);
>> +       debugfs_remove(debugfs_cpufreq);
>> +}
>> +#else
>> +static void cpufreq_stats_store_load_table(struct cpufreq_freqs *freq,
>> +                                          unsigned long val) { }
>> +static int cpufreq_stats_create_debugfs(struct cpufreq_policy *policy)
>> +{
>> +       return 0;
>> +}
>> +static void cpufreq_stats_free_debugfs(unsigned int cpu) { }
>> +#endif
>> +
>>  static int freq_table_get_index(struct cpufreq_stats *stat, unsigned int freq)
>>  {
>>         int index;
>> @@ -167,6 +335,9 @@ static void cpufreq_stats_free_table(unsigned int cpu)
>>
>>         if (stat) {
>>                 pr_debug("%s: Free stat table\n", __func__);
>> +#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
>> +               kfree(stat->load_table);
>> +#endif
>>                 kfree(stat->time_in_state);
>>                 kfree(stat);
>>                 per_cpu(cpufreq_stats_table, cpu) = NULL;
>> @@ -257,6 +428,14 @@ static int cpufreq_stats_create_table(struct cpufreq_policy *policy,
>>         spin_lock(&cpufreq_stats_lock);
>>         stat->last_time = get_jiffies_64();
>>         stat->last_index = freq_table_get_index(stat, policy->cur);
>> +
>> +       ret = cpufreq_stats_create_debugfs(data);
>> +       if (ret) {
>> +               spin_unlock(&cpufreq_stats_lock);
>> +               ret = -EINVAL;
>> +               goto error_out;
>> +       }
>> +
>>         spin_unlock(&cpufreq_stats_lock);
>>         cpufreq_cpu_put(data);
>>         return 0;
>> @@ -312,32 +491,40 @@ static int cpufreq_stat_notifier_trans(struct notifier_block *nb,
>>         struct cpufreq_stats *stat;
>>         int old_index, new_index;
>>
>> -       if (val != CPUFREQ_POSTCHANGE)
>> -               return 0;
>> -
>> -       stat = per_cpu(cpufreq_stats_table, freq->cpu);
>> -       if (!stat)
>> -               return 0;
>> +       switch (val) {
>> +       case CPUFREQ_POSTCHANGE:
>> +               stat = per_cpu(cpufreq_stats_table, freq->cpu);
>> +               if (!stat)
>> +                       return 0;
>>
>> -       old_index = stat->last_index;
>> -       new_index = freq_table_get_index(stat, freq->new);
>> +               old_index = stat->last_index;
>> +               new_index = freq_table_get_index(stat, freq->new);
>>
>> -       /* We can't do stat->time_in_state[-1]= .. */
>> -       if (old_index == -1 || new_index == -1)
>> -               return 0;
>> +               /* We can't do stat->time_in_state[-1]= .. */
>> +               if (old_index == -1 || new_index == -1)
>> +                       return 0;
>>
>> -       cpufreq_stats_update(freq->cpu);
>> +               cpufreq_stats_update(freq->cpu);
>>
>> -       if (old_index == new_index)
>> -               return 0;
>> +               if (old_index == new_index)
>> +                       return 0;
>>
>> -       spin_lock(&cpufreq_stats_lock);
>> -       stat->last_index = new_index;
>> +               spin_lock(&cpufreq_stats_lock);
>> +               stat->last_index = new_index;
>>  #ifdef CONFIG_CPU_FREQ_STAT_DETAILS
>> -       stat->trans_table[old_index * stat->max_state + new_index]++;
>> +               stat->trans_table[old_index * stat->max_state + new_index]++;
>>  #endif
>> -       stat->total_trans++;
>> -       spin_unlock(&cpufreq_stats_lock);
>> +               stat->total_trans++;
>> +               spin_unlock(&cpufreq_stats_lock);
>> +
>> +               cpufreq_stats_store_load_table(freq, CPUFREQ_POSTCHANGE);
>> +
>> +               break;
>> +       case CPUFREQ_LOADCHECK:
>> +               cpufreq_stats_store_load_table(freq, CPUFREQ_LOADCHECK);
>> +               break;
>> +       }
>> +
>>         return 0;
>>  }
>>
>> @@ -352,12 +539,14 @@ static int __cpuinit cpufreq_stat_cpu_callback(struct notifier_block *nfb,
>>                 cpufreq_update_policy(cpu);
>>                 break;
>>         case CPU_DOWN_PREPARE:
>> +               cpufreq_stats_free_debugfs(cpu);
>>                 cpufreq_stats_free_sysfs(cpu);
>>                 break;
>>         case CPU_DEAD:
>>                 cpufreq_stats_free_table(cpu);
>>                 break;
>>         case CPU_UP_CANCELED_FROZEN:
>> +               cpufreq_stats_free_debugfs(cpu);
>>                 cpufreq_stats_free_sysfs(cpu);
>>                 cpufreq_stats_free_table(cpu);
>>                 break;
>> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
>> index 037d36a..f780645 100644
>> --- a/include/linux/cpufreq.h
>> +++ b/include/linux/cpufreq.h
>> @@ -140,12 +140,18 @@ static inline bool policy_is_shared(struct cpufreq_policy *policy)
>>  #define CPUFREQ_POSTCHANGE     (1)
>>  #define CPUFREQ_RESUMECHANGE   (8)
>>  #define CPUFREQ_SUSPENDCHANGE  (9)
>> +#define CPUFREQ_LOADCHECK      (10)
>>
>>  struct cpufreq_freqs {
>>         unsigned int cpu;       /* cpu nr */
>>         unsigned int old;
>>         unsigned int new;
>>         u8 flags;               /* flags of cpufreq_driver, see below. */
>> +
>> +#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
>> +       int64_t time;
>> +       unsigned int load[NR_CPUS];
>> +#endif
>>  };
>>
>>

