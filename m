Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056AbaGAMYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 08:24:08 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:19182 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaGAMYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 08:24:06 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+RN7bUHgH4BU5Gi2Du6MgLeFkqoUhJp6c=
X-DKIM: OpenDKIM Filter v2.0.1 titan 691B459F45A
Date: Tue, 1 Jul 2014 08:23:48 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sricharan R <r.sricharan@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, nm@ti.com, linux@arm.linux.org.uk,
        rnayak@ti.com, santosh.shilimkar@ti.com, joe@perches.com,
        tglx@linutronix.de
Subject: Re: [PATCH V4 00/16] irqchip: crossbar: Driver fixes
Message-ID: <20140701122348.GE23978@titan.lakedaemon.net>
References: <1403766634-18543-1-git-send-email-r.sricharan@ti.com>
 <20140630192910.GA23978@titan.lakedaemon.net>
 <20140701075930.GN28884@atomide.com>
 <53B28124.40509@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B28124.40509@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 03:06:36PM +0530, Sricharan R wrote:
> Hi Tony,
> 
> On Tuesday 01 July 2014 01:29 PM, Tony Lindgren wrote:
> > * Jason Cooper <jason@lakedaemon.net> [140630 12:30]:
> >>
> >> Whole series applied to irqchip/crossbar, I'll give it a day or two in
> >> -next, then I'll merge it into irqchip/core.
> >>
> >> Tony: Right now, it's immutable unless you tell me I applied something
> >> incorrectly.  Once it goes into irqchip/core, it's immutable no matter
> >> what you say. ;-)
> > 
> > Thanks, looks good to me. Sricharan and Nishant, can you please
> > check that we can now apply the related .dts changes on top of
> > Jason's branch at:
> > 
> > git://git.infradead.org/users/jcooper/linux.git irqchip/crossbar
> > 
> 
> I applied the dts patches on top of this and it worked fine for
> me on dra72 evm

Awesome, thanks.  irqchip/crossbar has been merged into irqchip/core.

thx,

Jason.
