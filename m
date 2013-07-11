Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646Ab3GKJMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 05:12:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51221 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932611Ab3GKJMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 05:12:47 -0400
Date: Thu, 11 Jul 2013 11:12:44 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Hector Palacios <hector.palacios@digi.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>,
        Marek Vasut <marex@denx.de>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>
Subject: Re: MXS persistent bits driver
Message-ID: <20130711091244.GC31410@pengutronix.de>
References: <51DE5F1A.8010209@digi.com>
 <51DE624C.1080208@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51DE624C.1080208@digi.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:08:18 up 27 days, 21:18, 24 users,  load average: 0.04, 0.08,
 0.05
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 09:44:12AM +0200, Hector Palacios wrote:
> On 07/11/2013 09:30 AM, Hector Palacios wrote:
> >Greetings,
> >
> >Linux 2.6.35 had a driver for sysfs access to the MXS persistent bits
> >(drivers/misc/mxs-persistent.c).
> >I haven't seen this is supported upstream. Is anybody working on that?
> >Where would such a driver fit?
> 
> Adding Steffen Trumtrar, as I came across his patch:
> http://permalink.gmane.org/gmane.linux.drivers.devicetree/31370
> 
> @Steffen, was there no answer to your questions about these being binary attributes?

Hi!

I didn't work on the driver after the v2 and lost track about its whereabouts.
As far as I can see, I didn't get any answers regarding the binary attributes.


Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
