Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab3AQA7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 19:59:54 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:59962 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab3AQA7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 19:59:52 -0500
MIME-Version: 1.0
In-Reply-To: <50F6E811.2040606@wwwdotorg.org>
References: <1355343907-11535-1-git-send-email-linus.walleij@stericsson.com>
	<50EF27B4.60608@wwwdotorg.org>
	<CACRpkdZ0b=ZohgaBH3qPH_O5TiWmXJXs6872D+YPVA9g4BssYg@mail.gmail.com>
	<9702060.jEbHySsCv0@avalon>
	<CACRpkdbFH6RCEEnXO=A9FVa0B5rtE9RkjXz9Hhy+w7NvwcBCgg@mail.gmail.com>
	<50F6E811.2040606@wwwdotorg.org>
Date: Thu, 17 Jan 2013 01:59:52 +0100
Message-ID: <CACRpkdbnyzppd-iom4PL3N3-YkuK+BRNzR577qVc6cPoTKxhTw@mail.gmail.com>
Subject: Re: [PATCH v2] drivers/pinctrl: grab default handles from device core
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Simon Horman <horms@verge.net.au>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 6:49 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> Hmm. It's causing a lot of engineers here a lot of trouble, since they
> all see linux-next won't boot, and haven't been paying enough attention
> to know which commit to revert:-(. Lots of lost productivity:-(
>
> Simon, the offending commit:
>
> 6d3ef6b drivers/pinctrl: grab default handles from device core
>
> is still in next-20130116. Can you please remove it?

Not that this should be in the SH tree, but I have merged your fix
to the pinctrl tree and it should be in -next, does it fix the problem?

Mainly asking because once Greg ACKs that patch I want to
put it into the pinctrl tree...

Yours,
Linus Walleij
