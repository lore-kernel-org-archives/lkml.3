Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab3EHI4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 04:56:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:40626 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771Ab3EHI4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 04:56:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,632,1363158000"; 
   d="scan'208";a="330722270"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-acpi@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 0/2] dma: support Lynxpoint DMA
Date: Wed,  8 May 2013 11:55:47 +0300
Message-Id: <1368003349-12204-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the rest of patch series related to ACPI DMA helpers and Lynxpoint DMAC.
Patches are rebased against current Linus' tree and Vinod's branch for-linus.

Since v2:
 - remove patches that are already in the Vinod's tree
 - rebase on top of today's origin/master and Vinod's for-linus branch
 - fix description in patch 2/2

I will be on vacation next week. Mika promised to help if anything happens to
these patches.

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
1.7.10.4

