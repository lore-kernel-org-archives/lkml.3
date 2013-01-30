Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab3A3Kfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 05:35:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38523 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754965Ab3A3Kfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 05:35:45 -0500
Date: Wed, 30 Jan 2013 18:35:34 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Matt Porter <mporter@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Benoit Cousson <b-cousson@ti.com>,
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
Subject: Re: [PATCH v6 08/10] spi: omap2-mcspi: convert to
 dma_request_slave_channel_compat()
Message-ID: <20130130103530.GA6229@opensource.wolfsonmicro.com>
References: <1359529229-22207-1-git-send-email-mporter@ti.com>
 <1359529229-22207-9-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359529229-22207-9-git-send-email-mporter@ti.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 02:00:27AM -0500, Matt Porter wrote:
> Convert dmaengine channel requests to use
> dma_request_slave_channel_compat(). This supports the DT case of
> platforms requiring channel selection from either the OMAP DMA or
> the EDMA engine. AM33xx only boots from DT and is the only user
> implementing EDMA so in the !DT case we can default to the OMAP DMA
> filter.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
