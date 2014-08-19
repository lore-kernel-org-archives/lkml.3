Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbaHSR3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 13:29:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:36311 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbaHSR3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 13:29:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,896,1400050800"; 
   d="scan'208";a="470420409"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@kernel.org>,
        Hein Tibosch <hein_tibosch@yahoo.es>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Takashi Iwai <tiwai@suse.de>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 07/12] dmaengine: dw: add PCI IDs for Braswell DMAs
Date: Tue, 19 Aug 2014 20:29:18 +0300
Message-Id: <1408469363-15901-8-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1408469363-15901-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1408469363-15901-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Braswell SoC has two DMA controllers for LPSS. This patch adds them to
supported list in the PCI driver.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw/pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/dma/dw/pci.c b/drivers/dma/dw/pci.c
index 39e30c3..9c88828 100644
--- a/drivers/dma/dw/pci.c
+++ b/drivers/dma/dw/pci.c
@@ -108,6 +108,10 @@ static const struct pci_device_id dw_pci_id_table[] = {
 	{ PCI_VDEVICE(INTEL, 0x0f06), (kernel_ulong_t)&dw_pci_pdata },
 	{ PCI_VDEVICE(INTEL, 0x0f40), (kernel_ulong_t)&dw_pci_pdata },
 
+	/* Braswell */
+	{ PCI_VDEVICE(INTEL, 0x2286), (kernel_ulong_t)&dw_pci_pdata },
+	{ PCI_VDEVICE(INTEL, 0x22c0), (kernel_ulong_t)&dw_pci_pdata },
+
 	/* Haswell */
 	{ PCI_VDEVICE(INTEL, 0x9c60), (kernel_ulong_t)&dw_pci_pdata },
 	{ }
-- 
2.1.0

