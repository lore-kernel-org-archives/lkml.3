Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbaF3Mkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:40:31 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932309AbaF3Mb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:31:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Wendy Xiong <wenxiong@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 012/181] [SCSI] ipr: Add new CCIN definition for Grand Canyon support
Date: Mon, 30 Jun 2014 13:50:33 +0200
Message-Id: <dcc23f13ff973c49651f0f020495a26baec32343.1404128997.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wendy Xiong <wenxiong@linux.vnet.ibm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 5eeac3e99ae220aea787527d1bfd9e846adf9fac upstream.

Add the appropriate definition and table entry for new hardware support.

Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
Acked-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/scsi/ipr.c | 6 ++++++
 drivers/scsi/ipr.h | 3 +++
 2 files changed, 9 insertions(+)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 573f4128b6b6..074f278f7dab 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -10005,6 +10005,12 @@ static struct pci_device_id ipr_pci_table[] = {
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57EF, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57F0, 0, 0, 0 },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_2CCA, 0, 0, 0 },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_2CD2, 0, 0, 0 },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_2CCD, 0, 0, 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, ipr_pci_table);
diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index cad1483f05da..58c6630fe3e2 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -107,6 +107,9 @@
 #define IPR_SUBS_DEV_ID_57EE    0x049A
 #define IPR_SUBS_DEV_ID_57EF    0x049B
 #define IPR_SUBS_DEV_ID_57F0    0x049C
+#define IPR_SUBS_DEV_ID_2CCA	0x04C7
+#define IPR_SUBS_DEV_ID_2CD2	0x04C8
+#define IPR_SUBS_DEV_ID_2CCD	0x04C9
 #define IPR_NAME				"ipr"
 
 /*
-- 
2.0.0

