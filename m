Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab3FLJKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 05:10:16 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:32428 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113Ab3FLJKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 05:10:11 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-a8-51b83af1f469
Date: Wed, 12 Jun 2013 11:09:15 +0200
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
Message-id: <20130612110915.64cfdb1d@amdc308.digital.local>
In-reply-to: <CAKohpo=Q6ry9NJU7w3suQ3kB4LQT-CEoy8vcR9W0zL2rSa3hkg@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1370941408-29304-1-git-send-email-l.majewski@samsung.com>
 <1370941408-29304-2-git-send-email-l.majewski@samsung.com>
 <CAKohpomD1ru3_nqQkUq8EmMjJzR7hrtRNAY=UNPWCDHuVxZfBA@mail.gmail.com>
 <20130612093938.1cf73c9a@amdc308.digital.local>
 <CAKohpo=Q6ry9NJU7w3suQ3kB4LQT-CEoy8vcR9W0zL2rSa3hkg@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsVy+t9jQd2PVjsCDXZcYrf483Y5q8XTph/s
	FvM+y1p0nn3CbNG74CqbxZtH3BaXd81hs/jce4TR4nbjCjaL/oW9TBYdR74xW2z86uHA43Hn
	2h42j3XT3jJ79G1ZxejxaHELo8fnTXIBrFFcNimpOZllqUX6dglcGfufXGcuaDaueHv8GHMD
	40v1LkZODgkBE4md9xazQdhiEhfurQeyuTiEBKYzSlz8eIkdwmlnkvi56hg7SBWLgKrE3o4+
	RhCbTUBP4vPdp0xdjBwcIgJaEi9vpoLUMws8Y5Z4/GUNK0iNsECpxJOZL8F6eQWsJdat3gNm
	cwoES3R//sMMseA/k8TyY8tZQBL8ApIS7f9+MEOcZCdx7tMGqGZBiR+T74HVMAMt27ytiRXC
	lpfYvOYt8wRGwVlIymYhKZuFpGwBI/MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOBoeSa9
	g3FVg8UhRgEORiUe3gNm2wOFWBPLiitzDzFKcDArifBWae8IFOJNSaysSi3Kjy8qzUktPsQo
	zcGiJM57sNU6UEggPbEkNTs1tSC1CCbLxMEp1cAY1sEo8CP7+I++c+YzTIpLjyxw2FTN23fN
	kK1imf212qase+x3OpL9nQP8JJbMMjTmjtJXqW5RFVS2LdvIo8R32IfVjtfGSbX/6REp6Zu1
	p66UZ26oOd/0cxHPNgnNSl/T6T4T57e9uS1+KUP8+oLHH37P6lI1Pm1Z9oy70fUIw9S55zYe
	PKzEUpyRaKjFXFScCAA1aHAgkgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jun 2013 13:39:18 +0530, Viresh Kumar wrote:

Hi Viresh,

> On 12 June 2013 13:09, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > Hi Viresh,
> 
> Hi Lukasz,
> 
> >> Hi,
> 
> Please don't remove the line which says, who wrote last mail at what
> time. These >, >>, >>>, >>>>, ... have a meaning. They help us
> understand who wrote what in bottom posting. And as you removed my
> line, nobody can see who wrote above "Hi" to you :)

Ok, mailer adjusted.

> 
> >> You don't have to manually add "---" here. Just keep a blank line
> >> instead.
> >
> > One "---" is added by git automatically. The [*] was added to
> > distinct the changelog from rest of the commit. At least older
> > versions of GIT required this to not include changelog to commit
> > messages.
> 
> You don't have to add an extra "---" line. Just write your changelog
> after "---" added by git and give a blank line between your last
> changelog line and below ones (probably just to make it more
> readable and not a must, but i am not sure).

I got your point. If you prefer, I will stick to it. No problem.

As a side note:

In the other open source project (u-boot) we use the pattern which I've
used previously. It has one big advantage - I can edit change log at
git gui (just below sign-of-by). It is simply more convenient for
me :-). Those changes between "---" are simply skipped by git am
afterwards.

> 
> >> >  drivers/cpufreq/cpufreq.c    |   69
> >> > ++++++++++++++++++++++++++++++++++++++++++
> >> > drivers/cpufreq/freq_table.c |   57
> >> > ++++++++++++++++++++++++++++++++-- include/linux/cpufreq.h      |
> >> > 12 ++++++++ 3 files changed, 136 insertions(+), 2 deletions(-)
> 
> > I think that we shall give users some flexibility and don't assume
> > that low_level_boost is only used for one solution/vendor.
> >
> > It is also needed with software controlled boost. Please refer to
> > patch 3/3.
> 
> You didn't get me. I am not asking to keep it only for Intel. But keep
> this variable as is (s/low_level_boost/set_boost_freq), and make it
> optional. So, few drivers can implement it but not everybody is
> required to.

