Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab3GHSzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 14:55:31 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59889 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab3GHSz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 14:55:29 -0400
Date: Mon, 8 Jul 2013 20:55:09 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: tj@kernel.org, davem@davemloft.net, airlied@redhat.com, axboe@kernel.dk,
        tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com,
        rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Livi@jasper.es
Subject: Re: [PATCH V5 0/5] Queue work on power efficient wq
Message-ID: <20130708185509.GH29556@pengutronix.de>
References: <cover.1366803121.git.viresh.kumar@linaro.org>
 <20130708153716.GF29556@pengutronix.de>
 <CAKohpon+dFBDUhfbJcBBWyg4mAfQ1nU_wSd6OMvdTH6SzkUjNg@mail.gmail.com>
 <20130708155747.GG29556@pengutronix.de>
 <CAKohpokT3M5TNhzGxCwHZoFU69VkFutQ-KBCf5Xh5Vfwb+trzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKohpokT3M5TNhzGxCwHZoFU69VkFutQ-KBCf5Xh5Vfwb+trzg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jul 08, 2013 at 10:18:08PM +0530, Viresh Kumar wrote:
> On 8 July 2013 21:27, Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:
> > On Mon, Jul 08, 2013 at 09:17:01PM +0530, Viresh Kumar wrote:
> 
> >> Well, big LITTLE still runs an SMP kernel :) and so has this flag set.
> > The 'S' is justified because cpu0 and cpu1 are of the same type? Are
> > there b.L systems that have only one big and one LITTLE cpu? Do these
> > use SMP, too?
> 
> Following definition of SMP says:
> http://en.wikipedia.org/wiki/Symmetric_Multiprocessor
> 
> A system is SMP when:
> - It has same type of cores
> - controlled by a single instance of OS.
> 
> In big LITTLE first one is obviously not completely true as you pointed out.
> But second one is and so I would say its an SMP system :)
> 
> Don't know how it should be called though.
MP maybe.

> >> You can make it dependent on that if required.
> > Well, it's not required. It's just that the corresponding question in
> > make oldconfig isn't really an enrichment for a kernel targeting an
> > Cortex M3 :-)
> 
> Just to make it clear enough, you are saying it doesn't make any
> sense to enable it for M3? But because it is disabled by default,
> the problem is not seen?
No I'm saying that asking me is bad because on an UP machine it won't
matter what I answer. So please don't ask me if SMP is off.

> Why? Can't we have two M3's on a SoC and run an SMP kernel over
> it?
Yeah, you can. Then you'd have SMP (or MP) enabled though and the choice
for that workqueue thing makes a difference. In that case asking is OK.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
