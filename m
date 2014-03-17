Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404AbaCQIRQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 04:17:16 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37359 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932251AbaCQIRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 04:17:14 -0400
Date: Mon, 17 Mar 2014 09:17:07 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Landley <rob@landley.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH] spi: dw-mmio: add oftree support
Message-ID: <20140317081707.GQ27506@pengutronix.de>
References: <1394787326-14520-1-git-send-email-s.trumtrar@pengutronix.de>
 <20140314161403.GN25870@e106331-lin.cambridge.arm.com>
 <20140314162614.GW366@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140314162614.GW366@sirena.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:12:03 up 204 days, 17:42, 41 users,  load average: 0,49, 0,40,
 0,32
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Fri, Mar 14, 2014 at 04:26:14PM +0000, Mark Brown wrote:
> On Fri, Mar 14, 2014 at 04:14:03PM +0000, Mark Rutland wrote:
> 
> > > +Synopsys DesignWare SPI master controller.
> > > +
> > > +Required properties:
> > > +- compatible : "snps,dw-spi-mmio"
> 
> > Is there not a better name than "dw-spi-mmio"?
> 
> > What's the full name of the device, as on a datasheet? Is there no model
> > number?
> 
> It's a Synopsis Designware IP block rather than a part - Google suggests
> DW_apb_ssi.

That seems to be the correct IP block, so I will change the compatible to
"snps,dw-apb-ssi".

Thanks,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
