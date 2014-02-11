Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbaBKTHF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:07:05 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:33617 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587AbaBKTG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:06:59 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19u7+PplGLFYqF3B+0n93NLYkXLZsrg5iQ=
X-DKIM: OpenDKIM Filter v2.0.1 titan 171B3524BE3
Date: Tue, 11 Feb 2014 14:06:32 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Lior Amsalem <alior@marvell.com>,
        devicetree@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Tawfik Bayouk <tawfik@marvell.com>, linux-kernel@vger.kernel.org,
        Nadav Haklai <nadavh@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 6/6] dt: Update binding information for mvebu gating
 clocks with Armada 380/385
Message-ID: <20140211190632.GE27395@titan.lakedaemon.net>
References: <1392053569-28037-1-git-send-email-gregory.clement@free-electrons.com>
 <1392053569-28037-7-git-send-email-gregory.clement@free-electrons.com>
 <20140210175350.GD9995@lunn.ch>
 <20140210185908.3374eaf6@skate>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210185908.3374eaf6@skate>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 06:59:08PM +0100, Thomas Petazzoni wrote:
> Dear Andrew Lunn,
> 
> On Mon, 10 Feb 2014 18:53:50 +0100, Andrew Lunn wrote:
> > > +The following is a list of provided IDs for Armada 380/385:
> > > +ID	Clock		Peripheral
> > > +-----------------------------------
> > > +0	audio		Audio
> > > +2	ge2		Gigabit Ethernet 2
> > > +3	ge1		Gigabit Ethernet 1
> > > +4	ge0		Gigabit Ethernet 0
> > > +5	pex1		PCIe 1
> > > +6	pex2		PCIe 2
> > > +7	pex3		PCIe 3
> > > +8	pex4		PCIe 0
> > 
> > Is that last one a typo? It at least looks a bit odd.
> 
> Right, this should be:
> 
> 	8	pex0		PCIe 0
> 
> (just checked again in the datasheet)

I can fix this up when I pull it in for Mike.  No need to redo the
series just for this.

I'll let it sit for a day or two more before I pull it to give everyone
a chance to look it over.

thx,

Jason.

> 
> Thomas
> -- 
> Thomas Petazzoni, CTO, Free Electrons
> Embedded Linux, Kernel and Android engineering
> http://free-electrons.com
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
