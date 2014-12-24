Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaLXWfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 17:35:21 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41455 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbaLXWfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 17:35:19 -0500
Date: Wed, 24 Dec 2014 23:35:16 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        bcousson@baylibre.com, sakari.ailus@iki.fi, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, j.anaszewski@samsung.com,
        apw@canonical.com, joe@perches.com
Subject: Re: [PATCH] media: i2c/adp1653: devicetree support for adp1653
Message-ID: <20141224223516.GB20669@amd>
References: <20141203214641.GA1390@amd>
 <20141223152325.75e8cb4a@concha.lan.sisa.samsung.com>
 <20141223204903.GA1780@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141223204903.GA1780@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-12-23 21:49:04, Pavel Machek wrote:
> On Tue 2014-12-23 15:23:25, Mauro Carvalho Chehab wrote:
> > Em Wed, 3 Dec 2014 22:46:41 +0100
> > Pavel Machek <pavel@ucw.cz> escreveu:
> > 
> > > 
> > > We are moving to device tree support on OMAP3, but that currently
> > > breaks ADP1653 driver. This adds device tree support, plus required
> > > documentation.
> > > 
> > > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > 
> > Please be sure to check your patch with checkpatch. There are several
> > issues on it:

Ok, you should have fixed version in your inbox.

Happy holidays!
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
