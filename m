Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030202Ab3AXUmH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:42:07 -0500
Received: from mail-ia0-f182.google.com ([209.85.210.182]:40755 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030184Ab3AXUlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:41:55 -0500
Date: Thu, 24 Jan 2013 15:42:03 -0500
From: Matt Porter <mporter@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Chris Ball <cjb@laptop.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 00/14] DMA Engine support for AM33XX
Message-ID: <20130124204203.GD5256@beef>
References: <1358281974-8411-1-git-send-email-mporter@ti.com>
 <50FEB6B2.5020303@ti.com>
 <20130123022133.GA5727@opensource.wolfsonmicro.com>
 <20130123213736.GC5256@beef>
 <d07dbfd50690423b903803720152c0dc@DLEE74.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d07dbfd50690423b903803720152c0dc@DLEE74.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 05:14:13AM +0000, Sekhar Nori wrote:
> Matt,
> 
> On 1/24/2013 3:07 AM, Matt Porter wrote:
> > On Wed, Jan 23, 2013 at 10:21:42AM +0800, Mark Brown wrote:
> >> On Tue, Jan 22, 2013 at 09:26:34PM +0530, Sekhar Nori wrote:
> >>> On 1/16/2013 2:02 AM, Matt Porter wrote:
> >>
> >>>> This series adds DMA Engine support for AM33xx, which uses
> >>>> an EDMA DMAC. The EDMA DMAC has been previously supported by only
> >>>> a private API implementation (much like the situation with OMAP
> >>>> DMA) found on the DaVinci family of SoCs.
> >>
> >>> Will you take this series through the OMAP tree? Only 1/14 touches
> >>> mach-davinci and I am mostly okay with it except some changes I just
> >>> requested Matt to make in another thread.
> >>
> >> Is this series somewhere near actually getting merged then? It seemed
> >> like there was lots of stuff going on.
> > 
> > The issues raised by Sekhar and Santosh were reasonably minor and will
> > be addressed. My major concern is that the dependency on some api to
> > fetch dmaengine driver SG limitations is not resolved. That's being
> > discussed in https://lkml.org/lkml/2013/1/10/432
> 
> It might be worth posting the patches which don't have dependencies and
> are ready for acceptance as a separate series. That way at least some of
> these patches have a good chance of getting into v3.9 if not the entire
> series.

Yes a good idea and seems to be the best option. I've dropped the mmc
support from the series for the next version. I'll repost the separately
when we have an api to support it.

-Matt
