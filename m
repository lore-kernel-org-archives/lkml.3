Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbaCXMsA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 08:48:00 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:53224 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbaCXMr6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 08:47:58 -0400
Date: Mon, 24 Mar 2014 13:47:32 +0100
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] ARM: dts: tx53: Add IPU DI ports and endpoints
Message-ID: <20140324134732.43e59627@ipc1.ka-ro>
In-Reply-To: <20140322065038.GE5938@dragon>
References: <1395235721-13847-1-git-send-email-LW@KARO-electronics.de>
	<1395235721-13847-5-git-send-email-LW@KARO-electronics.de>
	<20140322065038.GE5938@dragon>
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
> On Wed, Mar 19, 2014 at 02:28:41PM +0100, Lothar Waßmann wrote:
> > 
> > Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
> > ---
> >  arch/arm/boot/dts/imx53-tx53-x03x.dts |    7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm/boot/dts/imx53-tx53-x03x.dts b/arch/arm/boot/dts/imx53-tx53-x03x.dts
> > index 0217dde3..43b4b7b 100644
> > --- a/arch/arm/boot/dts/imx53-tx53-x03x.dts
> > +++ b/arch/arm/boot/dts/imx53-tx53-x03x.dts
> > @@ -25,12 +25,17 @@
> >  	soc {
> >  		display: display@di0 {
> >  			compatible = "fsl,imx-parallel-display";
> > -			crtcs = <&ipu 0>;
> >  			interface-pix-fmt = "rgb24";
> >  			pinctrl-names = "default";
> >  			pinctrl-0 = <&pinctrl_rgb24_vga1>;
> >  			status = "okay";
> >  
> > +			port {
> > +				display0_in: endpoint {
> > +					remote-endpoint = <&ipu_di0_disp0>;
> > +				};
> > +			};
> > +
> 
> I shouldn't apply this until I rebase my branch on 3.15-rc1 where
> Philipp's OF graph is to be seen, right?
> 
That's ok with me.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