The low_level_boost (set_boost_freq)[*] is optional. However it seems to
me, that the burden of changing available set of frequencies (when
boost is enabled) must be put to cpufreq driver anyway. 

Without this function [*] defined, we cannot enable frequency boosting. 

> 
> So, Add another variable: boost_supported, which will tell cpufreq
> core that boost is supported by governor or not.
				  ^^^^^^^shouldn't it be cpufreq driver?

Ok, boost_supported seems needed. In my opinion it shall be defined at
cpufreq_driver structure (since it provides boosting infrastructure
anyway).

> 
> And a global variable in cpufreq.c boost_enabled to track status of
> what user has requested.

I think, that boost_enable shall be also defined at cpufreq driver (as
proposed in the patch). We keep pointer to cpufreq driver at cpufreq.c
anyway. Moreover, boost_enable flag is already defined at
acpi-cpufreq.c (as static). We will have two flags for the same
purpose. 

> 
> > However I've added one global flag: cpufreq_boost_sysfs_defined
> > which indicates if /sys/devices/system/cpu/cpufreq/boost attribute
> > has been already defined (to prevent multiple definitions attempts).
> 
> You don't need this variable anymore as sysfs create file is now
> moved to cpufreq_register_driver(), so this can't be called twice.

Yes, in this situation the cpufreq_boost_sysfs_defined flag is
redundant.

> 
> >> > char *buf) +static ssize_t show_available_freqs(struct
> >> > cpufreq_policy *policy, char *buf,
> >> > +                                   int show_boost)
> >> >  {
> >> >         unsigned int i = 0;
> >> >         unsigned int cpu = policy->cpu;
> >> > @@ -186,22 +208,53 @@ static ssize_t show_available_freqs(struct
> >> > cpufreq_policy *policy, char *buf) for (i = 0;
> >> > (table[i].frequency != CPUFREQ_TABLE_END); i++) { if
> >> > (table[i].frequency == CPUFREQ_ENTRY_INVALID) continue;
> >> > +               if (show_boost)
> >> > +                       if (table[i].index != CPUFREQ_BOOST_FREQ)
> >> > +                               continue;
> >> > +
> >>
> >> Looks wrong. You will show boost freqs when show_boost is false.
> >
> > My purpose here is to display frequencies only tagged with
> > CPUFREQ_BOOST_FREQ and when show_boost is true.
> >
> > When show_boost is false, the operation of the function is
> > unchanged.
> 
> Which is wrong. When show_boost is false, it means that user don't
> want to see boost frequencies and so you should skip them.

So we want as follows:
show_boost = 1 ---> show only frequencies tagged as CPUFREQ_BOOST_FREQ
show_boost = 0 ---> show only "normal" (non boost) frequencies

> 
> >> With this patch alone, we would be using boost frequencies even in
> >> normal cases where we haven't enabled boost.
> >
> > Correct me if I'm wrong here, but the
> > cpufreq_freq_attr_boost_available_freqs will be added to cpufreq
> > driver's freq_attr table (i.e. *exynos_cpufreq_attr[]).
> > It is cpufreq driver's responsibility to add this attribute. By
> > default all other drivers add only
> > cpufreq_freq_attr_boost_available_freqs.
> 
> You are just talking about showing boost freqs in sysfs. I am talking
> about the frequencies that governors will select when boost is
> disabled from sysfs. Because we don't skip boost frequencies in
> target() routines, we will set them as and when governor requests
> them.

I think, that it is the main issue here and it shall be cleared out:

Frequencies marked as: CPUFREQ_BOOST_FREQ are added permanently to the
freq_table. 
That is the distinction to the original overclocking patch posted with
LAB, where freq_boost structure was modified and boost frequencies were
either valid or invalid.

Then we can in SW control boost in two ways:
1. change policy->max value (to the maximal boost frequency) - as it is
done now (v3) at Exynos. This is the simple solution (patch 3/3)

2. Modify all freq_table helper functions to be aware of boost and
skip boost frequencies when boost_enable = 0. (as it was done at v2).
This requires code modification at freq_table.c and reevaluation of
policy. 

Maybe you have any other idea?


-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
