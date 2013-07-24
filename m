Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab3GXIqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 04:46:30 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:39602 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab3GXIqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 04:46:24 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-11-51ef945e8b13
Message-id: <51EF945E.3080802@samsung.com>
Date: Wed, 24 Jul 2013 17:46:22 +0900
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
 <51EF8590.7030405@samsung.com>
 <CAKohpom19C7JHSX6w31pSDrwcAR_PZn1HzP0Jui5iZL=bALDPQ@mail.gmail.com>
In-reply-to: <CAKohpom19C7JHSX6w31pSDrwcAR_PZn1HzP0Jui5iZL=bALDPQ@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsWyRsSkSDduyvtAg/WLdS2eNv1gtzjb9Ibd
	4v2hZ8wWl3fNYbP43HuE0eJ24wo2i/6FvUwWG796OHB43Lm2h83j9r/HzB59W1Yxejxa3MLo
	8XmTXABrFJdNSmpOZllqkb5dAlfGmQPP2ApWiFcs/vGUvYHxvWAXIyeHhICJxO6mJmYIW0zi
	wr31bF2MXBxCAksZJZ5MmsQOU/Rn+zt2iMQiRolTS5dAOa8YJZbf/MsKUsUroCVx8McZsA4W
	AVWJV+2bwWw2oPj+FzfYQGxRgTCJldOvsEDUC0r8mHwPyObgEAGqeXkzFWQms8B5Rond/8+B
	nSQs4CZx/l431EnTmCW+7O8Ba+YUCJY49v8I2AJmAR2J/a3T2CBseYnNa94ygzRICFxjl/h5
	8jEzxEUCEt8mHwLbJiEgK7HpANTPkhIHV9xgmcAoNgvJTbOQjJ2FZOwCRuZVjKKpBckFxUnp
	RSZ6xYm5xaV56XrJ+bmbGIExePrfswk7GO8dsD7EmAy0ciKzlGhyPjCG80riDY3NjCxMTUyN
	jcwtzUgTVhLnVW+xDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA6OLhcTq9fPPUsgo3jsVl
	AifOiV/3Kv8QtWb7zsebA1njLSYrV+zs/bv6n3STTWfw5V5NgzD7K0nH+v6svqgmVn7r1n2x
	7aEsE407jN96fTtVPvPxip2K9wr3nY8y/GCy0sNnwZvN1SnLOzq/8v+Ql/i6p/hQ7qVIKc3O
	gMPbF32xlDS5MjnsrxJLcUaioRZzUXEiADyEmL7XAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIKsWRmVeSWpSXmKPExsVy+t9jAd24Ke8DDXb8UbF42vSD3eJs0xt2
	i/eHnjFbXN41h83ic+8RRovbjSvYLPoX9jJZbPzq4cDhcefaHjaP2/8eM3v0bVnF6PFocQuj
	x+dNcgGsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+Abpu
	mTlAtygplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM84ceMZWsEK8YvGP
	p+wNjO8Fuxg5OSQETCT+bH/HDmGLSVy4t56ti5GLQ0hgEaPEqaVL2CGcV4wSy2/+ZQWp4hXQ
	kjj44wxYB4uAqsSr9s1gNhtQfP+LG2wgtqhAmMTK6VdYIOoFJX5Mvgdkc3CIANW8vJkKMpNZ
	4DyjxO7/55hBaoQF3CTO3+uG2jyNWeLL/h6wZk6BYIlj/4+ALWAW0JHY3zqNDcKWl9i85i3z
	BEaBWUh2zEJSNgtJ2QJG5lWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwRH+THoH46oGi0OM
	AhyMSjy8BbPeBQqxJpYVV+YeYpTgYFYS4V3c/D5QiDclsbIqtSg/vqg0J7X4EGMyMAgmMkuJ
	JucDk09eSbyhsYmZkaWRuaGFkbE5acJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTDaT7mp
	8szRXmLZAnMBoec7fn2MtPyR+WxX4r2/XVWlglNbbRrf/HwtsTl7V/yyxWp3z3o43Qyd+XpB
	ntaa0puP09Lmsd2bvZrdvjCtp/OV7kuFzMs+py3rY1y6/nZZv8qeyGtRvC9g2e0VRemeIkcX
	nWOoMo3W0ffoOWU7S3+XKMeqxR8FXvUqsRRnJBpqMRcVJwIAtEB14zQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 05:07 PM, Viresh Kumar wrote:
