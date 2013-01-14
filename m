Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302Ab3ANOz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 09:55:28 -0500
Received: from mx2.parallels.com ([64.131.90.16]:53549 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795Ab3ANOz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 09:55:26 -0500
Message-ID: <50F41C50.6090000@parallels.com>
Date: Mon, 14 Jan 2013 06:55:12 -0800
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
References: <1357731938-8417-1-git-send-email-glommer@parallels.com> <1357731938-8417-4-git-send-email-glommer@parallels.com> <CAFj3OHW5J8ypLZdW16AfiYR5y2S54mQxm5qka4m_3qsoGdD11A@mail.gmail.com>
In-Reply-To: <CAFj3OHW5J8ypLZdW16AfiYR5y2S54mQxm5qka4m_3qsoGdD11A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [205.164.11.246]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2013 12:34 AM, Sha Zhengju wrote:
>> +               struct kernel_cpustat *kcpustat = this_cpu_ptr(ca->cpustat);
>> > +
>> >                 kcpustat = this_cpu_ptr(ca->cpustat);
> Is this reassignment unnecessary?
> 
> 
No.

