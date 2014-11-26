Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbaKZLOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 06:14:43 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:61901 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbaKZLOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 06:14:41 -0500
From: Athira Lekshmi C V <andnlnbn18@gmail.com>
To: gregkh@linuxfoundation.org
Cc: domagoj.trsan@gmail.com, aysemelikeyurtoglu@gmail.com,
        speakup@linux-speakup.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Athira Lekshmi C V <andnlnbn18@gmail.com>
Subject: [PATCH] Drivers:staging:speakup: Fixed checkpatch warning
Date: Wed, 26 Nov 2014 16:44:38 +0530
Message-Id: <1417000478-29940-1-git-send-email-andnlnbn18@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the checkpatch warning:
WARNING: simple_strtoul is obsolete, use kstrtoul instead

Signed-off-by: Athira Lekshmi C V <andnlnbn18@gmail.com>
---
 drivers/staging/speakup/varhandlers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/speakup/varhandlers.c b/drivers/staging/speakup/varhandlers.c
index 1b0d1c0..00fd67e 100644
--- a/drivers/staging/speakup/varhandlers.c
+++ b/drivers/staging/speakup/varhandlers.c
@@ -324,7 +324,7 @@ char *spk_s2uchar(char *start, char *dest)
 {
 	int val = 0;
 
-	val = simple_strtoul(skip_spaces(start), &start, 10);
+	val = kstrtoul(skip_spaces(start), &start, 10);
 	if (*start == ',')
 		start++;
 	*dest = (u_char)val;
-- 
1.7.9.5

