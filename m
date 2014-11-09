Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbaKITj5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 14:39:57 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50256 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaKITj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 14:39:56 -0500
Date: Sun, 9 Nov 2014 20:39:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mark Brown <broonie@debian.org>
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg, peter.ujfalusi@ti.com,
        perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org
Subject: Re: sound: enable sound support on n900 on devicetree-based boot
Message-ID: <20141109193953.GA7852@amd>
References: <20141109120222.GA3815@amd>
 <20141109123753.GO2722@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141109123753.GO2722@sirena.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2014-11-09 12:37:53, Mark Brown wrote:
> On Sun, Nov 09, 2014 at 01:02:22PM +0100, Pavel Machek wrote:
> > 
> > With device tree, it is possible (and encouraged) to build N900
> > kernels without CONFIG_MACH_NOKIA_RX51. Update config file to enable
> > the driver build in this case.
> 
> Please do try to use subject lines reflecting the style for the
> subsystem.

Ok.

> >  config SND_OMAP_SOC_RX51
> >  	tristate "SoC Audio support for Nokia RX-51"
> > -	depends on SND_OMAP_SOC && ARM && (MACH_NOKIA_RX51 || COMPILE_TEST) && I2C
> > +	depends on SND_OMAP_SOC && ARM && I2C
> 
> Please also update the config text so users have a chance to figure out
> that this driver is the one they need for their system - I guess most
> people won't know what RX-51 is.

Actually help text below already explains that. I'll update tristate
text, too.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
