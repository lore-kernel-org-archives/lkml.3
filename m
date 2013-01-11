Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab3AKSRM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 13:17:12 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:57019 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab3AKSRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 13:17:09 -0500
Date: Fri, 11 Jan 2013 13:21:46 -0500
From: Matt Porter <mporter@ti.com>
To: Lars Poeschel <poeschel@lemonage.de>
Cc: Tony Lindgren <tony@atomide.com>, "Nori, Sekhar" <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <djbw@fb.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v4,03/14] ARM: edma: add AM33XX support to the private
 EDMA API
Message-ID: <20130111182146.GZ14660@beef>
References: <1357883330-5364-4-git-send-email-mporter@ti.com>
 <9fda86bbbec3444393fd5a2dc5135a5e@DFLE73.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9fda86bbbec3444393fd5a2dc5135a5e@DFLE73.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 06:14:27PM +0000, Lars Poeschel wrote:
> Hi Matt,
> 
> On Friday 11 January 2013 at 06:48:39, Matt Porter wrote:
> 
> > diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
> > index a3d189d..1951d63 100644
> > --- a/arch/arm/common/edma.c
> > +++ b/arch/arm/common/edma.c
> > @@ -24,6 +24,13 @@
> >  #include <linux/platform_device.h>
> >  #include <linux/io.h>
> >  #include <linux/slab.h>
> > +#include <linux/edma.h>
> > +#include <linux/err.h>
> > +#include <linux/of_address.h>
> > +#include <linux/of_device.h>
> > +#include <linux/of_dma.h>
> > +#include <linux/of_irq.h>
> > +#include <linux/pm_runtime.h>
> 
> You add the include linux/of_dma.h here, but maybe you missed to add the file 
> itself. It is not in Linus v3.8-rc3 tree, not in the patches yours depend on 
> listed and not in your patchset.

of_dma.h comes in with the dependencies listed in the cover letter.
Particularly, Vinod's dt_dmaengine branch in slave-dma.git contains Jon
Hunter's OF DMA helpers series.

-Matt
