Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365Ab3FLMbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 08:31:06 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:44706 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab3FLMbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 08:31:03 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-f1-51b86a0539a6
Date: Wed, 12 Jun 2013 14:30:15 +0200
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
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH v2 1/3] cpufreq:boost: CPU frequency boost code unification
 for software and hardware solutions
Message-id: <20130612143015.0c86c761@amdc308.digital.local>
In-reply-to: <CAKohpongMVUybmUUh1t+iHYV+=AHA7X=5Cdb66k_o6poiY-2+g@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1370941408-29304-1-git-send-email-l.majewski@samsung.com>
 <1370941408-29304-2-git-send-email-l.majewski@samsung.com>
 <CAKohpomD1ru3_nqQkUq8EmMjJzR7hrtRNAY=UNPWCDHuVxZfBA@mail.gmail.com>
 <20130612093938.1cf73c9a@amdc308.digital.local>
 <CAKohpo=Q6ry9NJU7w3suQ3kB4LQT-CEoy8vcR9W0zL2rSa3hkg@mail.gmail.com>
 <20130612110915.64cfdb1d@amdc308.digital.local>
 <CAKohpongMVUybmUUh1t+iHYV+=AHA7X=5Cdb66k_o6poiY-2+g@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsVy+t9jAV3WrB2BBjPXc1n8ebuc1eJp0w92
	i3mfZS06zz5htuhdcJXN4s0jbovLu+awWXzuPcJocbtxBZtF/8JeJouOI9+YLTZ+9XDg8bhz
	bQ+bx7ppb5k9+rasYvR4tLiF0ePzJrkA1igum5TUnMyy1CJ9uwSujDMLzrAXHDeqWNYwn7WB
	sVG9i5GTQ0LARKL75VtGCFtM4sK99WxdjFwcQgKLGCW29LUwQTjtTBJbF21nA6liEVCVuPDt
	PlgHm4CexOe7T4GKODhEBLQkXt5MBalnFnjGLPH4yxpWkBphgVKJJzNfsoPYvALWEh3fToD1
	cgoES7zqP8oCseAHs8SjCW/AFvALSEq0//vBDHGSncS5TxugmgUlfky+xwJiMwMt27ytiRXC
	lpfYvOYt8wRGwVlIymYhKZuFpGwBI/MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOBoeSa1
	g3Flg8UhRgEORiUe3gNm2wOFWBPLiitzDzFKcDArifAmxu8IFOJNSaysSi3Kjy8qzUktPsQo
	zcGiJM57oNU6UEggPbEkNTs1tSC1CCbLxMEp1cDoeuLY+wOTlu5t3i66jv3Q1e5lurKctsvb
	F59mXJT99KzJ1b74H7mTb+mfv235eK3K03zB1Tm+r/bKSIuo3F/w2b3YO1PId/49a9mm0sO/
	Dorlpa3yE0qz5HlrmldffXpF5O3ZmfufHJk/c4l4ilDphGn555Szl34U+R5U+kXQJPmU1mv2
	c3d4lFiKMxINtZiLihMBzvQYS5ICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jun 2013 14:55:45 +0530, Viresh Kumar wrote:
> On 12 June 2013 14:39, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > On Wed, 12 Jun 2013 13:39:18 +0530, Viresh Kumar wrote:
> >> On 12 June 2013 13:09, Lukasz Majewski <l.majewski@samsung.com>
> >> wrote:
> 
> >> You don't have to add an extra "---" line. Just write your
> >> changelog after "---" added by git and give a blank line between
> >> your last changelog line and below ones (probably just to make it
> >> more readable and not a must, but i am not sure).
> >
> > I got your point. If you prefer, I will stick to it. No problem.
> 
> Its not how I prefer it, but how everybody does it :)

Ok, :-)

> 
> > As a side note:
> >
> > In the other open source project (u-boot) we use the pattern which
> > I've used previously. It has one big advantage - I can edit change
> > log at git gui (just below sign-of-by). It is simply more
> > convenient for me :-). Those changes between "---" are simply
> > skipped by git am afterwards.
> 
> Yes, I am still asking you to follow the same steps:
> 
> git send-email --annotate ***patches***
> 
> and then write whatever you don't want to be logged by git am after
> the "---" already present in the patch.

Ok,

