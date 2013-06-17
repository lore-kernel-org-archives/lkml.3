Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178Ab3FQNw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 09:52:58 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:55193 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756312Ab3FQNwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 09:52:55 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-90-51bf14b58574
Date: Mon, 17 Jun 2013 15:51:56 +0200
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
Message-id: <20130617155156.4c729b5a@amdc308.digital.local>
In-reply-to: <CAKohpo=yPcH0FW7T38cd3E1xOpzC0AhJ5mtyVaQyuj_S8iLovw@mail.gmail.com>
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
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42I5/e+xoO5Wkf2BBqv2Sls0XA2x+PN2OavF
	06Yf7BbzPstadJ59wmzRu+Aqm8WbR9wWl3fNYbP43HuE0eJ24wo2i/6FvUwWHUe+MVts/Orh
	wOtx59oeNo91094ye/RtWcXo8WhxC6PH501yAaxRXDYpqTmZZalF+nYJXBkXp21hLPgrVPFp
	+RrWBsaHfF2MnBwSAiYSO16tYIOwxSQu3FsPZHNxCAlMZ5T42/KWCcJpZ5LYNf82C0gVi4Cq
	xLnDH9hBbDYBPYnPd58CFXFwiAhoSby8mQoSZhaYySJx+rciiC0s4CFx7sg0RhCbV8BaYs6D
	3WCtnALBEtcebGeBmP+eRWLHv4Ng8/kFJCXa//1ghrjITuLcpw3sEM2CEj8m32OBWKAlsXlb
	EyuELS+xec1b5gmMgrOQlM1CUjYLSdkCRuZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMEx
	80x6B+OqBotDjAIcjEo8vBx1+wKFWBPLiitzDzFKcDArifDGTgQK8aYkVlalFuXHF5XmpBYf
	YpTmYFES5z3Yah0oJJCeWJKanZpakFoEk2Xi4JRqYJy9Zu6DeV/MZDfmnJKelMCXdfhPhqbK
	n8AI5gt7hOeKv0i+qHWvdemS7wHTudjZr23T07A3Vc9zS36rd+zuiXKONls7RbfTf3l1jryy
	C10upx31t2qJe2/Ryx8f/MUF1C59mBeVsUBxEQfPz0U2ebF/t94JNWdXuc9anVYe4BDDKZ16
	LV4sUYmlOCPRUIu5qDgRAPPch+OVAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Jun 2013 18:40:50 +0530, Viresh Kumar wrote:
> On 17 June 2013 15:28, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > Yes. But I don't want to hardcode anything. Especially starting CPU
> > number.
> 
> There is nothing wrong with it. for_each_online_cpu() is good enough
> on these cases.

I've already changed this code to use list of policies.

I will send this at v4.

> 
> >> > How one can control the boost? I'm now (on my setup) using
> >> > thermal subsystem. I set proper trip points and when one of them
> >> > is met, then boost is disabled. Moreover the thermal governor
> >> > (stepwise) also reduces frequency.
> >> >
> >> > It works stable with v3.10 (with 3.8 there were some bugs - now
> >> > they are fixed).
> >> >
> >> >
> >> > The core acpi-cpufreq.c code hadn't been changed by me, so I
> >> > assume that it will work as before.
> >>
> >> That should adapt your patch in your patchset.

Could you explain what do you mean? 


> 
> ??
> 
> >> From sysfs?? I thought we are going to have some automatic control
> >> of this stuff from inside kernel.
> >
> > From sysfs I just enable the boost. I do not order from userpace the
> > cpufreq to run with a particular (boosted) frequency.
> >
> > When I enable boost - I ask (politely) the cpufreq core to
> > reevaluate policies and when applicable increase policy->max.
> >
> > Then governor can use this new frequencies for normal operation.
> 
> So, with your current patchset in, ondemand or conservative governors
> will start using boost frequencies. Which might burn your chip.

Two scenarios:
1. Thermal framework is compiled in and enabled (for exynos/other SoC)
-> trip point is reached -> boost is disabled -> frequency is reduced ->
SoC is cooled down.

I think, that thermal framework is a good "safe valve" here.


2. Thermal framework is disabled and user has enabled boost and used
ondemand / conservative governor. 
Then execute gzip < /dev/urandom > /dev/null & (on all cores).

Then yes, chip will hang/burn due to crossing operating point (or burn).


What other means of control (despite of thermal) would you consider
applicable? 

What comes to my mind is modifying governor logic to count how long the
CPU run with boost enabled and then disable it. 

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
