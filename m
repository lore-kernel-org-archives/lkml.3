Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbaIBKpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 06:45:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:63068 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753561AbaIBKpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 06:45:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,448,1406617200"; 
   d="scan'208";a="474608398"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 0/4] mfd: lpc_sch: Intel Quark support
Date: Tue,  2 Sep 2014 13:45:18 +0300
Message-Id: <1409654722-6570-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This brings support of the LPC SCH device found on Intel Quark SoC. Patches
were compile tested, and driver runs on actual hardware.

Please, note that PCI ID will be used in future in the gpio-sch driver.

Changelog v2:
- squash patches 1/5 and 2/5 into 1/4
- add Acked-by Bjorn
- address Lee's comments against 3/4 (former 4/5)
- rebase on newest linux-next

Andy Shevchenko (3):
  mfd: lpc_sch: reduce duplicate code and improve manageability
  mfd: lpc_sch: Add support for Intel Quark X1000
  mfd: lpc_sch: remove FSF address

Josef Ahmad (1):
  pci_ids: add support for Intel Quark ILB

 drivers/mfd/lpc_sch.c   | 211 ++++++++++++++++++++++++++++--------------------
 include/linux/pci_ids.h |   1 +
 2 files changed, 126 insertions(+), 86 deletions(-)

-- 
2.1.0

