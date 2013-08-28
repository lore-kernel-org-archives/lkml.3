Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab3H1SzH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 14:55:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54787 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab3H1SzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 14:55:05 -0400
Date: Wed, 28 Aug 2013 20:54:59 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] imx-drm: Fix probe failure
Message-ID: <20130828185459.GV30088@pengutronix.de>
References: <1377657163-6606-1-git-send-email-festevam@gmail.com>
 <20130828052758.GQ30088@pengutronix.de>
 <CAOMZO5BiE7tqja9p51gOGEwtWsKjyX23qZ3=ewyuubMwsgXcLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5BiE7tqja9p51gOGEwtWsKjyX23qZ3=ewyuubMwsgXcLA@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 20:54:26 up 4 days,  4:25, 38 users,  load average: 0.00, 0.04, 0.11
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 11:39:11AM -0300, Fabio Estevam wrote:
> On Wed, Aug 28, 2013 at 2:27 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> 
> > Nack. We need the references to prevent that encoders/connectors are
> > (de)registered while the device is active. Simply dropping this code is
> > no solution.
> 
> Any suggestions about a proper way of handling this?
> 
> After b5dc0d10, imx_drm_device_get() is called from
> imx_drm_driver_load(), which increments the 'references' very early
> now.

Do the open/close callbacks work?

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
