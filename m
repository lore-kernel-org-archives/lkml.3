Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab3GGPab (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 11:30:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:50193 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab3GGPaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 11:30:30 -0400
Date: Sun, 7 Jul 2013 17:30:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jason Cooper <jason@lakedaemon.net>
cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [GIT PULL] clockevents/clocksource: Add Marvell Orion SoC
 timer
In-Reply-To: <20130707144645.GA11908@titan.lakedaemon.net>
Message-ID: <alpine.DEB.2.02.1307071723220.32106@ionos.tec.linutronix.de>
References: <51B8D310.4050404@linaro.org> <51D9548B.9040907@gmail.com> <alpine.DEB.2.02.1307071508030.32106@ionos.tec.linutronix.de> <20130707144645.GA11908@titan.lakedaemon.net>
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
> Sure, but to be clear, Daniel, please drop this patch from your tree.  I
> have no desire to create an out-of-tree dependency if we can avoid it.
> It has a habit of going horribly wrong [1].
> 
> I'll cherry-pick
> 
>   0c1dcfd clocksource: Add Marvell Orion SoC timer

Don't do that. Do a git fetch on that branch and then git merge
0c1dcfd. The patches before that Marvel commit are already in Linus
tree. That way it does not matter who sends first or not.

We don't force others to drop stuff and cherry picking is a nuisance
as well as you end up with two different commits doing the same thing.

Also for the next merge window: Can we please let everything under
drivers/clocksoure go through Daniels and my trees?

I'm starting to be grumpy about anyone thinking that this directory is
a public dump ground with no rules.

Thanks,

	tglx




