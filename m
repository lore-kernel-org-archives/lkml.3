Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202Ab3AQCcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 21:32:50 -0500
Received: from mail.kernel.org ([198.145.19.201]:42831 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755928Ab3AQCcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:32:48 -0500
Date: Wed, 16 Jan 2013 18:33:31 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Simon Horman <horms@verge.net.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
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
Message-ID: <20130117023331.GC20928@kroah.com>
References: <1355343907-11535-1-git-send-email-linus.walleij@stericsson.com>
 <50EF27B4.60608@wwwdotorg.org>
 <CACRpkdZ0b=ZohgaBH3qPH_O5TiWmXJXs6872D+YPVA9g4BssYg@mail.gmail.com>
 <9702060.jEbHySsCv0@avalon>
 <CACRpkdbFH6RCEEnXO=A9FVa0B5rtE9RkjXz9Hhy+w7NvwcBCgg@mail.gmail.com>
 <50F6E811.2040606@wwwdotorg.org>
 <CACRpkdbnyzppd-iom4PL3N3-YkuK+BRNzR577qVc6cPoTKxhTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbnyzppd-iom4PL3N3-YkuK+BRNzR577qVc6cPoTKxhTw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 01:59:52AM +0100, Linus Walleij wrote:
> On Wed, Jan 16, 2013 at 6:49 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> 
> > Hmm. It's causing a lot of engineers here a lot of trouble, since they
> > all see linux-next won't boot, and haven't been paying enough attention
> > to know which commit to revert:-(. Lots of lost productivity:-(
> >
> > Simon, the offending commit:
> >
> > 6d3ef6b drivers/pinctrl: grab default handles from device core
> >
> > is still in next-20130116. Can you please remove it?
> 
> Not that this should be in the SH tree, but I have merged your fix
> to the pinctrl tree and it should be in -next, does it fix the problem?
> 
> Mainly asking because once Greg ACKs that patch I want to
> put it into the pinctrl tree...

I want to see the updated one with all of the fixes before I ack
anything.

thanks,

greg k-h
