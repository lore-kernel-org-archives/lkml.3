Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaFMNlf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 09:41:35 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:54368 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbaFMNlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 09:41:32 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+s5fX32U2IYXWCnyVKNHK8NT14B9Al4KU=
X-DKIM: OpenDKIM Filter v2.0.1 titan 33F8A58ECB7
Date: Fri, 13 Jun 2014 09:41:21 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Sricharan R <r.sricharan@ti.com>, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, nm@ti.com,
        rnayak@ti.com, linux@arm.linux.org.uk, tglx@linutronix.de
Subject: Re: [PATCH V2 03/19] irqchip: crossbar: Skip some irqs from
 getting mapped to crossbar
Message-ID: <20140613134121.GL8664@titan.lakedaemon.net>
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
 <1402574007-13987-4-git-send-email-r.sricharan@ti.com>
 <20140612125134.GS8664@titan.lakedaemon.net>
 <20140612135715.GE17845@atomide.com>
 <20140612140508.GC8664@titan.lakedaemon.net>
 <539AA08A.7010001@ti.com>
 <20140613131005.GF8664@titan.lakedaemon.net>
 <539AFE18.3020706@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539AFE18.3020706@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 09:35:20AM -0400, Santosh Shilimkar wrote:
> On Friday 13 June 2014 09:10 AM, Jason Cooper wrote:
...
> > Have you tried booting all the different scenarios?  eg:
> > 
> >   old dtb, new driver
> >   new dtb, old driver
> >   old dtb, old driver
> >   new dtb, new driver
> > 
> Old driver wasn't complete as mentioned and hence the above
> combinations becomes bit irrelevant.

Ahh, great!  In that case, I think we should be good without the
dependency between the code changes and the dtsi changes.

thx,

Jason.
