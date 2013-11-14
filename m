Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063Ab3KNQ4A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:56:00 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:49095 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531Ab3KNQzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:55:42 -0500
Date: Thu, 14 Nov 2013 11:55:36 -0500
From: Matt Porter <matt.porter@linaro.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Florian Meier <florian.meier@koalo.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree <devicetree@vger.kernel.org>, alsa-devel@alsa-project.org,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv4] dmaengine: Add support for BCM2835
Message-ID: <20131114165536.GQ13284@beef>
References: <5283BC93.1090801@koalo.de>
 <2385512.qcT1vt8HYp@flatron>
 <CABDT8WyUK6tDneDEm0G3o0zJHXaVTZp8JAMxOp5LRKQYG-7Umw@mail.gmail.com>
 <11018682.0TjgocUWod@flatron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11018682.0TjgocUWod@flatron>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 05:23:08PM +0100, Tomasz Figa wrote:
> On Thursday 14 of November 2013 17:14:31 Florian Meier wrote:
> > >> >> I am becoming desperate anyway that this migration will ever fully
> > >> >> take place....
> > >> >
> > >> > Why not? It's just a matter of people like you working on this (and
> > >> > addressing some review comments ;)).
> > >>
> > >> The most common comment about this is that people will not put effort in
> > >> the upstream kernel as long as there is no comfortable way for debugging
> > >> in the upstream kernel (i.e. at least USB support).......
> > >
> > > Right, you need USB to have ethernet working. Still, IMHO UART (for
> > > console) + ethernet (for file transfer or NFS root) is the reasonable
> > > setup allowing you to debug further drivers in a comfortable way.
> > 
> > I am fine with UART and switching SD cards :-)
> > But apparently this is not generally accepted.
> 
> Still, isn't some work on USB support for RPi already going on? I believe
> Matt Porter (now on Cc) has been working on unifying dwc2 host-mode
> driver with Samsung s3c-hsotg device-mode driver (for the same IP) to
> get full OTG support on all applicable platforms.

Baby steps in that direction, yes. I need to finish the basic s3c-hsotg
and dwc2 host only enablement for my platform and then will be focused on
combining them.

-Matt
