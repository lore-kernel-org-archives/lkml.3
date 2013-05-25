Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab3EYNxV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 09:53:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:14062 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756301Ab3EYNxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 09:53:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,741,1363158000"; 
   d="scan'208";a="339944506"
Date: Sat, 25 May 2013 18:46:32 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, djbw@fb.com
Subject: [GIT PULL] slave-dmaengine fixes
Message-ID: <20130525131632.GV30200@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are slave-dmaenegine fixes for 3.10. We have two patches from Andy & Rafael
fixing the Lynxpoint dma.

The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git fixes

Andy Shevchenko (1):
      dma: acpi-dma: parse CSRT to extract additional resources

Rafael J. Wysocki (1):
      ACPI / LPSS: register clock device for Lynxpoint DMA properly

 drivers/acpi/Makefile                  |    1 -
 drivers/acpi/acpi_lpss.c               |   26 ++++-
 drivers/acpi/csrt.c                    |  159 -----------------------------
 drivers/acpi/internal.h                |    1 -
 drivers/acpi/scan.c                    |    1 -
 drivers/clk/x86/clk-lpt.c              |   15 ++-
 drivers/dma/acpi-dma.c                 |  172 +++++++++++++++++++++++++++++++-
 include/linux/acpi_dma.h               |    4 +
 include/linux/platform_data/clk-lpss.h |    5 +
 9 files changed, 211 insertions(+), 173 deletions(-)
 delete mode 100644 drivers/acpi/csrt.c

--
~Vinod
