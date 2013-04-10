Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965111Ab3DJJjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 05:39:09 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:42346 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab3DJJjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 05:39:04 -0400
X-AuditID: cbfee61a-b7fa86d0000045ae-9e-516533372e88
Date: Wed, 10 Apr 2013 11:38:54 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        "sw0312.kim@samsung.com" <sw0312.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC PATCH 0/2] cpufreq: Introduce LAB cpufreq governor.
Message-id: <20130410113854.31734308@amdc308.digital.local>
In-reply-to: <CAKfTPtDOG94CU=y9oohuJA-bqGpNFehTnebcvTcnQf5iYjwJTA@mail.gmail.com>
References: <1364804657-16590-1-git-send-email-jonghwa3.lee@samsung.com>
 <CAOh2x=nPJa0GReiN=OHLG=m4Gq51F=4VppdaQL20xi-aUa8x2Q@mail.gmail.com>
 <20130409123719.7399d5ad@amdc308.digital.local>
 <CAKohpomL-mdx6DdFiGwJzDSeWr6Gw-_F4T-D-Jz9TNH5MSgjbw@mail.gmail.com>
 <20130409184440.4cd87c1b@amdc308.digital.local>
 <CAKfTPtD6MK9ogq7mOijSxLSsH0n65Xra48XfRSB3DFs35GT=2g@mail.gmail.com>
 <20130410104452.661902af@amdc308.digital.local>
 <CAKfTPtDOG94CU=y9oohuJA-bqGpNFehTnebcvTcnQf5iYjwJTA@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e+xgK65cWqgwZQlvBZPm36wW1z/8pzV
	Yt5nWYvOs0+YLc42vWG3uLxrDpvF594jjBZvfr9gt1h75C67xe3GFWwW/Qt7mSxmTH7JZtFx
	5BuzxcavHg58HmvmrWH0uHNtD5tH35ZVjB6PFrcwenzeJBfAGsVlk5Kak1mWWqRvl8CVMWk1
	f0GbdcXlS6dZGxgn6XYxcnJICJhIHN67kRHCFpO4cG89WxcjF4eQwCJGiYmvTjJBOO1MEieP
	zGECqWIRUJV4unYxC4jNJqAn8fnuU7C4iICBxM+Pn5hBGpgF7rFInJ/2CWyssICrRN/+K0A2
	BwevgLXEnR0mIGFOgWCJS/P+Qi34xSzR1/cHbCi/gKRE+78fzBAn2Umc+7SBHcTmFRCU+DH5
	HlgNs4CWxOZtTawQtrzE5jVvmScwCs5CUjYLSdksJGULGJlXMYqmFiQXFCel5xrqFSfmFpfm
	pesl5+duYgRH0DOpHYwrGywOMQpwMCrx8HropwQKsSaWFVfmHmKU4GBWEuG10EoNFOJNSays
	Si3Kjy8qzUktPsQozcGiJM57oNU6UEggPbEkNTs1tSC1CCbLxMEp1cBovqFQIzqjdbbAVZZl
	rCoNy8p/+6pHS9cu3J2QfUgyJsjce2Vq/5qnsZn9Gz8eqGB+KPdzv2xIz7vgZHWdQ4J//OLj
	TVh+d59wmlLm+zDy0OsXFw+9q1FOfeDykPe7pFpU0H+WfqH6Ym1+6333DT3kxBzZJe/f+6mf
	Xr/657/bmpKvHu9cN1+JpTgj0VCLuag4EQCCB/eHnAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,

> On 10 April 2013 10:44, Lukasz Majewski <l.majewski@samsung.com>
> wrote:
> > Hi Vincent,
> >
> >>
> >>
> >> On Tuesday, 9 April 2013, Lukasz Majewski <l.majewski@samsung.com>
> >> wrote:
> >> > Hi Viresh and Vincent,
> >> >
> >> >> On 9 April 2013 16:07, Lukasz Majewski <l.majewski@samsung.com>
> >> >> wrote:
> >> >> >> On Mon, Apr 1, 2013 at 1:54 PM, Jonghwa Lee
> >> >> > Our approach is a bit different than cpufreq_ondemand one.
> >> >> > Ondemand takes the per CPU idle time, then on that basis
> >> >> > calculates per cpu load. The next step is to choose the
> >> >> > highest load and then use this value to properly scale
> >> >> > frequency.
> >> >> >
> >> >> > On the other hand LAB tries to model different behavior:
> >> >> >
> >> >> > As a first step we applied Vincent Guittot's "pack small
> >> >> > tasks" [*] patch to improve "race to idle" behavior:
> >> >> > http://article.gmane.org/gmane.linux.kernel/1371435/match=sched+pack+small+tasks
> >> >>
> >> >> Luckily he is part of my team :)
> >> >>
> >> >> http://www.linaro.org/linux-on-arm/meet-the-team/power-management
> >> >>
> >> >> BTW, he is using ondemand governor for all his work.
> >> >>
> >> >> > Afterwards, we decided to investigate different approach for
> >> >> > power governing:
> >> >> >
> >> >> > Use the number of sleeping CPUs (not the maximal per-CPU
> >> >> > load) to change frequency. We thereof depend on [*] to "pack"
> >> >> > as many tasks to CPU as possible and allow other to sleep.
> >> >>
> >> >> He packs only small tasks.
> >> >
> >> > What's about packing not only small tasks? I will investigate the
> >> > possibility to aggressively pack (even with a cost of performance
> >> > degradation) as many tasks as possible to a single CPU.
> >>
> >> Hi Lukasz,
> >>
> >> I've got same comment on my current patch and I'm preparing a new
> >> version that can pack tasks more agressively based on the same
> >> buddy mecanism. This will be done at the cost of performance of
> >> course.
> >
> > Can you share your development tree?
> 
> The dev is not finished yet but i will share it as soon as possible

