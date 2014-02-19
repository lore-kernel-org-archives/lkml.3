Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbaBSPgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 10:36:04 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:57372 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753962AbaBSPgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 10:36:02 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18MzuZnQa6Sz88BYvWbGNn593MMITjjSvg=
X-DKIM: OpenDKIM Filter v2.0.1 titan A520652CCD0
Date: Wed, 19 Feb 2014 10:35:44 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] irqchip: mvebu fixes for v3.14
Message-ID: <20140219153544.GI7862@titan.lakedaemon.net>
References: <20140218162210.GU7862@titan.lakedaemon.net>
 <alpine.DEB.2.02.1402182122010.4468@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402182122010.4468@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 09:23:29PM +0100, Thomas Gleixner wrote:
> On Tue, 18 Feb 2014, Jason Cooper wrote:
> 
> > Thomas,
> > 
> > Here is a small round of fixes for irq-orion.c.  They've been in -next
> > for over a week.  Please pull.
> > 
> > We have a set of watchdog changes depending on this that are going
> > through mvebu/arm-soc.  So please don't rebase, just let me know if
> > there's something that isn't right.  I'll fix it up and resend.
> 
> Just a nit:
> 
> 12bd4f7: IRQ: Orion: Fix getting generic chip pointer.
> e0318ec: irqchip: orion: clear stale interrupts in irq_startup
> 5f40067: irqchip: orion: use handle_edge_irq on bridge irqs
> 7b119fd: irqchip: orion: clear bridge cause register on init

<looks at feet, kicks stones>

v2 on it's way.

thx,

Jason.
