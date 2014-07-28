Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbaG1Nax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:30:53 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:42876 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbaG1NaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:30:24 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+ZESK1DCBkX+eupJ3XH0ORR/UBMnV6gXU=
X-DKIM: OpenDKIM Filter v2.0.1 titan 434CC5B845D
Date: Mon, 28 Jul 2014 09:30:05 -0400
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
Subject: Re: [PATCH 2/2] V3 ARM: mvebu: Added dts defintion for Lenovo
 Iomega ix4-300d NAS
Message-ID: <20140728133005.GO23220@titan.lakedaemon.net>
References: <1406418490-61502-1-git-send-email-yahoo@perenite.com>
 <20140727015509.GB31974@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140727015509.GB31974@lunn.ch>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

On Sun, Jul 27, 2014 at 03:55:09AM +0200, Andrew Lunn wrote:
> On Sat, Jul 26, 2014 at 04:48:10PM -0700, Benoit Masson wrote:
> > The Lenovo Iomega ix4-300d is a 4-Bay sata NAS with dual Gb,
> >  USB2.0 & 3.0, powered by a Marvell Armada XP MV78230 dual core CPU.
> > 
> > http://shop.lenovo.com/us/en/servers/network-storage/lenovoemc/ix4-300d/
> > Signed-off-by: Benoit Masson <yahoo@perenite.com>
> > ---
> >  arch/arm/boot/dts/Makefile                      |   3 +-
> >  arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts | 285 ++++++++++++++++++++++++
> >  2 files changed, 287 insertions(+), 1 deletion(-)
> >  create mode 100644 arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts
> > 
...
> > diff --git a/arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts b/arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts
> > new file mode 100644
> > index 0000000..c82a8e3
> > --- /dev/null
> > +++ b/arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts
...
> > +			i2c@11000 {
> > +				compatible = "marvell,mv64xxx-i2c";
> 
> O.K, this version is good.

Is it?  As Arnd mentioned against the previous version, this overrides
the default compatible property inherited from the dtsi.  Since this is
also compatible with "marvell,mv78230-i2c", I think we should just
delete this line.

Benoit, this is still in V4.  If Andrew agrees, I'll just remove the
line when I apply V4.

> Acked-by: Andrew Lunn <andrew@lunn.ch>

thx,

Jason.
