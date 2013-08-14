Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383Ab3HNHaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 03:30:07 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:60703 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757923Ab3HNHaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 03:30:04 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+9HPeVpF9yEe/Gvz2JeOa+
Date: Wed, 14 Aug 2013 00:30:01 -0700
From: Tony Lindgren <tony@atomide.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 12/22] ARM: dts: Remove '0x's from OMAP2420 H4 DTS file
Message-ID: <20130814073000.GW7656@atomide.com>
References: <1374490361-25769-1-git-send-email-lee.jones@linaro.org>
 <1374490361-25769-12-git-send-email-lee.jones@linaro.org>
 <20130813154425.GH15278@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130813154425.GH15278@lee--X1>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Lee Jones <lee.jones@linaro.org> [130813 08:51]:
> Tony, Benoit,
> 
> Poke

Looks like Benoit's new email address is bcousson@baylibre.com.
Probably best for Benoit to pick these to avoid merge conflicts.

Regards,

Tony
 
> On Mon, 22 Jul 2013, Lee Jones wrote:
> 
> > Cc: Benoît Cousson <b-cousson@ti.com>
> > Cc: Tony Lindgren <tony@atomide.com>
> > Cc: linux-omap@vger.kernel.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  arch/arm/boot/dts/omap2420-h4.dts | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm/boot/dts/omap2420-h4.dts b/arch/arm/boot/dts/omap2420-h4.dts
> > index 224c08f..34cdecb 100644
> > --- a/arch/arm/boot/dts/omap2420-h4.dts
> > +++ b/arch/arm/boot/dts/omap2420-h4.dts
> > @@ -50,15 +50,15 @@
> >  			label = "bootloader";
> >  			reg = <0 0x20000>;
> >  		};
> > -		partition@0x20000 {
> > +		partition@20000 {
> >  			label = "params";
> >  			reg = <0x20000 0x20000>;
> >  		};
> > -		partition@0x40000 {
> > +		partition@40000 {
> >  			label = "kernel";
> >  			reg = <0x40000 0x200000>;
> >  		};
> > -		partition@0x240000 {
> > +		partition@240000 {
> >  			label = "file-system";
> >  			reg = <0x240000 0x3dc0000>;
> >  		};
> 
> -- 
> Lee Jones
> Linaro ST-Ericsson Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
