Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab3FQIiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:38:54 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:53067 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086Ab3FQIiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:38:52 -0400
Date: Mon, 17 Jun 2013 10:38:50 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin@allwinnertech.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com
Subject: Re: [linux-sunxi] [PATCH 5/6] ARM: sunxi: Add Olimex
 A10s-Olinuxino-micro device tree
Message-ID: <20130617083850.GD16699@lukather>
References: <1370795767-9769-1-git-send-email-maxime.ripard@free-electrons.com>
 <1370795767-9769-6-git-send-email-maxime.ripard@free-electrons.com>
 <51BB5C6D.5070308@elopez.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51BB5C6D.5070308@elopez.com.ar>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Emilio,

On Fri, Jun 14, 2013 at 03:09:49PM -0300, Emilio López wrote:
> Hi Maxime,
> 
> El 09/06/13 13:36, Maxime Ripard escribió:
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > ---
> >  arch/arm/boot/dts/sun5i-a10s-olinuxino-micro.dts | 75 ++++++++++++++++++++++++
> >  1 file changed, 75 insertions(+)
> >  create mode 100644 arch/arm/boot/dts/sun5i-a10s-olinuxino-micro.dts
> 
> Please add this on the sunxi target in arch/arm/boot/dts/Makefile so it
> gets built on make dtbs.
> 
> (snip)
> 
> > +	leds {
> > +		compatible = "gpio-leds";
> > +		pinctrl-names = "default";
> > +		pinctrl-0 = <&led_pins_olinuxino>;
> > +
> > +		power {
> > +			gpios = <&pio 4 3 0>;
> > +			default-state = "on";
> > +		};
> 
> Also, as discussed on IRC, I think it would be wise to change the name
> on the LED node. The schematics have a 'power' led already that is
> hard-wired to 3.3v, and this led node that you are declaring is referred
> as 'led1' there. I suppose 'green' would be a suitable name to keep
> consistency with other sunxi boards (namely cubieboard).
> 
> Other than that, my OLinuXino worked just fine after applying this
> patchset, so
> 
> Tested-by: Emilio López <emilio@elopez.com.ar>

Thanks for your comments and the test.

I'll send a v2.

Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
