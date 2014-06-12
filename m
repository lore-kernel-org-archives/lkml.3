Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933505AbaFLN5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 09:57:23 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:57540 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855AbaFLN5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 09:57:20 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX192VdrMx5ACyPK1gkkoxep/
Date: Thu, 12 Jun 2014 06:57:15 -0700
From: Tony Lindgren <tony@atomide.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Sricharan R <r.sricharan@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, santosh.shilimkar@ti.com, nm@ti.com,
        rnayak@ti.com, linux@arm.linux.org.uk, tglx@linutronix.de
Subject: Re: [PATCH V2 03/19] irqchip: crossbar: Skip some irqs from getting
 mapped to crossbar
Message-ID: <20140612135715.GE17845@atomide.com>
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
 <1402574007-13987-4-git-send-email-r.sricharan@ti.com>
 <20140612125134.GS8664@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140612125134.GS8664@titan.lakedaemon.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Cooper <jason@lakedaemon.net> [140612 05:52]:
> On Thu, Jun 12, 2014 at 05:23:11PM +0530, Sricharan R wrote:
> > From: Nishanth Menon <nm@ti.com>
> > 
> > When, in the system due to varied reasons, interrupts might be unusable
> > due to hardware behavior, but register maps do exist, then those interrupts
> > should be skipped while mapping irq to crossbars.
> > 
> > Signed-off-by: Nishanth Menon <nm@ti.com>
> > Signed-off-by: Sricharan R <r.sricharan@ti.com>
> > Signed-off-by: Tony Lindgren <tony@atomide.com>
> 
> Tony, have you applied these somewhere already?

I think some of these I had applied into a branch ready for
merging but then it was discovered that further changes
were needed and the branch was dropped.

Sricharan, please remove my Signed-off-by from this series.
If I end up applying it for merging my scripts will add it
automatically.

Regards,

Tony
