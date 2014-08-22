Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbaHVLA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 07:00:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:16586 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425AbaHVLA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 07:00:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,379,1406617200"; 
   d="scan'208";a="580353246"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 0/5] mfd: lpc_sch: Intel Quark support
Date: Fri, 22 Aug 2014 13:58:11 +0300
Message-Id: <1408705096-31286-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This brings support of the LPC SCH device found on Intel Quark SoC. Patches
were compile tested, and driver runs on actual hardware.

Please, note that PCI ID will be used in future in the gpio-sch driver.

Andy Shevchenko (4):
  mfd: lpc_sch: reduce duplicate code
  mfd: lpc_sch: better code manageability with chipset info struct
  mfd: lpc_sch: Add support for Intel Quark X1000
  mfd: lpc_sch: remove FSF address

Josef Ahmad (1):
  pci_ids: add support for Intel Quark ILB

 drivers/mfd/lpc_sch.c   | 207 ++++++++++++++++++++++++++++--------------------
 include/linux/pci_ids.h |   1 +
 2 files changed, 122 insertions(+), 86 deletions(-)

-- 
2.1.0

