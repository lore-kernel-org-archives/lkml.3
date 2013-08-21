Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616Ab3HUH5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 03:57:13 -0400
Received: from smtp2.goneo.de ([212.90.139.82]:48239 "EHLO smtp2.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382Ab3HUH5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 03:57:11 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.856
From: Lars Poeschel <poeschel@lemonage.de>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] ARM: dts: am33xx: Correct gpio #interrupt-cells property
Date: Wed, 21 Aug 2013 09:57:01 +0200
User-Agent: KMail/1.13.7 (Linux/3.10-2-amd64; KDE/4.8.4; x86_64; ; )
Cc: Benoit Cousson <bcousson@baylibre.com>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ian.campbell@citrix.com, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1375873592-26881-1-git-send-email-larsi@wh2.tu-dresden.de> <20130821075016.GW7656@atomide.com>
In-Reply-To: <20130821075016.GW7656@atomide.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201308210957.01956.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony!

On Wednesday 21 August 2013 at 09:50:16, Tony Lindgren wrote:
> Benoit,
> 
> Care to take a look at this too?

Benoit already applied this with Mark Rutlands Acked-By and Javier Martinez 
Canillas Reviewed-by.

Regards,
Lars
 
> * Lars Poeschel <larsi@wh2.tu-dresden.de> [130807 04:14]:
> > From: Lars Poeschel <poeschel@lemonage.de>
> > 
> > Following commit ff5c9059 and therefore other omap platforms using
> > the gpio-omap driver correct the #interrupt-cells property on am33xx
> > too. The omap gpio binding documentaion also states that
> > the #interrupt-cells property should be 2.
> > 
> > Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
> > ---
> > 
> >  arch/arm/boot/dts/am33xx.dtsi |    8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm/boot/dts/am33xx.dtsi
> > b/arch/arm/boot/dts/am33xx.dtsi index 38b446b..033c5dd 100644
> > --- a/arch/arm/boot/dts/am33xx.dtsi
> > +++ b/arch/arm/boot/dts/am33xx.dtsi
> > @@ -102,7 +102,7 @@
> > 
> >  			gpio-controller;
> >  			#gpio-cells = <2>;
> >  			interrupt-controller;
> > 
> > -			#interrupt-cells = <1>;
> > +			#interrupt-cells = <2>;
> > 
> >  			reg = <0x44e07000 0x1000>;
> >  			interrupts = <96>;
> >  		
> >  		};
> > 
> > @@ -113,7 +113,7 @@
> > 
> >  			gpio-controller;
> >  			#gpio-cells = <2>;
> >  			interrupt-controller;
> > 
> > -			#interrupt-cells = <1>;
> > +			#interrupt-cells = <2>;
> > 
> >  			reg = <0x4804c000 0x1000>;
> >  			interrupts = <98>;
> >  		
> >  		};
> > 
> > @@ -124,7 +124,7 @@
> > 
> >  			gpio-controller;
> >  			#gpio-cells = <2>;
> >  			interrupt-controller;
> > 
> > -			#interrupt-cells = <1>;
> > +			#interrupt-cells = <2>;
> > 
> >  			reg = <0x481ac000 0x1000>;
> >  			interrupts = <32>;
> >  		
> >  		};
> > 
> > @@ -135,7 +135,7 @@
> > 
> >  			gpio-controller;
> >  			#gpio-cells = <2>;
> >  			interrupt-controller;
> > 
> > -			#interrupt-cells = <1>;
> > +			#interrupt-cells = <2>;
> > 
> >  			reg = <0x481ae000 0x1000>;
> >  			interrupts = <62>;
> >  		
> >  		};

