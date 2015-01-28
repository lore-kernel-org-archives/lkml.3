Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934115AbbA1Umk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:42:40 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:60677 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969AbbA1Umg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:42:36 -0500
Date: Wed, 28 Jan 2015 13:19:25 +0200
From: Heba Aamer <heba93aamer@gmail.com>
To: devel@driverdev.osuosl.org
Cc: thomas.petazzoni@free-electrons.com, noralf@tronnes.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] staging: fbtft: fix Macros with complex values should be
 enclosed in parentheses
Message-ID: <8dfee4846d30defff32f46d4322979b33c2fa33b.1422443132.git.heba93aamer@gmail.com>
References: <cover.1422443132.git.heba93aamer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1422443132.git.heba93aamer@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl error:
fix Macros with complex values should be enclosed in parentheses

Signed-off-by: Heba Aamer <heba93aamer@gmail.com>
---
 drivers/staging/fbtft/fb_pcd8544.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/fbtft/fb_pcd8544.c b/drivers/staging/fbtft/fb_pcd8544.c
index 678ab8e..87ca96e 100644
--- a/drivers/staging/fbtft/fb_pcd8544.c
+++ b/drivers/staging/fbtft/fb_pcd8544.c
@@ -33,7 +33,7 @@
 #define DRVNAME	       "fb_pcd8544"
 #define WIDTH          84
 #define HEIGHT         48
-#define TXBUFLEN       84*6
+#define TXBUFLEN       (84*6)
 #define DEFAULT_GAMMA  "40" /* gamma is used to control contrast in this driver */
 
 static unsigned tc = 0;
-- 
1.7.9.5

