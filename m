Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab3GXJFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 05:05:38 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:52854 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3GXJFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 05:05:35 -0400
X-AuditID: cbfee691-b7fef6d000002d62-8e-51ef98dd3f91
Message-id: <51EF98DD.4010607@samsung.com>
Date: Wed, 24 Jul 2013 18:05:33 +0900
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
 <51EF945E.3080802@samsung.com>
 <CAKohpo=_3iR44XfxuRAmw-9DDk9APniWH=efd72v845wH3C-DQ@mail.gmail.com>
In-reply-to: <CAKohpo=_3iR44XfxuRAmw-9DDk9APniWH=efd72v845wH3C-DQ@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsWyRsSkWPfujPeBBje6ZC2eNv1gtzjb9Ibd
	4v2hZ8wWl3fNYbP43HuE0eJ24wo2i/6FvUwWG796OHB43Lm2h83j9r/HzB59W1Yxejxa3MLo
	8XmTXABrFJdNSmpOZllqkb5dAlfGklUPWAt+8Fdsm9HB3MC4iaeLkZNDQsBEYuah7ywQtpjE
	hXvr2boYuTiEBJYyStxd0cwKU7Tp41tWiMQiRokpKzYxgSSEBF4xSrTftwaxeQW0JE7dPMUM
	YrMIqErcO76BDcRmA4rvf3EDzBYVCJNYOf0KC0S9oMSPyfeAbA4OEaCalzdTQeYzC5xnlNj9
	/xzYHGEBN4nz97qhLvrHLDHxZg/YRZwCwRKPp84CG8osoCOxv3UalC0vsXnNW2aIq6+xSyy4
	5w9xkIDEt8mHwJZJCMhKbDoAVSIpcXDFDZYJjGKzkJw0C8nUWUimLmBkXsUomlqQXFCclF5k
	qlecmFtcmpeul5yfu4kRGH+n/z2buIPx/gHrQ4zJQCsnMkuJJucD4zevJN7Q2MzIwtTE1NjI
	3NKMNGElcV71FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYwTDx9l6P+lGOm499SO9ekz
	Rftm1rKLP4kRlcnyWnd0ujCvUYb7pXWOzzlUTCs+smYp7ciYflBUInHTHp0Cm9ruo3OKZ7De
	yjG6krJW6dWfSf1sy/MOPqzPE+MXKmt4fLnnckaAa4eCQLHLwq/hN88s4fBf8rfuzwahVfNf
	5r17MoGP2/ftzxQlluKMREMt5qLiRAAbBZVA1QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsVy+t9jAd27M94HGtw4LWLxtOkHu8XZpjfs
	Fu8PPWO2uLxrDpvF594jjBa3G1ewWfQv7GWy2PjVw4HD4861PWwet/89Zvbo27KK0ePR4hZG
	j8+b5AJYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTd
	MnOAblFSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZixZ9YC14Ad/xbYZ
	HcwNjJt4uhg5OSQETCQ2fXzLCmGLSVy4t56ti5GLQ0hgEaPElBWbmEASQgKvGCXa71uD2LwC
	WhKnbp5iBrFZBFQl7h3fwAZiswHF97+4AWaLCoRJrJx+hQWiXlDix+R7QDYHhwhQzcubqSDz
	mQXOM0rs/n8ObI6wgJvE+XvdUIv/MUtMvNkDdhGnQLDE46mzwIYyC+hI7G+dBmXLS2xe85Z5
	AqPALCQ7ZiEpm4WkbAEj8ypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Ph+Jr2DcVWDxSFG
	AQ5GJR7eglnvAoVYE8uKK3MPMUpwMCuJ8LZMex8oxJuSWFmVWpQfX1Sak1p8iDEZGAQTmaVE
	k/OBqSevJN7Q2MTMyNLI3NDCyNicNGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilGhgXBbEs
	YAvSZtRReCGruyMj86VlWAjLzbQ9D5uNizkPPt0yMWatkP2bL8tfzq6b4BAYM3/XavFzp7yc
	ltWKiwst4r7PncZ2/nvo8juTfgm0+n1IPZr89Vz7ay+Nz8JPMgpv/t1aKufl69rtNXNdfOQl
	nj4+EYc28UYxQ9ET/KLTNnnO+bzzyHQlluKMREMt5qLiRAAGjIKuMwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 05:51 PM, Viresh Kumar wrote:
> On 24 July 2013 14:16, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> In case that all CPUs share same cpufreq policy. Each debugfs dentry of CPU[1-3]
>> except for CPU0 has symbolic link to CPU0's debugfs directory as following.
>>
>> -sh-4.1# ls -al /sys/kernel/debug/cpufreq/
>> total 0
>> drwxr-xr-x  3 root root 0 Jan  1 09:00 .
>> drwx------ 28 root root 0 Jan  1 09:00 ..
>> drwxr-xr-x  2 root root 0 Jan  1 09:00 cpu0             (policy->cpu is 0)
>> lrwxrwxrwx  1 root root 0 Jan  1 09:00 cpu1 -> ./cpu0
>> lrwxrwxrwx  1 root root 0 Jan  1 09:00 cpu2 -> ./cpu0
>> lrwxrwxrwx  1 root root 0 Jan  1 09:00 cpu3 -> ./cpu0
>>
>> If turn off CPU0 state, I have to move debugfs directory data from cpu0 to cpu1
>> and again create link to cpu1's debugfs directory for CPU[2-3] debugfs directory.
>> So, I removed dentry link of CPU[1-3] before creating link again.
>>
>> cpu1
>> cpu2 -> ./cpu1
>> cpu3 -> ./cpu1
>>
>> But I can rewrite new link of CPU[2-3] to previous dentry link(policy->cpu_debugfs[2] or policy->cpu_debugfs[3])
>> for reducing unnecessary code without revmoval sequence.
> 
> Because we aren't freeing the debugfs node at all (just renaming
> it), the links might still be good after renaming.. But please check
> if it is true.
> 
> So, according to me you need to do this:
> - Remove symlink for new policy->cpu, i..e cpu1 in your example
> - rename debugfs entry to give it to cpu1 instead of cpu0.
> - Set cpu0 pointer to NULL.
> 
> Probably that's it.
> 

And, I add additional step on below:

> - Remove symlink for new policy->cpu, i..e cpu1 in your example
> - rename debugfs entry to give it to cpu1 instead of cpu0.
  - Store renamed cpu0 pointer to cpu1 pointer
  - Create new link for CPU[2-3] to CPU1's debugfs directory
	because debugfs use string path to create symbolic link.
	It isn't automatically connected with new CPU1 debugfs directory. 
> - Set cpu0 pointer to NULL.
> 

Thanks,
Chanwoo Choi



