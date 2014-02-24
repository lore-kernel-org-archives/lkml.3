Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbaBXUId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 15:08:33 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:60778 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbaBXUIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 15:08:32 -0500
From: Jon Mason <jdmason@kudzu.us>
To: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 1/2] staging/dt3155v4l: use PCI_VENDOR_ID_INTEL
Date: Mon, 24 Feb 2014 13:08:19 -0700
Message-Id: <1393272500-1862-1-git-send-email-jdmason@kudzu.us>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PCI_VENDOR_ID_INTEL instead of creating its own vendor ID #define.

Signed-off-by: Jon Mason <jdmason@kudzu.us>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/dt3155v4l/dt3155v4l.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
index 081407b..d3e1267 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
@@ -31,7 +31,6 @@
 
 #include "dt3155v4l.h"
 
-#define DT3155_VENDOR_ID 0x8086
 #define DT3155_DEVICE_ID 0x1223
 
 /* DT3155_CHUNK_SIZE is 4M (2^22) 8 full size buffers */
@@ -975,7 +974,7 @@ dt3155_remove(struct pci_dev *pdev)
 }
 
 static DEFINE_PCI_DEVICE_TABLE(pci_ids) = {
-	{ PCI_DEVICE(DT3155_VENDOR_ID, DT3155_DEVICE_ID) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, DT3155_DEVICE_ID) },
 	{ 0, /* zero marks the end */ },
 };
 MODULE_DEVICE_TABLE(pci, pci_ids);
-- 
1.8.3.2

