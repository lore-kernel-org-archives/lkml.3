Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbaCAQB1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 11:01:27 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34485 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752891AbaCAQB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 11:01:26 -0500
Date: Sat, 1 Mar 2014 16:01:14 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: James Hogan <james.hogan@imgtec.com>, grant.likely@linaro.org,
        linus.walleij@linaro.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] irq: Changed the return type of irq_chip.irq_startup()
	from unsigned int to int
Message-ID: <20140301160114.GE21483@n2100.arm.linux.org.uk>
References: <CACh+v5Nkuct0J65OHcnSd6Dfq4EyfafY8RpTvdwKXUA7A8_+Xw@mail.gmail.com> <1393521679-32331-1-git-send-email-jjhiblot@traphandler.com> <7150036.UpHTd1PK1K@radagast> <alpine.DEB.2.02.1403011629540.18573@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1403011629540.18573@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 01, 2014 at 04:31:13PM +0100, Thomas Gleixner wrote:
> On Fri, 28 Feb 2014, James Hogan wrote:
> > On Thursday 27 February 2014 18:21:19 Jean-Jacques Hiblot wrote:
> > >  drivers/irqchip/irq-metag.c               | 4 ++--
> > 
> > I think you've missed out drivers/irqchip/irq-metag-ext.c
> 
> There is a good reason why I asked to do this with coccinelle.

Go easy, not everyone understands that complex tool - I certainly don't.
I ended up deleting it from my system after several failed attempts, and
I came to the conclusion that to use it properly, you also needed a Julia
installed along side you to learn how to write its scripts.

The big problem is it /doesn't/ do what it advertises to - I ended up
writing expression after expression to make it detect all the various
forms of what I wanted it to, which as I understand the tool is precisely
the opposite of what you're supposed to do with it.

I ended up coming to the conclusion that a well formed sed and/or grep
expression was far more useful and effective than trying to figure out
coccinelle.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
