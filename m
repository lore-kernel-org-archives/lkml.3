Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbaGHLSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 07:18:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:44791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219AbaGHLS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 07:18:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,625,1400050800"; 
   d="scan'208";a="540204661"
From: Maurice Petallo <mauricex.r.petallo@intel.com>
To: Chris Ball <chris@printf.net>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Maurice Petallo <mauricex.r.petallo@intel.com>
Subject: [PATCH 0/2] mmc: sdhci: Preset Value disabling and DDR50 mode enabling for BayTrail eMMC
Date: Tue,  8 Jul 2014 19:10:59 +0800
Message-Id: <1404817861-23359-1-git-send-email-mauricex.r.petallo@intel.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series includes:
(1) Declare SDHCI_QUIRK2_PRESET_VALUE_BROKEN for PCI mode and ACPI mode
    Baytrail eMMC controller as it doesn't support Preset Value feature.
(2) Enable DDR50 1.8V mode support for PCI and ACPI mode BayTrail eMMC controller

Maurice Petallo (2):
  mmc: sdhci: Preset value not supported in Baytrail eMMC
  mmc: sdhci: add DDR50 1.8V mode support for BayTrail eMMC Controller

 drivers/mmc/host/sdhci-acpi.c | 4 +++-
 drivers/mmc/host/sdhci-pci.c  | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

-- 
1.8.1.4

