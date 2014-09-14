Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbaINANT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 20:13:19 -0400
Received: from sender1.zohomail.com ([74.201.84.155]:29650 "EHLO
	sender1.zohomail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbaINANS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 20:13:18 -0400
From: Sorin Facaoaru <work@sorin.cc>
To: gregkh@linuxfoundation.org
Cc: john.stultz@linaro.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Sorin Facaoaru <work@sorin.cc>
Subject: [PATCH] Staging: android: ion: fix coding style
Date: Sat, 13 Sep 2014 17:13:13 -0700
Message-Id: <1410653593-4611-1-git-send-email-work@sorin.cc>
X-Mailer: git-send-email 1.9.1
X-ZohoMail: Ss  SS_10 UW UB CHF_INT_SMD_EXT  SGR4_1_26084_1
X-ZohoMail-Owner: <1410653593-4611-1-git-send-email-work@sorin.cc>+zmo_0_<work@sorin.cc>
X-ZohoMail-Sender: 23.243.135.245
X-Zoho-Virus-Status: 2
X-ZohoMailClient: External
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- remove return statement in empty void function

Signed-off-by: Sorin Facaoaru <work@sorin.cc>
---
 drivers/staging/android/ion/ion_system_heap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 6b77c51..da2a63c 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -205,7 +205,6 @@ static struct sg_table *ion_system_heap_map_dma(struct ion_heap *heap,
 static void ion_system_heap_unmap_dma(struct ion_heap *heap,
 				      struct ion_buffer *buffer)
 {
-	return;
 }
 
 static int ion_system_heap_shrink(struct ion_heap *heap, gfp_t gfp_mask,
-- 
1.9.1


