Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab3FRJNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:13:18 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:13111 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547Ab3FRJNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:13:12 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-cf-51c024a6d44b
Date: Tue, 18 Jun 2013 11:12:36 +0200
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
Message-id: <20130618111236.614d43a0@amdc308.digital.local>
In-reply-to: <CAKohpo=Th-V4+i7r0+EoDL2fvoy-vMZrRa7wg5mJSQ7HjK_0YQ@mail.gmail.com>
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
 <20130618102429.5ff68931@amdc308.digital.local>
 <CAKohpo=Th-V4+i7r0+EoDL2fvoy-vMZrRa7wg5mJSQ7HjK_0YQ@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42I5/e+xoO4ylQOBBt/uWFk0XA2x+PN2OavF
	06Yf7BbzPstadJ59wmzRu+Aqm8WbR9wWl3fNYbP43HuE0eJ24wo2i/6FvUwWHUe+MVts/Orh
	wOtx59oeNo91094ye/RtWcXo8WhxC6PH501yAaxRXDYpqTmZZalF+nYJXBlf5y5lK3gtWLH0
	3SnmBsYLvF2MHBwSAiYSb3crdzFyApliEhfurWfrYuTiEBKYzihxa/UpJginnUni0MFlrCBV
	LAKqEj8PnAez2QT0JD7ffcoEMkhEQEvi5c1UkDCzwEwWidO/FUFsYQEPiXNHpjGC2LwC1hKH
	T3aB2ZwCwRKfO/axQ8x/yCZxvXUXO0iCX0BSov3fD2aIi+wkzn3awA7RLCjxY/I9FogFWhKb
	tzWxQtjyEpvXvGWewCg4C0nZLCRls5CULWBkXsUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kR
	HDHPpHcwrmqwOMQowMGoxMObILY/UIg1say4MvcQowQHs5IIb8kZoBBvSmJlVWpRfnxRaU5q
	8SFGaQ4WJXHeg63WgUIC6YklqdmpqQWpRTBZJg5OqQZGFnvfnUf3qGzXb49RON/xuPG5AmPg
	473TU17pzE474LntlhzHvw3W76t9FvlwbA268nb38umLpJa1uQQWM1sqydyuN7Q9LcSjfUB0
	tsr8/+6Ze0XkJZa+Kah4evFyd6uCp83pi6uieLgumygoM1k9FW13LuJjTgza8DhFoGrpm/kL
	n0W8L/uvxFKckWioxVxUnAgAcKRGyJQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Jun 2013 14:10:28 +0530, Viresh Kumar wrote:
> On 18 June 2013 13:54, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > On Tue, 18 Jun 2013 08:42:13 +0200, Viresh Kumar wrote:
> 
> >> Its not about how long.. One cpu type can work longer with boost
> >> freq compared to other.
> >>
> >> What we probably need is:
> >> - Enabled boost from sysfs if required (now below steps will come
> >> into picture)
> >> - See how many cpus are running, if only one then start using boost
> >> freqs
> >
> > You are right here.
> >
> > I'd like to propose following solution:
> > 1. For acpi (where boost_enable come into play) - do not consider
> > number of active cpus (this is done in HW anyway)
> >
> > 2. For SW solution evaluate how many CPUs are running. If only one
> > is running then allow enabling boost from sysfs.
> 
> Looks fine.

Ok,

> 
> > But following situation is also possible: User enable boost when one
> > core is only running and then for some reason other core is woken
> > up. What shall be done then?
> > Shall we then disable boost immediately when cpufreq detects that
> > more than one core is running? Or leave this situation to be
> > handled by thermal subsystem?
> 
> Obviously disable boost ASAP. Every SoC might not have a thermal
> framework glue to do it.

Implementation of counting number of idle CPUs would impose extending
the cpufreq core itself. Do you have any hints how this can be done in
a neat way?

I suspect, that porting the LAB solution to the cpufreq core may be not
easy. I think that the best place for it would be governor core code.

> 
> > As a side note:
> > Logic proposed at point 2, is already implemented at LAB
> > (enable LAB only when one core is running and disable it when more
> > than one come into play).
> 
> Hmm.. So, eventually that will go away now :)

But this is not the only functionality, which LAB posses :-).

> 
> >> - Now thermal should be come into picture to save chip in case a
> >> single cpu running at boost can burn it out.
> >
> > I will extent v4 to embrace code which switches off boost at
> > thermal.
> 
> Gud.

Ok.

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
