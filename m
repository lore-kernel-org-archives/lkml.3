Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbaA1Rfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:35:53 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:39478 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754817AbaA1Rfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:35:51 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19QDz8x93XZFgYjQcxOX4X+W9JucwVX+pU=
X-DKIM: OpenDKIM Filter v2.0.1 titan 9348C5172ED
Date: Tue, 28 Jan 2014 12:35:31 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] irqchip: dove: drivers for v3.14
Message-ID: <20140128173531.GT29184@titan.lakedaemon.net>
References: <20131201172914.GV2879@titan.lakedaemon.net>
 <20131211175037.GY10053@titan.lakedaemon.net>
 <20140110183430.GO19878@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140110183430.GO19878@titan.lakedaemon.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

On Fri, Jan 10, 2014 at 01:34:30PM -0500, Jason Cooper wrote:
> On Wed, Dec 11, 2013 at 12:50:37PM -0500, Jason Cooper wrote:
> > On Sun, Dec 01, 2013 at 12:29:14PM -0500, Jason Cooper wrote:
> > > Here's an mvebu driver we've had on the ML for a while, and it's been in
> > > -next for 5 days.
> > 
> > Just checking to make sure this hasn't slipped off of your plate.
> > 
> 
> I'm not able to see where this one might have been pulled, could you
> please pull or let me know if it's not acceptable?

I see you pulled in mvebu/irqchip-fixes.  Thanks for that.  It's getting
near to the end of the merge window and there's been no activity on this
pull request.

Please let us know if there's anything we can do to assist.

thx,

Jason.

> > > The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:
> > > 
> > >   Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)
> > > 
> > > are available in the git repository at:
> > > 
> > >   git://git.infradead.org/linux-mvebu.git tags/mvebu-irqchip-3.14
> > > 
> > > for you to fetch changes up to 40b367d95fb3d60fc1edb9ba8f6ef52272e48936:
> > > 
> > >   irqchip: irq-dove: Add PMU interrupt controller. (2013-11-26 15:04:53 +0000)
> > > 
> > > ----------------------------------------------------------------
> > > mvebu irqchip changes for v3.14
> > > 
> > >  - add Dove PMU interrupt controller
> > > 
> > > ----------------------------------------------------------------
> > > Andrew Lunn (1):
> > >       irqchip: irq-dove: Add PMU interrupt controller.
> > > 
> > >  .../interrupt-controller/marvell,dove-pmu-intc.txt |  17 +++
> > >  drivers/irqchip/Makefile                           |   1 +
> > >  drivers/irqchip/irq-dove.c                         | 126 +++++++++++++++++++++
> > >  3 files changed, 144 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/interrupt-controller/marvell,dove-pmu-intc.txt
> > >  create mode 100644 drivers/irqchip/irq-dove.c
> > > 
> > > _______________________________________________
> > > linux-arm-kernel mailing list
> > > linux-arm-kernel@lists.infradead.org
> > > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> > 
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
