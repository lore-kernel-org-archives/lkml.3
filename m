Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbaF0MCI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 08:02:08 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:51734 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752868AbaF0MCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 08:02:05 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/OH5JnNUaAop3PMQ6+J1VONKGBTH4cJl4=
X-DKIM: OpenDKIM Filter v2.0.1 titan 1A7D659BA03
Date: Fri, 27 Jun 2014 08:01:51 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Tony Lindgren <tony@atomide.com>
Cc: Sricharan R <r.sricharan@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, santosh.shilimkar@ti.com, nm@ti.com,
        rnayak@ti.com, linux@arm.linux.org.uk, tglx@linutronix.de,
        joe@perches.com
Subject: Re: [PATCH V4 00/16] irqchip: crossbar: Driver fixes
Message-ID: <20140627120151.GC23978@titan.lakedaemon.net>
References: <1403766634-18543-1-git-send-email-r.sricharan@ti.com>
 <20140626074209.GE28884@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140626074209.GE28884@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 12:42:09AM -0700, Tony Lindgren wrote:
> * Sricharan R <r.sricharan@ti.com> [140626 00:14]:
> > This series does some cleanups, fixes for handling two interrupts
> > getting mapped twice to same crossbar and provides support for
> > hardwired IRQ and crossbar definitions.
> > 
> > On certain platforms such as DRA7, SPIs 0, 1, 2, 3, 5, 6, 10,
> > 131, 132, 133 are direct wired to hardware blocks bypassing
> > crossbar. This quirky implementation is *NOT* supposed to be the
> > expectation of crossbar hardware usage. This series adds support
> > to represent such hard-wired irqs through DT and avoid generic
> > allocation/programming of crossbar in the driver.
> > 
> > This way of supporting hard-wired irqs was a result of
> > the below discussions.
> > http://www.spinics.net/lists/arm-kernel/msg329946.html
> > 
> > Based on 3.16 rc2 mainline.
> 
> Jason, once these patches look OK for merging, can you please
> set them up into an immutable branch so I too can merge them in?

Sure thing.

thx,

Jason.
