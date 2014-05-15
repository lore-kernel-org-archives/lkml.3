Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941AbaEOI14 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 04:27:56 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54629 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbaEOI1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 04:27:54 -0400
Message-ID: <1400142449.4102.16.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH v2 2/3] drm/panel: add support for EDT panels
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: stefan@agner.ch, swarren@wwwdotorg.org, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        marcel@ziswiler.com
Date: Thu, 15 May 2014 10:27:29 +0200
In-Reply-To: <20140515075102.GE5952@ulmo>
References: <cover.1400103181.git.stefan@agner.ch>
	 <35c081171a3d9a9401767601c02a12e266b37dd0.1400103181.git.stefan@agner.ch>
	 <20140515075102.GE5952@ulmo>
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

Am Donnerstag, den 15.05.2014, 09:51 +0200 schrieb Thierry Reding:
> On Wed, May 14, 2014 at 11:45:57PM +0200, stefan@agner.ch wrote:
> > From: Stefan Agner <stefan@agner.ch>
> > 
> > This panels are sold by Toradex for Colibri T20/T30 and Apalis T30
> > evaluation kits.
> > 
> > Signed-off-by: Stefan Agner <stefan@agner.ch>
> 
> Panel patches should go to the dri-devel mailing list as well.
> 
> Also a patch was posted only yesterday for a panel that seems to be the
> exact same one as this, even though the name differs minimally, see:
> 
> 	https://patchwork.kernel.org/patch/4175251/
> 
> Adding Philipp on Cc so you guys can work together whether this is
> indeed the same panel. The only differences seem to be in the vertical
> front and back porches, but I suspect that either settings will work on
> both Tegra and i.MX.

The ETM0700G0DH6 Datasheet lists 2 lines as the typical vsync pulse
width, 525 lines as the vertical period, and 35 lines as the vsync -de
time, which is vsync len + back porch.
So vertical timings 480 + 10 + 2 + 33 = 525 should be valid for the
ET0700G0DH6 panel:

https://www.glynshop.com/erp/owweb/Daten/DSS/EDT/Products/Specifications/Active%20Displays/ET0700G0DH6.pdf
et070080dh6

I have not seen the data sheet for ET070080DH6.

regards
Philipp

