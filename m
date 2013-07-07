Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab3GGXuY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 19:50:24 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31830 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab3GGXuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 19:50:19 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-57-51d9feb49410
Message-id: <51D9FEB3.9080805@samsung.com>
Date: Mon, 08 Jul 2013 08:50:11 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Pankaj Jangra <jangra.pankaj9@gmail.com>
Cc: viresh.kumar@linaro.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com
Subject: Re: [PATCH 1/6] cpufreq: Add debugfs directory for cpufreq
References: <1373014001-17746-1-git-send-email-cw00.choi@samsung.com>
 <1373014001-17746-2-git-send-email-cw00.choi@samsung.com>
 <CADTbHxqsSpyAKFBg7t31h3SH-p_x2UO=jTpLz80GZW4+64eo5g@mail.gmail.com>
In-reply-to: <CADTbHxqsSpyAKFBg7t31h3SH-p_x2UO=jTpLz80GZW4+64eo5g@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsWyRsSkWHfLv5uBBjd/c1s8bfrBbjG3Zxqj
	xdmmN+wWl3fNYbP43HuE0eJ24wo2i/6FvUwWG796OHB47Jx1l93jzrU9bB59W1Yxejxa3MLo
	8XmTXABrFJdNSmpOZllqkb5dAlfG0c2HmQpOWVfcOrGCsYFxjWYXIyeHhICJxPOTG9ghbDGJ
	C/fWs3UxcnEICSxllPjZOJWpi5EDrGj6D2+I+HRGifPL/7NAOC8YJRY9+gDWzSugJTFv2n8m
	EJtFQFXi0aoZYHE2oPj+FzfYQGxRgTCJldOvsEDUC0r8mHwPzBYR0JHonXaKEWQos8AmRon7
	S16ANQsLOEtcOzSLHWLbCUaJ03u/gnVwCgRLrH5zB2wqM1D3/tZpULa8xOY1b5lBGiQErrFL
	TLo/hxHiJAGJb5MPsUD8Iyux6QAzxM+SEgdX3GCZwCg2C8lRs5CMnYVk7AJG5lWMoqkFyQXF
	SelFhnrFibnFpXnpesn5uZsYgTF4+t+z3h2Mtw9YH2JMBlo5kVlKNDkfGMN5JfGGxmZGFqYm
	psZG5pZmpAkrifOqtVgHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamDcarnlt/6CiIhLcQ96
	jnJsN9L0XrJe54LUSx6ty/aif17tEy0Jyu40FNuU5fF4z8+wzRuuZM75bCH7SHx7UGWmvt2i
	k7OKF9jOyWQ1PCYXqfDQ8MU55suzsntP/vKoSpLP7up4yn48uO6PyK5mdefw0NVNEcb+x1Jt
	4+OT7q0u4CxN+/ll0xolluKMREMt5qLiRAA5DUtV1wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIKsWRmVeSWpSXmKPExsVy+t9jQd0t/24GGqw6ymTxtOkHu8XcnmmM
	Fmeb3rBbXN41h83ic+8RRovbjSvYLPoX9jJZbPzq4cDhsXPWXXaPO9f2sHn0bVnF6PFocQuj
	x+dNcgGsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+Abpu
	mTlAtygplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM45uPsxUcMq64taJ
	FYwNjGs0uxg5OCQETCSm//DuYuQEMsUkLtxbz9bFyMUhJDCdUeL88v8sEM4LRolFjz6wg1Tx
	CmhJzJv2nwnEZhFQlXi0agZYnA0ovv/FDTYQW1QgTGLl9CssEPWCEj8m3wOzRQR0JHqnnWIE
	GcossIlR4v6SF2DNwgLOEtcOzWKH2HaCUeL03q9gHZwCwRKr39wBm8oM1L2/dRqULS+xec1b
	5gmMArOQLJmFpGwWkrIFjMyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYIj/JnUDsaVDRaH
	GAU4GJV4eCVO3wwUYk0sK67MPcQowcGsJMKrfAEoxJuSWFmVWpQfX1Sak1p8iDEZGAYTmaVE
	k/OBySevJN7Q2MTMyNLI3NDCyNicNGElcd4DrdaBQgLpiSWp2ampBalFMFuYODilGhjbdLsX
	LGosO1f1SeyRz7MZr4OWmvnJJM7cM+VL5n0WNVm909djpivce7v5aOudNt4zutGaz80fz+W7
	V8v0YLm+an2D5qLQPdVvbsw7KPdl//Ktyy3XbftVem3fG0fmGWJfjhgtlLYw2TTrdfkic+sn
	Z77wLNokNfvY53VOH/cvPVU4uS7p6fqHXEosxRmJhlrMRcWJACZ9a7w0AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