> I just realized I missed answering few questions:
> 
> On 24 July 2013 13:13, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> On 07/24/2013 02:05 PM, Viresh Kumar wrote:
>>> On 24 July 2013 06:55, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>>>> On 07/22/2013 07:11 PM, Viresh Kumar wrote:
>>>>> On 18 July 2013 16:47, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> 
>>>>>> +static void cpufreq_move_debugfs_dir(struct cpufreq_policy *policy,
>>>>>> +                                    unsigned int new_cpu)
>>>>>> +{
>>>>>> +       struct dentry *old_entry, *new_entry;
>>>>>> +       char new_dir_name[CPUFREQ_NAME_LEN];
>>>>>> +       unsigned int j, old_cpu = policy->cpu;
>>>>>> +
>>>>>> +       if (!policy->cpu_debugfs[new_cpu])
>>>>>> +               return;
>>>>>> +
>>>>>> +       /*
>>>>>> +        * Remove symbolic link of debugfs directory except for debugfs
>>>>>> +        * directory of old_cpu.
>>>>>> +        */
>>>>>> +       for_each_present_cpu(j) {
>>>>>> +               if (old_cpu == j)
>>>>>> +                       continue;
>>>>>> +
>>>>>> +               debugfs_remove(policy->cpu_debugfs[j]);
>>>>>
>>>>> Why you need this? We aren't removing the earlier dentry at all here.
>>>
>>> haven't answered this.
>>
>> The debugfs entry of 'old_cpu' include child debugfs file(e.g., load_table)
>> If cpu is last user of policy and core call __cpufre_remove_dev() to remove last cpu,
>> core call cpufreq_move_debugfs_dir(). I have to move the data of debugfs directory/file and
>> child data for 'old_cpu' to debugfs directory for 'new_cpu'.
>>
>> If I remove earlier dentry of 'old_cpu', I can't get the child debugfs dir/file.
>> So I didn't remove the earlier dentry of 'old_cpu'.
> 
> Okay.. The original question was: why do you need to remove & add
> entries or links for cpus other than policy->cpu? Because we are renaming
> the entry, wouldn't that work straight away?
> 

In case that all CPUs share same cpufreq policy. Each debugfs dentry of CPU[1-3]
except for CPU0 has symbolic link to CPU0's debugfs directory as following.

-sh-4.1# ls -al /sys/kernel/debug/cpufreq/
total 0
drwxr-xr-x  3 root root 0 Jan  1 09:00 .
drwx------ 28 root root 0 Jan  1 09:00 ..
drwxr-xr-x  2 root root 0 Jan  1 09:00 cpu0		(policy->cpu is 0)
lrwxrwxrwx  1 root root 0 Jan  1 09:00 cpu1 -> ./cpu0
lrwxrwxrwx  1 root root 0 Jan  1 09:00 cpu2 -> ./cpu0
lrwxrwxrwx  1 root root 0 Jan  1 09:00 cpu3 -> ./cpu0

If turn off CPU0 state, I have to move debugfs directory data from cpu0 to cpu1
and again create link to cpu1's debugfs directory for CPU[2-3] debugfs directory.
So, I removed dentry link of CPU[1-3] before creating link again. 

cpu1
cpu2 -> ./cpu1
cpu3 -> ./cpu1

But I can rewrite new link of CPU[2-3] to previous dentry link(policy->cpu_debugfs[2] or policy->cpu_debugfs[3])
for reducing unnecessary code without revmoval sequence.



