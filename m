Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876AbaLJN5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 08:57:08 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:64704 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbaLJN5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 08:57:07 -0500
From: Anjana Sasindran <anjanasasindran123@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Anjana Sasindran <anjanasasindran123@gmail.com>
Subject: [PATCH] staging: rts5208: Removed the new typedefs
Date: Wed, 10 Dec 2014 19:24:16 +0530
Message-Id: <1418219656-2964-1-git-send-email-anjanasasindran123@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix the checkpatch.pl warning:

WARNING: do not add new typedefs

Signed-off-by: Anjana Sasindran <anjanasasindran123@gmail.com>
---
 drivers/staging/rts5208/rtsx_sys.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rts5208/rtsx_sys.h b/drivers/staging/rts5208/rtsx_sys.h
index 0b6b4d4..f04d997 100644
--- a/drivers/staging/rts5208/rtsx_sys.h
+++ b/drivers/staging/rts5208/rtsx_sys.h
@@ -28,7 +28,7 @@
 #include "rtsx_chip.h"
 #include "rtsx_card.h"
 
-typedef dma_addr_t ULONG_PTR;
+dma_addr_t ULONG_PTR;
 
 static inline void rtsx_exclusive_enter_ss(struct rtsx_chip *chip)
 {
-- 
1.9.1

