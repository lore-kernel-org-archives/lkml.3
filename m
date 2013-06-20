Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965326Ab3FTLSf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:18:35 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:48042 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964966Ab3FTLSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:18:34 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-76-51c2e5086aef
Message-id: <51C2E509.2030800@samsung.com>
Date: Thu, 20 Jun 2013 20:18:33 +0900
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
 <51C2E0AD.8060208@samsung.com>
In-reply-to: <51C2E0AD.8060208@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsWyRsSkSJfj6aFAg8mfzCzONr1ht7i8aw6b
	xe3GFWwW/Qt7mSw2fvVwYPW4c20Pm0ffllWMHo8WtzB6fN4kF8ASxWWTkpqTWZZapG+XwJVx
	c/V19oINPBWzu6YzNjBO4upi5OCQEDCRWHEPyOQEMsUkLtxbz9bFyMUhJLCUUWL+hE+sEAkT
	iY9zXzJCJKYzSvze9ZkdwnnBKHHlbw87SBWvgJbEt2U7GEGmsgioShz9wgQSZgMK739xgw3E
	FhUIk1g5/QoLRLmgxI/J91hAykWAal7eTAUJMwu0MkpcOOgJEhYWyJCY8LYKYtNUJon5J/8z
	gtRwCmhLHHhwiBGiXkdif+s0NghbXmLzmrfMIA0SAtvYJX6df88MkmAREJD4NvkQC8TDshKb
	DjBD/CUpcXDFDZYJjGKzkFw0C8nYWUjGLmBkXsUomlqQXFCclF5kolecmFtcmpeul5yfu4kR
	GFOn/z2bsIPx3gHrQ4zJQCsnMkuJJucDYzKvJN7Q2MzIwtTE1NjI3NKMNGElcV71FutAIYH0
	xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYxtj7bLzw8+sOP606S0RYd+qO1affvK2ryVBgbXtsac
	PTC14URv703zP7buL3zdlsYuiliToFq9ofSRXMwiH9a7d/6etPiR//NIgM3Dk1uu89qGXeBg
	2HjvEqfaxwNXf908zrPSaeq2v1pzzqee5lXnX70o6tySuSJPeafNbQ+beoRPKKrx32/JBCWW
	4oxEQy3mouJEAEn1Q6S/AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xoC7H00OBBjeX6VucbXrDbnF51xw2
	i9uNK9gs+hf2Mlls/OrhwOpx59oeNo++LasYPR4tbmH0+LxJLoAlqoHRJiM1MSW1SCE1Lzk/
	JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdor5JCWWJOKVAoILG4WEnfDtOE
	0BA3XQuYxghd35AguB4jAzSQsIYx4+bq6+wFG3gqZndNZ2xgnMTVxcjJISFgIvFx7ktGCFtM
	4sK99WxdjFwcQgLTGSV+7/rMDuG8YJS48reHHaSKV0BL4tuyHUAdHBwsAqoSR78wgYTZgML7
	X9xgA7FFBcIkVk6/wgJRLijxY/I9FpByEaCalzdTQcLMAq2MEhcOeoKEhQUyJCa8rYLYNJVJ
	Yv7J/2D3cApoSxx4cIgRol5HYn/rNDYIW15i85q3zBMYBWYh2TALSdksJGULGJlXMYqmFiQX
	FCel5xrpFSfmFpfmpesl5+duYgTH7DPpHYyrGiwOMQpwMCrx8GpcPhgoxJpYVlyZe4hRgoNZ
	SYQ3dc6hQCHelMTKqtSi/Pii0pzU4kOMyUD/T2SWEk3OB6aTvJJ4Q2MTMyNLI3NDCyNjc9KE
	lcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpgXHHkypT+CXczVLfah56YOjuu/5WBT6i0RfUX
	Y22vftESHaOdpf+V0kJ7n7/k5lyk7rwyKnGt+2m7jWfLLFbsfrxh5ffbc70OMymtnLadSdyb
	yeTQ2zVLS57v+Pe7l9W+yqMqplJH+s/77+1Rrz333cvgqLSOPNipGDA3y1FqiQSfnRPvjLle
	SizFGYmGWsxFxYkAgzt0Zx0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 07:59 PM, Chanwoo Choi wrote:
> On 06/20/2013 07:55 PM, Viresh Kumar wrote:
>> On 20 June 2013 16:15, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>>> Yes, freq->old is same freq->new.
>>>
>>> The cpufreq gorvernor(dbs_check_cpu()) send CPUFREQ_LOADCHECK noti
>>> right after calculating CPUs load, regardless of changing CPU frequency.
>>> So, I use only freq->old value without using freq->new because load_table
>>> debugfs file need current cpu frequency.
>>>
>>> Now, I can't think of any proper usage for freq->new.
>>> Do you have good way for using freq->new to include more useful data in load_table?
>>
>> This information might be interesting.. At what load, we moved from
>> which freq to which one..
>>
>> Just see if you can add the notification after frequency has been
>> changed.
>>
> OK, I'll modify it and send test result. Thanks.
> 
> Best Regards,
> Chanwoo Choi
> 

But,
To show old frequency/new frequency on load_table debugfs file,
governor function(dbs_check_cpu()) pass calculated CPUs load to specific governor(e.g., ondemand)
as below function flow.

dbs_check_cpu() (in cpufreq.c)
-> od_check_cpu() (in cpufreq_ondemand.c)
-> __cpufreq_driver_target() (in cpufreq.c)
-> cpufreq_driver->target(policy)

Also, The __cpufreq_driver_target() is external function which can be called on other file
so I must consider exception case.

If send CPUFREQ_LOADCHECK noti after changed cpu frequency,
I think it is complicated and has quite a little difficulty.

What is your opinion?

Thanks,
Chanwoo Choi