> 
> >> >> >  drivers/cpufreq/cpufreq.c    |   69
> >> >> > ++++++++++++++++++++++++++++++++++++++++++
> >> >> > drivers/cpufreq/freq_table.c |   57
> >> >> > ++++++++++++++++++++++++++++++++--
> >> >> > include/linux/cpufreq.h      | 12 ++++++++ 3 files changed,
> >> >> > 136 insertions(+), 2 deletions(-)
> >>
> >> > I think that we shall give users some flexibility and don't
> >> > assume that low_level_boost is only used for one solution/vendor.
> >> >
> >> > It is also needed with software controlled boost. Please refer to
> >> > patch 3/3.
> >>
> >> You didn't get me. I am not asking to keep it only for Intel. But
> >> keep this variable as is (s/low_level_boost/set_boost_freq), and
> >> make it optional. So, few drivers can implement it but not
> >> everybody is required to.
> >
> > The low_level_boost (set_boost_freq)[*] is optional. However it
> > seems to me, that the burden of changing available set of
> > frequencies (when boost is enabled) must be put to cpufreq driver
> > anyway.
> 
> Driver shouldn't play with boost freqs at runtime. This has to be
> handled by cpufreq core. The only thing cpufreq driver must be doing
> in low_level_boost or set_boost_freq (as what I suggested it to be),

So you want the set_boost_freq to not be used with software based
boosting. Ok.

> is to set the boost frequency requested by core. And so this routine
> would only be defined by drivers that have a special way of setting
> boost frequencies. For others ->target() routine should be able to
> set all freqs, boost or non boost.
> 
> > Without this function [*] defined, we cannot enable frequency
> > boosting.
> 
> why?

Hmm, please read my further comment.

> 
> >> So, Add another variable: boost_supported, which will tell cpufreq
> >> core that boost is supported by governor or not.
> >                                   ^^^^^^^shouldn't it be cpufreq
> > driver?
> 
> Yeah, sorry :(

Ok.

> 
> > Ok, boost_supported seems needed. In my opinion it shall be defined
> > at cpufreq_driver structure (since it provides boosting
> > infrastructure anyway).
> 
> that's what I asked.

Ok :-) .

> 
> >> And a global variable in cpufreq.c boost_enabled to track status of
> >> what user has requested.
> >
> > I think, that boost_enable shall be also defined at cpufreq driver
> > (as proposed in the patch).
> 
> Not really. Driver should only care about if it supports boost or not.
> If it is enabled/disabled by sysfs or not should be kept inside core
> in a global variable.

Ok,

> 
> Moreover, if we have 5-6 cpufreq drivers compiled in (for multi-arch
> compiled kernels), we will save memory wasted by this variable if
> it is present in cpufreq_driver.

Ok. I didn't thought about this use case. Agree.

> 
> > Moreover, boost_enable flag is already defined at
> > acpi-cpufreq.c (as static). We will have two flags for the same
> > purpose.
> 
> No, we don't have to. Just expose another API from cpufreq core
> to get status of boost.

Ok.

> 
> > So we want as follows:
> > show_boost = 1 ---> show only frequencies tagged as
> > CPUFREQ_BOOST_FREQ show_boost = 0 ---> show only "normal" (non
> > boost) frequencies
> 
> Yes.

Ok,

> 
> >> You are just talking about showing boost freqs in sysfs. I am
> >> talking about the frequencies that governors will select when
> >> boost is disabled from sysfs. Because we don't skip boost
> >> frequencies in target() routines, we will set them as and when
> >> governor requests them.
> >
> > I think, that it is the main issue here and it shall be cleared out:
> >
> > Frequencies marked as: CPUFREQ_BOOST_FREQ are added permanently to
> > the freq_table.
> > That is the distinction to the original overclocking patch posted
> > with
> >> LAB, where freq_boost structure was modified and boost frequencies
> >> were
> > either valid or invalid.
> 
> Yes.
> 
> > Then we can in SW control boost in two ways:
> > 1. change policy->max value (to the maximal boost frequency) - as
> > it is done now (v3) at Exynos. This is the simple solution (patch
> > 3/3)
> 
> Drivers aren't supposed to set policy->max. It should be taken care
> of by core or freq_table.c file.

This seems the right thing, but it would require some functions defined
at freq_table.c to be extended to accept bool "boost" parameter (which
would not consider freqs tagged as CPUFREQ_BOOST_FREQ).
Then each per cpu policy, shall be read and its max freq shall be
updated when someone enables boost from sysfs (at
cpufreq_boost_trigger_state).

This is my idea to manage boost mode from core code. Am I right?



> 
> > 2. Modify all freq_table helper functions to be aware of boost and
> > skip boost frequencies when boost_enable = 0. (as it was done at
> > v2). This requires code modification at freq_table.c and
> > reevaluation of policy.
> 
> Yes, the core must be aware of it and must take the right decision
> here. So, we need to take care of boost freq in freq_table.c

Ok. Then we agreed :-).

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
