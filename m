Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab3FQQV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 12:21:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:65235 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab3FQQV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 12:21:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Fernandes, Joel A" <joelagnel@ti.com>
Subject: Re: [PATCH v10 5/8] dmaengine: edma: Add TI EDMA device tree binding
Date: Mon, 17 Jun 2013 18:19:57 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Tony Lindgren <tony@atomide.com>, "Nori, Sekhar" <nsekhar@ti.com>,
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
References: <1371263570-9323-1-git-send-email-joelagnel@ti.com> <3940138.jZFEtfGGLz@wuerfel> <083BC63EECB6FD41B8E81CF7FD87CC0F2E4E9395@DLEE08.ent.ti.com>
In-Reply-To: <083BC63EECB6FD41B8E81CF7FD87CC0F2E4E9395@DLEE08.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306171819.57900.arnd@arndb.de>
X-Provags-ID: V02:K0:y4UP0GPseVJyEAk+/foXF0KH3XxOGA3dcSdtvLLQTrX
 CIMrgzsUQUGF6ucfUR3BIfNplJGgP+bW/+VNhOnj/bS8T/Qdbu
 sWkTjvk0Ya8lC5wobgeaseKItoNGOjIIgTaa+jXsPC370dyg/C
 hFTVUe9S8L0QK8oGK5qYxxrIkPuwT1VJv4v61oTqug9Rs4PhfT
 UHVHsCw58AAM3zSCV2SJ37Sge0MXlhkUS7qIEO9AUyycfhmbqK
 mn/6eBAtz7TrZUvzOmsszbdjVeJtO53QjQOSEWmmS/ZsXLuU9p
 7igMGnyXArWhNonrE0gt2453qtY7HNu4c+gq7UciiHv568Vv36
 er9W0r5C60PjITvxGXog=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 June 2013, Fernandes, Joel A wrote:
> [Joel] Thanks for the suggestion, I updated it and it looks like this now:
>                                                                                                              
> Required properties:                                                                                                                   
> - compatible : "ti,edma3"                                                                                                              
> - ti,hwmods: Name of the hwmods associated to the EDMA                                                                                 
> - ti,edma-regions: Number of regions                                                                                                   
> - ti,edma-slots: Number of slots
> - #dma-cells: Should be set to <1> 
>               Clients should use a single number per DMA channel request.

That still does not say what that number refers to.
Is it a channel number, or a request line number, or something completely
different?

	Arnd
