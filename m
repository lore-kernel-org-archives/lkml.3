Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab3F1JWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 05:22:48 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:42766 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950Ab3F1JWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 05:22:45 -0400
X-AuditID: cbfee691-b7fef6d000002d62-34-51cd55e366b0
Message-id: <51CD55E2.5060205@samsung.com>
Date: Fri, 28 Jun 2013 18:22:42 +0900
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
In-reply-to: <CAKohpon6AaSRQKvffPG+J=NUU+5JdVhFo-_uMm=2H3u-yT5h0A@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsWyRsSkQPdx6NlAg1s/ZSyeNv1gtzjb9Ibd
	4vKuOWwWn3uPMFrcblzBZtG/sJfJYuNXDwd2jzvX9rB59G1ZxejxaHELo8fnTXIBLFFcNimp
	OZllqUX6dglcGe8/L2MvuGlYceJ0E1MD4wmlLkYODgkBE4mmmXZdjJxAppjEhXvr2boYuTiE
	BJYySqxcsoEFImEisWPubxaIxHRGiTNbG1ghnBeMEn+fv2IHmcQroCWxZkU5SAOLgKpEz6YX
	rCA2G1B4/4sbbCC2qECYxMrpV8CG8goISvyYfI8FpFUEqOblzVSQkcwg86f/2MUMUiMskCFx
	/fgHqIt6GCU2Ln4K1swpECzx4ekMMJtZQEdif+s0NghbXmLzmrfMIA0SAsfYJWa9uMMIcZGA
	xLfJh1ggXpaV2HSAGeIzSYmDK26wTGAUm4XkpllIxs5CMnYBI/MqRtHUguSC4qT0IlO94sTc
	4tK8dL3k/NxNjMBYO/3v2cQdjPcPWB9iTAZaOZFZSjQ5HxireSXxhsZmRhamJqbGRuaWZqQJ
	K4nzqrdYBwoJpCeWpGanphakFsUXleakFh9iZOLglGpgjFGTe397fqSxhNQzvolvX//YW9vn
	3Pf+wP6oF1s0VBfLuTMZSy+Z/Y3zaPjug1cqV+/dd/W0dXfan9PRN3bsZHm55yV39fWpF4yP
	nioIPDVV75NMZP7fc8znJRQmBE/buP2YUFKJxO75UT3bNv34dEX37gfvRV/m7zp1/v7e3Y+C
	kufPN+UT5m1TYinOSDTUYi4qTgQAhyJ2GcsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jQd3HoWcDDea1iFg8bfrBbnG26Q27
	xeVdc9gsPvceYbS43biCzaJ/YS+TxcavHg7sHneu7WHz6NuyitHj0eIWRo/Pm+QCWKIaGG0y
	UhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgC5QUihLzCkF
	CgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGa8/7yMveCmYcWJ001MDYwnlLoYOTkk
	BEwkdsz9zQJhi0lcuLeerYuRi0NIYDqjxJmtDawQzgtGib/PX7F3MXJw8ApoSaxZUQ7SwCKg
	KtGz6QUriM0GFN7/4gYbiC0qECaxcvoVsKG8AoISPybfYwFpFQGqeXkzFWQkM8j86T92MYPU
	CAtkSFw//gFqcQ+jxMbFT8GaOQWCJT48nQFmMwvoSOxvncYGYctLbF7zlnkCo8AsJDtmISmb
	haRsASPzKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgWH4mvYNxVYPFIUYBDkYlHt6GxDOB
	QqyJZcWVuYcYJTiYlUR47ywACvGmJFZWpRblxxeV5qQWH2JMBgbBRGYp0eR8YJrJK4k3NDYx
	M7I0Mje0MDI2J01YSZz3YKt1oJBAemJJanZqakFqEcwWJg5OqQbGrTcWCzx5puOyltXzw13T
	rX7PDLZYt8fv41K5Eayyluej/PKTB64ZhQZMeOyhPuV28SZ9g0iV8rT5RQtcliqZ8cddZJYW
	4FqUdsqGY7XMh6pJO8/+aNy16/Stp6JTniW/vybwp6Vjx2X721+OVOe1BqTdFmp/XPvk8f4f
	8Zd3fJTcfzJmub2WihJLcUaioRZzUXEiABXzKJgpAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2013 05:18 PM, Viresh Kumar wrote:
> On 28 June 2013 13:18, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> Time(ms)   Old Freq(Hz) New Freq(Hz) CPU0 CPU1 CPU2 CPU3
>> 175320          1400000      1400000   41   47    0   79
> 
> We decided to left indent all entries here. I see only the first one
> like this. What about others?
> 

OK, I'll modify it.

Time(ms)   Old Freq(Hz) New Freq(Hz) CPU0 CPU1 CPU2 CPU3
23165      200000       200000       2    0    0    0

>> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
>> index dc9b72e..a13bdf9 100644
>> --- a/drivers/cpufreq/cpufreq_governor.c
>> +++ b/drivers/cpufreq/cpufreq_governor.c
>> @@ -87,6 +87,9 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
>>         struct od_dbs_tuners *od_tuners = dbs_data->tuners;
>>         struct cs_dbs_tuners *cs_tuners = dbs_data->tuners;
>>         struct cpufreq_policy *policy;
> 
> A simple solution to your problem can be
> 
>> +#ifdef CONFIG_CPU_FREQ_STAT
>> +       struct cpufreq_freqs freq;
> 
> struct cpufreq_freqs freq = {0};
> 
>> +#endif
>>         unsigned int max_load = 0;
>>         unsigned int ignore_nice;
>>         unsigned int j;
>> @@ -148,6 +151,9 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
>>                         continue;
>>
>>                 load = 100 * (wall_time - idle_time) / wall_time;
>> +#ifdef CONFIG_CPU_FREQ_STAT
>> +               freq.load[j] = load;
>> +#endif
>>
>>                 if (dbs_data->cdata->governor == GOV_ONDEMAND) {
>>                         int freq_avg = __cpufreq_driver_getavg(policy, j);
>> @@ -161,6 +167,15 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
>>                         max_load = load;
>>         }
>>
>> +#ifdef CONFIG_CPU_FREQ_STAT
>> +       for_each_cpu_not(j, policy->cpus)
>> +               freq.load[j] = 0;
> 
> and remove this.

OK. I'll modify it as your comment.

> 
>> +       freq.time = ktime_to_ms(ktime_get());
>> +       freq.old = policy->cur;
>> +
>> +       cpufreq_notify_transition(policy, &freq, CPUFREQ_LOADCHECK);
>> +#endif
> 
> If I remember well you had another instance where you were setting
> load as zero when wall time is less than idle time?

Right, I initailized CPUs load in for_each_cpu(j, policy->cpus) as zero.
The previous code couldn't initialize the load value of offline cpu.

But, This issue is resolved after applying following code as your comment.
	> struct cpufreq_freqs freq = {0};

> 
>>         dbs_data->cdata->gov_check_cpu(cpu, max_load);
>>  }
>>  EXPORT_SYMBOL_GPL(dbs_check_cpu);
>> diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
> 
>> +static int cpufreq_stats_create_debugfs(struct cpufreq_policy *policy)
>> +{
> 
>> +       /* Create debugfs directory and file for cpufreq */
>> +       sprintf(buf, "cpu%d", policy->cpu);
>> +       stat->debugfs_cpu = debugfs_create_dir(buf, debugfs_cpufreq);
>> +       if (!stat->debugfs_cpu) {
>> +               ret = -ENOMEM;
>> +               goto err_alloc;
>> +       }
>> +
>> +       if (!debugfs_create_file("load_table", S_IWUSR, stat->debugfs_cpu,
>> +                               policy, &load_table_fops)) {
>> +               ret = -ENOMEM;
>> +               goto err_debugfs;
>> +       }
>> +
>> +       return 0;
>> +
>> +err_debugfs:
>> +       debugfs_remove_recursive(stat->debugfs_cpu);
>> +err_alloc:
>> +       kfree(stat->load_table);
>> +err:
>> +       return ret;
>> +}
> 
> Can you describe a bit about the layout this will create in debugfs?
> I thought you will have a load_table file per policy->cpu ??
> 

The debugfs_cpufreq is debugfs root directory (/sys/kernel/debug/cpufreq)
and debugfs_cpufreq has many child directory for Per-CPU debugfs according to NR_CPUS number (/sys/kernel/debug/cpufreq/cpuX).
Finally, Per-CPU debugfs create load_table debugfs file (/sys/kernel/debug/cpufreq/cpuX/load_table).

For example, only CPU0 create sysfs directory and file (/sys/devices/system/cpu/cpu0/cpufreq)
and then other CPUx create link of created sysfs directory by CPU0 in cpufreq_add_dev_symlink().

So, I'm considering whether to create link of CPUx's debugfs file except for CPU0 as sysfs file.
- /sys/kernel/debug/cpufreq/cpu1/
- /sys/kernel/debug/cpufreq/cpu2/
- /sys/kernel/debug/cpufreq/cpu3/

> Like: /sys/kernel/debug/cpufreq/cpu0/load_table
> 
> Now in the show table function you are doing for_each_present_cpu()
> which may contain more cpus than are present in policy. Right?
> 

You're right.

> Probably you need to do, for_each_cpu(cpu, policy->cpus)..
> 

OK I'll modify it.

- A number of online CPU is 4
Time(ms)   Old Freq(Hz) New Freq(Hz) CPU0 CPU1 CPU2 CPU3
23165      200000       200000       2    0    0    0
23370      200000       200000       2    0    0    0
23575      200000       200000       2    0    1    0
23640      200000       200000       5    1    1    0
23780      200000       200000       3    0    1    0
23830      200000       200000       7    1    0    0
23985      200000       200000       1    0    0    0
24190      200000       200000       2    0    1    1
24385      200000       200000       2    0    0    0
24485      200000       200000       6    0    1    0

- A number of online CPU is 2
Time(ms)   Old Freq(Hz) New Freq(Hz) CPU0 CPU3
37615      200000       200000       0    0
37792      200000       200000       0    5
38015      200000       200000       21   8
38215      200000       200000       0    0
38275      200000       200000       5    0
38415      200000       200000       15   3
38615      200000       200000       0    0
38730      200000       200000       1    0
38945      200000       200000       0    0
39155      200000       200000       1    1

> Also what will happen when governor isn't ondemand/conservative?
> We will still try to create this table? What will be present inside it?
> 

I'm considering whether to check the kind of cpufreq governor for creating load_table
in cpufreq_stats or execute dbs_check_cpu() on performance/powersave governor to check
CPUx load. If you have opinion about this, I'd like to listen it.

Thanks,
Chanwoo Choi










