Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab3FRIZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:25:23 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:60076 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab3FRIZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:25:15 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-36-51c01969ceb4
Date: Tue, 18 Jun 2013 10:24:29 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocky" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: Re: [PATCH v3 1/3] cpufreq: Add boost frequency support in core
Message-id: <20130618102429.5ff68931@amdc308.digital.local>
In-reply-to: <CAKohpo=_=u35wTb-ZUXrR2hNno+ryAqq4gSC3EiJr=-bmgb9JQ@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1371195540-2991-1-git-send-email-l.majewski@samsung.com>
 <1371195540-2991-2-git-send-email-l.majewski@samsung.com>
 <CAKohpokQAsuAqWi7rNx9RaFz8KVRNXVkBD22KC5_Qh05k66qqA@mail.gmail.com>
 <20130617091549.398b865f@amdc308.digital.local>
 <CAKohpo=nfuqwCoQJRczmNRNXCOTL5FSJQEzjKpVdXU+wu-KJ1g@mail.gmail.com>
 <20130617110811.1e1805d2@amdc308.digital.local>
 <CAKohpo=oy3SQXgvNvOydggZ5NZu9yyVtKrdFQjNOGVmzhSaQUw@mail.gmail.com>
 <20130617115809.5206c42c@amdc308.digital.local>
 <CAKohpo=yPcH0FW7T38cd3E1xOpzC0AhJ5mtyVaQyuj_S8iLovw@mail.gmail.com>
 <20130617155156.4c729b5a@amdc308.digital.local>
 <CAKohpo=_=u35wTb-ZUXrR2hNno+ryAqq4gSC3EiJr=-bmgb9JQ@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42I5/e+xoG6m5IFAg5blohYNV0Ms/rxdzmrx
	tOkHu8W8z7IWnWefMFv0LrjKZvHmEbfF5V1z2Cw+9x5htLjduILNon9hL5NFx5FvzBYbv3o4
	8HrcubaHzWPdtLfMHn1bVjF6PFrcwujxeZNcAGsUl01Kak5mWWqRvl0CV8a/I5YFR5Uq3t27
	y9TA+Fqqi5GTQ0LARGL701ksELaYxIV769m6GLk4hASmM0pc3fyGHcJpZ5JY2T8HrIpFQFXi
	xbSf7CA2m4CexOe7T5m6GDk4RAS0JF7eTAUJMwvMZJE4/VsRxBYW8JA4d2QaI4jNK2At8XPh
	XiYQm1MgWGLp4x+sEPNfsEq8/NUAluAXkJRo//eDGeIiO4lznzawQzQLSvyYfI8FYoGWxOZt
	TawQtrzE5jVvmScwCs5CUjYLSdksJGULGJlXMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgRH
	zDPpHYyrGiwOMQpwMCrx8CaI7Q8UYk0sK67MPcQowcGsJMJbcgYoxJuSWFmVWpQfX1Sak1p8
	iFGag0VJnPdgq3WgkEB6YklqdmpqQWoRTJaJg1OqgbFvsnye/Nk5B5c9dmvrftuYrBopu3NN
	JecKJvdTcdNlHoaeSm65HvlEm01A//cV82T3++/3XWx/F7lzncnDN/rZJo9EVj3aLCrB26t4
	ecLx7Xb+73K29+6vmuj7KqZroZmqg83m0zuPp9dOOlScNXtxa73OydPTL7d86wxOnBttLN9y
	q7N1/wolluKMREMt5qLiRABuWPoilAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Jun 2013 08:42:13 +0200, Viresh Kumar wrote:
> On 17 June 2013 19:21, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > On Mon, 17 Jun 2013 18:40:50 +0530, Viresh Kumar wrote:
> >> >> > The core acpi-cpufreq.c code hadn't been changed by me, so I
> >> >> > assume that it will work as before.
> >> >>
> >> >> That should adapt your patch in your patchset.
> >
> > Could you explain what do you mean?
> 
> Update acpi-cpufreq to use your infrastructure.

Ach... It is already done, since I always post acpi related patch to
the boost series :-).

> 
> >> >> From sysfs?? I thought we are going to have some automatic
> >> >> control of this stuff from inside kernel.
> >> >
> >> > From sysfs I just enable the boost. I do not order from userpace
> >> > the cpufreq to run with a particular (boosted) frequency.
> >> >
> >> > When I enable boost - I ask (politely) the cpufreq core to
> >> > reevaluate policies and when applicable increase policy->max.
> >> >
> >> > Then governor can use this new frequencies for normal operation.
> >>
> >> So, with your current patchset in, ondemand or conservative
> >> governors will start using boost frequencies. Which might burn
> >> your chip.
> >
> > Two scenarios:
> > 1. Thermal framework is compiled in and enabled (for exynos/other
> > SoC) -> trip point is reached -> boost is disabled -> frequency is
> > reduced -> SoC is cooled down.
> >
> > I think, that thermal framework is a good "safe valve" here.
> 
> Even in this case boost shouldn't have been enabled by default.
> Its not only about burning the chip but more than that.
> 
> According to my understanding, boost was important for power
> saving. In case a high load can be managed by a single cpu with
> boost freqs, then its better to use boost freqs rather than bringing
> another cpu up.
> 
> Normally boost freqs are not so useful if we talk about powersaving,
> as their energy consumption is much higher with not so great impact
> on performance.
> 
> That's why when this thread started we talked about boost only when
> one cpu is operational. But with your patch all cores can use boost
> freq and thermal will come into picture just to save the chip.

I agree here.

> 
> That's wrong. This isn't why we invented boost here. Otherwise you
> just don't need boost feature at all for your SoC. Just make these
> freqs as available freqs and let thermal control policy->max/min
> to save your chip.

Also I agree.

> 
> > 2. Thermal framework is disabled and user has enabled boost and used
> > ondemand / conservative governor.
> > Then execute gzip < /dev/urandom > /dev/null & (on all cores).
> >
> > Then yes, chip will hang/burn due to crossing operating point (or
> > burn).
> >
> >
> > What other means of control (despite of thermal) would you consider
> > applicable?
> >
> > What comes to my mind is modifying governor logic to count how long
> > the CPU run with boost enabled and then disable it.
> 
> Its not about how long.. One cpu type can work longer with boost freq
> compared to other.
> 
> What we probably need is:
> - Enabled boost from sysfs if required (now below steps will come into
>   picture)
> - See how many cpus are running, if only one then start using boost
> freqs

You are right here. 

I'd like to propose following solution:
1. For acpi (where boost_enable come into play) - do not consider
number of active cpus (this is done in HW anyway)

2. For SW solution evaluate how many CPUs are running. If only one is
running then allow enabling boost from sysfs. 

But following situation is also possible: User enable boost when one
core is only running and then for some reason other core is woken up.
What shall be done then?
Shall we then disable boost immediately when cpufreq detects that
more than one core is running? Or leave this situation to be handled by
thermal subsystem?

As a side note:
Logic proposed at point 2, is already implemented at LAB
(enable LAB only when one core is running and disable it when more
than one come into play).


> - Now thermal should be come into picture to save chip in case a
> single cpu running at boost can burn it out.

I will extent v4 to embrace code which switches off boost at thermal.

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
