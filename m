Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab3F0HYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 03:24:13 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49772 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab3F0HYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 03:24:11 -0400
Date: Thu, 27 Jun 2013 09:24:08 +0200
From: Michael Grzeschik <mgr@pengutronix.de>
To: Felipe Balbi <balbi@ti.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        George Cherian <george.cherian@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-omap@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] usb: dwc3: core: continue probe even if usb3 phy is
 not available
Message-ID: <20130627072408.GJ3523@pengutronix.de>
References: <1372238954-29047-1-git-send-email-george.cherian@ti.com>
 <20130626101647.GT12640@arwen.pp.htv.fi>
 <51CAD977.6040309@ti.com>
 <20130626121210.GA12640@arwen.pp.htv.fi>
 <874nclghu2.fsf@ashishki-desk.ger.corp.intel.com>
 <20130627061416.GI3523@pengutronix.de>
 <20130627063526.GG15455@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130627063526.GG15455@arwen.pp.htv.fi>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:19:27 up 13 days, 19:29, 17 users,  load average: 0.03, 0.04,
 0.05
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 27, 2013 at 09:35:26AM +0300, Felipe Balbi wrote:
> Hi,
> 
> On Thu, Jun 27, 2013 at 08:14:16AM +0200, Michael Grzeschik wrote:
> > > > right, but in DT you will define both instances and each instance will
> > > > have a seaparate snps,maximum_speed attribute :-)
> > > >
> > > > I'm now considering if we should make maximum_speed a generic attribute,
> > > > Kishon ? Alex ? Alan ?
> > > >
> > > > anyone else needs such thing ?
> > > 
> > > We have a force-full-speed attibute for chipidea on the way. This
> > > maximum_speed looks like a more generic alternative. Michael, what say
> > > you?
> > 
> > The maximum_speed attribute sounds more reasonable. I will change my
> > patch to it.
> 
> thanks, perhaps we can add a generic helper in udc-core or usb-common ?

As this function is not only udc specific, this should go into usb-common.
But right, we should go with a helper here. I will write one in addition
to my full-speed patch as first user of it.

Thanks,
Michael

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
