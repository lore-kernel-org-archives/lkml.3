Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbaKPKPw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 05:15:52 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51411 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868AbaKPKPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 05:15:50 -0500
Date: Sun, 16 Nov 2014 11:15:48 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg, bcousson@baylibre.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sakari.ailus@iki.fi, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [RFC] adp1653: Add device tree bindings for LED controller
Message-ID: <20141116101548.GB32483@amd>
References: <20141116075928.GA9763@amd>
 <546877EF.8010906@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <546877EF.8010906@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2014-11-16 11:09:51, Andreas Färber wrote:
> Hi Pavel,
> 
> Am 16.11.2014 um 08:59 schrieb Pavel Machek:
> > For device tree people: Yes, I know I'll have to create file in
> > documentation, but does the binding below look acceptable?
> [...]
> > diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
> > index 739fcf2..ed0bfc1 100644
> > --- a/arch/arm/boot/dts/omap3-n900.dts
> > +++ b/arch/arm/boot/dts/omap3-n900.dts
> > @@ -553,6 +561,18 @@
> >  
> >  		ti,usb-charger-detection = <&isp1704>;
> >  	};
> > +
> > +	adp1653: adp1653@30 {
> 
> This should probably be led-controller@30 (a generic description not
> specific to the model). The label name is fine.

Thanks.

> > +		gpios = <&gpio3 24 GPIO_ACTIVE_HIGH>; /* Want 88 */
> 
> At least to me, the meaning of "Want 88" is not clear - drop or clarify?

I changed it to /* 88 */ to match rest of code.

Best regards,
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
