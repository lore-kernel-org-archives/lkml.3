Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab3CNKy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:54:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51898 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088Ab3CNKhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:32 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: James Ralston <james.d.ralston@intel.com>,
        Jeff Garzik <jgarzik@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 40/88] ata_piix: Add Device IDs for Intel Wellsburg PCH
Date: Thu, 14 Mar 2013 10:35:33 +0000
Message-Id: <1363257381-15900-41-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Ralston <james.d.ralston@intel.com>

commit 3aee8bc52c415aba8148f144e5e5359b0fd75dd1 upstream.

This patch adds the IDE-mode SATA Device IDs for the Intel Wellsburg PCH

Signed-off-by: James Ralston <james.d.ralston@intel.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/ata/ata_piix.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 5e01966..47bd6ab 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -339,6 +339,15 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	{ 0x8086, 0x1f30, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* SATA Controller IDE (Avoton) */
 	{ 0x8086, 0x1f31, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (Wellsburg) */
+	{ 0x8086, 0x8d00, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
+	/* SATA Controller IDE (Wellsburg) */
+	{ 0x8086, 0x8d08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (Wellsburg) */
+	{ 0x8086, 0x8d60, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
+	/* SATA Controller IDE (Wellsburg) */
+	{ 0x8086, 0x8d68, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+
 	{ }	/* terminate list */
 };
 
-- 
1.8.1.2

