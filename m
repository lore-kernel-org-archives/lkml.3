Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933110AbaEPNlA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:41:00 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:44439 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933029AbaEPNk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:40:56 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 24/49] media: davinci; vpif_display: fix checkpatch error
Date: Fri, 16 May 2014 19:03:29 +0530
Message-Id: <1400247235-31434-26-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch fixes following checkpatch warning, and alongside
renames the DAVINCIHD_DISPLAY_H to VPIF_DISPLAY_H.

WARNING: Unnecessary space before function pointer arguments

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_display.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.h b/drivers/media/platform/davinci/vpif_display.h
index 18cba9a..7b21a76 100644
--- a/drivers/media/platform/davinci/vpif_display.h
+++ b/drivers/media/platform/davinci/vpif_display.h
@@ -13,8 +13,8 @@
  * GNU General Public License for more details.
  */
 
-#ifndef DAVINCIHD_DISPLAY_H
-#define DAVINCIHD_DISPLAY_H
+#ifndef VPIF_DISPLAY_H
+#define VPIF_DISPLAY_H
 
 /* Header files */
 #include <media/videobuf2-dma-contig.h>
@@ -92,7 +92,7 @@ struct common_obj {
 	u32 cbtm_off;				/* offset of C bottom from the
 						 * starting of the buffer */
 	/* Function pointer to set the addresses */
-	void (*set_addr) (unsigned long, unsigned long,
+	void (*set_addr)(unsigned long, unsigned long,
 				unsigned long, unsigned long);
 	u32 height;
 	u32 width;
@@ -124,4 +124,4 @@ struct vpif_device {
 	struct vpif_display_config *config;
 };
 
-#endif				/* DAVINCIHD_DISPLAY_H */
+#endif				/* VPIF_DISPLAY_H */
-- 
1.7.9.5

