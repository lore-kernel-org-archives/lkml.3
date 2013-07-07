Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab3GGNKh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 09:10:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:49970 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab3GGNKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 09:10:24 -0400
Date: Sun, 7 Jul 2013 15:10:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [GIT PULL] clockevents/clocksource: Add Marvell Orion SoC
 timer
In-Reply-To: <51D9548B.9040907@gmail.com>
Message-ID: <alpine.DEB.2.02.1307071508030.32106@ionos.tec.linutronix.de>
References: <51B8D310.4050404@linaro.org> <51D9548B.9040907@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Jul 2013, Sebastian Hesselbarth wrote:
> > ----------------------------------------------------------------
> > Sebastian Hesselbarth (1):
> >        clocksource: Add Marvell Orion SoC timer
> 
> with tip timers/core PR sent, I realized that the above did not make it
> in. As we have a whole bunch of cleanup and DT conversion patches for

Opps. Fell through the cracks.

> v3.11-rc1 depending on it, would it be ok for you to let Jason Cooper
> take it through his ARM sub-branch?

> If you are fine with it, I will resend the patch and note that Daniel
> can drop it and Jason will take it.

Nah, Jason can just pull it from Daniels tree and be done with it.

Thanks,

	tglx
