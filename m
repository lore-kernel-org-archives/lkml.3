Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab3GGOrH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 10:47:07 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:12977 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752295Ab3GGOrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 10:47:03 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19VuV4BzKiR0QJizV+h+gHMMsxOoVJ5iaE=
Date: Sun, 7 Jul 2013 10:46:45 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [GIT PULL] clockevents/clocksource: Add Marvell Orion SoC timer
Message-ID: <20130707144645.GA11908@titan.lakedaemon.net>
References: <51B8D310.4050404@linaro.org>
 <51D9548B.9040907@gmail.com>
 <alpine.DEB.2.02.1307071508030.32106@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307071508030.32106@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

On Sun, Jul 07, 2013 at 03:10:25PM +0200, Thomas Gleixner wrote:
> On Sun, 7 Jul 2013, Sebastian Hesselbarth wrote:
> > > ----------------------------------------------------------------
> > > Sebastian Hesselbarth (1):
> > >        clocksource: Add Marvell Orion SoC timer
> > 
> > with tip timers/core PR sent, I realized that the above did not make it
> > in. As we have a whole bunch of cleanup and DT conversion patches for
> 
> Opps. Fell through the cracks.

No problem.

> > v3.11-rc1 depending on it, would it be ok for you to let Jason Cooper
> > take it through his ARM sub-branch?
> 
> > If you are fine with it, I will resend the patch and note that Daniel
> > can drop it and Jason will take it.
> 
> Nah, Jason can just pull it from Daniels tree and be done with it.

Sure, but to be clear, Daniel, please drop this patch from your tree.  I
have no desire to create an out-of-tree dependency if we can avoid it.
It has a habit of going horribly wrong [1].

I'll cherry-pick

  0c1dcfd clocksource: Add Marvell Orion SoC timer

from dlezcano/timers/clockevents to get the Signed-off-by's Tested-by's,
etc.  If I could get an Acked-by from Daniel or Thomas on this, I'd
appreciate it.

Daniel, it looks like you only have cpuidle work going into linux-next.
If you do decide to include timers/clockevents, please drop the patch
before hand.

thx,

Jason.

[1] https://lkml.org/lkml/2013/2/28/725

