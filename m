Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab3FQQ00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 12:26:26 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34699 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220Ab3FQQ0Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 12:26:24 -0400
From: "Fernandes, Joel A" <joelagnel@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Tony Lindgren <tony@atomide.com>, "Nori, Sekhar" <nsekhar@ti.com>,
        "Matt Porter" <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Rob Herring" <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>,
        "Devicetree Discuss" <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>
Subject: RE: [PATCH v10 5/8] dmaengine: edma: Add TI EDMA device tree binding
Thread-Topic: [PATCH v10 5/8] dmaengine: edma: Add TI EDMA device tree
 binding
Thread-Index: AQHOaXCq5Ahsa0wut0SvcD1WJ4Ax1pk6GA8A///1IaCAAGDEgP//rZWQ
Date: Mon, 17 Jun 2013 16:25:31 +0000
Message-ID: <083BC63EECB6FD41B8E81CF7FD87CC0F2E4E9479@DLEE08.ent.ti.com>
References: <1371263570-9323-1-git-send-email-joelagnel@ti.com>
 <3940138.jZFEtfGGLz@wuerfel>
 <083BC63EECB6FD41B8E81CF7FD87CC0F2E4E9395@DLEE08.ent.ti.com>
 <201306171819.57900.arnd@arndb.de>
In-Reply-To: <201306171819.57900.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Monday, June 17, 2013 11:20 AM
> To: Fernandes, Joel A
> Cc: Tony Lindgren; Nori, Sekhar; Matt Porter; Grant Likely; Rob Herring; Vinod
> Koul; Mark Brown; Cousson, Benoit; Russell King; Rob Landley; Andrew Morton;
> Jason Kridner; Koen Kooi; Devicetree Discuss; Linux OMAP List; Linux ARM
> Kernel List; Linux DaVinci Kernel List; Linux Kernel Mailing List; Linux
> Documentation List; Linux MMC List; Linux SPI Devel List
> Subject: Re: [PATCH v10 5/8] dmaengine: edma: Add TI EDMA device tree
> binding
> 
> On Monday 17 June 2013, Fernandes, Joel A wrote:
> > [Joel] Thanks for the suggestion, I updated it and it looks like this now:
> >
> > Required properties:
> > - compatible : "ti,edma3"
> > - ti,hwmods: Name of the hwmods associated to the EDMA
> > - ti,edma-regions: Number of regions
> > - ti,edma-slots: Number of slots
> > - #dma-cells: Should be set to <1>
> >               Clients should use a single number per DMA channel request.
> 
> That still does not say what that number refers to.
> Is it a channel number, or a request line number, or something completely
> different?
 
[Joel] 
Ah! Will fix, it's a channel number.

Thanks,
Joel
