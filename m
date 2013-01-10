Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab3AJUts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 15:49:48 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:39581 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab3AJUtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 15:49:46 -0500
Date: Thu, 10 Jan 2013 14:49:11 -0600
From: Nishanth Menon <nm@ti.com>
To: Matt Porter <mporter@ti.com>
CC: Sekhar Nori <nsekhar@ti.com>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Chris Ball <cjb@laptop.org>, Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <b-cousson@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH v3 16/16] ARM: dts: add AM33XX SPI support
Message-ID: <20130110204911.GA7586@kahuna>
References: <1350566815-409-1-git-send-email-mporter@ti.com>
 <1350566815-409-17-git-send-email-mporter@ti.com>
 <508D1791.1040806@ti.com>
 <20130110193547.GQ14660@beef>
 <20130110194653.GA32519@kahuna>
 <20130110204959.GS14660@beef>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130110204959.GS14660@beef>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15:49-20130110, Matt Porter wrote:
> On Thu, Jan 10, 2013 at 01:46:53PM -0600, Nishanth Menon wrote:
> > On 14:35-20130110, Matt Porter wrote:
> > > On Sun, Oct 28, 2012 at 05:01:29PM +0530, Sekhar Nori wrote:
> > > > On 10/18/2012 6:56 PM, Matt Porter wrote:
[...]
> 
> > > > > +				0x19c 0x13	/* mcasp0_ahclkr.spi1_cs0, OUTPUT_PULLUP | MODE3 */
> > > > > +			>;
> > > > 
> > > > Is there a single pinmux setting that provides SPI functionality on the
> > > > bone headers? Or this is specific to a cape you tested with?
> > > 
> > > No, there are two usable settings for spi1 and one setting for spi0.
> > > I'm dropping this from the series since it's specific to how I wired up
> > > the homebrew cape I use for spi testing on the Bone. I publish the
> > > branch where all these extra "test-specific" patches (that aren't intended
> > > to be merged) are at in the cover letter.  Anybody that needs context of
> > > how/what worked and was tested can grab them there.
> > Possibly dumb question:
> > Cant we have pre-usable spi configurations?  Like spi1_configuration1_pins,
> > spi2_configuration1_pins, spi0_configuration1_pins? If documented with
> > P9 pin names in the bone dts, it saves a bit of effort in looking up
> > pad offset when dealing with capes.
> 
> Yes, let's introduce these things separately. I plan to reintroduce
> patches to fix the incorrect 1-based numbering on many of the AM33xx as
> previous ones were dropped...and I think this makes sense on top of
> that.
sounds good to me.

-- 
Regards,
Nishanth Menon
