Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbaEOJft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 05:35:49 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47905 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbaEOJfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 05:35:47 -0400
Message-ID: <1400146519.4102.30.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH v2 2/3] drm/panel: add support for EDT panels
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Stefan Agner <stefan@agner.ch>, swarren@wwwdotorg.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, marcel@ziswiler.com
Date: Thu, 15 May 2014 11:35:19 +0200
In-Reply-To: <20140515091220.GC6434@ulmo>
References: <cover.1400103181.git.stefan@agner.ch>
	 <35c081171a3d9a9401767601c02a12e266b37dd0.1400103181.git.stefan@agner.ch>
	 <20140515075102.GE5952@ulmo> <4de1d09b7873e012e43525c1f8ab9c66@agner.ch>
	 <20140515091220.GC6434@ulmo>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 15.05.2014, 11:12 +0200 schrieb Thierry Reding:
> On Thu, May 15, 2014 at 10:24:39AM +0200, Stefan Agner wrote:
> > Hi Thierry, hi Philipp,
> > 
> > Am 2014-05-15 09:51, schrieb Thierry Reding:
> > > On Wed, May 14, 2014 at 11:45:57PM +0200, stefan@agner.ch wrote:
> > >> From: Stefan Agner <stefan@agner.ch>
> > >>
> > >> This panels are sold by Toradex for Colibri T20/T30 and Apalis T30
> > >> evaluation kits.
> > >>
> > >> Signed-off-by: Stefan Agner <stefan@agner.ch>
> > > 
> > > Panel patches should go to the dri-devel mailing list as well.
> > > 
> > > Also a patch was posted only yesterday for a panel that seems to be the
> > > exact same one as this, even though the name differs minimally, see:
> > > 
> > > 	https://patchwork.kernel.org/patch/4175251/
> > > 
> > > Adding Philipp on Cc so you guys can work together whether this is
> > > indeed the same panel. The only differences seem to be in the vertical
> > > front and back porches, but I suspect that either settings will work on
> > > both Tegra and i.MX.
> > 
> > Its etm0700g0dh6 vs. et070080dh6, Philipp's panel is with captive multi
> > touch, (hence the M I guess). The panel itself really looks the same.
> > 
> > I found this overview of EDT displays:
> > http://www.dmbtechnics.com/scripts/passthru.php?id=7
> > 
> > There seem to be quite a lot variants with the same panel...
> > 
> > Regarding timings, I just checked the documentation, Philipp's timing
> > really matches the documented ones, I miscalculated the vertical back
> > porch.
> 
> Okay, so that means that the panel works for you with the same timings
> that Philipp has in the ETM0700G0DH6 patch? If so then I definitely
> think we should be sharing the timings in the driver by making the two
> compatible entries point to the same driver data.
> 
> > How do we resolve that?
> > 
> > I would suggest that I split out that patch and remove the et070080dh6
> > panel and send the other as a single patch to the dri-devel mailing list
> > as well.
> 
> Yes, that would work.
> 
> > Philipp, could you add my display type (et070080dh6) to the compatible
> > list of your mode/panel entry?
> 
> I also noticed that Philipp's patch doesn't actually introduce the
> device tree bindings, so that will have to be added as well.

Hmm, yes. Should I take over the edt,et070080dh6.txt from Stefan's
series and repost all, or can I just hand in the missing
edt,etm0700g0dh6.txt separately?

regards
Philipp

