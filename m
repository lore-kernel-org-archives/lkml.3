Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab3FBS22 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 14:28:28 -0400
Received: from void.printf.net ([89.145.121.20]:37635 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754895Ab3FBS2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 14:28:21 -0400
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: [GIT PULL] MMC fixes for 3.10-rc5
Date: Sun, 02 Jun 2013 14:28:14 -0400
Message-ID: <878v2sbc5d.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-fixes-for-3.10-rc5

to receive MMC fixes for 3.10-rc5.  There are no merge conflicts, and
the patches have been tested in linux-next.  Thanks.


The following changes since commit c7788792a5e7b0d5d7f96d0766b4cb6112d47d75:

  Linux 3.10-rc2 (2013-05-20 14:37:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-fixes-for-3.10-rc5

for you to fetch changes up to 4a29b5591faf25555fdf2b717594d50f70c15066:

  mmc: omap_hsmmc: Skip platform_get_resource_byname() for dt case (2013-05-26 14:23:11 -0400)

----------------------------------------------------------------
MMC fixes for 3.10-rc5:
 - sdhci-acpi: Fix initial runtime PM status, add more ACPI IDs
 - atmel-mci, omap_hsmmc: DT handling fixes
 - esdhc-imx: Fix SDIO IRQs, fix multiblock reads (both h/w errata)

----------------------------------------------------------------
Adrian Hunter (3):
      mmc: sdhci-acpi: fix initial runtime pm status
      mmc: sdhci-acpi: add more device ids
      mmc: sdhci-pci: add more device ids

Lucas Stach (1):
      mmc: sdhci-esdhc-imx: fix multiblock reads on i.MX53

Ludovic Desroches (1):
      mmc: atmel-mci: convert to dma_request_slave_channel_compat()

Martin Fuzzey (1):
      mmc: sdhci-esdhc-imx: Fix SDIO interrupts

Matt Porter (1):
      mmc: omap_hsmmc: convert to dma_request_slave_channel_compat

Santosh Shilimkar (1):
      mmc: omap_hsmmc: Skip platform_get_resource_byname() for dt case

Tony Lindgren (1):
      mmc: omap_hsmmc: Fix the DT pbias workaround for MMC controllers 2 to 5

 drivers/mmc/host/atmel-mci.c       | 25 +++++++-------
 drivers/mmc/host/omap_hsmmc.c      | 51 +++++++++++++++++-----------
 drivers/mmc/host/sdhci-acpi.c      | 69 +++++++++++++++++++++++++++++++++-----
 drivers/mmc/host/sdhci-esdhc-imx.c | 41 +++++++++++++++++++---
 drivers/mmc/host/sdhci-pci.c       | 54 +++++++++++++++++++++++++++++
 5 files changed, 195 insertions(+), 45 deletions(-)

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
