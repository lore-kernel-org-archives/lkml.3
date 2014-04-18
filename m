Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbaDRW2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 18:28:09 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:30320 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbaDRW2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 18:28:07 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+AV6RB4tHHylp31klWpqdT
Date: Fri, 18 Apr 2014 15:27:59 -0700
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        tomi.valkeinen@ti.com, eduardo.valentin@ti.com, arnd@arndb.de
Subject: Re: [PATCH] ARM: OMAP2+: Fix config name for USB3 PHY
Message-ID: <20140418222758.GG21823@atomide.com>
References: <1396347274-32750-1-git-send-email-kishon@ti.com>
 <20140401141135.GA4717@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140401141135.GA4717@saruman.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [140401 07:17]:
> On Tue, Apr 01, 2014 at 03:44:34PM +0530, Kishon Vijay Abraham I wrote:
> > commit a70143 (drivers: phy: usb3/pipe3: Adapt pipe3 driver to Generic PHY
> > Framework) moved phy-omap-usb3 driver in drivers/usb/phy to drivers/phy and
> > also renamed the file to phy-ti-pipe3. It also renamed the config from
> > OMAP_USB3 to TI_PIPE3 in Kconfig. However the config name was not changed in
> > omap2plus_defconfig. Fixed it here.
> > 
> > Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> 
> Acked-by: Felipe Balbi <balbi@ti.com>

Applying into omap-for-v3.15/fixes thanks.

Tony
 
> > ---
> >  arch/arm/configs/omap2plus_defconfig |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
> > index a966795..a4e8d01 100644
> > --- a/arch/arm/configs/omap2plus_defconfig
> > +++ b/arch/arm/configs/omap2plus_defconfig
> > @@ -226,7 +226,7 @@ CONFIG_USB_DWC3=m
> >  CONFIG_USB_TEST=y
> >  CONFIG_NOP_USB_XCEIV=y
> >  CONFIG_OMAP_USB2=y
> > -CONFIG_OMAP_USB3=y
> > +CONFIG_TI_PIPE3=y
> >  CONFIG_AM335X_PHY_USB=y
> >  CONFIG_USB_GADGET=y
> >  CONFIG_USB_GADGET_DEBUG=y
> > -- 
> > 1.7.9.5
> > 
> 
> -- 
> balbi


