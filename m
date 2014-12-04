Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbaLDBMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 20:12:21 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:48416 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaLDBMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 20:12:20 -0500
From: Arun <arun267@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Arun <arun267@gmail.com>
Subject: [PATCH] Staging: bcm: Fix lines exceeding 80 character limit in CmHost.h This is a patch to CmHost.h that fixes Exceeds 80 Character limits warning found by checkpatch.pl Signed-off-by: Arun Ayyer <arun267@gmail.com>
Date: Wed,  3 Dec 2014 17:12:09 -0800
Message-Id: <1417655529-8640-1-git-send-email-arun267@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/bcm/CmHost.h |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/bcm/CmHost.h b/drivers/staging/bcm/CmHost.h
index 0887d3f..a6e30da 100644
--- a/drivers/staging/bcm/CmHost.h
+++ b/drivers/staging/bcm/CmHost.h
@@ -20,8 +20,8 @@
 #pragma once
 #pragma pack(push, 4)
 
-#define DSX_MESSAGE_EXCHANGE_BUFFER        0xBF60AC84 /* This contains the pointer */
-#define DSX_MESSAGE_EXCHANGE_BUFFER_SIZE   72000      /* 24 K Bytes */
+#define DSX_MESSAGE_EXCHANGE_BUFFER       0xBF60AC84 /* Contains the pointer */
+#define DSX_MESSAGE_EXCHANGE_BUFFER_SIZE  72000      /* 24 K Bytes */
 
 struct bcm_add_indication_alt {
 	u8	u8Type;
@@ -51,7 +51,9 @@ struct bcm_change_indication {
 	u16	u16Padd;
 };
 
-unsigned long StoreCmControlResponseMessage(struct bcm_mini_adapter *Adapter, void *pvBuffer, unsigned int *puBufferLength);
+unsigned long StoreCmControlResponseMessage(struct bcm_mini_adapter *Adapter,
+					void *pvBuffer,
+					unsigned int *puBufferLength);
 int AllocAdapterDsxBuffer(struct bcm_mini_adapter *Adapter);
 int FreeAdapterDsxBuffer(struct bcm_mini_adapter *Adapter);
 unsigned long SetUpTargetDsxBuffers(struct bcm_mini_adapter *Adapter);
-- 
1.7.9.5

