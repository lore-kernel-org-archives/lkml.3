Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab3AORwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 12:52:44 -0500
Received: from mx2.parallels.com ([64.131.90.16]:58483 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755556Ab3AORwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 12:52:42 -0500
Message-ID: <50F59741.7010002@parallels.com>
Date: Tue, 15 Jan 2013 09:52:01 -0800
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sha Zhengju <handai.szj@gmail.com>
CC: <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Michal Hocko <mhocko@suse.cz>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Dave Jones <davej@redhat.com>, Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH v5 03/11] cgroup, sched: let cpu serve the same files
 as cpuacct
References: <1357731938-8417-1-git-send-email-glommer@parallels.com> <1357731938-8417-4-git-send-email-glommer@parallels.com> <CAFj3OHW5J8ypLZdW16AfiYR5y2S54mQxm5qka4m_3qsoGdD11A@mail.gmail.com> <50F41C50.6090000@parallels.com> <CAFj3OHWB8GF9UYcLdObptrY+BfB=EEwbBtsf17M1=6qfZt+k6g@mail.gmail.com>
In-Reply-To: <CAFj3OHWB8GF9UYcLdObptrY+BfB=EEwbBtsf17M1=6qfZt+k6g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [216.239.55.193]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2013 02:19 AM, Sha Zhengju wrote:
> On Mon, Jan 14, 2013 at 10:55 PM, Glauber Costa <glommer@parallels.com> wrote:
>> On 01/14/2013 12:34 AM, Sha Zhengju wrote:
>>>> +               struct kernel_cpustat *kcpustat = this_cpu_ptr(ca->cpustat);
>>>>> +
>>>>>                 kcpustat = this_cpu_ptr(ca->cpustat);
>>> Is this reassignment unnecessary?
>>>
>>>
>> No.
>>
> 
> No?  No!
> 
I misread your question as "is this reassignment necessary".
For which the answer is no: there is no reason to do it, it is just a
bad chunk.

