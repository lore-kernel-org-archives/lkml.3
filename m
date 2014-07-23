Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758381AbaGWXnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 19:43:16 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:62957 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757992AbaGWXnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 19:43:15 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19w8xbfM8+4gtxrOXV3+YcC0Ue6l4W4n8U=
X-DKIM: OpenDKIM Filter v2.0.1 titan 4AB1A5B45A6
Date: Wed, 23 Jul 2014 19:42:56 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Benoit Masson <yahoo@perenite.com>, benoitm@perenite.com,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gregory.clement@free-electrons.com,
        sebastian.hesselbarth@googlemail.com
Subject: Re: [PATCH 2/2] ARM: mvebu: Added dts defintion for Lenovo Iomega
 ix4-300d NAS
Message-ID: <20140723234256.GN23220@titan.lakedaemon.net>
References: <1406155973-13657-1-git-send-email-yahoo@perenite.com>
 <20140723232715.GL23220@titan.lakedaemon.net>
 <20140723232909.GE28485@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140723232909.GE28485@lunn.ch>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 01:29:09AM +0200, Andrew Lunn wrote:
> > On Wed, Jul 23, 2014 at 03:52:53PM -0700, Benoit Masson wrote:
> > > The Lenovo Iomega ix4-300d is a 4-Bay sata NAS with dual Gb,
> > >  USB2.0 & 3.0, powered by a Marvell Armada XP MV78230 dual core CPU.
> > > 
> > > http://shop.lenovo.com/fr/fr/servers/network-storage/lenovoemc/ix4-300d/
> > > Signed-off-by: Benoit Masson <yahoo@perenite.com>
> > > ---
> > >  arch/arm/boot/dts/Makefile                      |   3 +-
> > >  arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts | 284 ++++++++++++++++++++++++
> > >  2 files changed, 286 insertions(+), 1 deletion(-)
> > >  create mode 100644 arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts
> > ...
> > > diff --git a/arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts b/arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts
> > > new file mode 100644
> > > index 0000000..1f33cbc
> > > --- /dev/null
> > > +++ b/arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts
> > ...
> > > +	/* Warning: you need both eth1 & 0 PHY initialized
> > > +		(i.e having them up does the tweak)
> > > +		for poweroff to shutdown otherwise it reboots */
> > 
> > nit: multi-line comments are like this:
> > 
> > 	/*
> > 	 * Warning: you need both eth1 & 0 PHY initialized (i.e having
> > 	 * them up does the tweak) for poweroff to shutdown otherwise it
> > 	 * reboots
> > 	 */
> > 
> > If that's the only thing left, I'll fix it up when I pull it in.  No
> > need to respin just for this.
> 
> Hi Jason
> 
> We should not really leave the i2c compatibility string as it is.

Agreed.

> Hopefully the OEM moved onto B1 stepping at some point.  Although B1
> devices will work with the workaround, you get better performance
> without it.
> 
> We should wait for Gregory to look at the quirk and soc-id code.

Yep.

thx,

Jason.
