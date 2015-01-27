Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849AbbA0UkD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 15:40:03 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:45001 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932822AbbA0UkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 15:40:00 -0500
Date: Tue, 27 Jan 2015 22:39:56 +0200
From: Heba Aamer <heba93aamer@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, notro@tronnes.org,
        thomas.petazzoni@free-electrons.com, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] staging: fbtft: fix Macros with complex values should be
 enclosed in parentheses
Message-ID: <3120ddbbd88e899cebf5b641e2de3b00b422f1f3.1422296762.git.heba93aamer@gmail.com>
References: <cover.1422296762.git.heba93aamer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1422296762.git.heba93aamer@gmail.com>
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
index dd72bed..d20d432 100644
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

