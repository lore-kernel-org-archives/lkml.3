Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab3F0KcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 06:32:16 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:17619 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab3F0KcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 06:32:14 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-e2-51cc14a5d0af
Message-id: <51CC14A6.6070800@samsung.com>
Date: Thu, 27 Jun 2013 19:32:06 +0900
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
 <51CC1099.5060201@samsung.com>
 <CAKohpo=oZS8U1ZZ4Kbiz2yf_LLEMTr5HsrWFt_LiBkmRqKfdvQ@mail.gmail.com>
In-reply-to: <CAKohpo=oZS8U1ZZ4Kbiz2yf_LLEMTr5HsrWFt_LiBkmRqKfdvQ@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsWyRsSkWHepyJlAg+tHNS2eNv1gtzjb9Ibd
	4vKuOWwWn3uPMFrcblzBZtG/sJfJYuNXDwd2jzvX9rB59G1ZxejxaHELo8fnTXIBLFFcNimp
	OZllqUX6dglcGY/XRhdsEKy49/8pUwPjZN4uRk4OCQETiUnP9zNB2GISF+6tZ+ti5OIQEljK
	KLHw3yMWmKKtEy8wQSSmM0r8vT2BHcJ5wShx/+8qsHZeAS2Jbc1/2UBsFgFVidU999lBbDag
	+P4XN8DiogJhEiunX2GBqBeU+DH5HpDNwSECVPPyZirITGaQBdN/7GIGqREWyJD4f+UF1ObP
	jBLnH1wGW8YpECzx4ut0VhCbWUBHYn/rNDYIW15i85q3zBBnH2OXWHRCFOIgAYlvkw+BLZMQ
	kJXYdACqRFLi4IobLBMYxWYhOWkWkqmzkExdwMi8ilE0tSC5oDgpvchQrzgxt7g0L10vOT93
	EyMw1k7/e9a7g/H2AetDjMlAKycyS4km5wNjNa8k3tDYzMjC1MTU2Mjc0ow0YSVxXrUW60Ah
	gfTEktTs1NSC1KL4otKc1OJDjEwcnFINjNO4ue6GdQstkL3Zw73XjDlpi8zbaXYJ6R4qbLP9
	rwevqE7xq3TpPOOZMF1iWf+32ksfAuxVcsXf/1v8qLRcagHbRePtbWv1mr5bN11rM49f/dFe
	Punb3ZyEuTGPjN3aZrEHFOy0+5Zcms819aqE1rMlP8yi9AJr7RuWz/FtMrx7WvHq18aDSizF
	GYmGWsxFxYkAdvY1X8sCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jQd2lImcCDTY3K1k8bfrBbnG26Q27
	xeVdc9gsPvceYbS43biCzaJ/YS+TxcavHg7sHneu7WHz6NuyitHj0eIWRo/Pm+QCWKIaGG0y
	UhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgC5QUihLzCkF
	CgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGY8XhtdsEGw4t7/p0wNjJN5uxg5OSQE
	TCS2TrzABGGLSVy4t56ti5GLQ0hgOqPE39sT2CGcF4wS9/+uAqviFdCS2Nb8lw3EZhFQlVjd
	c58dxGYDiu9/cQMsLioQJrFy+hUWiHpBiR+T7wHZHBwiQDUvb6aCzGQGWTD9xy5mkBphgQyJ
	/1deMEEs+8wocf7BZbBlnALBEi++TmcFsZkFdCT2t05jg7DlJTavecs8gVFgFpIds5CUzUJS
	toCReRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcCw/k97BuKrB4hCjAAejEg/vB8bTgUKs
	iWXFlbmHGCU4mJVEeGcKnwkU4k1JrKxKLcqPLyrNSS0+xJgMDIKJzFKiyfnANJNXEm9obGJm
	ZGlkbmhhZGxOmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYyL/jxc/qDK7EVW/OOW6ryY
	c9uDLXX3LiiepMw+2WDB4RKZV0lJnE9O/D64NqHbJWCSzb4bV4I1zjYvCne3P2R6I3q+3wNN
	gzfWYUwNhV/DGB9MWZG/t8n1qYn9WbuYyR78LnJ6fJ517aeqp+zS3LuMI219SGDrr9jlW1K2
	7fxoEqh7xGvRGnMlluKMREMt5qLiRADkImCtKQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2013 07:23 PM, Viresh Kumar wrote:
> On 27 June 2013 15:44, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> On 06/26/2013 05:04 PM, Viresh Kumar wrote:
>>> On 24 June 2013 14:32, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> 
>>> Maybe 10 to 1000.. Lets give others a chance to see long logs :)
>>>
>>
>> OK, I'll extend the maximum value from 100 to 1000.
> 
> 10-1000 please.

OK.

>>>> +       freq.old = freq.new = policy->cur;
>>>
>>> No need to set freq.new here.
>>
>> If cpufreq governor don't change cpu frequency on specific situation,
>> cpufreq SoC driver won't send CPUFREQ_POSTCHANGE. In case of this situation,
>> I store current cpu frequency to freq.new field.
> 
> You are doing this at the time of LOADCHECK notification :)
> 
>                stat->load_table[last_idx].new = freq->old;
> 

OK, I'll fix it.

>>>> +static ssize_t load_table_read(struct file *file, char __user *user_buf,
>>>> +                                       size_t count, loff_t *ppos)
>>>> +{
>>>> +       struct cpufreq_policy *policy = file->private_data;
>>>> +       struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, policy->cpu);
>>>> +       struct cpufreq_freqs *load_table = stat->load_table;
>>>> +       ssize_t len = 0;
>>>> +       char *buf;
>>>> +       int i, cpu, ret;
>>>> +
>>>> +       buf = kzalloc(MAX_LINE_SIZE * stat->load_max_index, GFP_KERNEL);
>>>> +       if (!buf)
>>>> +               return 0;
>>>
>>> Above use of stat->load_max_index must be inside locks I guess. Otherwise
>>> you may allocate memory for 10 lines and by the time lock is taken, we
>>> already have 12 entries. And so, below loop will go beyond array limits.
>>>
>>
>> I store CONFIG_NR_CPU_LOAD_STORAGE to stat->load_max_index in cpufreq_stats_create_debugfs()
>> So, stat->load_max_index value isn't always 10.
>>
>> If I misunderstood for your comment, I'd like you to explain more detailed about this comment.
> 
> No you didn't but looking second time at the code, i couldn't find a
> problem with it.
> 
> You allocate memory for max entries and so shouldn't be a problem.
> 

OK,

I'll send v4 patch. Thanks.

Best Regards,
Chanwoo Choi


