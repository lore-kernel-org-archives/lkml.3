Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934730AbaGYQuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:50:37 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:36120 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933537AbaGYQug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:50:36 -0400
From: Igor Bezukh <igbzkh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, forest@alittletooquiet.net,
        linux-kernel@vger.kernel.org, igbzkh@gmail.com
Subject: [PATCH] Staging: vt6655: removed redundant comments from michael.h
Date: Fri, 25 Jul 2014 19:50:25 +0300
Message-Id: <1406307025-527-1-git-send-email-igbzkh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed redundant comments from michael.h header file.

Signed-off-by: Igor Bezukh <igbzkh@gmail.com>
---
 drivers/staging/vt6655/michael.h |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/vt6655/michael.h b/drivers/staging/vt6655/michael.h
index f6c2c15..86cb140 100644
--- a/drivers/staging/vt6655/michael.h
+++ b/drivers/staging/vt6655/michael.h
@@ -33,10 +33,6 @@
 
 #include <linux/types.h>
 
-/*---------------------  Export Definitions -------------------------*/
-
-/*---------------------  Export Types  ------------------------------*/
-
 void MIC_vInit(u32 dwK0, u32 dwK1);
 
 void MIC_vUnInit(void);
@@ -48,8 +44,6 @@ void MIC_vAppend(unsigned char *src, unsigned int nBytes);
 /* This also resets the message to empty. */
 void MIC_vGetMIC(u32 *pdwL, u32 *pdwR);
 
-/*---------------------  Export Macros ------------------------------*/
-
 /* Rotation functions on 32 bit values */
 #define ROL32(A, n)							\
 	(((A) << (n)) | (((A)>>(32-(n)))  & ((1UL << (n)) - 1)))
-- 
1.7.9.5

