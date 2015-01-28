Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973AbbA2D0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:26:46 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:44156 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757995AbbA2D0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 22:26:43 -0500
Date: Wed, 28 Jan 2015 13:21:16 +0200
From: Heba Aamer <heba93aamer@gmail.com>
To: devel@driverdev.osuosl.org
Cc: thomas.petazzoni@free-electrons.com, noralf@tronnes.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] staging: fbtft: fix do not initialise statics to 0 or
 NULL
Message-ID: <6c3bb405c14119fd2db5f1784d03c3be2008f3f1.1422443132.git.heba93aamer@gmail.com>
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
fix do not initialise statics to 0 or NULL

Signed-off-by: Heba Aamer <heba93aamer@gmail.com>
---
 drivers/staging/fbtft/fb_pcd8544.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/fbtft/fb_pcd8544.c b/drivers/staging/fbtft/fb_pcd8544.c
index 87ca96e..d0e5892 100644
--- a/drivers/staging/fbtft/fb_pcd8544.c
+++ b/drivers/staging/fbtft/fb_pcd8544.c
@@ -36,7 +36,7 @@
 #define TXBUFLEN       (84*6)
 #define DEFAULT_GAMMA  "40" /* gamma is used to control contrast in this driver */
 
-static unsigned tc = 0;
+static unsigned tc;
 module_param(tc, uint, 0);
 MODULE_PARM_DESC(tc, "TC[1:0] Temperature coefficient: 0-3 (default: 0)");
 
-- 
1.7.9.5

