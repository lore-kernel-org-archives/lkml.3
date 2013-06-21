Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750925Ab3FUEBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 00:01:38 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:57345 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab3FUEBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 00:01:36 -0400
X-AuditID: cbfee691-b7fef6d000002d62-1d-51c3d01ebc10
Message-id: <51C3D01F.7040907@samsung.com>
Date: Fri, 21 Jun 2013 13:01:35 +0900
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
 <51C2DD3D.5040601@samsung.com>
 <CAKohpomx54Y3WVToYP0nOw-hsxKzGjp2nyfzWf5bo1s530Yg1w@mail.gmail.com>
 <51C2E0AD.8060208@samsung.com> <51C2E509.2030800@samsung.com>
 <CAKohpo=0m8+WegUmMR2BOKeY2mJZw=X5-nEAp26M5L3PH9Bz2A@mail.gmail.com>
In-reply-to: <CAKohpo=0m8+WegUmMR2BOKeY2mJZw=X5-nEAp26M5L3PH9Bz2A@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsWyRsSkUFfuwuFAg1fntSzONr1ht7i8aw6b
	xe3GFWwW/Qt7mSw2fvVwYPW4c20Pm0ffllWMHo8WtzB6fN4kF8ASxWWTkpqTWZZapG+XwJVx
	vX0tc8FrropFPz8zNzC+5uhi5OSQEDCRaJk1jx3CFpO4cG89WxcjF4eQwFJGiY5Jm9hgiib0
	9kAlpjNKvF6+nxHCecEo8aBzIytIFa+AlsSl/7uYQWwWAVWJrlmHwcayAcX3v7gBNklUIExi
	5fQrLBD1ghI/Jt8Dsjk4RIBqXt5MBQkzC7QySlw46AkSFhbIkJjwtgpi1W8midubbjGB1HAK
	BEtcOz+bCaJeR2J/6zQ2CFteYvOat8wgDRIC29glFn77BnWPgMS3yYfAdkkIyEpsOsAM8Zik
	xMEVN1gmMIrNQnLRLCRjZyEZu4CReRWjaGpBckFxUnqRqV5xYm5xaV66XnJ+7iZGYFyd/vds
	4g7G+wesDzEmA62cyCwlmpwPjMu8knhDYzMjC1MTU2Mjc0sz0oSVxHnVW6wDhQTSE0tSs1NT
	C1KL4otKc1KLDzEycXBKNTDy50YbfZ3/IyJly/zde2sW/JNeEX9c/0jBhfqsSefU+Bs32CUV
	d/J4pZiz77z2o2ZnR8LEW+fnaFsE1T96vtW+z2G/1fUSz4RplmWMJgrNa7e18x5fILkze/mU
	vSFvV8mdthVJr74v93j+90kpLgy/GY8v2F91RMTl/At9hSnK36xZg+aIRuYrsRRnJBpqMRcV
	JwIAmrfzAMECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xoK7chcOBBp92KFucbXrDbnF51xw2
	i9uNK9gs+hf2Mlls/OrhwOpx59oeNo++LasYPR4tbmH0+LxJLoAlqoHRJiM1MSW1SCE1Lzk/
	JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdor5JCWWJOKVAoILG4WEnfDtOE
	0BA3XQuYxghd35AguB4jAzSQsIYx43r7WuaC11wVi35+Zm5gfM3RxcjJISFgIjGht4cNwhaT
	uHBvPZDNxSEkMJ1R4vXy/YwQzgtGiQedG1lBqngFtCQu/d/FDGKzCKhKdM06zA5iswHF97+4
	ATZJVCBMYuX0KywQ9YISPybfA7I5OESAal7eTAUJMwu0MkpcOOgJEhYWyJCY8LYKYtVvJonb
	m24xgdRwCgRLXDs/mwmiXkdif+s0NghbXmLzmrfMExgFZiHZMAtJ2SwkZQsYmVcxiqYWJBcU
	J6XnGukVJ+YWl+al6yXn525iBEftM+kdjKsaLA4xCnAwKvHwBigdDhRiTSwrrsw9xCjBwawk
	wis2ESjEm5JYWZValB9fVJqTWnyIMRkYABOZpUST84EJJa8k3tDYxMzI0sjc0MLI2Jw0YSVx
	3oOt1oFCAumJJanZqakFqUUwW5g4OKUaGFkmdMS23FhsdSX/Z4nkt1WfdKxbFMQi3jMVlqzd
	G3LnbPyZM+0SNpe//zWKnBK8/lvT6gvT/K3PHv9zqLxf/snzpa/NOPYXeKe+5Qj9OSG7dOKZ
	Kxnr9vY9m7EqtO6Xz1H1ENG/iiZfTEwlH3Y8aNtRHv6XQ82iwp1dtfOXy/GVN1b8mnDLJFuJ
	pTgj0VCLuag4EQDqjhYmHgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2013 12:42 AM, Viresh Kumar wrote:
> On 20 June 2013 16:48, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> But,
>> To show old frequency/new frequency on load_table debugfs file,
>> governor function(dbs_check_cpu()) pass calculated CPUs load to specific governor(e.g., ondemand)
>> as below function flow.
>>
>> dbs_check_cpu() (in cpufreq.c)
>> -> od_check_cpu() (in cpufreq_ondemand.c)
>> -> __cpufreq_driver_target() (in cpufreq.c)
>> -> cpufreq_driver->target(policy)
>>
>> Also, The __cpufreq_driver_target() is external function which can be called on other file
>> so I must consider exception case.
>>
>> If send CPUFREQ_LOADCHECK noti after changed cpu frequency,
>> I think it is complicated and has quite a little difficulty.
>>
>> What is your opinion?
> 
> What you can do is:
> - create another routine: cpufreq_governor_driver_target()
> - replace all __cpufreq_driver_target() from ondemand/conservative governors
> with this one
> - In cpufreq_governor_driver_target() call __cpufreq_driver_target() and
> take a note of new freq.
> 
> Maybe you don't need to check the actual freq that is set (even
> that would be simple to implement), but what is requested.
> 

OK, I understand and will try to implement it.
Thanks.

@Rafael?
If possible, I want to know the your opinion about this.

Best Regards,
Chanwoo Choi