Ok

> 
> >
> >>
> >>
> >> >
> >> > It seems a good idea for a power consumption reduction.
> >>
> >> In fact, it's not always true and depends several inputs like the
> >> number of tasks that run simultaneously
> >
> > In my understanding, we can try to couple (affine) maximal number of
> > task with a CPU. Performance shall decrease, but we will avoid
> > costs of tasks migration.
> >
> > If I remember correctly, I've asked you about some testbench/test
> > program for scheduler evaluation. I assume that nothing has changed
> > and there isn't any "common" set of scheduler tests?
> 
> There are a bunch of bench that are used to evaluate scheduler like
> hackbench, pgbench but they generally fills all CPU in order to test
> max performance. Are you looking for such kind of bench ?

I'd rather see a bit different set of tests - something similar to
"cyclic" tests for PREEMPT_RT patch.

For sched work it would be welcome to spawn a lot of processes with
different duration and workload. And on this basis observe if e.g. 2 or
3 processors are idle.

> 
> >
> >>
> >> >
> >> >> And if there are many small tasks we are
> >> >> packing, then load must be high and so ondemand gov will
> >> >> increase freq.
> >> >
> >> > This is of course true for "packing" all tasks to a single CPU.
> >> > If we stay at the power consumption envelope, we can even
> >> > overclock the frequency.
> >> >
> >> > But what if other - lets say 3 CPUs - are under heavy workload?
> >> > Ondemand will switch frequency to maximum, and as Jonghwa pointed
> >> > out this can cause dangerous temperature increase.
> >>
> >> IIUC, your main concern is to stay in a power consumption budget to
> >> not over heat and have to face the side effect of high temperature
> >> like a decrease of power efficiency. So your governor modifies the
> >> max frequency based on the number of running/idle CPU
> > Yes, this is correct.
> >
> >> to have an
> >> almost stable power consumtpion ?
> >
> > From our observation it seems, that for 3 or 4 running CPUs under
> > heavy load we see much more power consumption reduction.
> 
> That's logic because you will reduce the voltage
> 
> >
> > To put it in another way - ondemand would increase frequency to max
> > for all 4 CPUs. On the other hand, if user experience drops to the
> > acceptable level we can reduce power consumption.
> >
> > Reducing frequency and CPU voltage (by DVS) causes as a side effect,
> > that temperature stays at acceptable level.
> >
> >>
> >> Have you also looked at the power clamp driver that have similar
> >> target ?
> >
> > I might be wrong here, but in my opinion the power clamp driver is
> > a bit different:
> 
> yes, it periodically forces the cluster in a low power state
> 
> >
> > 1. It is dedicated to Intel SoCs, which provide special set of
> > registers (i.e. MSR_PKG_Cx_RESIDENCY [*]), which forces a processor
> > to enter certain C state for a given duration. Idle duration is
> > calculated by per CPU set of high priority kthreads (which also
> > program [*] registers).
> 
> IIRC, a trial on ARM platform have been done by lorenzo and daniel.
> Lorenzo, Daniel, have you more information ?

More information would be welcome :-)

> 
> >
> > 2. ARM SoCs don't have such infrastructure, so we depend on SW here.
> > Scheduler has to remove tasks from a particular CPU and "execute" on
> > it the idle_task.
> > Moreover at Exynos4 thermal control loop depends on SW, since we can
> > only read SoC temperature via TMU (Thermal Management Unit) block.
> 
> The idle duration is quite small and should not perturb normal
> behavior

What do you mean by "small idle duration"? You think about exact time
needed to enter idle state (ARM's WFI) or the time in which CPU is idle.

> 
> Vincent
> >
> >
> > Correct me again, but it seems to me that on ARM we can use CPU
> > hotplug (which as Tomas Glexner stated recently is going to be
> > "refactored" :-) ) or "ask" scheduler to use smallest possible
> > number of CPUs and enter C state for idling CPUs.
> >
> >
> >
> >>
> >>
> >> Vincent
> >>
> >> >
> >> >>
> >> >> > Contrary, when all cores are heavily loaded, we decided to
> >> >> > reduce frequency by around 30%. With this approach user
> >> >> > experience recution is still acceptable (with much less power
> >> >> > consumption).
> >> >>
> >> >> Don't know.. running many cpus at lower freq for long duration
> >> >> will probably take more power than running them at high freq
> >> >> for short duration and making system idle again.
> >> >>
> >> >> > We have posted this "RFC" patch mainly for discussion, and I
> >> >> > think it fits its purpose :-).
> >> >>
> >> >> Yes, no issues with your RFC idea.. its perfect..
> >> >>
> >> >> @Vincent: Can you please follow this thread a bit and tell us
> >> >> what your views are?
> >> >>
> >> >> --
> >> >> viresh
> >> >
> >> >
> >> >
> >> > --
> >> > Best regards,
> >> >
> >> > Lukasz Majewski
> >> >
> >> > Samsung R&D Poland (SRPOL) | Linux Platform Group
> >> >
> >
> >
> > --
> > Best regards,
> >
> > Lukasz Majewski
> >
> > Samsung R&D Poland (SRPOL) | Linux Platform Group



-- 
Best regards,

Lukasz Majewski

Samsung R&D Poland (SRPOL) | Linux Platform Group
