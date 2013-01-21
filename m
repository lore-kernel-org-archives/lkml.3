Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab3AUILe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 03:11:34 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57985 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab3AUILc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 03:11:32 -0500
Date: Mon, 21 Jan 2013 09:11:29 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Anton Vorontsov <anton@enomsg.org>
Cc: Andrew Lunn <andrew@lunn.ch>,
        linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] power: reset: qnap-poweroff: Fix License String
Message-ID: <20130121081129.GP8668@pengutronix.de>
References: <20130106215509.GD26928@lizard.sbx05280.losalca.wayport.net>
 <1357668926-20598-1-git-send-email-andrew@lunn.ch>
 <20130120201336.GO8668@pengutronix.de>
 <20130120204728.GA16339@lizard.gateway.2wire.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130120204728.GA16339@lizard.gateway.2wire.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Anton,

On Sun, Jan 20, 2013 at 12:47:29PM -0800, Anton Vorontsov wrote:
> On Sun, Jan 20, 2013 at 09:13:36PM +0100, Uwe Kleine-König wrote:
> > On Tue, Jan 08, 2013 at 07:15:26PM +0100, Andrew Lunn wrote:
> > > GPLv2+ is not a valid license string. Replace it with one that is.
> > > 
> > > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > > ---
> > >  drivers/power/reset/qnap-poweroff.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/power/reset/qnap-poweroff.c b/drivers/power/reset/qnap-poweroff.c
> > > index ca0b476..8af772b 100644
> > > --- a/drivers/power/reset/qnap-poweroff.c
> > > +++ b/drivers/power/reset/qnap-poweroff.c
> > > @@ -121,4 +121,4 @@ module_platform_driver(qnap_power_off_driver);
> > >  
> > >  MODULE_AUTHOR("Andrew Lunn <andrew@lunn.ch>");
> > >  MODULE_DESCRIPTION("QNAP Power off driver");
> > > -MODULE_LICENSE("GPLv2+");
> > > +MODULE_LICENSE("GPL v2");
> > This change is wrong.
> > 
> > According to include/linux/module.h "GPL v2" means exactly that: version
> > 2. As the file specifies v2 or later in the header you have to use "GPL"
> > which means v2 or later.
> 
> Does it even make sense to have the two separate things ("GPL v2" and
> "GPL")?
Yeah. If you had another OS project that uses GPL-4 you can just copy
over a GPL-2+ driver to it, not an GPL-2 driver. So assuming the kernel
will stay at GPL-2 forever it doesn't make any difference for the
kernel. But other projects might benefit. (And if in the future someone
might want to change the kernel to GPL-4, she only needs to contact the
GPL-2 authors and can legally change GPL-2+ to GPL-4+.)

> Suppose there is a global change that modifies a bunch of drivers, some of
> them are GPLv2+. Now, the author of the global change is submitting it
> under "GPL v2 only" license, which, by definition, turns any GPLv2+ code
> into "GPL v2 only", right?
See http://yarchive.net/comp/linux/dual_license_bsd_gpl.html for Linus'
POV. It's an old mail, but I think it still applies.

> So, changing from GPLv2+ to "GPL v2 only" is OK, but not the other way
> around.
OK as in (probably) legal. OK as in fair is questionable.

> IANAL, tho.
ditto.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
