Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab3AKUeb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 15:34:31 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:49816 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab3AKUe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 15:34:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Simon Horman <horms@verge.net.au>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Kevin Hilman <khilman@ti.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <b-cousson@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Mitch Bradley <wmb@firmworks.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-next@vger.kernel.org
Subject: Re: [PATCH v2] drivers/pinctrl: grab default handles from device core
Date: Fri, 11 Jan 2013 21:36:10 +0100
Message-ID: <9702060.jEbHySsCv0@avalon>
User-Agent: KMail/4.9.2 (Linux/3.6.11-gentoo; KDE/4.9.2; x86_64; ; )
In-Reply-To: <CACRpkdZ0b=ZohgaBH3qPH_O5TiWmXJXs6872D+YPVA9g4BssYg@mail.gmail.com>
References: <1355343907-11535-1-git-send-email-linus.walleij@stericsson.com> <50EF27B4.60608@wwwdotorg.org> <CACRpkdZ0b=ZohgaBH3qPH_O5TiWmXJXs6872D+YPVA9g4BssYg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

On Friday 11 January 2013 21:12:43 Linus Walleij wrote:
> On Thu, Jan 10, 2013 at 9:42 PM, Stephen Warren wrote:
> > On 12/12/2012 01:25 PM, Linus Walleij wrote:
> >> From: Linus Walleij <linus.walleij@linaro.org>
> >> 
> >> This makes the device core auto-grab the pinctrl handle and set
> >> the "default" (PINCTRL_STATE_DEFAULT) state for every device
> >> that is present in the device model right before probe. This will
> >> account for the lion's share of embedded silicon devcies.
> > 
> > There are quite a few problems with this patch, and they end up
> > completely breaking at least Tegra in next-20130110.
> 
> But I have not put this patch into linux-next.
> 
> I was still waiting for Greg to ACK it...
> 
> Apparently it was included in a pull request to the SH tree or something,
> Simon can you remove these patches for now, this patch needs to
> be elaborated on in the pinctrl tree first.

I've sent several patch series for the SH PFC (Pin Function Controller) to the 
linux-sh mailing list. One of the series included pinctrl core patches for 
easier testing, but I made it clear that they should *not* be pushed to 
mainline through the SH tree.

Actually the whole PFC series have been found out today by Guennadi 
Liakhovetski to be buggy. I will fix the problems and send a new version. In 
the meantime the pinmux-pinctrl and pinmux-dt series should not be pushed to 
mainline.

-- 
Regards,

Laurent Pinchart

