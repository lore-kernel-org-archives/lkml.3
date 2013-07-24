Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab3GXHnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 03:43:18 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33693 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab3GXHnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 03:43:15 -0400
X-AuditID: cbfee68e-b7f276d000002279-a3-51ef85919f3b
Message-id: <51EF8590.7030405@samsung.com>
Date: Wed, 24 Jul 2013 16:43:12 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH 1/3 v6] cpufreq: Add debugfs directory for cpufreq
References: <1374146275-5758-1-git-send-email-cw00.choi@samsung.com>
 <1374146275-5758-2-git-send-email-cw00.choi@samsung.com>
 <CAKohpo=oTsEjzi_51UaZ8ww8UEfZ6hwKAnu9rFgGBkt=TfHi8A@mail.gmail.com>
 <51EF2D06.7000704@samsung.com>
 <CAKohpok7B6DaqFPWZcODEgK5GRSoAQYZ27-h2=AQ1HBBP4gH8Q@mail.gmail.com>
In-reply-to: <CAKohpok7B6DaqFPWZcODEgK5GRSoAQYZ27-h2=AQ1HBBP4gH8Q@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsWyRsSkUHdi6/tAg2knRC2eNv1gtzjb9Ibd
	4v2hZ8wWl3fNYbP43HuE0eJ24wo2i/6FvUwWG796OHB43Lm2h83j9r/HzB59W1Yxejxa3MLo
	8XmTXABrFJdNSmpOZllqkb5dAlfGlKdsBet1Kr5sb2BuYHyu2MXIySEhYCJx/80SdghbTOLC
	vfVsXYxcHEICSxklDq7dyghTdPPcBqjEdEaJbQ0fmSCcV4wSG7d/BGvnFdCSaJzewApiswio
	SvRuOwIWZwOK739xgw3EFhUIk1g5/QoLRL2gxI/J94BsDg4RoJqXN1NBZjILnGeU2P3/HDNI
	jbCAm8T5e91Qm9cxSVy/cgesmVMgWOLQqvVgC5gFdCT2t05jg7DlJTavecsM0iAhcIld4lvb
	UjaIiwQkvk0+BLZNQkBWYtMBZojXJCUOrrjBMoFRbBaSm2YhGTsLydgFjMyrGEVTC5ILipPS
	i4z0ihNzi0vz0vWS83M3MQIj8PS/Z307GG8esD7EmAy0ciKzlGhyPjCC80riDY3NjCxMTUyN
	jcwtzUgTVhLnVWuxDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA2PJsuebeA+8+en1w//pS
	aFpe0tmzbmeEjvdceav8b0quYIrZ5v1/HZb63YjL2/Dhj4HatY3RpS/+rrlY/tCgeXPyH4lE
	RbviRr/GzKb4fTe5ZlamOm9RaV++10Zqrcc+w/gHe0I1BX9JLjvYrHh59hsuYXfGl4eLHBxm
	512cliZaXPj6+d+OSiWW4oxEQy3mouJEAEnGneHWAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsVy+t9jQd2Jre8DDebv5bF42vSD3eJs0xt2
	i/eHnjFbXN41h83ic+8RRovbjSvYLPoX9jJZbPzq4cDhcefaHjaP2/8eM3v0bVnF6PFocQuj
	x+dNcgGsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+Abpu
	mTlAtygplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM6Y8ZStYr1PxZXsD
	cwPjc8UuRk4OCQETiZvnNrBB2GISF+6tB7K5OIQEpjNKbGv4yAThvGKU2Lj9IztIFa+AlkTj
	9AZWEJtFQFWid9sRsDgbUHz/ixtgk0QFwiRWTr/CAlEvKPFj8j0gm4NDBKjm5c1UkJnMAucZ
	JXb/P8cMUiMs4CZx/l431OZ1TBLXr9wBa+YUCJY4tGo92AJmAR2J/a3T2CBseYnNa94yT2AU
	mIVkxywkZbOQlC1gZF7FKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERzfz6R3MK5qsDjEKMDB
	qMTDWzDrXaAQa2JZcWXuIUYJDmYlEd7Fze8DhXhTEiurUovy44tKc1KLDzEmA4NgIrOUaHI+
	MPXklcQbGpuYGVkamRtaGBmbkyasJM57sNU6UEggPbEkNTs1tSC1CGYLEwenVAPj5mfFFwPe
	T3uyN/zsZ8cTqsun5b7q+rZWYNKpqsVuMx/wP5z927POy2tSgmD8onULmVYftbVXXb9Y0yik
	4uM1z3sBbKtq8vtd5h3/3bDtwTuD49Hbuecps1z7IjHtjo9/wp4/28v0S++I1DMWyd7Y233K
	x+jkZ1ZR+5XGuyc2zv0Xq2Tc/q5uthJLcUaioRZzUXEiANVB+gMzAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 02:05 PM, Viresh Kumar wrote:
