Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbaG2PaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:30:08 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:16387 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753605AbaG2PaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:30:05 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+tIGhmSUIXWQTUj55+MOvA
Date: Tue, 29 Jul 2014 08:28:38 -0700
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        bcousson@baylibre.com, linux@arm.linux.org.uk,
        khilman@deeprootsystems.com, tglx@linutronix.de, jason@lakedaemon.net,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 30/35] irqchip: add irq-omap-intc.h header
Message-ID: <20140729152838.GW29045@atomide.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
 <1406582183-696-31-git-send-email-balbi@ti.com>
 <20140729120133.GQ29045@atomide.com>
 <20140729141045.GA17808@saruman.home>
 <20140729150655.GU29045@atomide.com>
 <20140729151936.GC17808@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729151936.GC17808@saruman.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [140729 08:22]:
> On Tue, Jul 29, 2014 at 08:06:55AM -0700, Tony Lindgren wrote:
> > * Felipe Balbi <balbi@ti.com> [140729 07:13]:
> > > This is the third time I rebase the series after a long hiatus and it
> > > always comes out to the same result -> "let's wait some more".
> > 
> > Nope, it's always been "this series causes PM regressions"
> 
> you just said that we haven't been in any position to really test this,
> so can it be that the status has always been "this series causes PM
> regressions". We couldn't test that before, right ?

It's been working for legacy booting for years with the mainline
kernel, but not for device tree based booting until with v3.16-rc4.
I believe I tested your earlier series with my pending DT patches
though.
 
> > and few other minor comments. And we have not been in any
> > position to really test that until with v3.16-rc4. And then
> > you always run out of time and nobody else does anything :)
> 
> sure, I have other stuff to do as well.

Right :) I and others can provide some help here, but it's
the mr. patch author that needs to follow up on this series
too :p

Regards,

Tony
