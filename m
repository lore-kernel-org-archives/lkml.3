Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab3JJE2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 00:28:51 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:62409 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab3JJE2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 00:28:39 -0400
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: plagnioj@jcrosoft.com, tomi.valkeinen@ti.com, nsekhar@ti.com,
        badarkhe.manish@gmail.com
Subject: [PATCH] video: da8xx-fb: remove unwanted define
Date: Thu, 10 Oct 2013 09:58:31 +0530
Message-Id: <1381379311-22240-1-git-send-email-badarkhe.manish@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unwanted define "WSI_TIMEOUT" present in code.

Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
---
:100644 100644 e030e17... fa61323... M	drivers/video/da8xx-fb.c
 drivers/video/da8xx-fb.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index e030e17..fa61323 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -129,7 +129,6 @@
 
 #define LCD_NUM_BUFFERS	2
 
-#define WSI_TIMEOUT	50
 #define PALETTE_SIZE	256
 
 #define	CLK_MIN_DIV	2
-- 
1.7.10.4

