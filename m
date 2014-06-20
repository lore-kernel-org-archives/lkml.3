Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967150AbaFTWJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 18:09:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:34324 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966137AbaFTWJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 18:09:58 -0400
Date: Sat, 21 Jun 2014 00:09:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Florian Fainelli <f.fainelli@gmail.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH] irqchip: brcmstb-l2: Level-2 interrupts are edge
 sensitive
In-Reply-To: <CAGVrzcbpS0tJtkH5vkGRSteV5NU2CzNNkQ43_26XySFqJMAK5A@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1406202357280.5170@nanos>
References: <1402337102-19428-1-git-send-email-f.fainelli@gmail.com> <CAGVrzcZmakEpNW=vGtsb+OmzU_J4hJNoM1sUAoYNsaju_YzGwQ@mail.gmail.com> <CAGVrzcbpS0tJtkH5vkGRSteV5NU2CzNNkQ43_26XySFqJMAK5A@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2014, Florian Fainelli wrote:
> 2014-06-12 12:13 GMT-07:00 Florian Fainelli <f.fainelli@gmail.com>:
> > 2014-06-09 11:05 GMT-07:00 Florian Fainelli <f.fainelli@gmail.com>:
> >> The driver was configuring the interrupt handler for the Level-2
> >> interrupts to be "level" triggered while they are in fact "edge"
> >> triggered. Fix this by using the correct handler.
> >>
> >> Reported-by: Brian Norris <computersforpeace@gmail.com>
> >> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> >
> > Jason, Thomas, this driver just got merged into 3.16-rc0, can you
> > carry this fix such that it gets into a future 3.16-rc? Thanks!
> 
> Ping! I want to make sure this gets into a next 3.16-rc pull request.
> Andrew, can you take that one if neither Thomas nor Andrew respond in
> a timely manner?

So Andrew should take it if neither Thomas nor Andrew respond. I'm
curious how that works out.

Dude, keep calm. Timely manner?

For something you brought yourself into the merge window and does not
bring the world to a grinding halt like a nasty NULL pointer
dereference in the scheduler?

I have no problem with a polite reminder as stuff falls down the
cracks occassionaly, but please keep the proportions right. The only
user of the code YOU wreckaged has a bugfix already, so what's the
problem whether this hits rc2 or rc3?

Thanks,

	tglx