On 07/08/2013 03:54 AM, Pankaj Jangra wrote:
> Hi Chanwoo,
> 
> On Fri, Jul 5, 2013 at 1:46 AM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> This patch create debugfs root directory and child directory according to
>> the number of CPUs for CPUFreq as below debugfs directory path:
>> - /sys/kernel/debug/cpufreq/cpuX
>>
>> If many CPUs share only one cpufreq policy, other CPU(except for CPU0) create
>> a link for debugfs directory of CPU0.
>> - /sys/kernel/debug/cpufreq/cpu0
>> - /sys/kernel/debug/cpufreq/cpu[1-(N-1)] -> /sys/kernel/debug/cpufreq/cpu0
>>
>> And then cpufreq may need to create debugfs specific file below of debugfs
>> directory of cpufreq. (e.g., /sys/kernel/debug/cpufreq/cpu0/load_table)
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
>> ---
>>  drivers/cpufreq/cpufreq.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/cpufreq.h   |  1 +
>>  2 files changed, 58 insertions(+)
>>
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> index 2d53f47..bc01c8e 100644
>> --- a/drivers/cpufreq/cpufreq.c
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -23,6 +23,7 @@
>>  #include <linux/notifier.h>
>>  #include <linux/cpufreq.h>
>>  #include <linux/delay.h>
>> +#include <linux/debugfs.h>
>>  #include <linux/interrupt.h>
>>  #include <linux/spinlock.h>
>>  #include <linux/device.h>
>> @@ -47,6 +48,10 @@ static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
>>  #endif
>>  static DEFINE_RWLOCK(cpufreq_driver_lock);
>>
>> +/* The cpufreq_debugfs is used to create debugfs root directory for CPUFreq. */
>> +#define MAX_DEBUGFS_NAME_LEN   CPUFREQ_NAME_LEN
>> +static struct dentry *cpufreq_debugfs;
>> +
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
>> +               i = cpu;
>> +
>> +               policy->cpu_debugfs = devm_kzalloc(dev, size, GFP_KERNEL);
>> +               policy->cpu_debugfs[i] = debugfs_create_dir(name,
>> +                                                           cpufreq_debugfs);
>> +               if (!policy->cpu_debugfs[i])
>> +                       pr_debug("creating debugfs directory failed\n");
>> +       }
>> +
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
>> +
>>         return 0;
>>  }
>>  #endif
>> @@ -1046,6 +1095,7 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
>>
>>         if (cpu != data->cpu) {
>>                 sysfs_remove_link(&dev->kobj, "cpufreq");
>> +               debugfs_remove(data->cpu_debugfs[cpu]);
> 
> I think you should add the call to remove the "cpufreq" also ???

No, we have to remove 'cpufreq' debugfs directory when the last online CPU is removed.
If condition("cpu != data->cpu") is true, it means that various CPUs share only one cpufreq policy.
When CPU[1-3] is removed, kernel execute first if statement to remove the link of CPU[1-3] debugfs directory.

>                "debugfs_remove(cpufreq_debugfs);"
>>         } else if (cpus > 1) {
>>                 /* first sibling now owns the new sysfs dir */
>>                 cpu_dev = get_cpu_device(cpumask_first(data->cpus));
>> @@ -1068,6 +1118,9 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
>>                         return -EINVAL;
>>                 }
>>
>> +               debugfs_remove_recursive(data->cpu_debugfs[cpu]);
>> +               debugfs_remove(cpufreq_debugfs);
>> +
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
>> +
>>         return 0;
>>  }
>>  core_initcall(cpufreq_core_init);
>> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
>> index 037d36a..825f379 100644
>> --- a/include/linux/cpufreq.h
>> +++ b/include/linux/cpufreq.h
>> @@ -115,6 +115,7 @@ struct cpufreq_policy {
>>
>>         struct kobject          kobj;
>>         struct completion       kobj_unregister;
>> +       struct dentry           **cpu_debugfs;
>>  };
>>
>>  #define CPUFREQ_ADJUST                 (0)
>> --
>> 1.8.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Regards,
> Pankaj Jangra
> --
> To unsubscribe from this list: send the line "unsubscribe cpufreq" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Thanks,
Chanwoo Choi

