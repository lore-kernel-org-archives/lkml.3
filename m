Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbaJIVEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:04:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58940 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbaJIVD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:03:29 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: James Ralston <james.d.ralston@intel.com>, Tejun Heo <tj@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 014/163] ata_piix: Add Device IDs for Intel 9 Series PCH
Date: Thu,  9 Oct 2014 14:00:39 -0700
Message-Id: <1412888588-26755-15-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Ralston <james.d.ralston@intel.com>

commit 6cad1376954e591c3c41500c4e586e183e7ffe6d upstream.

This patch adds the IDE mode SATA Device IDs for the Intel 9 Series PCH.

Signed-off-by: James Ralston <james.d.ralston@intel.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/ata/ata_piix.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 6334c8d..39f76b9 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -340,6 +340,14 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	{ 0x8086, 0x0F21, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata_byt },
 	/* SATA Controller IDE (Coleto Creek) */
 	{ 0x8086, 0x23a6, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (9 Series) */
+	{ 0x8086, 0x8c88, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata_snb },
+	/* SATA Controller IDE (9 Series) */
+	{ 0x8086, 0x8c89, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata_snb },
+	/* SATA Controller IDE (9 Series) */
+	{ 0x8086, 0x8c80, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
+	/* SATA Controller IDE (9 Series) */
+	{ 0x8086, 0x8c81, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
 
 	{ }	/* terminate list */
 };
-- 
1.9.1

