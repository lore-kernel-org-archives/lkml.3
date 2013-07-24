Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab3GXTuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 15:50:00 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:19583 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753149Ab3GXTt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 15:49:59 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18bgQnUqHDeDfihE7Qnmp0OpGt631yveu0=
Date: Wed, 24 Jul 2013 15:49:40 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [GIT PULL] clockevents/clocksource: Add Marvell Orion SoC timer
Message-ID: <20130724194940.GD23879@titan.lakedaemon.net>
References: <51B8D310.4050404@linaro.org>
 <51D9548B.9040907@gmail.com>
 <alpine.DEB.2.02.1307071508030.32106@ionos.tec.linutronix.de>
 <20130707144645.GA11908@titan.lakedaemon.net>
 <alpine.DEB.2.02.1307071723220.32106@ionos.tec.linutronix.de>
 <20130707235819.GB11908@titan.lakedaemon.net>
 <alpine.DEB.2.02.1307081041290.32106@ionos.tec.linutronix.de>
 <51E56CFD.9050508@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E56CFD.9050508@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 05:55:41PM +0200, Daniel Lezcano wrote:
> On 07/08/2013 10:45 AM, Thomas Gleixner wrote:
> > On Sun, 7 Jul 2013, Jason Cooper wrote:
> >> On Sun, Jul 07, 2013 at 05:30:31PM +0200, Thomas Gleixner wrote:
> >> I don't mind delaying half of a series so the drivers/ portion can land
> >> in mainline, and the rest can land in the next cycle.  But when things
> >> don't go according to that plan, I'd like a little consideration /
> >> flexibility about solving the problem.  Especially considering I'm
> >> *trying* to do the right thing by pushing to appropriate maintainers
> >> first.
> >>
> >> Of course, this is a moot point since, as you clarified above, this
> >> dependency doesn't have the hazards typically associated with
> >> out-of-tree dependencies.
> > 
> > There is a very simple procedure for stuff like this.
> > 
> > Series has parts which go through tree A and B and another larger part
> > for tree C which depends on the A and B parts.
> > 
> > So ask the maintainers of A and B to apply this to separate branches,
> > which are based on some commit in Linus tree. These branches can be
> > pulled into C and C can apply the depending stuff on top.
> > 
> > Now the maintainers of A and B merge these branches into their main
> > devel branch, can do further fixups and stuff on top. And the whole
> > thing just works without glitches during the merge window.
> > 
> > We do this all the time.
> 
> Ok, I was about to send to both of you a PR with a common ancestor [1]
> for this patch but finally this patch has been taken for timers/urgent.
> 
> I don't have to send the PR, right ?
> 
> timers/urgent will be merged into timers/core, correct ?

Sorry for the late reply.  I'm crawling out from under my backlog.  It
appears

  0c1dcfd clocksource: Add Marvell Orion SoC timer

has made it into Linus' tree.  Ezequiel, you should be able to base your
series on v3.11-rc[12] to pick this up.

thx,

Jason.
