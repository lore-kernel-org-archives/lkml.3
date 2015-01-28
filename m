Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760805AbbA1EOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:14:40 -0500
Received: from mail.kernel.org ([198.145.29.136]:37046 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760740AbbA1EOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:14:36 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, James Ralston <james.d.ralston@intel.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 15/91] ata_piix: Add Device IDs for Intel 9 Series PCH
Date: Wed, 28 Jan 2015 12:06:36 +0800
Message-Id: <1422418236-12852-29-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Ralston <james.d.ralston@intel.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 6cad1376954e591c3c41500c4e586e183e7ffe6d upstream.

This patch adds the IDE mode SATA Device IDs for the Intel 9 Series PCH.

Signed-off-by: James Ralston <james.d.ralston@intel.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/ata/ata_piix.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 9f165a81..2f081a3 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -362,6 +362,14 @@ static const struct pci_device_id piix_pci_tbl[] = {
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

