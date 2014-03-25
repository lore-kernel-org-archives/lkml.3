Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbaCYNOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 09:14:32 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:53654 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbaCYNOb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 09:14:31 -0400
Date: Tue, 25 Mar 2014 14:14:07 +0100
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/5] ARM: dts: tx53: add simple-panel support
Message-ID: <20140325141407.75b0750e@ipc1.ka-ro>
In-Reply-To: <20140322064653.GC5938@dragon>
References: <1395235721-13847-1-git-send-email-LW@KARO-electronics.de>
 <1395235721-13847-4-git-send-email-LW@KARO-electronics.de>
 <20140322064653.GC5938@dragon>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Shawn Guo wrote:
> On Wed, Mar 19, 2014 at 02:28:40PM +0100, Lothar Waßmann wrote:
> > 
> > Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
> > ---
> >  arch/arm/boot/dts/imx53-tx53-x13x.dts |   12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> > 
> > diff --git a/arch/arm/boot/dts/imx53-tx53-x13x.dts b/arch/arm/boot/dts/imx53-tx53-x13x.dts
> > index 26b918e..86a964d 100644
> > --- a/arch/arm/boot/dts/imx53-tx53-x13x.dts
> > +++ b/arch/arm/boot/dts/imx53-tx53-x13x.dts
> > @@ -63,6 +63,18 @@
> >  		default-brightness-level = <50>;
> >  	};
> >  
> > +	panel0 {
> > +		compatible = "simple-panel";
> 
> From what I can see, "simple-panel" is not a documented compatible.
> 
There is Documentation/devicetree/bindings/panel/simple-panel.txt
which describes the bindings for drivers/gpu/drm/panel/panel-simple.c.
"simple-panel" is the common compatible for all panels that the driver
supports. If no compatible for a specific panel is given, the
driver supports a generic panel with an ENABLE GPIO, an attached
backlight and a regulator. This is what's being used here. 


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
