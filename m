Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbaBRUX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 15:23:26 -0500
Received: from www.linutronix.de ([62.245.132.108]:45594 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaBRUXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 15:23:25 -0500
Date: Tue, 18 Feb 2014 21:23:29 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jason Cooper <jason@lakedaemon.net>
cc: Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] irqchip: mvebu fixes for v3.14
In-Reply-To: <20140218162210.GU7862@titan.lakedaemon.net>
Message-ID: <alpine.DEB.2.02.1402182122010.4468@ionos.tec.linutronix.de>
References: <20140218162210.GU7862@titan.lakedaemon.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Feb 2014, Jason Cooper wrote:

> Thomas,
> 
> Here is a small round of fixes for irq-orion.c.  They've been in -next
> for over a week.  Please pull.
> 
> We have a set of watchdog changes depending on this that are going
> through mvebu/arm-soc.  So please don't rebase, just let me know if
> there's something that isn't right.  I'll fix it up and resend.

Just a nit:

12bd4f7: IRQ: Orion: Fix getting generic chip pointer.
e0318ec: irqchip: orion: clear stale interrupts in irq_startup
5f40067: irqchip: orion: use handle_edge_irq on bridge irqs
7b119fd: irqchip: orion: clear bridge cause register on init

Can you see it ?

Thanks,

	tglx

