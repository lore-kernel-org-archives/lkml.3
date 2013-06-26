Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646Ab3FZAKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 20:10:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:49081 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab3FZAKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 20:10:17 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-5c-51ca3167c951
Message-id: <51CA3167.1020606@samsung.com>
Date: Wed, 26 Jun 2013 09:10:15 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: rjw@sisk.pl, viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com
Subject: Re: [PATCH v3] cpufreq: stats: Add 'load_table' debugfs file to show
 accumulated data of CPUs
References: <1372064549-5872-1-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1372064549-5872-1-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsWyRsSkSDfd8FSgwaPZEhZPm36wW1z/8pzV
	4mzTG3aLy7vmsFl87j3CaHG7cQWbRf/CXiaLjV89HDg87lzbw+bRt2UVo8ejxS2MHp83yQWw
	RHHZpKTmZJalFunbJXBlnF/ayV7Q1MVYserUHuYGxhupXYycHBICJhJ/Xt1mhbDFJC7cW8/W
	xcjFISSwlFHizJFXrDBFK6Z9Y4RILGKU+Hm6jQXCecEosfrdXBaQKl4BLYlFn2Yxg9gsAqoS
	e149B4uzAcX3v7jBBmKLCoRJrJx+BapeUOLH5HtgtoiAhsTMv1fANjALbGKUuHH5AliDsECG
	xP8rL5hAbCEBF4m9Oyayg9icAq4SJxqegtUwC+hI7G+dBmXLS2xe85YZ4uxz7BLzZjlBHCQg
	8W3yIaBlHEBxWYlNB6BKJCUOrrjBMoFRbBaSk2YhmToLydQFjMyrGEVTC5ILipPSiwz1ihNz
	i0vz0vWS83M3MQIj7/S/Z707GG8fsD7EmAy0ciKzlGhyPjBy80riDY3NjCxMTUyNjcwtzUgT
	VhLnVWuxDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAeP7Z9Km7i1gDOGZOb8n/eMsgWWOv
	VKK7v7yOvkXu9llqnytCjkf6qS6OfSxmqWH/f/WaddODIn41WG3bITgj/qXKCwG2yJQDq65M
	9op88ivryuunZ5U+HFH8E6c/aXvqlFkHb166oRGf57E35YZnr7hhNEdd2vEP1YXnO/p8H365
	eXrfzY6DZkosxRmJhlrMRcWJANnJLSHSAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jAd10w1OBBs+v81g8bfrBbnH9y3NW
	i7NNb9gtLu+aw2bxufcIo8XtxhVsFv0Le5ksNn71cODwuHNtD5tH35ZVjB6PFrcwenzeJBfA
	EtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdIaS
	QlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMeP80k72gqYuxopVp/YwNzDe
	SO1i5OSQEDCRWDHtGyOELSZx4d56ti5GLg4hgUWMEj9Pt7FAOC8YJVa/m8sCUsUroCWx6NMs
	ZhCbRUBVYs+r52BxNqD4/hc32EBsUYEwiZXTr0DVC0r8mHwPzBYR0JCY+fcKI8hQZoFNjBI3
	Ll8AaxAWyJD4f+UFE4gtJOAisXfHRHYQm1PAVeJEw1OwGmYBHYn9rdOgbHmJzWveMk9gFJiF
	ZMcsJGWzkJQtYGRexSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREc2c+kdzCuarA4xCjAwajE
	w6uw9WSgEGtiWXFl7iFGCQ5mJRHe/BtAId6UxMqq1KL8+KLSnNTiQ4zJwCCYyCwlmpwPTDp5
	JfGGxiZmRpZG5oYWRsbmpAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cCYxHmnyeBAsL+U
	4CyzQzdYFjzYrfZ8a5hMZHZSyOy351OaV5a99/nbIPfvZ6eGqpFywdr7HTsCRefZmgTKv7+6
	v/u81Z/UUiGbKRqN319cfnBp24y/Ul4TrOKYmI8tXWJ1dNmv2jUehU+47nBpT3294soOt/D8
	j3NUl8yLW3au8tuackPhZ5filFiKMxINtZiLihMBxx2Z2DADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

