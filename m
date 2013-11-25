Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab3KYNI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:08:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57257 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab3KYNIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:08:53 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: James Ralston <james.d.ralston@intel.com>, Tejun Heo <tj@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 58/78] ahci: Add Device IDs for Intel Wildcat Point-LP
Date: Mon, 25 Nov 2013 13:06:45 +0000
Message-Id: <1385384825-21681-59-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Ralston <james.d.ralston@intel.com>

commit 9f961a5f6efc87a79571d7166257b36af28ffcfe upstream.

This patch adds the AHCI-mode SATA Device IDs for the Intel Wildcat Point-LP PCH.

Signed-off-by: James Ralston <james.d.ralston@intel.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/ata/ahci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 9270f35..d0f8a93 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -301,6 +301,10 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x8d66), board_ahci }, /* Wellsburg RAID */
 	{ PCI_VDEVICE(INTEL, 0x8d6e), board_ahci }, /* Wellsburg RAID */
 	{ PCI_VDEVICE(INTEL, 0x23a3), board_ahci }, /* Coleto Creek AHCI */
+	{ PCI_VDEVICE(INTEL, 0x9c83), board_ahci }, /* Wildcat Point-LP AHCI */
+	{ PCI_VDEVICE(INTEL, 0x9c85), board_ahci }, /* Wildcat Point-LP RAID */
+	{ PCI_VDEVICE(INTEL, 0x9c87), board_ahci }, /* Wildcat Point-LP RAID */
+	{ PCI_VDEVICE(INTEL, 0x9c8f), board_ahci }, /* Wildcat Point-LP RAID */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
-- 
1.8.3.2

