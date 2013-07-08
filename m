Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab3GHIpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 04:45:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:51949 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab3GHIpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 04:45:47 -0400
Date: Mon, 8 Jul 2013 10:45:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jason Cooper <jason@lakedaemon.net>
cc: Andrew Lunn <andrew@lunn.ch>, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [GIT PULL] clockevents/clocksource: Add Marvell Orion SoC
 timer
In-Reply-To: <20130707235819.GB11908@titan.lakedaemon.net>
Message-ID: <alpine.DEB.2.02.1307081041290.32106@ionos.tec.linutronix.de>
References: <51B8D310.4050404@linaro.org> <51D9548B.9040907@gmail.com> <alpine.DEB.2.02.1307071508030.32106@ionos.tec.linutronix.de> <20130707144645.GA11908@titan.lakedaemon.net> <alpine.DEB.2.02.1307071723220.32106@ionos.tec.linutronix.de>
 <20130707235819.GB11908@titan.lakedaemon.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Jul 2013, Jason Cooper wrote:
> On Sun, Jul 07, 2013 at 05:30:31PM +0200, Thomas Gleixner wrote:
> I don't mind delaying half of a series so the drivers/ portion can land
> in mainline, and the rest can land in the next cycle.  But when things
> don't go according to that plan, I'd like a little consideration /
> flexibility about solving the problem.  Especially considering I'm
> *trying* to do the right thing by pushing to appropriate maintainers
> first.
> 
> Of course, this is a moot point since, as you clarified above, this
> dependency doesn't have the hazards typically associated with
> out-of-tree dependencies.

There is a very simple procedure for stuff like this.

Series has parts which go through tree A and B and another larger part
for tree C which depends on the A and B parts.

So ask the maintainers of A and B to apply this to separate branches,
which are based on some commit in Linus tree. These branches can be
pulled into C and C can apply the depending stuff on top.

Now the maintainers of A and B merge these branches into their main
devel branch, can do further fixups and stuff on top. And the whole
thing just works without glitches during the merge window.

We do this all the time.

Thanks,

	tglx