Ping!

This patch implemented load_table debugfs file
whilch show old frequncy/new frequency. 

Best Regards,
Chanwoo Choi


On 06/24/2013 06:02 PM, Chanwoo Choi wrote:
> This patch add new 'load_table' debugfs file to show previous accumulated data
> of CPUs load as following path and add CPUFREQ_LOADCHECK notification to
> CPUFREQ_TRANSITION_NOTIFIER notifier chain.
> - /sys/kernel/debug/cpufreq/cpuX/load_table
> 
> When governor calculates CPUs load on dbs_check_cpu(), governor send
> CPUFREQ_LOADCHECK notification with CPUs load, so that cpufreq_stats
> accumulates calculated CPUs load on 'load_table' storage.
> 
> This debugfs file is used to judge the correct system state or determine
> suitable system resource according to current CPUs load on user-space.
> 
> This debugfs file include following data:
> - Measurement point of time
> - CPU frequency
> - Per-CPU load
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
> ---
> Changes since v2:
> - Code clean according to Viresh Kumar's comment
> - Show both old frequency and new frequency on 'load_table' debugfs file
> - Change debufs file patch as below
>   old: /sys/kernel/debugfs/cpufreq/load_table
>   new: /sys/kernel/debugfs/cpufreq/cpuX/load_table
> 
> Changes since v1:
> - Set maximum storage size to save CPUs load on Kconfig
> - Use spinlock to synchronize read/write operation for CPUs load
> - Use local variable instead of global variable(struct cpufreq_freqs *freqs)
> - Use pointer of data structure to get correct size of data structure
>   in sizeof() macro instead of structure name
>   : sizeof(struct cpufreq_freqs) -> sizeof(*stat->load_table)
> - Change time unit from nanosecond to microsecond
> - Remove unnecessary memory copy
> 
> Following Test result :
> - Cpufreq governor : ondemand governor
> - Test application : MP3 play + Picture Audo-slide application
> - NR_CPU_LOAD_STORAGE is 50
> 
>       Time Old Frequency New Frequency CPU0 CPU1 CPU2 CPU3
>     347000       1600000       1600000   12   33   86    8
>     347100       1600000       1600000    4   30   72    4
>     347200       1600000       1600000   20   18   15   80
>     347300       1600000       1500000   61   20   56   66
>     347400       1500000       1300000   64    5   58   52
>     347500       1300000       1100000   39   19   57   59
>     347600       1100000       1100000   73    2   77   49
>     347700       1100000       1600000   70   40   84   58
>     347800       1600000       1600000   98   95   45   25
>     347900       1600000       1200000   39   30   16   53
>     348000       1200000        600000   37    7    1    3
>     348100        600000        200000    6    0   18    5
>     348200        200000        200000   22    8    5   23
>     348300        200000        200000   43    3   75   13
>     348400        200000       1600000   43   12  100   16
>     348500       1600000        700000   19    7   17   30
>     348600        700000        400000   31   12   37    2
>     348705        400000       1600000   67   53   83   18
>     348800       1600000        600000   26    7    7   17
>     348900        600000        600000   16    3    0    3
>     349000        200000        200000   42    9    9   48
>     349100        200000       1600000   19   11   26   84
>     349200       1600000        400000   17    9   15   15
>     349300        400000        300000   38   27    6    7
>     349400        300000        300000   53   11    2   21
>     349500        300000        300000   56   19   16   38
>     349600        300000        300000   58   32    7   40
>     349700        300000        300000   54   39   12   21
>     349800        300000       1600000   91   70   85   67
>     349900       1600000        900000   42    2   42   23
>     350000        900000        400000   30    3    2    5
>     350100        400000        200000   15   15    3    8
>     350200        200000        200000   37   33    1   26
>     350300        200000       1600000   10   95    0    4
>     350400       1600000        500000   20   10    1   13
>     350500        500000        300000   31    8    1   25
>     350600        300000        200000   36   10   10    6
>     350700        200000        200000   65    9   23   45
>     350800        200000        200000   68   40   63   44
>     350900        200000       1600000   95   73   84   89
>     351000       1600000       1600000   35   81    5    1
>     351100       1600000        600000   26    3    7    7
>     351200        600000        200000   13    6    8   23
>     351300        200000        200000   36    9    2   16
>     351400        200000        200000   60   53    0   57
>     351500        200000        200000   36   21   11   31
>     351600        200000        200000   54    1   33   34
>     351700        200000        200000   60    1   30   59
>     351800        200000        200000   36   18    9   16
>     351900        200000       1600000   84   12   46   17
> 
> drivers/cpufreq/Kconfig            |   6 +
>  drivers/cpufreq/cpufreq.c          |   4 +
>  drivers/cpufreq/cpufreq_governor.c |  19 +++-
>  drivers/cpufreq/cpufreq_stats.c    | 227 +++++++++++++++++++++++++++++++++----
>  include/linux/cpufreq.h            |   6 +
>  5 files changed, 242 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
> index 534fcb8..8a429b3 100644
> --- a/drivers/cpufreq/Kconfig
> +++ b/drivers/cpufreq/Kconfig
> @@ -45,6 +45,12 @@ config CPU_FREQ_STAT_DETAILS
>  
>  	  If in doubt, say N.
>  
> +config NR_CPU_LOAD_STORAGE
> +	int "Maximum storage size to save CPU load (10-100)"
> +	range 10 100
> +	depends on CPU_FREQ_STAT_DETAILS
> +	default "10"
> +
>  choice
>  	prompt "Default CPUFreq governor"
>  	default CPU_FREQ_DEFAULT_GOV_USERSPACE if ARM_SA1100_CPUFREQ || ARM_SA1110_CPUFREQ
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 2d53f47..cbaaff0 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -292,6 +292,10 @@ void __cpufreq_notify_transition(struct cpufreq_policy *policy,
>  		if (likely(policy) && likely(policy->cpu == freqs->cpu))
>  			policy->cur = freqs->new;
>  		break;
> +	case CPUFREQ_LOADCHECK:
> +		srcu_notifier_call_chain(&cpufreq_transition_notifier_list,
> +				CPUFREQ_LOADCHECK, freqs);
> +		break;
>  	}
>  }
>  /**
> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> index dc9b72e..7f19394 100644
> --- a/drivers/cpufreq/cpufreq_governor.c
> +++ b/drivers/cpufreq/cpufreq_governor.c
> @@ -90,6 +90,9 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
>  	unsigned int max_load = 0;
>  	unsigned int ignore_nice;
>  	unsigned int j;
> +#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
> +	struct cpufreq_freqs freq;
> +#endif
>  
>  	if (dbs_data->cdata->governor == GOV_ONDEMAND)
>  		ignore_nice = od_tuners->ignore_nice;
> @@ -144,10 +147,17 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
>  			idle_time += jiffies_to_usecs(cur_nice_jiffies);
>  		}
>  
> -		if (unlikely(!wall_time || wall_time < idle_time))
> +		if (unlikely(!wall_time || wall_time < idle_time)) {
> +#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
> +			freq.load[j] = 0;
> +#endif
>  			continue;
> +		}
>  
>  		load = 100 * (wall_time - idle_time) / wall_time;
> +#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
> +		freq.load[j] = load;
> +#endif
>  
>  		if (dbs_data->cdata->governor == GOV_ONDEMAND) {
>  			int freq_avg = __cpufreq_driver_getavg(policy, j);
> @@ -161,6 +171,13 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
>  			max_load = load;
>  	}
>  
> +#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
> +	freq.time = ktime_to_ms(ktime_get());
> +	freq.old = freq.new = policy->cur;
> +
> +	cpufreq_notify_transition(policy, &freq, CPUFREQ_LOADCHECK);
> +#endif
> +
>  	dbs_data->cdata->gov_check_cpu(cpu, max_load);
>  }
>  EXPORT_SYMBOL_GPL(dbs_check_cpu);
> diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
> index fb65dec..1b74b03 100644
> --- a/drivers/cpufreq/cpufreq_stats.c
> +++ b/drivers/cpufreq/cpufreq_stats.c
> @@ -12,6 +12,7 @@
>  #include <linux/kernel.h>
>  #include <linux/slab.h>
>  #include <linux/cpu.h>
> +#include <linux/debugfs.h>
>  #include <linux/sysfs.h>
>  #include <linux/cpufreq.h>
>  #include <linux/module.h>
> @@ -24,6 +25,10 @@
>  
>  static spinlock_t cpufreq_stats_lock;
>  
> +#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
> +static struct dentry *debugfs_cpufreq;
> +#endif
> +
>  struct cpufreq_stats {
>  	unsigned int cpu;
>  	unsigned int total_trans;
> @@ -35,6 +40,12 @@ struct cpufreq_stats {
>  	unsigned int *freq_table;
>  #ifdef CONFIG_CPU_FREQ_STAT_DETAILS
>  	unsigned int *trans_table;
> +
> +	/* debugfs file for load_table */
> +	struct cpufreq_freqs *load_table;
> +	unsigned int load_last_index;
> +	unsigned int load_max_index;
> +	struct dentry *debugfs_cpu;
>  #endif
>  };
>  
> @@ -149,6 +160,163 @@ static struct attribute_group stats_attr_group = {
>  	.name = "stats"
>  };
>  
> +#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
> +#define MAX_LINE_SIZE		255
> +static ssize_t load_table_read(struct file *file, char __user *user_buf,
> +					size_t count, loff_t *ppos)
> +{
> +	struct cpufreq_policy *policy = file->private_data;
> +	struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, policy->cpu);
> +	struct cpufreq_freqs *load_table = stat->load_table;
> +	ssize_t len = 0;
> +	char *buf;
> +	int i, cpu, ret;
> +
> +	buf = kzalloc(MAX_LINE_SIZE * stat->load_max_index, GFP_KERNEL);
> +	if (!buf)
> +		return 0;
> +
> +	spin_lock(&cpufreq_stats_lock);
> +	len += sprintf(buf + len, "%10s %13s %13s", "Time", "Old Frequency",
> +						    "New Frequency");
> +	for_each_present_cpu(cpu)
> +		len += sprintf(buf + len, " %3s%d", "CPU", cpu);
> +	len += sprintf(buf + len, "\n");
> +
> +	i = stat->load_last_index;
> +	do {
> +		len += sprintf(buf + len, "%10lld %13d %13d",
> +				load_table[i].time,
> +				load_table[i].old,
> +				load_table[i].new);
> +
> +		for_each_present_cpu(cpu)
> +			len += sprintf(buf + len, " %4d",
> +					load_table[i].load[cpu]);
> +		len += sprintf(buf + len, "\n");
> +
> +		if (++i == stat->load_max_index)
> +			i = 0;
> +	} while (i != stat->load_last_index);
> +	spin_unlock(&cpufreq_stats_lock);
> +
> +	ret = simple_read_from_buffer(user_buf, count, ppos, buf, len);
> +	kfree(buf);
> +
> +	return ret;
> +}
> +
> +static const struct file_operations load_table_fops = {
> +	.read		= load_table_read,
> +	.open		= simple_open,
> +	.llseek		= no_llseek,
> +};
> +
> +static void cpufreq_stats_store_load_table(struct cpufreq_freqs *freq,
> +					   unsigned long val)
> +{
> +	struct cpufreq_stats *stat;
> +	int cpu, last_idx;
> +
> +	stat = per_cpu(cpufreq_stats_table, freq->cpu);
> +	if (!stat)
> +		return;
> +
> +	spin_lock(&cpufreq_stats_lock);
> +
> +	switch (val) {
> +	case CPUFREQ_POSTCHANGE:
> +		if (!stat->load_last_index)
> +			last_idx = stat->load_max_index;
> +		else
> +			last_idx = stat->load_last_index - 1;
> +
> +		stat->load_table[last_idx].new = freq->new;
> +		break;
> +	case CPUFREQ_LOADCHECK:
> +		last_idx = stat->load_last_index;
> +
> +		stat->load_table[last_idx].time = freq->time;
> +		stat->load_table[last_idx].old = freq->old;
> +		stat->load_table[last_idx].new = freq->old;
> +		for_each_present_cpu(cpu)
> +			stat->load_table[last_idx].load[cpu] = freq->load[cpu];
> +
> +		if (++stat->load_last_index == stat->load_max_index)
> +			stat->load_last_index = 0;
> +		break;
> +	}
> +
> +	spin_unlock(&cpufreq_stats_lock);
> +}
> +
> +static int cpufreq_stats_create_debugfs(struct cpufreq_policy *policy)
> +{
> +	struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, policy->cpu);
> +	char buf[10];
> +	int size, ret = 0;
> +
> +	if (!stat)
> +		return -EINVAL;
> +
> +	stat->load_last_index = 0;
> +	stat->load_max_index = CONFIG_NR_CPU_LOAD_STORAGE;
> +
> +	size = sizeof(*stat->load_table) * stat->load_max_index;
> +	stat->load_table = kzalloc(size, GFP_KERNEL);
> +	if (!stat->load_table) {
> +		ret = -ENOMEM;
> +		goto err_alloc;
> +	}
> +
> +	/* Create debugfs root and file for cpufreq */
> +	if (!debugfs_cpufreq) {
> +		debugfs_cpufreq = debugfs_create_dir("cpufreq", NULL);
> +		if (!debugfs_cpufreq) {
> +			ret = -EINVAL;
> +			goto err_alloc;
> +		}
> +	}
> +
> +	sprintf(buf, "cpu%d", policy->cpu);
> +
> +	stat->debugfs_cpu = debugfs_create_dir(buf, debugfs_cpufreq);
> +	if (!stat->debugfs_cpu) {
> +		ret = -EINVAL;
> +		goto err_alloc;
> +	}
> +
> +	debugfs_create_file("load_table", S_IWUSR, stat->debugfs_cpu,
> +				(void *)policy, &load_table_fops);
> +
> +	return 0;
> +
> +err_alloc:
> +	kfree(stat->load_table);
> +
> +	return ret;
> +}
> +
> +static void cpufreq_stats_free_debugfs(unsigned int cpu)
> +{
> +	struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, cpu);
> +
> +	if (!stat)
> +		return;
> +
> +	pr_debug("%s: Free debugfs stat\n", __func__);
> +	debugfs_remove(debugfs_cpufreq);
> +}
> +#else
> +static void cpufreq_stats_store_load_table(struct cpufreq_freqs *freq,
> +					   unsigned long val) { }
> +static int cpufreq_stats_create_debugfs(struct cpufreq_policy *policy)
> +{
> +	return 0;
> +}
> +static void cpufreq_stats_free_debugfs(unsigned int cpu) { }
> +#endif
> +
>  static int freq_table_get_index(struct cpufreq_stats *stat, unsigned int freq)
>  {
>  	int index;
> @@ -167,6 +335,9 @@ static void cpufreq_stats_free_table(unsigned int cpu)
>  
>  	if (stat) {
>  		pr_debug("%s: Free stat table\n", __func__);
> +#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
> +		kfree(stat->load_table);
> +#endif
>  		kfree(stat->time_in_state);
>  		kfree(stat);
>  		per_cpu(cpufreq_stats_table, cpu) = NULL;
> @@ -257,6 +428,14 @@ static int cpufreq_stats_create_table(struct cpufreq_policy *policy,
>  	spin_lock(&cpufreq_stats_lock);
>  	stat->last_time = get_jiffies_64();
>  	stat->last_index = freq_table_get_index(stat, policy->cur);
> +
> +	ret = cpufreq_stats_create_debugfs(data);
> +	if (ret) {
> +		spin_unlock(&cpufreq_stats_lock);
> +		ret = -EINVAL;
> +		goto error_out;
> +	}
> +
>  	spin_unlock(&cpufreq_stats_lock);
>  	cpufreq_cpu_put(data);
>  	return 0;
> @@ -312,32 +491,40 @@ static int cpufreq_stat_notifier_trans(struct notifier_block *nb,
>  	struct cpufreq_stats *stat;
>  	int old_index, new_index;
>  
> -	if (val != CPUFREQ_POSTCHANGE)
> -		return 0;
> -
> -	stat = per_cpu(cpufreq_stats_table, freq->cpu);
> -	if (!stat)
> -		return 0;
> +	switch (val) {
> +	case CPUFREQ_POSTCHANGE:
> +		stat = per_cpu(cpufreq_stats_table, freq->cpu);
> +		if (!stat)
> +			return 0;
>  
> -	old_index = stat->last_index;
> -	new_index = freq_table_get_index(stat, freq->new);
> +		old_index = stat->last_index;
> +		new_index = freq_table_get_index(stat, freq->new);
>  
> -	/* We can't do stat->time_in_state[-1]= .. */
> -	if (old_index == -1 || new_index == -1)
> -		return 0;
> +		/* We can't do stat->time_in_state[-1]= .. */
> +		if (old_index == -1 || new_index == -1)
> +			return 0;
>  
> -	cpufreq_stats_update(freq->cpu);
> +		cpufreq_stats_update(freq->cpu);
>  
> -	if (old_index == new_index)
> -		return 0;
> +		if (old_index == new_index)
> +			return 0;
>  
> -	spin_lock(&cpufreq_stats_lock);
> -	stat->last_index = new_index;
> +		spin_lock(&cpufreq_stats_lock);
> +		stat->last_index = new_index;
>  #ifdef CONFIG_CPU_FREQ_STAT_DETAILS
> -	stat->trans_table[old_index * stat->max_state + new_index]++;
> +		stat->trans_table[old_index * stat->max_state + new_index]++;
>  #endif
> -	stat->total_trans++;
> -	spin_unlock(&cpufreq_stats_lock);
> +		stat->total_trans++;
> +		spin_unlock(&cpufreq_stats_lock);
> +
> +		cpufreq_stats_store_load_table(freq, CPUFREQ_POSTCHANGE);
> +
> +		break;
> +	case CPUFREQ_LOADCHECK:
> +		cpufreq_stats_store_load_table(freq, CPUFREQ_LOADCHECK);
> +		break;
> +	}
> +
>  	return 0;
>  }
>  
> @@ -352,12 +539,14 @@ static int __cpuinit cpufreq_stat_cpu_callback(struct notifier_block *nfb,
>  		cpufreq_update_policy(cpu);
>  		break;
>  	case CPU_DOWN_PREPARE:
> +		cpufreq_stats_free_debugfs(cpu);
>  		cpufreq_stats_free_sysfs(cpu);
>  		break;
>  	case CPU_DEAD:
>  		cpufreq_stats_free_table(cpu);
>  		break;
>  	case CPU_UP_CANCELED_FROZEN:
> +		cpufreq_stats_free_debugfs(cpu);
>  		cpufreq_stats_free_sysfs(cpu);
>  		cpufreq_stats_free_table(cpu);
>  		break;
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index 037d36a..f780645 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -140,12 +140,18 @@ static inline bool policy_is_shared(struct cpufreq_policy *policy)
>  #define CPUFREQ_POSTCHANGE	(1)
>  #define CPUFREQ_RESUMECHANGE	(8)
>  #define CPUFREQ_SUSPENDCHANGE	(9)
> +#define CPUFREQ_LOADCHECK	(10)
>  
>  struct cpufreq_freqs {
>  	unsigned int cpu;	/* cpu nr */
>  	unsigned int old;
>  	unsigned int new;
>  	u8 flags;		/* flags of cpufreq_driver, see below. */
> +
> +#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
> +	int64_t time;
> +	unsigned int load[NR_CPUS];
> +#endif
>  };
>  
>  
> 

