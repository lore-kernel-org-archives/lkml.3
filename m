Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab3F0Dmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 23:42:47 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38588 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588Ab3F0Dmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 23:42:42 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@linaro.org>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
CC: Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>
Subject: [PATCH v2 0/2] DMA: EDMA: Config and comments
Date: Wed, 26 Jun 2013 22:41:45 -0500
Message-ID: <1372304505-30707-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor patches remaining after EDMA series was posted.

First patch adds the TI_EDMA option which people can forget to add and
can result in failure without any informative errors of why DMA is not
working. There was a discussion on avoiding Kconfig and putting this in
the defconfig instead.

Second patch adds comments to the EDMA code for the calculations in the
A-sync case. From my experience, this code is not-so-obvious. Hopefully
this makes the life of readers of the code a little better.

Joel Fernandes (2):
  ARM: configs: Enable TI_EDMA in omap2plus_defconfig
  DMA: EDMA: Add comments for A-sync case calculations

 arch/arm/configs/omap2plus_defconfig |    1 +
 drivers/dma/edma.c                   |   22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+)

-- 
1.7.9.5