> On 24 July 2013 06:55, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> On 07/22/2013 07:11 PM, Viresh Kumar wrote:
>>> On 18 July 2013 16:47, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> 
>>>> +static void cpufreq_remove_debugfs_dir(struct cpufreq_policy *policy,
>>>> +                                      unsigned int cpu)
>>>> +{
>>>> +       unsigned int idx = cpumask_weight(policy->cpus) > 1 ? cpu : 0;
>>>> +
>>>> +       if (!policy->cpu_debugfs[idx])
>>>> +               return;
>>>> +
>>>> +       debugfs_remove_recursive(policy->cpu_debugfs[idx]);
>>>
>>> Whey do we need recursive here? And what exactly does recursive will
>>> do?
>>>
>>
>> If cpu is last user of policy, __cpufreq_remove_dev() have to remove debugfs directory
>> and child file/directory of root debugfs directory. So, I used debugfs_remove_recursive() function.
> 
> You are calling this routine even when we aren't at the last cpu of a policy.
> And so, eventually you are calling this routine for a link you have created.

I'll call proper debugfs_remove*() function according to type of debugfs pointer.
- if cpu is last user of policy, call debugfs_remove_recursive()
- else, call debugfs_remove().

> 
> Have you actually tested your code? What kind of platform? What is cpu
> topology ?? And what exactly you tested..

I tested quad-core EXYNOS4412 SoC based on Cortex-A9 with Tizen platform.
It is opereated on this environment but as you commnet, this test and environment
isn't enough to verify this patchset.
- Testcase1 : Change cpufreq governor on runtime
- Testcase2 : Turn on/off CPU state on runtme

> 
> We are already on v6 and this patch still looks like the v1.. It still has lots
> of basic mistakes, which I don't expect so later in the series..
> 
> Its very difficult for me to review the same patchset again and again.. So,
> normally people might not review it well after v3-v4 and just trust the sender..
> But I am nowhere close to getting that.. And so discouraged to review it..
> 

I'm so sorry about this and thanks for previous your review sincerely.

> Please review/test it well on multiple kind of systems if possible. Test on
> your intel laptop and see if it has multiple policy structures with
> multiple cpus
> in it.. cpuX/cpufreq/related_cpus gives you all cpus that share policy
> structure.

As you comment, I'll modify/test this patchset on various system with enough testcase
and resend this patchset after a thorough review.


> 
>>>> +}
>>>> +
>>>
>>> same problem here too.
>>>> +static void cpufreq_move_debugfs_dir(struct cpufreq_policy *policy,
>>>> +                                    unsigned int new_cpu)
>>>> +{
>>>> +       struct dentry *old_entry, *new_entry;
>>>> +       char new_dir_name[CPUFREQ_NAME_LEN];
>>>> +       unsigned int j, old_cpu = policy->cpu;
>>>> +
>>>> +       if (!policy->cpu_debugfs[new_cpu])
>>>> +               return;
>>>> +
>>>> +       /*
>>>> +        * Remove symbolic link of debugfs directory except for debugfs
>>>> +        * directory of old_cpu.
>>>> +        */
>>>> +       for_each_present_cpu(j) {
>>>> +               if (old_cpu == j)
>>>> +                       continue;
>>>> +
>>>> +               debugfs_remove(policy->cpu_debugfs[j]);
>>>
>>> Why you need this? We aren't removing the earlier dentry at all here.
> 
> haven't answered this.

The debugfs entry of 'old_cpu' include child debugfs file(e.g., load_table)
If cpu is last user of policy and core call __cpufre_remove_dev() to remove last cpu,
core call cpufreq_move_debugfs_dir(). I have to move the data of debugfs directory/file and
child data for 'old_cpu' to debugfs directory for 'new_cpu'.

If I remove earlier dentry of 'old_cpu', I can't get the child debugfs dir/file.
So I didn't remove the earlier dentry of 'old_cpu'.

> 
>>>> +       if (!new_entry) {
>>>> +               pr_err("changing debugfs directory name failed\n");
>>>> +               goto err_rename;
>>>> +       }
>>>> +
>>>> +       policy->cpu_debugfs[new_cpu] = new_entry;
>>>> +       policy->cpu_debugfs[old_cpu] = NULL;
>>>> +
>>>> +       /* Create again symbolic link of debugfs directory */
>>>> +       for_each_present_cpu(j) {
>>>
>>> present_cpu?? We discussed this before.. You will break multi cluster
>>> systems.
>>
>> My mistake. I'll use for_each_cpu() macro instead of for_each_present_cpu().
> 
> Go through earlier comments about this.. you are still wrong.. You need to
> run over cpus that are in this policy.. i.e. policy->cpus.
> 

OK.

>>>> +               if (new_cpu == j)
>>>> +                       continue;
>>>> +
> 
>>>> @@ -1894,6 +2065,8 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
>>>>         cpufreq_driver = driver_data;
>>>>         write_unlock_irqrestore(&cpufreq_driver_lock, flags);
>>>>
>>>> +       cpufreq_create_debugfs();
>>>
>>> Why you moved this to register_driver? It was fine at cpufreq_core_init()
>>
>> If we moved this to cpufreq_core_int(), I have to create cpufreq_core_exit().
>> Do you agree about creating cpufreq_core_exit()(?
> 
> No you don't need that routine. Or in other words there isn't any exit
> for cpufreq core and so this directory must not be removed.
> 

I understood on your previous comment as You said that I had to remove 'cpufreq' debugfs directory
when cpufreq isn't used.

If the core execute cpufreq_create_debugfs() in cpufreq_core_init(),
don't I need to remove 'cpufreq' debugfs directory without cpufreq_core_exit()?

Thanks,
Chanwoo Choi
