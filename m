Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbaFMTMB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 15:12:01 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:53628 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaFMTL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 15:11:59 -0400
Date: Fri, 13 Jun 2014 19:11:58 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Felipe Balbi <balbi@ti.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>
cc: Tony Lindgren <tony@atomide.com>, Benoit Cousson <bcousson@baylibre.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sathya Prakash M R <sathyap@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RESEND PATCH 1/2] ARM: AM43xx: hwmod: add DSS hwmod data
In-Reply-To: <20140613162323.GH8319@saruman.home>
Message-ID: <alpine.DEB.2.02.1406131910060.340@utopia.booyaka.com>
References: <1402676147-3711-1-git-send-email-balbi@ti.com> <1402676147-3711-2-git-send-email-balbi@ti.com> <20140613162323.GH8319@saruman.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe, Tomi,

On Fri, 13 Jun 2014, Felipe Balbi wrote:

> On Fri, Jun 13, 2014 at 11:15:46AM -0500, Felipe Balbi wrote:
> > From: Sathya Prakash M R <sathyap@ti.com>
> > 
> > Add DSS hwmod data for AM43xx.
> > 
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Acked-by: Rajendra Nayak <rnayak@ti.com>
> > Signed-off-by: Sathya Prakash M R <sathyap@ti.com>
> > Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > ---
> > 
> > Note that this patch was originally send on May 9th [1], changes were requested
> > and a new version was sent on May 19th [2], then on May 27th [3] Tomi pinged
> > maintainer again and go no response.
> > 
> > Without this patch, we cannot get display working on any AM437x devices.
> > 
> > [1] http://marc.info/?l=linux-arm-kernel&m=139963677925227&w=2
> > [2] http://marc.info/?l=linux-arm-kernel&m=140049799425512&w=2
> > [3] http://marc.info/?l=linux-arm-kernel&m=140117232826754&w=2
> > 
> >  arch/arm/mach-omap2/omap_hwmod_43xx_data.c | 98 ++++++++++++++++++++++++++++++
> >  arch/arm/mach-omap2/prcm43xx.h             |  1 +
> >  2 files changed, 99 insertions(+)

Sorry for the delay on this.  Have been corresponding with TI management 
to figure out what to do about patches for AM43xx.  I don't have boards or 
public documentation for these devices, so it's impossible for me to 
meaningfully review the patches.  Looks like boards and/or public docs 
won't be coming any time soon.

So for my part, here's what I'll need to merge any hwmod or PRCM patches 
that involve AM437x:

1. A Reviewed-by: from one of the following folks (which should come from
a different person than who is submitting the patches):

Roger Quadros
Nishanth Menon
Rajendra Nayak
Kevin Hilman
Tony Lindgren

2. A Tested-by: from one of the following folks (who can be the same as 
the person who is the same as the person who is submitting the patches):

Nishanth Menon
Rajendra Nayak
Kevin Hilman 
Tony Lindgren


- Paul
