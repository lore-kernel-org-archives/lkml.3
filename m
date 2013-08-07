Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054Ab3HGPLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 11:11:10 -0400
Received: from smtp1-1.goneo.de ([212.90.139.81]:53520 "EHLO smtp1-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992Ab3HGPLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 11:11:08 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.808
From: Lars Poeschel <poeschel@lemonage.de>
To: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] ARM: dts: am33xx: Correct gpio #interrupt-cells property
Date: Wed, 7 Aug 2013 17:11:00 +0200
User-Agent: KMail/1.13.7 (Linux/3.9-1-amd64; KDE/4.8.4; x86_64; ; )
Cc: Lars Poeschel <larsi@wh2.tu-dresden.de>,
        "b-cousson@ti.com" <b-cousson@ti.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1375873592-26881-1-git-send-email-larsi@wh2.tu-dresden.de> <20130807145309.GG28558@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130807145309.GG28558@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201308071711.00449.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 August 2013 at 16:53:09, Mark Rutland wrote:
> On Wed, Aug 07, 2013 at 12:06:32PM +0100, Lars Poeschel wrote:
> > From: Lars Poeschel <poeschel@lemonage.de>
> > 
> > Following commit ff5c9059 and therefore other omap platforms using
> > the gpio-omap driver correct the #interrupt-cells property on am33xx
> > too. The omap gpio binding documentaion also states that
> > the #interrupt-cells property should be 2.
> 
> I take it there are no device nodes for which any of these nodes are an
> interrupt parent (which would need to be updated)?

As far as I know: No.

Lars

> If so:
> 
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> 
> Thanks,
> Mark.
> 
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
