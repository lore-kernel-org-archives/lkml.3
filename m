Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab3FTG5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 02:57:15 -0400
Received: from mail-gh0-f180.google.com ([209.85.160.180]:46271 "EHLO
	mail-gh0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3FTG5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 02:57:14 -0400
From: "John B. Wyatt IV" <sageofredondo@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "John B. Wyatt IV" <sageofredondo@gmail.com>
Subject: [PATCH] Staging: vt6655: aes_ccmp: fixed a brace coding style
Date: Wed, 19 Jun 2013 23:56:45 -0700
Message-Id: <1371711405-7260-1-git-send-email-sageofredondo@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John B. Wyatt IV" <sageofredondo@gmail.com>

Fixed a coding style issue.

Signed-off-by: John B. Wyatt IV <sageofredondo@gmail.com>
---
 drivers/staging/vt6655/aes_ccmp.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6655/aes_ccmp.c b/drivers/staging/vt6655/aes_ccmp.c
index 3608148..c53478f 100644
--- a/drivers/staging/vt6655/aes_ccmp.c
+++ b/drivers/staging/vt6655/aes_ccmp.c
@@ -381,9 +381,8 @@ bool AESbGenCCMP(unsigned char *pbyRxKey, unsigned char *pbyFrame, unsigned shor
 	//=>above is the dec-MIC from packet
 	//--------------------------------------------
 
-	if (!memcmp(abyMIC, abyTmp, 8)) {
+	if (!memcmp(abyMIC, abyTmp, 8))
 		return true;
-	} else {
+	else
 		return false;
-	}
 }
-- 
1.8.1.2

