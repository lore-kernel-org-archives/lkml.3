Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab3AaBbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 20:31:49 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:60024 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab3AaBbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 20:31:46 -0500
Date: Wed, 30 Jan 2013 20:32:15 -0500
From: Matt Porter <mporter@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <b-cousson@ti.com>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Chris Ball <cjb@laptop.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v6 09/10] spi: omap2-mcspi: add generic DMA request
 support to the DT binding
Message-ID: <20130131013215.GF2244@beef>
References: <1359529229-22207-1-git-send-email-mporter@ti.com>
 <1359529229-22207-10-git-send-email-mporter@ti.com>
 <201301300924.00508.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201301300924.00508.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 09:24:00AM +0000, Arnd Bergmann wrote:
> On Wednesday 30 January 2013, Matt Porter wrote:
> > +Optional properties:
> > +- dmas: List of DMA controller phandle and DMA request ordered
> > +       pairs. One tx and one rx pair is required for each chip
> > +       select.
> 
> The binding looks ok, but the wording is slightly incorrect here:
> strictly speaking, it's not a pair of controller phandle and request
> line number, but a DMA descriptor as specified in bindings/dma/dma.txt
> with a format specific to the dma engine being used. That can
> require more than just a single integer request number.

Correct. I will update accordingly.

-Matt
