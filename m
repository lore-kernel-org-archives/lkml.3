Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076AbaGVMlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 08:41:09 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57660 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbaGVMlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 08:41:06 -0400
From: Igor Bezukh <igbzkh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, forest@alittletooquiet.net,
        linux-kernel@vger.kernel.org, igbzkh@gmail.com
Subject: [PATCH] Staging: vt6655: removed redundant comments from aes_ccmp.h
Date: Tue, 22 Jul 2014 15:40:05 +0300
Message-Id: <1406032805-19807-1-git-send-email-igbzkh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed redundant comments from aes_ccmp.h header file

Signed-off-by: Igor Bezukh <igbzkh@gmail.com>
---
 drivers/staging/vt6655/aes_ccmp.h |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/staging/vt6655/aes_ccmp.h b/drivers/staging/vt6655/aes_ccmp.h
index cc02e64..fe0c506 100644
--- a/drivers/staging/vt6655/aes_ccmp.h
+++ b/drivers/staging/vt6655/aes_ccmp.h
@@ -32,15 +32,6 @@
 
 #include "ttype.h"
 
-/*---------------------  Export Definitions -------------------------*/
-
-/*---------------------  Export Types  ------------------------------*/
-
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
 bool AESbGenCCMP(unsigned char *pbyRxKey, unsigned char *pbyFrame, unsigned short wFrameSize);
 
 #endif /* __AES_H__ */
-- 
1.7.9.5

