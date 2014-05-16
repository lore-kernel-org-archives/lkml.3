Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933618AbaEPNnD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:43:03 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:44534 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933601AbaEPNm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:42:58 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 47/49] media: davinci: vpif_capture: drop check __KERNEL__
Date: Fri, 16 May 2014 19:03:53 +0530
Message-Id: <1400247235-31434-50-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this drops check for #ifdef __KERNEL__

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_capture.h |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.h b/drivers/media/platform/davinci/vpif_capture.h
index 3b5ea30..f65d28d 100644
--- a/drivers/media/platform/davinci/vpif_capture.h
+++ b/drivers/media/platform/davinci/vpif_capture.h
@@ -19,8 +19,6 @@
 #ifndef VPIF_CAPTURE_H
 #define VPIF_CAPTURE_H
 
-#ifdef __KERNEL__
-
 /* Header files */
 #include <media/videobuf2-dma-contig.h>
 #include <media/v4l2-device.h>
@@ -121,5 +119,4 @@ struct vpif_device {
 	struct vpif_capture_config *config;
 };
 
-#endif				/* End of __KERNEL__ */
 #endif				/* VPIF_CAPTURE_H */
-- 
1.7.9.5

