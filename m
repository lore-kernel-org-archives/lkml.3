Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759030Ab3HNDhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 23:37:01 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49698 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759359Ab3HNDg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 23:36:57 -0400
Date: Wed, 14 Aug 2013 05:36:51 +0200
From: Michael Grzeschik <mgr@pengutronix.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mc13xxx-ts: use zero as default value if no pdata was
 defined
Message-ID: <20130814033651.GH9885@pengutronix.de>
References: <1376396070-24507-1-git-send-email-m.grzeschik@pengutronix.de>
 <20130813164609.GA21548@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130813164609.GA21548@core.coreip.homeip.net>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 05:34:43 up 14 days, 12:38, 18 users,  load average: 0.05, 0.04,
 0.05
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dimitry,

On Tue, Aug 13, 2013 at 09:46:09AM -0700, Dmitry Torokhov wrote:
> Hi Michael,
> 
> On Tue, Aug 13, 2013 at 02:14:30PM +0200, Michael Grzeschik wrote:
> > In case of devicetree, we currently don't have a way to append pdata for
> > the touchscreen. The current approach is to bail out in that case.
> > This patch makes it possible to probe the touchscreen without pdata
> > and use zero as default values for the atox and ato adc conversion.
> 
> I'd rather you added the devicetree support to the driver.

I know that we will need real devictree glue that generates pdata in the
long run. I am working on that. Beside that, for now this patch makes
sense anyway.

Regards,
Michael

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
