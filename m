Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab3H3KPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 06:15:47 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:60534 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996Ab3H3KPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 06:15:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH v4] gpio: pcf857x: Add OF support
Date: Fri, 30 Aug 2013 12:17:08 +0200
Message-ID: <1476237.1F2pAZlCTd@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CACRpkdbohob2cST6Wmn3yJ8cxy162iwR8oZaBk+QJRJTvSN-QA@mail.gmail.com>
References: <1377524753-4027-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <32047086.JjfkHtWF69@avalon> <CACRpkdbohob2cST6Wmn3yJ8cxy162iwR8oZaBk+QJRJTvSN-QA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 August 2013 10:07:23 Linus Walleij wrote:
> On Fri, Aug 30, 2013 at 2:05 AM, Laurent Pinchart wrote:
> > On Thursday 29 August 2013 14:16:59 Linus Walleij wrote:
> >> On Mon, Aug 26, 2013 at 3:45 PM, Laurent Pinchart wrote:
> >> 
> >> Don't we want to do this generic if we shall do it?
> >> 
> >> Like for *any* GPIO chips we provide lines-initial state in the device
> >> tree and some code in the gpiochip with a callback in struct gpio_chip
> >> that can be called by the gpiolib core to set this up? Then we don't
> >> have to reimplement this for every GPIO controller that needs it.
> > 
> > Most GPIO chips will provide a way to read back the current state. The
> > initial state only needs to be provided for write-only chips. This is
> > (luckily) rather an exception, so I don't think we should implement it in
> > the core, at least not yet. We can always refactor the code later if
> > needed, the proposed DT binding is generic enough.
> 
> But I think this can be useful on any GPIO chip.
> 
> For someone deploying some system and hacking around in the
> device tree to set the GPIOs up properly at boot it can be a
> real useful tool.
> 
> Or is that giving them too much rope? :-D

That's the job of the boot loader, isn't it ? :-)

-- 
Regards,

Laurent Pinchart

