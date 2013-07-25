Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab3GYKPl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 06:15:41 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:59105 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab3GYKPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 06:15:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Tomasz Figa <t.figa@samsung.com>, Greg KH <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>, broonie@kernel.org,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, kyungmin.park@samsung.com,
        balbi@ti.com, jg1.han@samsung.com, s.nawrocki@samsung.com,
        kgene.kim@samsung.com, grant.likely@linaro.org, tony@atomide.com,
        swarren@nvidia.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-fbdev@vger.kernel.org, akpm@linux-foundation.org,
        balajitk@ti.com, george.cherian@ti.com, nsekhar@ti.com, olof@lixom.net,
        Stephen Warren <swarren@wwwdotorg.org>, b.zolnierkie@samsung.com,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 01/15] drivers: phy: add generic PHY framework
Date: Thu, 25 Jul 2013 12:16:30 +0200
Message-ID: <2174304.5JlzJ583hP@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <201307242032.03597.arnd@arndb.de>
References: <Pine.LNX.4.44L0.1307231708020.1304-100000@iolanthe.rowland.org> <5977067.8rykRgjgre@flatron> <201307242032.03597.arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Wednesday 24 July 2013 20:32:03 Arnd Bergmann wrote:
> On Tuesday 23 July 2013, Tomasz Figa wrote:
> > On Tuesday 23 of July 2013 17:14:20 Alan Stern wrote:
> > > On Tue, 23 Jul 2013, Tomasz Figa wrote:
> > > > Where would you want to have those phy_address arrays stored? There
> > > > are no board files when booting with DT. Not even saying that you
> > > > don't need to use any hacky schemes like this when you have DT that
> > > > nicely specifies relations between devices.
> > > 
> > > If everybody agrees DT has a nice scheme for specifying relations
> > > between devices, why not use that same scheme in the PHY core?
> > 
> > It is already used, for cases when consumer device has a DT node attached.
> > In non-DT case this kind lookup translates loosely to something that is
> > being done in regulator framework - you can't bind devices by pointers,
> > because you don't have those pointers, so you need to use device names.
> 
> Sorry for jumping in to the middle of the discussion, but why does a *new*
> framework even bother defining an interface for board files?
> 
> Can't we just drop any interfaces for platform data passing in the phy
> framework and put the burden of adding those to anyone who actually needs
> them? All the platforms we are concerned with here (exynos and omap, plus
> new platforms) can be booted using DT anyway.

What about non-DT architectures such as MIPS (still widely used in consumer 
networking equipments from what I've heard) ?

-- 
Regards,

Laurent Pinchart

