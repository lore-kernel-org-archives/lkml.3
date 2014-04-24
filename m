Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbaDXAXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 20:23:37 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:40778 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaDXAXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 20:23:35 -0400
Date: Thu, 24 Apr 2014 09:23:31 +0900
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 2/2] ARM: shmobile: armadillo800eva defconfig: Enable
 REGULATOR_GPIO and LEDS_GPIO
Message-ID: <20140424002331.GF32087@verge.net.au>
References: <1398171667-24288-1-git-send-email-geert+renesas@glider.be>
 <1398171667-24288-2-git-send-email-geert+renesas@glider.be>
 <20140423005043.GF5738@verge.net.au>
 <CAMuHMdV8EJ_edZKqtxft8fGjro-NcBwiRiXaDNRtoLC550xQCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdV8EJ_edZKqtxft8fGjro-NcBwiRiXaDNRtoLC550xQCQ@mail.gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 10:38:58AM +0200, Geert Uytterhoeven wrote:
> Hi Simon,
> 
> On Wed, Apr 23, 2014 at 2:50 AM, Simon Horman <horms@verge.net.au> wrote:
> > On Tue, Apr 22, 2014 at 03:01:07PM +0200, Geert Uytterhoeven wrote:
> >> Refresh armadillo800eva_defconfig, and enable missing options for devices
> >> in platform data and/or DT:
> >>   - REGULATOR_GPIO
> >>   - LEDS_GPIO
> >
> > I would prefer if changes were made in a more incremental patch.
> >
> > * A patch to enable LEDS_GPIO and REGULATOR_GPIO.
> 
> OK, will do for v2, when I know more about SHMOBILE_IOMMU.
> 
> > * Then a cleanup patch, if you really want to do that: but why?
> 
> It's a good idea to run a "make savedefconfig" once in a while, to get rid of
> stale symbols, and symbols that are now auto-selected.
> Anyway, although there were quite some changes in the actual defconfig, the
> net impact on "make armadillo800eva_defconfig" is much smaller than I expected
> (only CONFIG_NET_VENDOR_SAMSUNG gets enabled), so I'll leave the regular
> refreshing to you ;-

I agree that its nice to keep things up to date. But there
is a goal to eventually remove the per-board defconfigs.
So my motivation to spruce things up is a little lower than
it might otherwise be.

> >> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> >> ---
> >> Do we want SHMOBILE_IOMMU, too? The help text says "If unsure, say N."
> >> If yes, is the default SHMOBILE_IOMMU_ADDRSIZE_2048MB OK?
> >
> > I defer to Magnus on that one.
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> 
