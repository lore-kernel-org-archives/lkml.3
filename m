Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772Ab3GKOr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:47:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42947 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932730Ab3GKOZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:25:55 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Seth Heasley <seth.heasley@intel.com>, Tejun Heo <tj@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 29/98] ahci: AHCI-mode SATA patch for Intel Coleto Creek DeviceIDs
Date: Thu, 11 Jul 2013 15:23:59 +0100
Message-Id: <1373552708-15235-30-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seth Heasley <seth.heasley@intel.com>

commit 1cfc7df3de10c40ed459e13cce6de616023bf41c upstream.

This patch adds the AHCI-mode SATA DeviceIDs for the Intel Coleto Creek PCH.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/ata/ahci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index ec7f1a8..9270f35 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -300,6 +300,7 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x8d64), board_ahci }, /* Wellsburg RAID */
 	{ PCI_VDEVICE(INTEL, 0x8d66), board_ahci }, /* Wellsburg RAID */
 	{ PCI_VDEVICE(INTEL, 0x8d6e), board_ahci }, /* Wellsburg RAID */
+	{ PCI_VDEVICE(INTEL, 0x23a3), board_ahci }, /* Coleto Creek AHCI */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
-- 
1.8.1.2

