Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaINKsM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 06:48:12 -0400
Received: from sender1.zohomail.com ([74.201.84.155]:29827 "EHLO
	sender1.zohomail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbaINKsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 06:48:11 -0400
From: Sorin Facaoaru <work@sorin.cc>
To: gregkh@linuxfoundation.org
Cc: lordzen87@gmail.com, monamagarwal123@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Sorin Facaoaru <work@sorin.cc>
Subject: [PATCH] Staging: gs_fpgaboot: fix coding style
Date: Sun, 14 Sep 2014 03:48:08 -0700
Message-Id: <1410691688-10263-1-git-send-email-work@sorin.cc>
X-Mailer: git-send-email 1.9.1
X-ZohoMail: Ss  SS_10 UW UB CHF_INT_SMD_EXT  SGR4_1_26084_0
X-ZohoMail-Owner: <1410691688-10263-1-git-send-email-work@sorin.cc>+zmo_0_<work@sorin.cc>
X-ZohoMail-Sender: 23.243.135.245
X-Zoho-Virus-Status: 2
X-ZohoMailClient: External
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- remove return statement at the end of void function

Signed-off-by: Sorin Facaoaru <work@sorin.cc>
---
 drivers/staging/gs_fpgaboot/io.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/gs_fpgaboot/io.c b/drivers/staging/gs_fpgaboot/io.c
index 23c12f4..f5cd33b 100644
--- a/drivers/staging/gs_fpgaboot/io.c
+++ b/drivers/staging/gs_fpgaboot/io.c
@@ -251,17 +251,14 @@ int xl_init_io(void)
 
 void xl_program_b(int32_t i)
 {
-	return;
 }
 
 void xl_rdwr_b(int32_t i)
 {
-	return;
 }
 
 void xl_csi_b(int32_t i)
 {
-	return;
 }
 
 int xl_get_init_b(void)
@@ -276,17 +273,14 @@ int xl_get_done_b(void)
 
 static inline void byte0_out(unsigned char data)
 {
-	return;
 }
 
 static inline void byte1_out(unsigned char data)
 {
-	return;
 }
 
 static inline void xl_cclk_b(int32_t i)
 {
-	return;
 }
 
 /*
-- 
1.9.1


