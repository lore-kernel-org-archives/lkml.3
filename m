Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762718Ab3DCRGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 13:06:35 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51239 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762605Ab3DCRGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 13:06:33 -0400
Date: Wed, 3 Apr 2013 19:06:30 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Christian Gmeiner <christian.gmeiner@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        linux-i2c@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] watchdog: Add Congatec CGEB watchdog driver
Message-ID: <20130403170630.GZ1906@pengutronix.de>
References: <1360663374-30951-1-git-send-email-s.hauer@pengutronix.de>
 <1360663374-30951-4-git-send-email-s.hauer@pengutronix.de>
 <CAH9NwWd7YdtK0urutisVgKoE7NmPFLpG3wFG5W6P7o45vUqAng@mail.gmail.com>
 <20130326143331.GA5529@roeck-us.net>
 <20130403150952.GX1906@pengutronix.de>
 <20130403153000.GA30641@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130403153000.GA30641@roeck-us.net>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 19:03:02 up 284 days,  8:14, 60 users,  load average: 11.24, 11.41,
 11.23
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 08:30:00AM -0700, Guenter Roeck wrote:
> On Wed, Apr 03, 2013 at 05:09:52PM +0200, Sascha Hauer wrote:
> [ ... ]
> 
> > > 
> > > On a side note, if the driver supports devicetree, it might make sense to call
> > > watchdog_init_timeout, since it initializes the timeout from devicetree data.
> > 
> > The driver does not support devicetree.
> > 
> I should have said "the system". Calling watchdog_init_timeout is the only thing
> a watchdog driver has to do to support devicetree.

The system does not use devicetrees. I'm very familiar with devicetrees
on ARM, but I have never seen a x86 system with devicetree support
(although I know they exist)

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
