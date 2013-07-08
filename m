Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab3GHP6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 11:58:08 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42219 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab3GHP6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 11:58:06 -0400
Date: Mon, 8 Jul 2013 17:57:47 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: tj@kernel.org, davem@davemloft.net, airlied@redhat.com, axboe@kernel.dk,
        tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com,
        rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Livi@jasper.es
Subject: Re: [PATCH V5 0/5] Queue work on power efficient wq
Message-ID: <20130708155747.GG29556@pengutronix.de>
References: <cover.1366803121.git.viresh.kumar@linaro.org>
 <20130708153716.GF29556@pengutronix.de>
 <CAKohpon+dFBDUhfbJcBBWyg4mAfQ1nU_wSd6OMvdTH6SzkUjNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKohpon+dFBDUhfbJcBBWyg4mAfQ1nU_wSd6OMvdTH6SzkUjNg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 08, 2013 at 09:17:01PM +0530, Viresh Kumar wrote:
> On 8 July 2013 21:07, Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:
> > This patch set hit my tree now. I wonder if it makes sense to make
> > WQ_POWER_EFFICIENT_DEFAULT depend on SMP. (Oh wait, big.LITTLE isn't
> > SMP, so probably there is a better symbol to depend on?)
> 
> Well, big LITTLE still runs an SMP kernel :) and so has this flag set.
The 'S' is justified because cpu0 and cpu1 are of the same type? Are
there b.L systems that have only one big and one LITTLE cpu? Do these
use SMP, too?

> You can make it dependent on that if required.
Well, it's not required. It's just that the corresponding question in
make oldconfig isn't really an enrichment for a kernel targeting an
Cortex M3 :-)

Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
