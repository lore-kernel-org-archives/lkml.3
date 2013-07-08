Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab3GHAES (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 20:04:18 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:53520 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab3GHAER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 20:04:17 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18lDaykWYWLViNyLFgBfOmMRGl4zmg/ohc=
Date: Sun, 7 Jul 2013 20:04:01 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [GIT PULL] clockevents/clocksource: Add Marvell Orion SoC timer
Message-ID: <20130708000401.GC11908@titan.lakedaemon.net>
References: <51B8D310.4050404@linaro.org>
 <51D9548B.9040907@gmail.com>
 <alpine.DEB.2.02.1307071508030.32106@ionos.tec.linutronix.de>
 <20130707144645.GA11908@titan.lakedaemon.net>
 <alpine.DEB.2.02.1307071723220.32106@ionos.tec.linutronix.de>
 <51D99B1B.7050106@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D99B1B.7050106@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 07, 2013 at 06:45:15PM +0200, Daniel Lezcano wrote:
> On 07/07/2013 05:30 PM, Thomas Gleixner wrote:
> > On Sun, 7 Jul 2013, Jason Cooper wrote:
> >> Sure, but to be clear, Daniel, please drop this patch from your tree.  I
> >> have no desire to create an out-of-tree dependency if we can avoid it.
> >> It has a habit of going horribly wrong [1].
> >>
> >> I'll cherry-pick
> >>
> >>   0c1dcfd clocksource: Add Marvell Orion SoC timer
> > 
> > Don't do that. Do a git fetch on that branch and then git merge
> > 0c1dcfd. The patches before that Marvel commit are already in Linus
> > tree. That way it does not matter who sends first or not.
> > 
> > We don't force others to drop stuff and cherry picking is a nuisance
> > as well as you end up with two different commits doing the same thing.
> > 
> > Also for the next merge window: Can we please let everything under
> > drivers/clocksoure go through Daniels and my trees?
> > 
> > I'm starting to be grumpy about anyone thinking that this directory is
> > a public dump ground with no rules.
> 
> Yes I agree. I will meet John this week and we will sort out this and
> define a clear set of rules to prevent that to happen again.

Oh god no!  The rules we have are fine.  "Defer to the appropriate
maintainer first."  Which I did (that's why the patch is in your tree
;-) ).  A mistake happened, and we're working together to find the best
solution.

The last thing we need is more bureaucratic crap.

thx,

Jason.
