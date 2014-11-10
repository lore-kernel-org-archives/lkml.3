Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbaKJXrD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 18:47:03 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:61974 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaKJXrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 18:47:01 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+A7j6uxRGtVGCB7g260UgQ
Date: Mon, 10 Nov 2014 15:46:16 -0800
From: Tony Lindgren <tony@atomide.com>
To: Tom Rini <trini@ti.com>
Cc: Nishanth Menon <nm@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-omap@vger.kernel.org, balbi@ti.com, gerald@granddesignsgroup.com,
        fcooper@ti.com, beagleboard@googlegroups.com
Subject: Re: [PATCH POST V2] ARM: dts: Add am57xx-beagle-x15
Message-ID: <20141110234615.GF31454@atomide.com>
References: <1415382433-31772-1-git-send-email-nm@ti.com>
 <545D1150.9000700@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545D1150.9000700@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tom Rini <trini@ti.com> [141107 10:38]:
> On 11/07/2014 12:47 PM, Nishanth Menon wrote:
> > BeagleBoard-X15 is the next generation Open Source Hardware
> > BeagleBoard based on TI's AM5728 SoC featuring dual core 1.5GHz A15
> > processor. The platform features 2GB DDR3L (w/dual 32bit busses),
> > eSATA, 3 USB3.0 ports, integrated HDMI (1920x1080@60), separate LCD
> > port, video In port, 4GB eMMC, uSD, Analog audio in/out, dual 1G
> > Ethernet.
> > 
> > For more information, refer to:
> > BeagleBoard-X15 Wiki:
> > http://www.elinux.org/Beagleboard:BeagleBoard-X15
> > 
> > AM5728 is part of the Sitara product family whose additional details
> > will be available: http://www.ti.com/lsds/ti/arm/overview.page
> > 
> > Technical Reference Manual for AM5728 is public domain at:
> > http://www.ti.com/lit/spruhz6
> > 
> > Just add basic support for the moment, the following updates are needed:
> >   i)	Ethernet - depends on SoC dts fixes
> >   ii)	USB Client (USB2) - depends on GPIO extcon
> >   ii)	HDMI - additional driver fixes pending
> >   iii)	Audio - additional driver fixes pending
> > 
> > NOTE:
> > AM5728 Data Manual (SPRS915L - August 2014) section 4.1.1 states: "All
> > unused power supply balls must be supplied with the voltages specified
> > in the Section 5.2, Recommended Operating Conditions". This implies
> > that all unused voltage rails for AM5728 can never be switched off even
> > if the hardware blocks inside that voltage domain is unused. Switching
> > off these unused rails may result in stability issues on other domains
> > and increased leakage and power-on-hour impacts.
> > 
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > Signed-off-by: Nishanth Menon <nm@ti.com>
> 
> Reviewed-by: Tom Rini <trini@ti.com>

Applying into omap-for-v3.19/dt thanks.

Tony
