Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab3FGTCF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 15:02:05 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:33638 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757094Ab3FGTCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 15:02:03 -0400
From: Valentin Ilie <valentin.ilie@gmail.com>
To: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
        sameo@linux.intel.com
Cc: linux-nfc@ml01.01.org, linux-kernel@vger.kernel.org,
        Valentin Ilie <valentin.ilie@gmail.com>
Subject: [PATCH] NFC: mei_phy: Clean up file
Date: Fri,  7 Jun 2013 22:01:55 +0300
Message-Id: <1370631715-23075-1-git-send-email-valentin.ilie@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warnings.
Replace __attribute__((__packed__)) with __packed.
Replace spaces with tabs.

Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
---
 drivers/nfc/mei_phy.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/mei_phy.c b/drivers/nfc/mei_phy.c
index 1201bdb..606bf55 100644
--- a/drivers/nfc/mei_phy.c
+++ b/drivers/nfc/mei_phy.c
@@ -30,7 +30,7 @@ struct mei_nfc_hdr {
 	u16 req_id;
 	u32 reserved;
 	u16 data_size;
-} __attribute__((packed));
+} __packed;
 
 #define MEI_NFC_MAX_READ (MEI_NFC_HEADER_SIZE + MEI_NFC_MAX_HCI_PAYLOAD)
 
@@ -60,8 +60,8 @@ int nfc_mei_phy_enable(void *phy_id)
 
 	r = mei_cl_enable_device(phy->device);
 	if (r < 0) {
-                pr_err("MEI_PHY: Could not enable device\n");
-                return r;
+		pr_err("MEI_PHY: Could not enable device\n");
+		return r;
 	}
 
 	r = mei_cl_register_event_cb(phy->device, nfc_mei_event_cb, phy);
-- 
1.7.9.5

