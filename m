Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab3FQAL5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 20:11:57 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:60067 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab3FQALz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 20:11:55 -0400
From: Chad Williamson <chad@dahc.us>
To: gregkh@linuxfoundation.org
Cc: puff65537@bansheeslibrary.com, viro@zeniv.linux.org.uk,
        tulinizer@gmail.com, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chad Williamson <chad@dahc.us>
Subject: [PATCH 3/3] Staging: silicom: remove the EXPORT_SYMBOL_NOVERS macro
Date: Sun, 16 Jun 2013 19:05:25 -0500
Message-Id: <1371427525-6007-4-git-send-email-chad@dahc.us>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371427525-6007-1-git-send-email-chad@dahc.us>
References: <1371427525-6007-1-git-send-email-chad@dahc.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since all references to EXPORT_SYMBOL_NOVERS have been removed,
we can remove its definition from bp_mod.h and bypasslib/bplibk.h.

Signed-off-by: Chad Williamson <chad@dahc.us>
---
 drivers/staging/silicom/bp_mod.h           | 2 --
 drivers/staging/silicom/bypasslib/bplibk.h | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/staging/silicom/bp_mod.h b/drivers/staging/silicom/bp_mod.h
index b8275f5..cfa1f43 100644
--- a/drivers/staging/silicom/bp_mod.h
+++ b/drivers/staging/silicom/bp_mod.h
@@ -15,8 +15,6 @@
 #define BP_MOD_H
 #include "bits.h"
 
-#define EXPORT_SYMBOL_NOVERS EXPORT_SYMBOL
-
 #define usec_delay(x) udelay(x)
 #ifndef msec_delay_bp
 #define msec_delay_bp(x)			\
diff --git a/drivers/staging/silicom/bypasslib/bplibk.h b/drivers/staging/silicom/bypasslib/bplibk.h
index b31694f..c5c75c4 100644
--- a/drivers/staging/silicom/bypasslib/bplibk.h
+++ b/drivers/staging/silicom/bypasslib/bplibk.h
@@ -28,8 +28,6 @@
 	 ((pid == INTEL_PEG4BPII_PID) ||   \
 	  (pid == INTEL_PEG4BPFII_PID)))
 
-#define EXPORT_SYMBOL_NOVERS EXPORT_SYMBOL
-
 #ifdef BP_VENDOR_SUPPORT
 char *bp_desc_array[] = { "e1000bp", "e1000bpe", "slcm5700",
 			"bnx2xbp", "ixgbp", "ixgbpe", NULL };
-- 
1.8.1.4

